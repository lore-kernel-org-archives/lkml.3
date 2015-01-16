Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbbAPM0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:26:36 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:35906 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbbAPM0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:26:35 -0500
Date: Fri, 16 Jan 2015 12:26:03 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Will Deacon <Will.Deacon@arm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH] perf: drop module reference on event init failure
Message-ID: <20150116122603.GJ21809@leverpostej>
References: <1420642611-22667-1-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420642611-22667-1-git-send-email-mark.rutland@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 02:56:51PM +0000, Mark Rutland wrote:
> When initialising an event, perf_init_event will call try_module_get to
> ensure that the PMU's module cannot be removed for the lifetime of the
> event, with __free_event dropping the reference when the event is
> finally destroyed. If something fails after the event has been
> initialised, but before the event is installed, perf_event_alloc will
> drop the reference on the module.
> 
> However, if we fail to initialise an event for some reason (e.g. we ask
> an uncore PMU to perform sampling, and it refuses to initialise the
> event), we do not drop the refcount. If we try to open such a bogus
> event without a precise IDR type, we will loop over each PMU in the pmus
> list, incrementing each of their refcounts without decrementing them.
> 
> This patch adds a module_put when pmu->event_init(event) fails, ensuring
> that the refcounts are balanced in failure cases. As the innards of the
> precise and search based initialisation look very similar, this logic is
> hoisted out into a new helper function. While the early return for the
> failed try_module_get is removed from the search case, this is handled
> by the remaining return when ret is not -ENOENT.

I hate to ping, but is anyone going to look at this?

I'm happy to rework if required.

Thanks,
Mark.

> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> ---
>  kernel/events/core.c | 28 ++++++++++++++++------------
>  1 file changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 4c1ee7f..4faccf3 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6857,6 +6857,20 @@ void perf_pmu_unregister(struct pmu *pmu)
>  }
>  EXPORT_SYMBOL_GPL(perf_pmu_unregister);
>  
> +static int perf_try_init_event(struct pmu *pmu, struct perf_event *event)
> +{
> +	int ret;
> +
> +	if (!try_module_get(pmu->module))
> +		return -ENODEV;
> +	event->pmu = pmu;
> +	ret = pmu->event_init(event);
> +	if (ret)
> +		module_put(pmu->module);
> +
> +	return ret;
> +}
> +
>  struct pmu *perf_init_event(struct perf_event *event)
>  {
>  	struct pmu *pmu = NULL;
> @@ -6869,24 +6883,14 @@ struct pmu *perf_init_event(struct perf_event *event)
>  	pmu = idr_find(&pmu_idr, event->attr.type);
>  	rcu_read_unlock();
>  	if (pmu) {
> -		if (!try_module_get(pmu->module)) {
> -			pmu = ERR_PTR(-ENODEV);
> -			goto unlock;
> -		}
> -		event->pmu = pmu;
> -		ret = pmu->event_init(event);
> +		ret = perf_try_init_event(pmu, event);
>  		if (ret)
>  			pmu = ERR_PTR(ret);
>  		goto unlock;
>  	}
>  
>  	list_for_each_entry_rcu(pmu, &pmus, entry) {
> -		if (!try_module_get(pmu->module)) {
> -			pmu = ERR_PTR(-ENODEV);
> -			goto unlock;
> -		}
> -		event->pmu = pmu;
> -		ret = pmu->event_init(event);
> +		ret = perf_try_init_event(pmu, event);
>  		if (!ret)
>  			goto unlock;
>  
> -- 
> 1.9.1
> 
