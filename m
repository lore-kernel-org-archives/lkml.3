Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbaHVPVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:21:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:58962 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459AbaHVPVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:21:54 -0400
Date: Fri, 22 Aug 2014 12:21:48 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v3] perf hists browser: Consolidate callchain print
 functions in TUI
Message-ID: <20140822152148.GA4064@kernel.org>
References: <1408666401-594-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408666401-594-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 22, 2014 at 09:13:21AM +0900, Namhyung Kim escreveu:
> Currently there're two callchain print functions in TUI - one for the
> hists browser and another for file dump.  They do almost same job so
> it'd be better consolidate the codes.
> 
> To do that, provide two callbacks to the generic logic - one for
> printing and another for checking whether it should stop.

Thanks a lot, I just changed the name of the check_output_full_fn
parameter to "is_output_full", as "check" is way too generic to help one
understand what is it that is being checked.

I also aligned aligned the members of the struct callchain_print_arg, as
suggested by Ingo.

Applied.

- Arnaldo
 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/ui/browsers/hists.c | 203 ++++++++++++++++-------------------------
>  1 file changed, 80 insertions(+), 123 deletions(-)
> 
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index 519353d9f5fb..026421e0d53d 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -477,20 +477,37 @@ static char *callchain_list__sym_name(struct callchain_list *cl,
>  	return bf;
>  }
>  
> +struct callchain_print_arg {
> +	/* for hists browser */
> +	off_t row_offset;
> +	bool is_current_entry;
> +
> +	/* for file dump */
> +	FILE *fp;
> +	int printed;
> +};
> +
> +typedef void (*print_callchain_entry_fn)(struct hist_browser *browser,
> +					 struct callchain_list *chain,
> +					 const char *str, int offset,
> +					 unsigned short row,
> +					 struct callchain_print_arg *arg);
> +
>  static void hist_browser__show_callchain_entry(struct hist_browser *browser,
>  					       struct callchain_list *chain,
> -					       unsigned short row, int offset,
> -					       char folded_sign, const char *str,
> -					       bool *is_current_entry)
> +					       const char *str, int offset,
> +					       unsigned short row,
> +					       struct callchain_print_arg *arg)
>  {
>  	int color, width;
> +	char folded_sign = callchain_list__folded(chain);
>  
>  	color = HE_COLORSET_NORMAL;
>  	width = browser->b.width - (offset + 2);
>  	if (ui_browser__is_current_entry(&browser->b, row)) {
>  		browser->selection = &chain->ms;
>  		color = HE_COLORSET_SELECTED;
> -		*is_current_entry = true;
> +		arg->is_current_entry = true;
>  	}
>  
>  	ui_browser__set_color(&browser->b, color);
> @@ -500,12 +517,41 @@ static void hist_browser__show_callchain_entry(struct hist_browser *browser,
>  	slsmg_write_nstring(str, width);
>  }
>  
> +static void hist_browser__fprintf_callchain_entry(struct hist_browser *b __maybe_unused,
> +						  struct callchain_list *chain,
> +						  const char *str, int offset,
> +						  unsigned short row __maybe_unused,
> +						  struct callchain_print_arg *arg)
> +{
> +	char folded_sign = callchain_list__folded(chain);
> +
> +	arg->printed += fprintf(arg->fp, "%*s%c %s\n", offset, " ",
> +				folded_sign, str);
> +}
> +
> +typedef bool (*check_output_full_fn)(struct hist_browser *browser,
> +				     unsigned short row);
> +
> +static bool hist_browser__check_output_full(struct hist_browser *browser,
> +					    unsigned short row)
> +{
> +	return browser->b.rows == row;
> +}
> +
> +static bool hist_browser__check_dump_full(struct hist_browser *browser __maybe_unused,
> +					  unsigned short row __maybe_unused)
> +{
> +	return false;
> +}
> +
>  #define LEVEL_OFFSET_STEP 3
>  
>  static int hist_browser__show_callchain(struct hist_browser *browser,
>  					struct rb_root *root, int level,
> -					unsigned short row, off_t *row_offset,
> -					u64 total, bool *is_current_entry)
> +					unsigned short row, u64 total,
> +					print_callchain_entry_fn print,
> +					struct callchain_print_arg *arg,
> +					check_output_full_fn check)
>  {
>  	struct rb_node *node;
>  	int first_row = row, offset = level * LEVEL_OFFSET_STEP;
> @@ -532,8 +578,8 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
>  				extra_offset = LEVEL_OFFSET_STEP;
>  
>  			folded_sign = callchain_list__folded(chain);
> -			if (*row_offset != 0) {
> -				--*row_offset;
> +			if (arg->row_offset != 0) {
> +				arg->row_offset--;
>  				goto do_next;
>  			}
>  
> @@ -550,13 +596,11 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
>  					str = alloc_str;
>  			}
>  
> -			hist_browser__show_callchain_entry(browser, chain, row,
> -							   offset + extra_offset,
> -							   folded_sign, str,
> -							   is_current_entry);
> +			print(browser, chain, str, offset + extra_offset, row, arg);
> +
>  			free(alloc_str);
>  
> -			if (++row == browser->b.rows)
> +			if (check(browser, ++row))
>  				goto out;
>  do_next:
>  			if (folded_sign == '+')
> @@ -572,12 +616,10 @@ do_next:
>  				new_total = total;
>  
>  			row += hist_browser__show_callchain(browser, &child->rb_root,
> -							    new_level,
> -							    row, row_offset,
> -							    new_total,
> -							    is_current_entry);
> +							    new_level, row, new_total,
> +							    print, arg, check);
>  		}
> -		if (row == browser->b.rows)
> +		if (check(browser, row))
>  			break;
>  		node = next;
>  	}
> @@ -757,16 +799,20 @@ static int hist_browser__show_entry(struct hist_browser *browser,
>  
>  	if (folded_sign == '-' && row != browser->b.rows) {
>  		u64 total = hists__total_period(entry->hists);
> +		struct callchain_print_arg arg = {
> +			.row_offset = row_offset,
> +			.is_current_entry = current_entry,
> +		};
>  
>  		if (symbol_conf.cumulate_callchain)
>  			total = entry->stat_acc->period;
>  
>  		printed += hist_browser__show_callchain(browser,
> -							&entry->sorted_chain,
> -							1, row, &row_offset,
> -							total, &current_entry);
> +					&entry->sorted_chain, 1, row, total,
> +					hist_browser__show_callchain_entry, &arg,
> +					hist_browser__check_output_full);
>  
> -		if (current_entry)
> +		if (arg.is_current_entry)
>  			browser->he_selection = entry;
>  	}
>  
> @@ -1022,110 +1068,21 @@ do_offset:
>  	}
>  }
>  
> -static int hist_browser__fprintf_callchain_node_rb_tree(struct hist_browser *browser,
> -							struct callchain_node *chain_node,
> -							u64 total, int level,
> -							FILE *fp)
> -{
> -	struct rb_node *node;
> -	int offset = level * LEVEL_OFFSET_STEP;
> -	u64 new_total;
> -	int printed = 0;
> -
> -	if (callchain_param.mode == CHAIN_GRAPH_REL)
> -		new_total = chain_node->children_hit;
> -	else
> -		new_total = total;
> -
> -	node = rb_first(&chain_node->rb_root);
> -	while (node) {
> -		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
> -		struct rb_node *next = rb_next(node);
> -		u64 cumul = callchain_cumul_hits(child);
> -		struct callchain_list *chain;
> -		char folded_sign = ' ';
> -		int first = true;
> -		int extra_offset = 0;
> -
> -		list_for_each_entry(chain, &child->val, list) {
> -			char bf[1024], *alloc_str;
> -			const char *str;
> -			bool was_first = first;
> -
> -			if (first)
> -				first = false;
> -			else
> -				extra_offset = LEVEL_OFFSET_STEP;
> -
> -			folded_sign = callchain_list__folded(chain);
> -
> -			alloc_str = NULL;
> -			str = callchain_list__sym_name(chain, bf, sizeof(bf),
> -						       browser->show_dso);
> -			if (was_first) {
> -				double percent = cumul * 100.0 / new_total;
> -
> -				if (asprintf(&alloc_str, "%2.2f%% %s", percent, str) < 0)
> -					str = "Not enough memory!";
> -				else
> -					str = alloc_str;
> -			}
> -
> -			printed += fprintf(fp, "%*s%c %s\n", offset + extra_offset, " ", folded_sign, str);
> -			free(alloc_str);
> -			if (folded_sign == '+')
> -				break;
> -		}
> -
> -		if (folded_sign == '-') {
> -			const int new_level = level + (extra_offset ? 2 : 1);
> -			printed += hist_browser__fprintf_callchain_node_rb_tree(browser, child, new_total,
> -										new_level, fp);
> -		}
> -
> -		node = next;
> -	}
> -
> -	return printed;
> -}
> -
> -static int hist_browser__fprintf_callchain_node(struct hist_browser *browser,
> -						struct callchain_node *node,
> -						int level, FILE *fp)
> -{
> -	struct callchain_list *chain;
> -	int offset = level * LEVEL_OFFSET_STEP;
> -	char folded_sign = ' ';
> -	int printed = 0;
> -
> -	list_for_each_entry(chain, &node->val, list) {
> -		char bf[1024], *s;
> -
> -		folded_sign = callchain_list__folded(chain);
> -		s = callchain_list__sym_name(chain, bf, sizeof(bf), browser->show_dso);
> -		printed += fprintf(fp, "%*s%c %s\n", offset, " ", folded_sign, s);
> -	}
> -
> -	if (folded_sign == '-')
> -		printed += hist_browser__fprintf_callchain_node_rb_tree(browser, node,
> -									browser->hists->stats.total_period,
> -									level + 1,  fp);
> -	return printed;
> -}
> -
>  static int hist_browser__fprintf_callchain(struct hist_browser *browser,
> -					   struct rb_root *chain, int level, FILE *fp)
> +					   struct hist_entry *he, FILE *fp)
>  {
> -	struct rb_node *nd;
> -	int printed = 0;
> -
> -	for (nd = rb_first(chain); nd; nd = rb_next(nd)) {
> -		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
> +	u64 total = hists__total_period(he->hists);
> +	struct callchain_print_arg arg  = {
> +		.fp = fp,
> +	};
>  
> -		printed += hist_browser__fprintf_callchain_node(browser, node, level, fp);
> -	}
> +	if (symbol_conf.cumulate_callchain)
> +		total = he->stat_acc->period;
>  
> -	return printed;
> +	hist_browser__show_callchain(browser, &he->sorted_chain, 1, 0, total,
> +				     hist_browser__fprintf_callchain_entry, &arg,
> +				     hist_browser__check_dump_full);
> +	return arg.printed;
>  }
>  
>  static int hist_browser__fprintf_entry(struct hist_browser *browser,
> @@ -1164,7 +1121,7 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
>  	printed += fprintf(fp, "%s\n", rtrim(s));
>  
>  	if (folded_sign == '-')
> -		printed += hist_browser__fprintf_callchain(browser, &he->sorted_chain, 1, fp);
> +		printed += hist_browser__fprintf_callchain(browser, he, fp);
>  
>  	return printed;
>  }
> -- 
> 2.0.0
