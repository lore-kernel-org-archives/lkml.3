Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbaKSHFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 02:05:47 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54879 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbaKSHFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 02:05:46 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: kan.liang@intel.com
Cc: acme@kernel.org, jolsa@redhat.com, a.p.zijlstra@chello.nl,
        eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, ak@linux.intel.com
Subject: Re: [PATCH V4 1/3] perf tools: enable LBR call stack support
References: <1416346617-3577-1-git-send-email-kan.liang@intel.com>
	<1416346617-3577-2-git-send-email-kan.liang@intel.com>
Date: Wed, 19 Nov 2014 16:05:43 +0900
In-Reply-To: <1416346617-3577-2-git-send-email-kan.liang@intel.com> (kan
	liang's message of "Tue, 18 Nov 2014 16:36:55 -0500")
Message-ID: <87r3wzpt4o.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014 16:36:55 -0500, kan liang wrote:
> From: Kan Liang <kan.liang@intel.com>
>
> Currently, there are two call chain recording options, fp and dwarf.
> Haswell has a new feature that utilizes the existing LBR facility to
> record call chains. So it provides the third options to record call
> chain. This patch enables the lbr call stack support.
>
> LBR call stack has some limitations. It reuses current LBR facility, so
> LBR call stack and branch record can not be enabled at the same time. It
> is only available for user callchain.
> However, LBR call stack can work on the user app which doesn't have
> frame-pointer or dwarf debug info compiled. It is a good alternative
> when nothing else works.


[SNIP]
>  static void
> -perf_evsel__config_callgraph(struct perf_evsel *evsel)
> +perf_evsel__config_callgraph(struct perf_evsel *evsel,
> +			     struct record_opts *opts)
>  {
>  	bool function = perf_evsel__is_function_event(evsel);
>  	struct perf_event_attr *attr = &evsel->attr;
>  
>  	perf_evsel__set_sample_bit(evsel, CALLCHAIN);
>  
> +	if (callchain_param.record_mode == CALLCHAIN_LBR) {
> +		if (!opts->branch_stack) {
> +			perf_evsel__set_sample_bit(evsel, BRANCH_STACK);
> +			attr->branch_sample_type = PERF_SAMPLE_BRANCH_USER |
> +						PERF_SAMPLE_BRANCH_CALL_STACK;
> +			if (attr->exclude_user) {
> +				attr->exclude_user = 0;
> +
> +				pr_warning("LBR callstack option is only available"
> +					   " to get user callchain information."
> +					   " Force exclude_user to 0.\n");
> +			}

I'm not sure what's in a higher priority - maybe I missed earlier
discussion.  IOW what about this?

			if (attr->exclude_user) {
				pr_warning("LBR callstack option is only available"
					   " to get user callchain information.\n");
			} else {
				perf_evsel__set_sample_bit(evsel, BRANCH_STACK);
				attr->branch_sample_type = PERF_SAMPLE_BRANCH_USER |
							PERF_SAMPLE_BRANCH_CALL_STACK;
			}

> +		} else
> +			 pr_info("Cannot use LBR callstack with branch stack\n");

It seems pr_warning is more appropriate here.

Thanks,
Namhyung


> +	}
> +
>  	if (callchain_param.record_mode == CALLCHAIN_DWARF) {
>  		if (!function) {
>  			perf_evsel__set_sample_bit(evsel, REGS_USER);
> @@ -659,7 +676,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
>  	}
>  
>  	if (callchain_param.enabled && !evsel->no_aux_samples)
> -		perf_evsel__config_callgraph(evsel);
> +		perf_evsel__config_callgraph(evsel, opts);
>  
>  	if (target__has_cpu(&opts->target))
>  		perf_evsel__set_sample_bit(evsel, CPU);
