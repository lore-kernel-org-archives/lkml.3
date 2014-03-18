Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbaCRRqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:46:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756705AbaCRRqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:46:10 -0400
Date: Tue, 18 Mar 2014 18:45:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com,
        Linus Torvalds <torvalds@linux-foundation.org>, tj@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@lists.ubuntu.com>
Subject: Re: [v3.13][v3.14][Regression] kthread: make kthread_create()
	killable
Message-ID: <20140318174527.GA11866@redhat.com>
References: <53236AA2.7030105@canonical.com> <20140317130241.7e4fde86d75d417628da6f1a@linux-foundation.org> <20140317201919.GA28997@redhat.com> <20140317133920.7b944250d90886daa8ea4287@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317133920.7b944250d90886daa8ea4287@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17, Andrew Morton wrote:
>
> On Mon, 17 Mar 2014 21:19:19 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > > Root cause time: it's wrong for the oom-killer to use SIGKILL.
> >
> > Not sure... what else?
>
> If we really really have to use userspace IPC in the kernel then I
> suppose we could add a new signal type (SIGKERNEL?) which userspace can
> neither receive nor send.

But for what?

> > > In fact
> > > it's basically always wrong to send signals from in-kernel.
> >
> > Well, SIGSEGV, SIGIO...
>
> Those are kernel->userspace, not kernel->kernel.

OK, this is probably true.

> We have all sorts of cross-task mechanisms available in kernel (set_bit
> and wake_up would suffice here) so we don't need to use signals with
> all the baggage they bring along.

but why do we need another mechanism if we want terminate the task
for any reason?

OK. Perhaps the killed task wants to know if it was killed by kernel
or user-space... Not sure we really need this, but OK. We can add the
SIGNAL_GROUP_KILLED_BY_KERNEL flag. But it is not clear if we want
TASK_WAKEKILL_BY_KERNEL or not... And probably I missed your point.

> > Well, I think in this case it doesn't matter who/why sends a signal.
> > The task is killed, it should react and exit asap. And kthread_create()
> > can fail in any case, at least the kernel should not crash.
>
> Well yes.  In this "bug", userspace tried to kill udev and surprise
> surprise, that's what happened.  The only real kernel bug here is the
> incorrect errno.

and the kernel crash in mptsas_probe's error paths. This should be fixed.
And it seems that this driver has more problems, but I can be wrong.

> But in the real world, the kernel changed and systems
> broke - we should try to unbreak them.

Yes, yes, sure. But so far I think we should uglify the driver or scsi
(unless we have the right fix), not the poor kthread_create().

Oleg.

