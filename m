Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbaDVWwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 18:52:33 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:50300 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaDVWwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 18:52:31 -0400
MIME-Version: 1.0
From: Aditya Kali <adityakali@google.com>
Date: Tue, 22 Apr 2014 15:52:10 -0700
Message-ID: <CAGr1F2H+iFi4ZBZXK4nQGomRtpP3f-1sfcMHMMu8GVYjtpXPOQ@mail.gmail.com>
Subject: dropping capabilities in user namespace
To: serge.hallyn@canonical.com, james.l.morris@oracle.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Robert Swiecki <swiecki@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am trying to understand the behavior of how we can drop capabilities
inside user namespace. i.e., I want to start a process inside user
namespace with its effective and permitted capability sets cleared.

A typical way in which a root (uid=0) process can drop its privileges is:

prctl(PR_SET_KEEPCAPS, 0, 0, 0, 0);
setresuid(uid, uid, uid);  // At this point, permitted and effective
capabilities are cleared
exec()

But this sequence of operation inside a user namespace does not work
as expected:

Assume /proc/pid/uid_map has entry: uid uid 1

attach_user_ns(pid);  // OR create_user_ns() & write_uid_map()
prctl(PR_SET_KEEPCAPS, 0, 0, 0, 0);
setresuid(uid, uid, uid);  // Fails to reset capabilities
exec()

The exec()ed process starts with correct uid set, but still with all
the capabilities.

The differentiating factor here seems to be the 'root_uid' value in
security/commoncap.c:cap_emulate_setxuid():

static inline void cap_emulate_setxuid(struct cred *new, const struct cred *old)
{
  kuid_t root_uid = make_kuid(old->user_ns, 0);

  if ((uid_eq(old->uid, root_uid) ||
      uid_eq(old->euid, root_uid) ||
      uid_eq(old->suid, root_uid)) &&
     (!uid_eq(new->uid, root_uid) &&
      !uid_eq(new->euid, root_uid) &&
      !uid_eq(new->suid, root_uid)) &&
     !issecure(SECURE_KEEP_CAPS)) {
    cap_clear(new->cap_permitted);
    cap_clear(new->cap_effective);
  }
  ...

There are couple of problems here:
(1) In above example when there is no mapping for uid 0 inside
old->user_ns, make_kuid() returns INVALID_UID. Since we go on to
compare root_uid without first checking if its even valid, we never
satisfy the 'if' condition and never clear the caps. This looks like a
bug.

(2) Even if there is some mapping for uid 0 inside old->user_ns (say
"0 1111 1"), since old->uid = 0, and root_uid=1111 (or some non-zero
uid), the 'if' condition again remains unsatisfied.

It looks like currently the only case where global root (uid=0)
process can drop its capabilities inside a user namespace is by having
"0 0 <length>" mapping in the uid_map file. It seems wrong to expose
global root in user namespace just to drop privileges! So I feel we
need to fix the condition checks everywhere we are using make_kuid()
in security/commoncap.c.
Can the security experts please advice how this is supposed to work?

(FYI: Commit 18815a18085364d8514c0d0c4c986776cb74272c "userns: Convert
capabilities related permsion checks" introduced the make_uid() change
in cap_emulate_setxuid() & other places).

Thanks,
-- 
Aditya
