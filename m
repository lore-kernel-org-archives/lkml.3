Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaKLHyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:54:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbaKLHyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:54:16 -0500
Date: Wed, 12 Nov 2014 08:50:49 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com
Subject: Re: [PATCH 1/2] perf tools: enable LBR call stack support
Message-ID: <20141112075049.GB22994@krava>
References: <1415285886-16949-1-git-send-email-kan.liang@intel.com>
 <1415285886-16949-2-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415285886-16949-2-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 09:58:05AM -0500, kan.liang@intel.com wrote:

SNIP

>  };
>  
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 2f9e680..8c23607 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -537,13 +537,24 @@ int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size)
>  }
>  
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
> +			attr->exclude_user = 0;

I think we shouldn't siletly change attr->exclude_user,
if it was defined, we need to display warning that
we are changing that or fail

jirka
