Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbbALMbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:31:38 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:57950 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbbALMbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:31:37 -0500
Message-ID: <54B3BEA2.3020700@hitachi.com>
Date: Mon, 12 Jan 2015 21:31:30 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 2/4] perf probe: Do not rely on map__load() filter to
 find symbols
References: <1420886028-15135-1-git-send-email-namhyung@kernel.org> <1420886028-15135-2-git-send-email-namhyung@kernel.org>
In-Reply-To: <1420886028-15135-2-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/10 19:33), Namhyung Kim wrote:
> The find_probe_trace_events_from_map() searches matching symbol from a
> map (so from a backing dso).  For uprobes, it'll create a new map (and
> dso) and loads it using a filter.  It's a little bit inefficient in that
> it'll read out the symbol table everytime but works well anyway.
> 
> For kprobes however, it'll reuse existing kernel map which might be
> loaded before.  In this case map__load() just returns with no result.
> It makes kprobes always failed to find symbol even if it exists in the
> map (dso).
> 
> To fix it, use map__find_symbol_by_name() instead.  It'll load a map
> with full symbols and sorts them by name.  It needs to search sibing
> nodes since there can be multiple (local) symbols with same name.  Now
> resulting symbol references are saved in the funcs list.
> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/probe-event.c | 101 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 87 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 7f9b8632e433..e5af16988791 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -2191,20 +2191,86 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
>  	return ret;
>  }
>  
> -static char *looking_function_name;
> -static int num_matched_functions;
> +struct symbol_entry {
> +	struct list_head node;
> +	struct symbol *sym;
> +};
>  
> -static int probe_function_filter(struct map *map __maybe_unused,
> -				      struct symbol *sym)
> +/* returns 1 if symbol was added, 0 if symbol was skipped, -1 if error */
> +static int add_symbol_entry(struct symbol *sym, struct list_head *head)
>  {
> -	if ((sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL) &&
> -	    strcmp(looking_function_name, sym->name) == 0) {
> -		num_matched_functions++;
> +	struct symbol_entry *ent;
> +
> +	if (sym->binding != STB_GLOBAL && sym->binding != STB_LOCAL)
>  		return 0;
> -	}
> +
> +	ent = malloc(sizeof(*ent));
> +	if (ent == NULL)
> +		return -1;

return -ENOMEM; ?

> +
> +	ent->sym = sym;
> +	list_add(&ent->node, head);
>  	return 1;
>  }
>  
> +static int find_probe_functions(struct map *map, char *name, struct list_head *head)
> +{
> +	struct symbol *sym, *orig_sym;
> +	struct symbol_entry *ent;
> +	struct rb_node *node;
> +	int found = 0;
> +	int ret;
> +
> +	sym = map__find_symbol_by_name(map, name, NULL);
> +	if (sym == NULL)
> +		return 0;
> +
> +	ret = add_symbol_entry(sym, head);
> +	if (ret < 0)
> +		goto err;
> +
> +	found += ret;

If ret always be 1 in successful case, we'd better do "found++" here.
And it also means we can do it shorter as below.

if (add_symbol_entry(sym, head) < 0)
	goto err;
found++;

> +
> +	/* search back and forth to find symbols that have same name */

Hmm, I see. but this code looks no-good sign... Can we have any generic
synonym handling routine?

Other parts looks good to me:)

Thank you,



-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


