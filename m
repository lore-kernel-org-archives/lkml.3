Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaCQUjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 16:39:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaCQUjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 16:39:23 -0400
Date: Mon, 17 Mar 2014 13:39:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com,
        Linus Torvalds <torvalds@linux-foundation.org>, tj@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@lists.ubuntu.com>
Subject: Re: [v3.13][v3.14][Regression] kthread: make kthread_create()
 killable
Message-Id: <20140317133920.7b944250d90886daa8ea4287@linux-foundation.org>
In-Reply-To: <20140317201919.GA28997@redhat.com>
References: <53236AA2.7030105@canonical.com>
	<20140317130241.7e4fde86d75d417628da6f1a@linux-foundation.org>
	<20140317201919.GA28997@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2014 21:19:19 +0100 Oleg Nesterov <oleg@redhat.com> wrote:

> > kthread_create_on_node() thinks that SIGKILL came from the oom-killer
> > and it cheerfully returns -ENOMEM, which is incorrect if that signal
> > came from userspace.
> 
> Yes, I think it should return -EINTR.
> 
> > And I don't _think_ we prevent
> > userspace-originated signals from unblocking
> > wait_for_completion_killable()?
> 
> And we should not.
> 
> > Root cause time: it's wrong for the oom-killer to use SIGKILL.
> 
> Not sure... what else?

If we really really have to use userspace IPC in the kernel then I
suppose we could add a new signal type (SIGKERNEL?) which userspace can
neither receive nor send.

> > In fact
> > it's basically always wrong to send signals from in-kernel.
> 
> Well, SIGSEGV, SIGIO...

Those are kernel->userspace, not kernel->kernel.

We have all sorts of cross-task mechanisms available in kernel (set_bit
and wake_up would suffice here) so we don't need to use signals with
all the baggage they bring along.

We used to do a lot more kernel signalling, but quite a lot got weeded
out years ago.  The favorite failure mode was for a task to use
TASK_INTERRUPTIBLE so that a kernel-sent signal could wake it up. 
Whoops, drivers would outright fail if the calling task happened to
have SIGINT pending!

> > Signals
> > are a userspace IPC mechanism and using them in-kernel a) makes it hard
> > (or impossible) to distinguish them from userspace-originated signals
> > and b) permits userspace to produce surprising results in the kernel,
> > which I suspect is what we're seeing here.
> 
> Well, I think in this case it doesn't matter who/why sends a signal.
> The task is killed, it should react and exit asap. And kthread_create()
> can fail in any case, at least the kernel should not crash.

Well yes.  In this "bug", userspace tried to kill udev and surprise
surprise, that's what happened.  The only real kernel bug here is the
incorrect errno.  But in the real world, the kernel changed and systems
broke - we should try to unbreak them.
