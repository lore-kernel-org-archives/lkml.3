Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab3FXIo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:44:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45626 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3FXIo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:44:27 -0400
Date: Mon, 24 Jun 2013 10:44:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH 1/8] perf,x86: disable PEBS-LL in intel_pmu_pebs_disable()
Message-ID: <20130624084414.GJ28407@twins.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
 <1371824448-7306-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371824448-7306-2-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 04:20:41PM +0200, Stephane Eranian wrote:
> Make sure intel_pmu_pebs_disable() and intel_pmu_pebs_enable()
> are symmetrical w.r.t. PEBS-LL and precise store.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

This seems unrelated to the actual patch series and should still go in.


> ---
>  arch/x86/kernel/cpu/perf_event_intel_ds.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index ed3e553..3065c57 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -653,6 +653,12 @@ void intel_pmu_pebs_disable(struct perf_event *event)
>  	struct hw_perf_event *hwc = &event->hw;
>  
>  	cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
> +
> +	if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_LDLAT)
> +		cpuc->pebs_enabled &= ~(1ULL << (hwc->idx + 32));
> +	else if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_ST)
> +		cpuc->pebs_enabled &= ~(1ULL << 63);
> +
>  	if (cpuc->enabled)
>  		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
>  
> -- 
> 1.8.1.2
> 
