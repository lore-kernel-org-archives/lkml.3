Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaKLMeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 07:34:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbaKLMeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:34:17 -0500
Date: Wed, 12 Nov 2014 13:33:43 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com
Subject: Re: [PATCH 2/2] perf tools: Construct LBR call chain
Message-ID: <20141112123305.GA27796@krava.redhat.com>
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
> From: Kan Liang <kan.liang@intel.com>
> 

SNIP

> +	/* LBR call stack */
> +	if (lbr) {
> +		struct branch_stack *lbr_stack = sample->branch_stack;
> +		int lbr_nr = lbr_stack->nr;
> +		int mix_chain_nr;
>  
> -		if (callchain_param.order == ORDER_CALLEE)
> -			j = i;
> -		else
> -			j = chain->nr - i - 1;
> +		for (i = 0; i < chain_nr; i++) {
> +			if (chain->ips[i] == PERF_CONTEXT_USER)
> +				break;
> +		}
>  
> -#ifdef HAVE_SKIP_CALLCHAIN_IDX
> -		if (j == skip_idx)
> -			continue;
> -#endif
> -		ip = chain->ips[j];
> +		/* LBR only affects the user callchain */
> +		if (i == chain_nr) {
> +			lbr = 0;
> +			goto again;
> +		}

'goto again' sounds like u want to try something again,
but you prepare the condition already with lbr = 0,
could you please restruct the code in another way?


SNIP

> +				goto exit;
>  		}
> +	} else {
>  
> -		err = callchain_cursor_append(&callchain_cursor,
> -					      ip, al.map, al.sym);
> -		if (err)
> -			return err;
> -	}
> +		/*
> +		 * Based on DWARF debug information, some architectures skip
> +		 * a callchain entry saved by the kernel.
> +		 */
> +		skip_idx = arch_skip_callchain_idx(thread, chain);
>  
> -	return 0;
> +		for (i = 0; i < chain_nr; i++) {
> +			struct addr_location al;
> +
> +			if (callchain_param.order == ORDER_CALLEE)
> +				j = i;
> +			else
> +				j = chain->nr - i - 1;
> +
> +#ifdef HAVE_SKIP_CALLCHAIN_IDX
> +			if (j == skip_idx)
> +				continue;
> +#endif
> +			ip = chain->ips[j];
> +			err = __thread__resolve_callchain_sample(thread,

Uou factored out the common functionality into __thread__resolve_callchain_sample
function and added your own functionality.. could you please split this into 2
separate patches? (first the new function, then your change)
IMO It'll make the change simple and more obvious.

thanks,
jirka
