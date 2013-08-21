Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab3HUQl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:41:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab3HUQl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:41:27 -0400
Date: Wed, 21 Aug 2013 18:35:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Walters <walters@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH? fix unshare(NEWPID) && vfork()
Message-ID: <20130821163532.GA15152@redhat.com>
References: <20130819172524.GA22268@redhat.com> <CALCETrW+dEwR38ERQhx25-aw1dhsCE6X+9BQZJhusO88aUxN1A@mail.gmail.com> <20130819183319.GA24846@redhat.com> <CALCETrWrpNszRGCRRMLgiOopcSdDShB3Mck6gRPco=dAZeX3pQ@mail.gmail.com> <20130819184355.GA25362@redhat.com> <87siy4z1pf.fsf@xmission.com> <20130820184521.GA23293@redhat.com> <87li3ww0e6.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87li3ww0e6.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> >>
> >> The patch below also needs CLONE_SIGHAND.  You can't meaningfully share
> >> signal handlers if you can't represent the pid in the siginfo.  pids and
> >> signals are too interconnected.
> >
> > I don't really understand. If we allow to share ->mm (with this patch),
> > why it is bad to share sighand_struct->action[] ? This only shares the
> > pointers to the code which handles a signal.
>
> Not the signal queues?   I guess it is only CLONE_THREAD that shares the
> signal queues between tasks.

Yes, and we should nack CLONE_THREAD anyway.

> I believe that sharing just the signal handlers between tasks is also a
> problem because while in principle you could distinguish the signals.
> In practice it will require at least an extra system call to do so.

I still do not think this is a problem. If nothing else they share
the code, the fact that they also share the entry point for the signal
handler is not relevant, I think. And they share it anyway until the
child or parent does sigaction().

But this doesn't matter, we both agree that it would be better to deny
CLONE_SIGHAND anyway.

> So I am thinking something like the diff below.  CLONE_SIGHAND as in
> theory you can figure out which task you are in and sort it out,
> although I don't expect that to happen in practice.

Well, I do not really mind. And I won't argue if you submit this patch.

But can't we at least move this CLONE_NEWUSER to copy_process? closer
to other clone_flags checks.

As for your patch,


> +	/* Dissallow unshare(CLONE_NEWPID) ; clone(CLONE_NEWPID).
> +	 * That can result in a possibly empty parent pid namespace
> +	 * which makes no sense.
> +	 */
> +	if ((clone_flags & CLONE_NEWPID) &&
> +	    task_active_pid_ns(current) != current->nsproxy->pid_ns)
> +		return ERR_PTR(-EINVAL);

This looks unneeded... copy_pid_ns() should fail in this case, no?


> +	if ((clone_flags & (CLONE_THREAD|CLONE_SIGHAND|CLONE_PARENT)) &&
> ...
> +		if (clone_flags & (CLONE_THREAD | CLONE_PARENT | CLONE_SIGHAND))

This doesn't really matter, but CLONE_THREAD can be omitted.


Still. Can't we make a single check? Like the initial patch I sent, but
this one moves the check into copy_process() and checks CLONE_* first.
Looks a bit simpler. And more understandable to me but this is subjective.

But once again, I won't argue, it's up to you.

Oleg.

--- x/kernel/fork.c
+++ x/kernel/fork.c
@@ -1173,12 +1173,13 @@ static struct task_struct *copy_process(
 		return ERR_PTR(-EINVAL);
 
 	/*
-	 * If the new process will be in a different pid namespace
-	 * don't allow the creation of threads.
+	 * --------------  COMMENT -----------------
 	 */
-	if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
-	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
-		return ERR_PTR(-EINVAL);
+	if (clone_flags & (CLONE_SIGHAND | CLONE_PARENT)) {
+		if ((clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) ||
+		    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
+			return -EINVAL;
+	}
 
 	retval = security_task_create(clone_flags);
 	if (retval)
@@ -1575,15 +1576,6 @@ long do_fork(unsigned long clone_flags,
 	long nr;
 
 	/*
-	 * Do some preliminary argument and permissions checking before we
-	 * actually start allocating stuff
-	 */
-	if (clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) {
-		if (clone_flags & (CLONE_THREAD|CLONE_PARENT))
-			return -EINVAL;
-	}
-
-	/*
 	 * Determine whether and which event to report to ptracer.  When
 	 * called from kernel_thread or CLONE_UNTRACED is explicitly
 	 * requested, no event is reported; otherwise, report if the event

