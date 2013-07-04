Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3GDMmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:42:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38846 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab3GDMmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:42:05 -0400
Date: Thu, 4 Jul 2013 14:41:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH v2 3/7] perf, x86: Introduce x86 special perf event
 context
Message-ID: <20130704124148.GI23916@twins.programming.kicks-ass.net>
References: <1372663387-11754-1-git-send-email-zheng.z.yan@intel.com>
 <1372663387-11754-4-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372663387-11754-4-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 03:23:03PM +0800, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> The x86 special perf event context is named x86_perf_event_context,
> We can enlarge it later to store PMU special data.

This changelog is completely inadequate. It fails to state what and why
we do things.

I hate doing this; but I can't see another way around it either. That
said:

> @@ -274,6 +274,11 @@ struct pmu {
>  	 * flush branch stack on context-switches (needed in cpu-wide mode)
>  	 */
>  	void (*flush_branch_stack)	(void);
> +
> +	/*
> +	 * Allocate PMU special perf event context
> +	 */
> +	void *(*event_context_alloc)	(struct perf_event_context *parent_ctx);
>  };

It should be *optional*, also wtf is that parent_ctx thing for?

> +++ b/kernel/events/core.c
> @@ -2961,13 +2961,20 @@ static void __perf_event_init_context(struct perf_event_context *ctx)
>  }
>  
>  static struct perf_event_context *
> -alloc_perf_context(struct pmu *pmu, struct task_struct *task)
> +alloc_perf_context(struct pmu *pmu, struct task_struct *task,
> +		   struct perf_event_context *parent_ctx)
>  {
>  	struct perf_event_context *ctx;
>  
> -	ctx = kzalloc(sizeof(struct perf_event_context), GFP_KERNEL);
> -	if (!ctx)
> -		return NULL;
> +	if (pmu->event_context_alloc) {
> +		ctx = pmu->event_context_alloc(parent_ctx);
> +		if (IS_ERR(ctx))
> +			return ctx;
> +	} else {
> +		ctx = kzalloc(sizeof(struct perf_event_context), GFP_KERNEL);
> +		if (!ctx)
> +			return ERR_PTR(-ENOMEM);
> +	}
>  
>  	__perf_event_init_context(ctx);
>  	if (task) {

I'm not at all sure we want to do it like this; why not simply query the
size. Something like:

  alloc_perf_context(struct pmu *pmu, struct task_struct *task)
  {
    size_t ctx_size = sizeof(struct perf_event_context);

    if (pmu->task_context_size)
      size = pmu->task_context_size();

    ctx = kzalloc(size, GFP_KERNEL);
    if (!ctx)
      return ERR_PTR(-ENOMEM);

    ...

  }


