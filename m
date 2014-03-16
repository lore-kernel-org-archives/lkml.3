Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaCPQZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 12:25:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbaCPQZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 12:25:52 -0400
Date: Sun, 16 Mar 2014 17:25:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: rientjes@google.com, akpm@linux-foundation.org,
        joseph.salisbury@canonical.com, torvalds@linux-foundation.org,
        tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [v3.13][v3.14][Regression] kthread: make kthread_create()
	killable
Message-ID: <20140316162512.GA9467@redhat.com>
References: <53236AA2.7030105@canonical.com> <201403150943.BIH30251.FOQLOOtFJHSMVF@I-love.SAKURA.ne.jp> <201403170013.GJF86930.FtVOOQOHLFFMSJ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201403170013.GJF86930.FtVOOQOHLFFMSJ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17, Tetsuo Handa wrote:
>
> Therefore, I'd like to propose this patch for 3.14-final
> and 3.13-stable.

Well, I disagree. To me, the patch tries to fix the problem in the wrong
place,

> Commit 786235ee "kthread: make kthread_create() killable" changed to
> leave kthread_create() as soon as receiving SIGKILL. But this change
> caused boot failures if systemd-udevd received SIGKILL (probably due
> to timeout) while loading SCSI controller drivers using
> finit_module() [1].

Shouldn't we fix the caller instead? It should handle the error from
kthread_create() correctly.

And could you tell who is the caller which doesn't do this? If it can't
be fixed, then, say, it can use workqueue to create a kernel thread.

> @@ -292,6 +292,17 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
>  	 * new kernel thread.
>  	 */
>  	if (unlikely(wait_for_completion_killable(&done))) {
> +		int i = 0;
> +
> +		/*
> +		 * I got SIGKILL, but wait for 10 more seconds for completion
> +		 * unless chosen by the OOM killer. This delay is there as a
> +		 * workaround for boot failure caused by SIGKILL upon device
> +		 * driver initialization timeout.
> +		 */
> +		while (i++ < 10 && !test_tsk_thread_flag(current, TIF_MEMDIE))
> +			if (wait_for_completion_timeout(&done, HZ))
> +				goto ready;

Personally I really dislike this hack. And btw, why we return -ENOMEM if
SIGKILL'ed? Why not EINTR ?

If nothing else we can change the caller to do

	for (;;) {
		kthread = kthread_create(...);
		if (!IS_ERR(kthread) || PTR_ERR(kthread) != -EINTR)
			break;
		// FIXME, I am stupid and can't handle SIGKILL properly
		clear_thread_flag(TIF_SIGPENDING);
	}
	recalc_sigpending();

Oleg.

