Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaKQP4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:56:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaKQP4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:56:09 -0500
Date: Mon, 17 Nov 2014 16:55:53 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com
Subject: Re: [PATCH V3 3/3] perf tools: Construct LBR call chain
Message-ID: <20141117155553.GC21532@krava.brq.redhat.com>
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

> +	if (lbr) {
> +		for (i = 0; i < chain_nr; i++) {
> +			if (chain->ips[i] == PERF_CONTEXT_USER)
> +				break;
> +		}
> +
> +		/* LBR only affects the user callchain */
> +		if (i != chain_nr) {
> +			struct branch_stack *lbr_stack = sample->branch_stack;
> +			int lbr_nr = lbr_stack->nr;
> +			/*
> +			 * LBR callstack can only get user call chain.
> +			 * The mix_chain_nr is kernel call chain
> +			 * number plus LBR user call chain number.
> +			 * i is kernel call chain number,
> +			 * 1 is PERF_CONTEXT_USER,
> +			 * lbr_nr + 1 is the user call chain number.
> +			 * For details, please refer to the comments
> +			 * in callchain__printf
> +			 */
> +			int mix_chain_nr = i + 1 + lbr_nr + 1;
> +
> +			if (mix_chain_nr > PERF_MAX_STACK_DEPTH) {
> +				pr_warning("corrupted callchain. skipping...\n");
> +				return 0;
> +			}
> +
> +			for (j = 0; j < mix_chain_nr; j++) {
> +				if (callchain_param.order == ORDER_CALLEE) {
> +					if (j < i + 1)
> +						ip = chain->ips[j];
> +					else if (j > i + 1)
> +						ip = lbr_stack->entries[j - i - 2].from;
> +					else
> +						ip = lbr_stack->entries[0].to;
> +				} else {
> +					if (j < lbr_nr)
> +						ip = lbr_stack->entries[lbr_nr - j - 1].from;
> +					else if (j > lbr_nr)
> +						ip = chain->ips[i + 1 - (j - lbr_nr)];
> +					else
> +						ip = lbr_stack->entries[0].to;
> +				}
> +
> +				err = add_callchain_ip(thread, parent, root_al,
> +						       cpumode, ip);
> +				if (err)
> +					goto exit;
> +			}
> +			return 0;
> +		}
> +	}

also could you please move whole block above into separated function?
Andi has another change for this function and it's becoming really big.

other then that I think it's ok IMO and I could ack next version

thanks,
jirka
