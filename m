Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbaDXBvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 21:51:04 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:52384 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaDXBvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 21:51:00 -0400
MIME-Version: 1.0
In-Reply-To: <87a9bciev9.fsf@x220.int.ebiederm.org>
References: <CAGr1F2H+iFi4ZBZXK4nQGomRtpP3f-1sfcMHMMu8GVYjtpXPOQ@mail.gmail.com>
 <87a9bciev9.fsf@x220.int.ebiederm.org>
From: Aditya Kali <adityakali@google.com>
Date: Wed, 23 Apr 2014 18:50:40 -0700
Message-ID: <CAGr1F2G=f+nZ8qc9rxXoG_Wc52XxwdKi26B8JJjgntTmS-3ifQ@mail.gmail.com>
Subject: Re: dropping capabilities in user namespace
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, james.l.morris@oracle.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Swiecki <swiecki@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 2:17 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Aditya Kali <adityakali@google.com> writes:
>
>> Hi all,
>>
>> I am trying to understand the behavior of how we can drop capabilities
>> inside user namespace. i.e., I want to start a process inside user
>> namespace with its effective and permitted capability sets cleared.
>
> Please note to start with that at the point you are in a user namespace
> all of your capabilities are relative to that user namespace.
>
> Now I have not had any problem dropping capabilities in a user namespace
> so you are doing something weird.  Let me see if I can see what that
> weird thing is.
>
>> A typical way in which a root (uid=0) process can drop its privileges is:
>>
>> prctl(PR_SET_KEEPCAPS, 0, 0, 0, 0);
>
> You clear this bit in securebits that should already be clear anyay.
>
>> setresuid(uid, uid, uid);  // At this point, permitted and effective
>> capabilities are cleared
>> exec()
>>
>> But this sequence of operation inside a user namespace does not work
>> as expected:
>
>
> As I look at this it seems to work as designed.  By not starting with
> uid 0 you are triggered the non-zero uid with caps section of the code
> that has always behaved differently.
>
>> Assume /proc/pid/uid_map has entry: uid uid 1
>>
>> attach_user_ns(pid);  // OR create_user_ns() & write_uid_map()
>> prctl(PR_SET_KEEPCAPS, 0, 0, 0, 0);
>> setresuid(uid, uid, uid);  // Fails to reset capabilities
>> exec()
>>
>> The exec()ed process starts with correct uid set, but still with all
>> the capabilities.
>>
>> The differentiating factor here seems to be the 'root_uid' value in
>> security/commoncap.c:cap_emulate_setxuid():
>>
>> static inline void cap_emulate_setxuid(struct cred *new, const struct cred *old)
>> {
>>   kuid_t root_uid = make_kuid(old->user_ns, 0);
>>
>>   if ((uid_eq(old->uid, root_uid) ||
>>       uid_eq(old->euid, root_uid) ||
>>       uid_eq(old->suid, root_uid)) &&
>>      (!uid_eq(new->uid, root_uid) &&
>>       !uid_eq(new->euid, root_uid) &&
>>       !uid_eq(new->suid, root_uid)) &&
>>      !issecure(SECURE_KEEP_CAPS)) {
>>     cap_clear(new->cap_permitted);
>>     cap_clear(new->cap_effective);
>>   }
>>   ...
>>
>> There are couple of problems here:
>> (1) In above example when there is no mapping for uid 0 inside
>> old->user_ns, make_kuid() returns INVALID_UID. Since we go on to
>> compare root_uid without first checking if its even valid, we never
>> satisfy the 'if' condition and never clear the caps. This looks like a
>> bug.
>
> INVALID_UID will never be in a capability set, so the comparison is
> guaranteed against root_uid is guaranteed to fail if there is not a root
> uid.  That is correct.
>

So this does seem like a regression in userns w.r.t.
global/init-user-ns. (See below for correct example when the behavior
is different).

>> (2) Even if there is some mapping for uid 0 inside old->user_ns (say
>> "0 1111 1"), since old->uid = 0, and root_uid=1111 (or some non-zero
>> uid), the 'if' condition again remains unsatisfied.
>
> Correct.  Because this code is not supposed to do something if you have
> caps and your uid is not zero.
>
>> It looks like currently the only case where global root (uid=0)
>> process can drop its capabilities inside a user namespace is by having
>> "0 0 <length>" mapping in the uid_map file. It seems wrong to expose
>> global root in user namespace just to drop privileges!
>
> Where does global root come into this?  Nothing above is global root
> specific?  Or do you just mean you are starting all of this as the
> global root user?
>

I am starting my program as global root user, yes. The program
attaches to given user namespaces, sets uid to given uid and does some
work (which it expects to do as user <uid> without any capabilities).

I made a mistake in my example above. If I exec() at the end, the
capabilities do get cleared as you suggest. The problematic case is:

attach_to_userns(pid)
prctl(PR_SET_KEEPCAPS, 0, 0, 0, 0);
setresuid(uid, uid, uid);  // Fails to reset capabilities
pause() / sleep(...) / do_some_work_as_uid()  [[ no exec, sorry ]]

And I was looking at the Cap* fields in /proc/<process-pid>/status
from another terminal. I noticed that the capabilities were not reset
after the setresuid() call. This behavior is different as compared to
what happens in init_user_ns.

>>  So I feel we
>> need to fix the condition checks everywhere we are using make_kuid()
>> in security/commoncap.c.
>> Can the security experts please advice how this is supposed to work?
>
> If you don't want to set your uid to 0 inside a user namespace before
> setting your uid to something else.  You need to call capset, because
> you are in bizarro land with respect to capabilities.
>
> If you don't want things to work like normal, and you want to skip
> setting your uid to 0 before calling setrexuid(2) you need to call
> capset(2).
>

I cannot call setuid(0) before setting the uid to something else there
is no uid 0 inside userns as per the uid_map. I will try the capset()
approach, but I hope we could fix the above case too.

> But your scenario continues to be very weird because after exec you
> should not have capabilities.
>

Thats correct. exec() will clear the capabilities. Sorry for the
confusing example.

> Looking at cap_bprm_set_creds()
> {
>         if (!issecure(SECURE_NOROOT)) {
>
>                 ...
>
>                 if (uid_eq(new->euid, root_uid))
>                         effective = true;
>         }
>
>         ...
>
>         if (effective)
>                 new->cap_effective = new->cap_permitted;
>         else
>                 cap_clear(new->cap_effective);
>
>         ...
> }
>
> That very clearly clears your effective set if your uid is not 0 in the
> user namespace.
>
> I fail to see how even in the example you gave above that you would have
> any effective capabilities after exec.
>
> Eric



-- 
Aditya
