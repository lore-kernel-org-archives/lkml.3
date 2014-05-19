Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbaESIVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:21:19 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:51081 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaESIVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:21:17 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/9] perf, tools: Support handling complete branch stacks as histograms v6
References: <1400259938-3436-1-git-send-email-andi@firstfloor.org>
	<1400259938-3436-2-git-send-email-andi@firstfloor.org>
Date: Mon, 19 May 2014 17:21:15 +0900
In-Reply-To: <1400259938-3436-2-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Fri, 16 May 2014 10:05:30 -0700")
Message-ID: <87fvk6ji10.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Fri, 16 May 2014 10:05:30 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Currently branch stacks can be only shown as edge histograms for
> individual branches. I never found this display particularly useful.
>
> This implements an alternative mode that creates histograms over complete
> branch traces, instead of individual branches, similar to how normal
> callgraphs are handled. This is done by putting it in
> front of the normal callgraph and then using the normal callgraph
> histogram infrastructure to unify them.
>
> This way in complex functions we can understand the control flow
> that lead to a particular sample, and may even see some control
> flow in the caller for short functions.

[SNIP]
> +static int add_callchain_ip(struct machine *machine,
> +			    struct thread *thread,
> +			    struct symbol **parent,
> +			    struct addr_location *root_al,
> +			    int cpumode,
> +			    u64 ip)
> +{
> +	struct addr_location al;
> +
> +	al.filtered = 0;
> +	al.sym = NULL;
> +	thread__find_addr_location(thread, machine, cpumode, MAP__FUNCTION,
> +				   ip, &al);
> +	if (al.sym != NULL) {
> +		if (sort__has_parent && !*parent &&
> +		    symbol__match_regex(al.sym, &parent_regex))
> +			*parent = al.sym;
> +		else if (have_ignore_callees && root_al &&
> +		  symbol__match_regex(al.sym, &ignore_callees_regex)) {
> +			/* Treat this symbol as the root,
> +			   forgetting its callees. */
> +			*root_al = al;
> +			callchain_cursor_reset(&callchain_cursor);
> +		}
> +		if (!symbol_conf.use_callchain)
> +			return -EINVAL;

This is gone with 540476de74c9 ("perf tools: Remove
symbol_conf.use_callchain check").


> +	}
> +
> +	return callchain_cursor_append(&callchain_cursor, ip, al.map, al.sym);
> +}
> +
> +#define CHASHSZ 127
> +#define CHASHBITS 7
> +#define NO_ENTRY 0xff
> +
> +#define PERF_MAX_BRANCH_DEPTH 127
> +
> +/* Remove loops. */
> +static int remove_loops(struct branch_entry *l, int nr)
> +{
> +	int i, j, off;
> +	unsigned char chash[CHASHSZ];
> +	memset(chash, -1, sizeof(chash));

s/-1/NO_ENTRY/ ?

> +
> +	BUG_ON(nr >= 256);
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
> +					(nr - (i + off))
> +					* sizeof(struct branch_entry));
> +				nr -= off;
> +			}
> +		}
> +	}
> +	return nr;
> +}
> +
>  static int machine__resolve_callchain_sample(struct machine *machine,
>  					     struct thread *thread,
>  					     struct ip_callchain *chain,
> +					     struct branch_stack *branch,
>  					     struct symbol **parent,
>  					     struct addr_location *root_al,
>  					     int max_stack)
> @@ -1290,17 +1363,73 @@ static int machine__resolve_callchain_sample(struct machine *machine,
>  	int chain_nr = min(max_stack, (int)chain->nr);
>  	int i;
>  	int err;
> +	int first_call = 0;
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
> +	if (branch->nr > PERF_MAX_BRANCH_DEPTH) {
> +		pr_warning("corrupted branch chain. skipping...\n");
> +		return 0;
> +	}
> +
> +	if (callchain_param.branch_callstack) {
> +		int nr = min(max_stack, (int)branch->nr);
> +		struct branch_entry be[nr];
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
> +				if (be[i].from < chain->ips[first_call] &&
> +				    be[i].from >= chain->ips[first_call] - 8)
> +					first_call++;

It seems that you need to check chain->ips[first_call] is greater than
PERF_CONTEXT_MAX and use such value as the cpumode...


> +			} else
> +				be[i] = branch->entries[branch->nr - i - 1];
> +		}
> +
> +		nr = remove_loops(be, nr);
> +
> +		for (i = 0; i < nr; i++) {
> +			err = add_callchain_ip(machine, thread, parent,
> +					       root_al,
> +					       -1, be[i].to);
> +			if (!err)
> +				err = add_callchain_ip(machine, thread,
> +						       parent, root_al,
> +						       -1, be[i].from);

... for here.


> +			if (err == -EINVAL)
> +				break;
> +			if (err)
> +				return err;
> +		}
> +		chain_nr -= nr;

It seems it could make some callchain nodes being ignored.  What if a
case like small callchains with matches to only 2 nodes in the LBR?

  nr = 16, chain_nr = 10 and first_call = 2

Thanks,
Namhyung
