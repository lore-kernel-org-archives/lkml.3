Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab3KFTvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:51:23 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:55656 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3KFTvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:51:22 -0500
MIME-Version: 1.0
In-Reply-To: <20131106193311.GA18720@redhat.com>
References: <20131106180232.GA8980@ac100> <20131106193311.GA18720@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 6 Nov 2013 11:50:59 -0800
Message-ID: <CALCETrV=G30_4bVQbRF0Z9kzYpP8V+aUf-uZES+qVD5MXEAWZQ@mail.gmail.com>
Subject: Re: CLONE_PARENT after setns(CLONE_NEWPID)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Brad Spengler <spender@grsecurity.net>,
        Christian Seiler <christian@iwakd.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Lxc development list <lxc-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 11:33 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Hi Serge,
>
> On 11/06, Serge Hallyn wrote:
>>
>> Hi Oleg,
>>
>> commit 40a0d32d1eaffe6aac7324ca92604b6b3977eb0e :
>> "fork: unify and tighten up CLONE_NEWUSER/CLONE_NEWPID checks"
>> breaks lxc-attach in 3.12.  That code forks a child which does
>> setns() and then does a clone(CLONE_PARENT).  That way the
>> grandchild can be in the right namespaces (which the child was
>> not) and be a child of the original task, which is the monitor.
>
> Thanks...
>
> Yes, this is what 40a0d32d1ea explicitly tries to disallow.
>
>> Is there a real danger in allowing CLONE_PARENT
>> when current->nsproxy->pidns_for_children is not our pidns,
>> or was this done out of an "over-abundance of caution"?
>
> I am not sure... This all was based on the long discussion, and
> it was decided that the CLONE_PARENT check should be consistent
> wrt CLONE_NEWPID and pidns_for_children != task_active_pid_ns().
>
>> Can we
>> safely revert that new extra check?
>
> Well, usually we do not break user-space, but I am not sure about
> this case...

Presumably if we allow this, then we should also allow
clone(CLONE_NEWPID | CLONE_PARENT).  This seems a little odd, but off
the top of my head it doesn't seem obviously dangerous.

(Why were we worried about this in the first place?  The comment says
that we don't want signal handlers or thread groups to span
namespaces, but CLONE_PARENT has nothing to do with that.)

I feel like I'm rehashing something ancient, but shouldn't that code just be:

if (clone_flags & CLONE_VM) {
  // check for unsharing namespaces

with an update to the comment that CLONE_THREAD and CLONE_SIGHAND both
require CLONE_VM.

--Andy
