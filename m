Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaKQPyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:54:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbaKQPys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:54:48 -0500
Date: Mon, 17 Nov 2014 16:54:25 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com
Subject: Re: [PATCH V3 3/3] perf tools: Construct LBR call chain
Message-ID: <20141117155425.GA31042@krava.brq.redhat.com>
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
 <1415972652-17310-4-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415972652-17310-4-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 08:44:12AM -0500, kan.liang@intel.com wrote:

SNIP

> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index f4478ce..335c3a9 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -557,15 +557,63 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
>  	return 0;
>  }
>  
> -static void callchain__printf(struct perf_sample *sample)
> +static void callchain__printf(struct perf_evsel *evsel,
> +			      struct perf_sample *sample)
>  {
>  	unsigned int i;
> +	struct ip_callchain *callchain = sample->callchain;
> +	bool lbr = has_branch_callstack(evsel);
>  
> -	printf("... chain: nr:%" PRIu64 "\n", sample->callchain->nr);
> +	if (lbr) {
> +		struct branch_stack *lbr_stack = sample->branch_stack;
> +		u64 kernel_callchain_nr = callchain->nr;
>  
> -	for (i = 0; i < sample->callchain->nr; i++)
> +		for (i = 0; i < kernel_callchain_nr; i++) {
> +			if (callchain->ips[i] == PERF_CONTEXT_USER)
> +				break;
> +		}
> +
> +		if ((i != kernel_callchain_nr) && lbr_stack->nr) {
> +			u64 total_nr;
> +			/*
> +			 * LBR callstack can only get user call chain,
> +			 * i is kernel call chain number,
> +			 * 1 is PERF_CONTEXT_USER.
> +			 *
> +			 * The user call chain is stored in LBR registers.
> +			 * LBR are pair registers. The caller is stored
> +			 * in "from" register, while the callee is stored
> +			 * in "to" register.
> +			 * For example, there is a call stack
> +			 * "A"->"B"->"C"->"D".
> +			 * The LBR registers will recorde like
> +			 * "C"->"D", "B"->"C", "A"->"B".
> +			 * So only the first "to" register and all "from"
> +			 * registers are needed to construct the whole stack.
> +			 */

Andi is using some sanity checks:
http://marc.info/?l=linux-kernel&m=141584447819894&w=2
I guess this could be applied in here, once his patch gets in.

jirka
