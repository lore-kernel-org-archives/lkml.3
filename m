Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868AbaKMTOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:14:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:55047 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933587AbaKMTOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:14:23 -0500
Date: Thu, 13 Nov 2014 16:14:17 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 02/10] perf, tools: Support handling complete branch
 stacks as histograms
Message-ID: <20141113191417.GC3612@kernel.org>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
 <1415844328-4884-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415844328-4884-3-git-send-email-andi@firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 12, 2014 at 06:05:20PM -0800, Andi Kleen escreveu:
> +static int remove_loops(struct branch_entry *l, int nr)
> +{
> +	int i, j, off;
> +	unsigned char chash[CHASHSZ];
> +
> +	memset(chash, NO_ENTRY, sizeof(chash));
> +
> +	BUG_ON(nr >= 256);

What is wrong with return -1 and propagating the error, so that the user
is informed if the data being processed is bogus, stop processing with a
warning or continue processing if finding the next valid record is
possible?

In general just aborting (and this only does that when NDEBUG is set)
should be avoided...

I can go on and help you and do that for you, but why introduce it in
the first place?

- Arnaldo

> +	for (i = 0; i < nr; i++) {
> +		int h = hash_64(l[i].from, CHASHBITS) % CHASHSZ;
> +
> +		/* no collision handling for now */
> +		if (chash[h] == NO_ENTRY) {
> +			chash[h] = i;
> +		} else if (l[chash[h]].from == l[i].from) {
> +			bool is_loop = true;
> +			/* check if it is a real loop */
> +			off = 0;
> +			for (j = chash[h]; j < i && i + off < nr; j++, off++)
> +				if (l[j].from != l[i + off].from) {
> +					is_loop = false;
> +					break;
> +				}
> +			if (is_loop) {
> +				memmove(l + i, l + i + off,
> +					(nr - (i + off)) * sizeof(*l));
> +				nr -= off;
> +			}
> +		}
> +	}
> +	return nr;
> +}
> +
>  static int thread__resolve_callchain_sample(struct thread *thread,
>  					     struct ip_callchain *chain,
> +					     struct branch_stack *branch,
>  					     struct symbol **parent,
>  					     struct addr_location *root_al,
>  					     int max_stack)
> @@ -1438,22 +1484,82 @@ static int thread__resolve_callchain_sample(struct thread *thread,
>  	int i;
>  	int j;
>  	int err;
> -	int skip_idx __maybe_unused;
> +	int skip_idx = -1;
> +	int first_call = 0;
> +
> +	/*
> +	 * Based on DWARF debug information, some architectures skip
> +	 * a callchain entry saved by the kernel.
> +	 */
> +	if (chain->nr < PERF_MAX_STACK_DEPTH)
> +		skip_idx = arch_skip_callchain_idx(thread, chain);
>  
>  	callchain_cursor_reset(&callchain_cursor);
>  
> +	/*
> +	 * Add branches to call stack for easier browsing. This gives
> +	 * more context for a sample than just the callers.
> +	 *
> +	 * This uses individual histograms of paths compared to the
> +	 * aggregated histograms the normal LBR mode uses.
> +	 *
> +	 * Limitations for now:
> +	 * - No extra filters
> +	 * - No annotations (should annotate somehow)
> +	 */
> +
> +	if (branch && callchain_param.branch_callstack) {
> +		int nr = min(max_stack, (int)branch->nr);
> +		struct branch_entry be[nr];
> +
> +		if (branch->nr > PERF_MAX_BRANCH_DEPTH) {
> +			pr_warning("corrupted branch chain. skipping...\n");
> +			goto check_calls;
> +		}
> +
> +		for (i = 0; i < nr; i++) {
> +			if (callchain_param.order == ORDER_CALLEE) {
> +				be[i] = branch->entries[i];
> +				/*
> +				 * Check for overlap into the callchain.
> +				 * The return address is one off compared to
> +				 * the branch entry. To adjust for this
> +				 * assume the calling instruction is not longer
> +				 * than 8 bytes.
> +				 */
> +				if (i == skip_idx ||
> +				    chain->ips[first_call] >= PERF_CONTEXT_MAX)
> +					first_call++;
> +				else if (be[i].from < chain->ips[first_call] &&
> +				    be[i].from >= chain->ips[first_call] - 8)
> +					first_call++;
> +			} else
> +				be[i] = branch->entries[branch->nr - i - 1];
> +		}
> +
> +		nr = remove_loops(be, nr);
> +
> +		for (i = 0; i < nr; i++) {
> +			err = add_callchain_ip(thread, parent, root_al,
> +					       -1, be[i].to);
> +			if (!err)
> +				err = add_callchain_ip(thread, parent, root_al,
> +						       -1, be[i].from);
> +			if (err == -EINVAL)
> +				break;
> +			if (err)
> +				return err;
> +		}
> +		chain_nr -= nr;
> +	}
> +
> +check_calls:
>  	if (chain->nr > PERF_MAX_STACK_DEPTH) {
>  		pr_warning("corrupted callchain. skipping...\n");
>  		return 0;
>  	}
>  
> -	/*
> -	 * Based on DWARF debug information, some architectures skip
> -	 * a callchain entry saved by the kernel.
> -	 */
> -	skip_idx = arch_skip_callchain_idx(thread, chain);
> -
> -	for (i = 0; i < chain_nr; i++) {
> +	for (i = first_call; i < chain_nr; i++) {
>  		u64 ip;
>  
>  		if (callchain_param.order == ORDER_CALLEE)
> @@ -1517,6 +1623,7 @@ int thread__resolve_callchain(struct thread *thread,
>  			      int max_stack)
>  {
>  	int ret = thread__resolve_callchain_sample(thread, sample->callchain,
> +						   sample->branch_stack,
>  						   parent, root_al, max_stack);
>  	if (ret)
>  		return ret;
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index ded3ca7..b364d96 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -123,7 +123,8 @@ struct symbol_conf {
>  			demangle,
>  			demangle_kernel,
>  			filter_relative,
> -			show_hist_headers;
> +			show_hist_headers,
> +			branch_callstack;
>  	const char	*vmlinux_name,
>  			*kallsyms_name,
>  			*source_prefix,
> -- 
> 1.9.3
