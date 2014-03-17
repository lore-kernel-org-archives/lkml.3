Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaCQUUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 16:20:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbaCQUUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 16:20:02 -0400
Date: Mon, 17 Mar 2014 21:19:19 +0100
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
Message-ID: <20140317201919.GA28997@redhat.com>
References: <53236AA2.7030105@canonical.com> <20140317130241.7e4fde86d75d417628da6f1a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317130241.7e4fde86d75d417628da6f1a@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17, Andrew Morton wrote:
>
> On Fri, 14 Mar 2014 16:46:26 -0400 Joseph Salisbury <joseph.salisbury@canonical.com> wrote:
>
> > Hi Tetsuo,
> >
> > A kernel bug report was opened against Ubuntu[0].  We performed a kernel
> > bisect, and found that reverting the following commit resolved this bug:
> >
> >
> > commit 786235eeba0e1e85e5cbbb9f97d1087ad03dfa21
> > Author: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Date:   Tue Nov 12 15:06:45 2013 -0800
> >
> >     kthread: make kthread_create() killable
> >
> > The regression was introduced as of v3.13-rc1.
> >
> > The bug indicates an issue with the SAS controller during
> > initialization, which prevents the system from booting.  Additional
> > details are available in the bug report or on request.
> >
> > I was hoping to get your feedback, since you are the patch author.  Do
> > you think gathering any additional data will help diagnose this issue,
> > or would it be best to submit a revert request?
> >
> > [0] http://pad.lv/1276705
>
> What process is running here?  Presumably modprobe.
>
> A possible explanation is that modprobe has genuinely received a
> SIGKILL.  Can you identify anything in this setup which might send a
> SIGKILL to the modprobe process?

See also other discussion in this thread, I thinks the code in drivers/
is buggy anyway.

> kthread_create_on_node() thinks that SIGKILL came from the oom-killer
> and it cheerfully returns -ENOMEM, which is incorrect if that signal
> came from userspace.

Yes, I think it should return -EINTR.

> And I don't _think_ we prevent
> userspace-originated signals from unblocking
> wait_for_completion_killable()?

And we should not.

> Root cause time: it's wrong for the oom-killer to use SIGKILL.

Not sure... what else?

> In fact
> it's basically always wrong to send signals from in-kernel.

Well, SIGSEGV, SIGIO...

> Signals
> are a userspace IPC mechanism and using them in-kernel a) makes it hard
> (or impossible) to distinguish them from userspace-originated signals
> and b) permits userspace to produce surprising results in the kernel,
> which I suspect is what we're seeing here.

Well, I think in this case it doesn't matter who/why sends a signal.
The task is killed, it should react and exit asap. And kthread_create()
can fail in any case, at least the kernel should not crash.

Oleg.

