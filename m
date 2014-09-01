Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaIAIil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:38:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50007 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaIAIij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:38:39 -0400
Date: Mon, 1 Sep 2014 10:38:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Cong Wang <cwang@twopensource.com>
Subject: Re: [Patch] perf_event: fix a race condition in
 perf_remove_from_context()
Message-ID: <20140901083828.GA27892@worktop.ger.corp.intel.com>
References: <1409268455-11807-1-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409268455-11807-1-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 04:27:35PM -0700, Cong Wang wrote:
> From: Cong Wang <cwang@twopensource.com>
> 
> We saw a kernel soft lockup in perf_remove_from_context(),
> it looks like the `perf` process, when exiting, could not go
> out of the retry loop. Meanwhile, the target process was forking
> a child. So either the target process should execute the smp
> function call to deactive the event (if it was running) or it should
> do a context switch which deactives the event.
> 
> It seems we optimize out a context switch in perf_event_context_sched_out(),
> and what's more important, we still test an obsolete task pointer when
> retrying, so no one actually would deactive that event in this situation.
> Fix it directly by reloading the task pointer in perf_remove_from_context().
> This should fix the above soft lockup.



> ---
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index f9c1ed0..c4141a0 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -1524,6 +1524,11 @@ retry:

Please use either:

.gitconfig:

[diff "default"]
        xfuncname = "^[[:alpha:]$_].*[^:]$"

.quiltrc:

QUILT_DIFF_OPTS="-F ^[[:alpha:]\$_].*[^:]\$"

>  	 */
>  	if (ctx->is_active) {
>  		raw_spin_unlock_irq(&ctx->lock);
> +		/*
> +		 * Reload the task pointer, it might have been changed by
> +		 * a concurrent perf_event_context_sched_out() without switching
> +		 */
> +		task = ctx->task;
>  		goto retry;
>  	}

You forgot to check if that same error happened in other places (it
does), please fix all of them.
