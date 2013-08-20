Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab3HTUw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:52:28 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41814 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3HTUwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:52:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Walters <walters@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20130819172524.GA22268@redhat.com>
	<CALCETrW+dEwR38ERQhx25-aw1dhsCE6X+9BQZJhusO88aUxN1A@mail.gmail.com>
	<20130819183319.GA24846@redhat.com>
	<CALCETrWrpNszRGCRRMLgiOopcSdDShB3Mck6gRPco=dAZeX3pQ@mail.gmail.com>
	<20130819184355.GA25362@redhat.com> <87siy4z1pf.fsf@xmission.com>
	<20130820184521.GA23293@redhat.com>
Date: Tue, 20 Aug 2013 13:52:17 -0700
In-Reply-To: <20130820184521.GA23293@redhat.com> (Oleg Nesterov's message of
	"Tue, 20 Aug 2013 20:45:21 +0200")
Message-ID: <87li3ww0e6.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19aseFqaMu8lhfJZEOF/cuv2Gck+l2erIg=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4957]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: PATCH? fix unshare(NEWPID) && vfork()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 08/20, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>>
>> > On 08/19, Andy Lutomirski wrote:
>> >>
>> >> On Mon, Aug 19, 2013 at 11:33 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >> >
>> >> > So do you think this change is fine or not (ignoring the fact it needs
>> >> > cleanups) ?
>> >>
>> >> I think that removing the CLONE_VM check is fine (although there are
>> >> some other ones that should probably be removed as well), but I'm not
>> >> sure if that check needs replacing with something else.
>> >
>> > OK, thanks... but I still can't understand.
>> >
>> > The patch I sent is equivalent to the new one below. I just tried to
>> > unify it with another check in do_fork().
>>
>> The patch below also needs CLONE_SIGHAND.  You can't meaningfully share
>> signal handlers if you can't represent the pid in the siginfo.  pids and
>> signals are too interconnected.
>
> I don't really understand. If we allow to share ->mm (with this patch),
> why it is bad to share sighand_struct->action[] ? This only shares the
> pointers to the code which handles a signal.

Not the signal queues?   I guess it is only CLONE_THREAD that shares the
signal queues between tasks.

The practical problem I am worried about with signals is in
__send_signal and the lead up to send signal, pids and uids are stored
in the struct siginfo in the namespace of the destination task.  If that
destination task shares the signal queues we can not possibly store the
proper information.

I believe that sharing just the signal handlers between tasks is also a
problem because while in principle you could distinguish the signals.
In practice it will require at least an extra system call to do so.

> However I agree it probably makes sense to deny it "just in case",
> I do not think CLONE_SIGHAND can be useful in this case.

I agree.  The only CLONE_VM case I can imagine being useful is vfork().

> But then we should also deny CLONE_SIGHAND if CLONE_NEWUSER|CLONE_NEWPID
> (another check in do_fork()). Which makes me think again we should unify
> these 2 checks.

I agree CLONE_SIGHAND if CLONE_NEWUSER|CLONE_NEWPID.

As for unifying them.  I can see colocating the related checks to keep
everything together.  I don't know about unifying them.

I know I get a little dizzy when trying to think of all of the possible
orderings of unshare and clone that can result in problem cases.

Hmm.  Thinking a little more I am half sold on unification.  If we just
handle the pid namespace by itself.  And we handle the user namespace by
itself I think things make sense.

So I am thinking something like the diff below.  CLONE_SIGHAND as in
theory you can figure out which task you are in and sort it out,
although I don't expect that to happen in practice.

Eric



diff --git a/kernel/fork.c b/kernel/fork.c
index 66635c8..0356852 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1172,12 +1172,21 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 				current->signal->flags & SIGNAL_UNKILLABLE)
 		return ERR_PTR(-EINVAL);
 
+	/* Dissallow unshare(CLONE_NEWPID) ; clone(CLONE_NEWPID).
+	 * That can result in a possibly empty parent pid namespace
+	 * which makes no sense.
+	 */
+	if ((clone_flags & CLONE_NEWPID) &&
+	    task_active_pid_ns(current) != current->nsproxy->pid_ns)
+		return ERR_PTR(-EINVAL);
+
 	/*
 	 * If the new process will be in a different pid namespace
-	 * don't allow the creation of threads.
+	 * don't allow the problematic sharing.
 	 */
-	if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
-	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
+	if ((clone_flags & (CLONE_THREAD|CLONE_SIGHAND|CLONE_PARENT)) &&
+	    ((clone_flags & CLONE_NEWPID) ||
+	     (task_active_pid_ns(current) != current->nsproxy->pid_ns))
 		return ERR_PTR(-EINVAL);
 
 	retval = security_task_create(clone_flags);
@@ -1578,8 +1587,8 @@ long do_fork(unsigned long clone_flags,
 	 * Do some preliminary argument and permissions checking before we
 	 * actually start allocating stuff
 	 */
-	if (clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) {
-		if (clone_flags & (CLONE_THREAD|CLONE_PARENT))
+	if (clone_flags & (CLONE_NEWUSER)) {
+		if (clone_flags & (CLONE_THREAD | CLONE_PARENT | CLONE_SIGHAND))
 			return -EINVAL;
 	}
 
@@ -1816,12 +1825,12 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 	 * If unsharing a user namespace must also unshare the thread.
 	 */
 	if (unshare_flags & CLONE_NEWUSER)
-		unshare_flags |= CLONE_THREAD | CLONE_FS;
+		unshare_flags |= CLONE_THREAD | CLONE_FS | CLONE_SIGHAND;
 	/*
 	 * If unsharing a pid namespace must also unshare the thread.
 	 */
 	if (unshare_flags & CLONE_NEWPID)
-		unshare_flags |= CLONE_THREAD;
+		unshare_flags |= CLONE_THREAD | CLONE_SIGHAND;
 	/*
 	 * If unsharing a thread from a thread group, must also unshare vm.
 	 */
