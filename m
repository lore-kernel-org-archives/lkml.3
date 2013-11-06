Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab3KFWyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:54:47 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:39331 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3KFWyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:54:45 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Christian Seiler <christian@iwakd.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Lxc development list <lxc-devel@lists.sourceforge.net>
References: <20131106180232.GA8980@ac100> <20131106193311.GA18720@redhat.com>
Date: Wed, 06 Nov 2013 14:50:43 -0800
In-Reply-To: <20131106193311.GA18720@redhat.com> (Oleg Nesterov's message of
	"Wed, 6 Nov 2013 20:33:11 +0100")
Message-ID: <87vc05jgak.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19cTDdNFryH5XQuwtU/ghdX6Vu40iYKVBM=
X-SA-Exim-Connect-IP: 8.25.195.25
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4975]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: CLONE_PARENT after setns(CLONE_NEWPID)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

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

Serge that is a clever trick to get around the limitation that we can
not change the pid namespace of our current process.  Given the
challenging relaying of signals etc I can see why you would use this.

At the same time it makes me a little sad to see new users of
CLONE_PARENT.  With CLONE_THREAD in existence the original reasons for
CLONE_PARENT are gone now.

Having used bash as an init process I know it can handle unexpeted
children.  However using CLONE_PARENT in this way still seems a little
dodgy.  Or am I misunderstanding why you are using CLONE_PARENT?

That trick sounds like it might be worth adding to nsenter in util-linux
just to simplify the code.

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
>
> Eric, Andy, what do you think?
>
> And if we allow CLONE_PARENT when ->pidns_for_children was changed,
> should we also allow, say, CLONE_NEWPID && CLONE_PARENT ?

The two fundamental things I know we can not allow are:
- A shared signal queue aka CLONE_THREAD.  Because we compute the pid
  and uid of the signal when we place it in the queue.

- Changing the pid and by extention pid_namespace of an existing
  process.

>From a parents perspective there is nothing special about the pid
namespace, to deny CLONE_PARENT, because the parent simply won't know or
care.

>From the childs perspective all that is special really are shared signal
queues.

User mode threading with CLONE_PARENT|CLONE_VM|CLONE_SIGHAND and tasks
in different pid namespaces is almost certainly going to break because
it is complicated.  But shared signal handlers can look at per thread
information to know which pid namespace a process is in, so I don't know
of any reason not to support CLONE_PARENT|CLONE_VM|CLONE_SIGHAND threads
at the kernel level.  It would be absolutely stupid to implement but
that is a different thing.

So hmm.

Because it can do no harm, and because it is a regression let's remove
the CLONE_PARENT check and send it stable.

diff --git a/kernel/fork.c b/kernel/fork.c
index 086fe73..c447fbc 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1174,7 +1174,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
         * do not allow it to share a thread group or signal handlers or
         * parent with the forking task.
         */
-       if (clone_flags & (CLONE_SIGHAND | CLONE_PARENT)) {
+       if (clone_flags & (CLONE_SIGHAND)) {
                if ((clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) ||
                    (task_active_pid_ns(current) !=
                                current->nsproxy->pid_ns_for_children))


I don't know if there are shells that CLONE_PARENT can confuse but if
there are lxcattach and nsenter using this functionality should be
enough to slowly get that confusion fixed.

Changing the CLONE_SIGHAND into CLONE_THREAD will need to happen in a
separate patch.  It isn't stable material, and so far there is no
compelling use case for it.

Eric
