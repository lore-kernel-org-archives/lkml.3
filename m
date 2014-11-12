Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbaKLI7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 03:59:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaKLI7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 03:59:33 -0500
Date: Wed, 12 Nov 2014 09:59:14 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com
Subject: Re: [PATCH 2/2] perf tools: Construct LBR call chain
Message-ID: <20141112085914.GC25338@krava>
References: <1415285886-16949-1-git-send-email-kan.liang@intel.com>
 <1415285886-16949-3-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415285886-16949-3-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 09:58:06AM -0500, kan.liang@intel.com wrote:

SNIP

>  
> -static void callchain__printf(struct perf_sample *sample)
> +static void callchain__printf(struct perf_evsel *evsel,
> +			      struct perf_sample *sample)
>  {
>  	unsigned int i;
> +	u64 total_nr, callchain_nr;
> +	int lbr = 0;
>  
> -	printf("... chain: nr:%" PRIu64 "\n", sample->callchain->nr);
> +	total_nr = callchain_nr = sample->callchain->nr;
>  
> -	for (i = 0; i < sample->callchain->nr; i++)
> +	if (evsel->attr.branch_sample_type & PERF_SAMPLE_BRANCH_CALL_STACK)
> +		lbr = 1;
> +
> +	if (lbr) {
> +		struct branch_stack *lbr_stack = sample->branch_stack;
> +
> +		for (i = 0; i < callchain_nr; i++) {
> +			if (sample->callchain->ips[i] == PERF_CONTEXT_USER)
> +				break;
> +		}
> +
> +		if (i != callchain_nr) {
> +			total_nr = i + 1 + lbr_stack->nr;
> +			callchain_nr = i + 1;
> +		}
> +	}
> +
> +	printf("... chain: nr:%" PRIu64 "\n", total_nr);
> +
> +	for (i = 0; i < callchain_nr + 1; i++)
>  		printf("..... %2d: %016" PRIx64 "\n",
>  		       i, sample->callchain->ips[i]);

so if there's lbr callstack info we dont display user stack
part from standard callchain? I think the dump code should
dump out all the info..

jirka
