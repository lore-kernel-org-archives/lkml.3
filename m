Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbaCQMiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 08:38:24 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51100 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906AbaCQMiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 08:38:23 -0400
X-Nat-Received: from [202.181.97.72]:58386 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1395059901.11978
To: oleg@redhat.com
Cc: rientjes@google.com, akpm@linux-foundation.org,
        joseph.salisbury@canonical.com, torvalds@linux-foundation.org,
        tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [v3.13][v3.14][Regression] kthread: make kthread_create()killable
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <53236AA2.7030105@canonical.com>
	<201403150943.BIH30251.FOQLOOtFJHSMVF@I-love.SAKURA.ne.jp>
	<201403170013.GJF86930.FtVOOQOHLFFMSJ@I-love.SAKURA.ne.jp>
	<20140316162512.GA9467@redhat.com>
In-Reply-To: <20140316162512.GA9467@redhat.com>
Message-Id: <201403172138.GFB43278.OOOFFSQLVHJMtF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 17 Mar 2014 21:38:19 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 17032014 #7535038, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> > @@ -292,6 +292,17 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
> >  	 * new kernel thread.
> >  	 */
> >  	if (unlikely(wait_for_completion_killable(&done))) {
> > +		int i = 0;
> > +
> > +		/*
> > +		 * I got SIGKILL, but wait for 10 more seconds for completion
> > +		 * unless chosen by the OOM killer. This delay is there as a
> > +		 * workaround for boot failure caused by SIGKILL upon device
> > +		 * driver initialization timeout.
> > +		 */
> > +		while (i++ < 10 && !test_tsk_thread_flag(current, TIF_MEMDIE))
> > +			if (wait_for_completion_timeout(&done, HZ))
> > +				goto ready;
> 
> Personally I really dislike this hack. And btw, why we return -ENOMEM if
> SIGKILL'ed? Why not EINTR ?

I chose -ENOMEM because -ENOMEM looked better for conveying that current thread
was SIGKILLed by the OOM killer in order to solve no memory state. But I forgot
that -ENOMEM will not convey the reason properly if current thread was
SIGKILLed by other than the OOM killer. Maybe

  return test_tsk_thread_flag(current, TIF_MEMDIE) ? -ENOMEM : -EINTR;

rather than

  return -ENOMEM;

?

> > Commit 786235ee "kthread: make kthread_create() killable" changed to
> > leave kthread_create() as soon as receiving SIGKILL. But this change
> > caused boot failures if systemd-udevd received SIGKILL (probably due
> > to timeout) while loading SCSI controller drivers using
> > finit_module() [1].
> 
> Shouldn't we fix the caller instead? It should handle the error from
> kthread_create() correctly.
> 
> And could you tell who is the caller which doesn't do this? If it can't
> be fixed, then, say, it can use workqueue to create a kernel thread.
> 

There are many callers. One of them is scsi_host_alloc() which is called
upon bootup in order to recognize SCSI storage devices.

To my surprise, systemd-udevd process sends SIGKILL to worker systemd-udevd
processes if they did not complete their jobs within 30 seconds. On some
machines, it takes more than 30 seconds to recognize SCSI storage devices.

On such machines, scsi_host_alloc() is called after the worker process
received SIGKILL. Since commit 786235ee "kthread: make kthread_create()
killable" broke all callers of kthread_create() who had been able to survive
SIGKILL, I think fixing this regression at kthread_create() is the appropriate
response.

Given that said, which one do we prefer?

  (a) Wait for completion forever after receiving SIGKILL, unless chosen
      by the OOM killer.

  (b) Wait for completion for only limited duration after receiving SIGKILL.

This patch is (b) which waits for only 10 seconds after receiving SIGKILL.
(a) will change "kthread: make kthread_create() killable" to
"kthread: allow the OOM-killer to kill kthread_create()".
