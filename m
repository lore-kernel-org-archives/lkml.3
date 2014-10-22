Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaJVBFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 21:05:08 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:49651 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaJVBFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 21:05:06 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] perf, tools: Support handling complete branch stacks as histograms
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
	<1411774636-6870-2-git-send-email-andi@firstfloor.org>
Date: Wed, 22 Oct 2014 10:03:51 +0900
In-Reply-To: <1411774636-6870-2-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Fri, 26 Sep 2014 16:37:09 -0700")
Message-ID: <87r3y0gbk8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Fri, 26 Sep 2014 16:37:09 -0700, Andi Kleen wrote:
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
>
> Example (simplified, of course for such simple code this
> is usually not needed):
>
> tcall.c:
>
> volatile a = 10000, b = 100000, c;
>
> __attribute__((noinline)) f2()
> {
> 	c = a / b;
> }
>
> __attribute__((noinline)) f1()
> {
> 	f2();
> 	f2();
> }
> main()
> {
> 	int i;
> 	for (i = 0; i < 1000000; i++)
> 		f1();
> }
>
> % perf record -b -g ./tsrc/tcall
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.044 MB perf.data (~1923 samples) ]
> % perf report --branch-history
> ...
>     54.91%  tcall.c:6  [.] f2                      tcall
>             |
>             |--65.53%-- f2 tcall.c:5
>             |          |
>             |          |--70.83%-- f1 tcall.c:11
>             |          |          f1 tcall.c:10
>             |          |          main tcall.c:18
>             |          |          main tcall.c:18
>             |          |          main tcall.c:17
>             |          |          main tcall.c:17
>             |          |          f1 tcall.c:13
>             |          |          f1 tcall.c:13
>             |          |          f2 tcall.c:7
>             |          |          f2 tcall.c:5
>             |          |          f1 tcall.c:12
>             |          |          f1 tcall.c:12
>             |          |          f2 tcall.c:7
>             |          |          f2 tcall.c:5
>             |          |          f1 tcall.c:11

I think it'd be better if it just prints function names as normal
callchain does (and optionally srcline with a switch) and duplicates
removed like below:

     54.91%  tcall.c:6  [.] f2                      tcall
             |
             |--65.53%-- f2 tcall.c:5
             |          |
             |          |--70.83%-- f1
             |          |          main
             |          |          f1
             |          |          f2
             |          |          f1
             |          |          f2


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
> +	if (cpumode == -1)
> +		thread__find_cpumode_addr_location(thread, machine, MAP__FUNCTION, ip, &al);
> +	else
> +		thread__find_addr_location(thread, machine, cpumode, MAP__FUNCTION,
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

This check already went away.

And, to remove duplicates, I think we need to check last callchain
cursor node wrt the callchain_param.key here.


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
> +	memset(chash, NO_ENTRY, sizeof(chash));
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

					(nr - (i + off)) * sizeof(*l));


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
> @@ -1377,9 +1453,66 @@ static int machine__resolve_callchain_sample(struct machine *machine,
>  	int j;
>  	int err;
>  	int skip_idx __maybe_unused;
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
> +	if (branch && callchain_param.branch_callstack) {
> +		int nr = min(max_stack, (int)branch->nr);
> +		struct branch_entry be[nr];
> +
> +		if (branch->nr > PERF_MAX_BRANCH_DEPTH) {
> +			pr_warning("corrupted branch chain. skipping...\n");
> +			return 0;

Not checking normal callchains here?


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
> +				if (be[i].from < chain->ips[first_call] &&
> +				    be[i].from >= chain->ips[first_call] - 8)
> +					first_call++;

chain->ips[0] is a context info and you should skip that before
comparing addresses.  Something like below:

				if (chain->ips[first_call] >= PERF_CONTEXT_MAX)
					first_call++;

Also, by comparing 'from' address, I'd expect you add the from address
alone but you add both of 'from' and 'to'.  Do we really need to do
that?

And the first address saved in normal callchain is address of the
function itself so it might be 'to' you need to check if sampled before
any branch in a function.


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
> +			if (err == -EINVAL)
> +				break;
> +			if (err)
> +				return err;
> +		}
> +		chain_nr -= nr;

I'm not sure this line is needed.

Thanks,
Namhyung


> +	}
> +
>  	if (chain->nr > PERF_MAX_STACK_DEPTH) {
>  		pr_warning("corrupted callchain. skipping...\n");
>  		return 0;
> @@ -1391,9 +1524,8 @@ static int machine__resolve_callchain_sample(struct machine *machine,
>  	 */
>  	skip_idx = arch_skip_callchain_idx(machine, thread, chain);
>  
> -	for (i = 0; i < chain_nr; i++) {
> +	for (i = first_call; i < chain_nr; i++) {
>  		u64 ip;
> -		struct addr_location al;
>  
>  		if (callchain_param.order == ORDER_CALLEE)
>  			j = i;
> @@ -1430,24 +1562,10 @@ static int machine__resolve_callchain_sample(struct machine *machine,
>  			continue;
>  		}
>  
> -		al.filtered = 0;
> -		thread__find_addr_location(thread, machine, cpumode,
> -					   MAP__FUNCTION, ip, &al);
> -		if (al.sym != NULL) {
> -			if (sort__has_parent && !*parent &&
> -			    symbol__match_regex(al.sym, &parent_regex))
> -				*parent = al.sym;
> -			else if (have_ignore_callees && root_al &&
> -			  symbol__match_regex(al.sym, &ignore_callees_regex)) {
> -				/* Treat this symbol as the root,
> -				   forgetting its callees. */
> -				*root_al = al;
> -				callchain_cursor_reset(&callchain_cursor);
> -			}
> -		}
> -
> -		err = callchain_cursor_append(&callchain_cursor,
> -					      ip, al.map, al.sym);
> +		err = add_callchain_ip(machine, thread, parent, root_al,
> +				       cpumode, ip);
> +		if (err == -EINVAL)
> +			break;
>  		if (err)
>  			return err;
>  	}
> @@ -1473,7 +1591,9 @@ int machine__resolve_callchain(struct machine *machine,
>  	int ret;
>  
>  	ret = machine__resolve_callchain_sample(machine, thread,
> -						sample->callchain, parent,
> +						sample->callchain,
> +						sample->branch_stack,
> +						parent,
>  						root_al, max_stack);
>  	if (ret)
>  		return ret;
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index bec4b7b..bae04e2 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -122,7 +122,8 @@ struct symbol_conf {
>  			demangle,
>  			demangle_kernel,
>  			filter_relative,
> -			show_hist_headers;
> +			show_hist_headers,
> +			branch_callstack;
>  	const char	*vmlinux_name,
>  			*kallsyms_name,
>  			*source_prefix,
