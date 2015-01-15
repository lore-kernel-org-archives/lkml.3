Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbbAOMJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:09:31 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49632 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbbAOMJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:09:30 -0500
Message-ID: <54B7ADF2.9090409@hitachi.com>
Date: Thu, 15 Jan 2015 21:09:22 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: Re: [PATCH v2 3/4] perf probe: Do not rely on map__load()
 filter to find symbols
References: <1421234288-22758-1-git-send-email-namhyung@kernel.org> <1421234288-22758-3-git-send-email-namhyung@kernel.org> <20150114135417.GC3691@kernel.org>
In-Reply-To: <20150114135417.GC3691@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/14 22:54), Arnaldo Carvalho de Melo wrote:
> Em Wed, Jan 14, 2015 at 08:18:07PM +0900, Namhyung Kim escreveu:
>> The find_probe_trace_events_from_map() searches matching symbol from a
>> map (so from a backing dso).  For uprobes, it'll create a new map (and
>> dso) and loads it using a filter.  It's a little bit inefficient in that
>> it'll read out the symbol table everytime but works well anyway.
>>
>> For kprobes however, it'll reuse existing kernel map which might be
>> loaded before.  In this case map__load() just returns with no result.
>> It makes kprobes always failed to find symbol even if it exists in the
>> map (dso).
>>
>> To fix it, use map__find_symbol_by_name() instead.  It'll load a map
>> with full symbols and sorts them by name.  It needs to search sibing
>> nodes since there can be multiple (local) symbols with same name.
>>
>> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/util/probe-event.c | 32 +++++++++++++++-----------------
>>  1 file changed, 15 insertions(+), 17 deletions(-)
>>
>> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
>> index 94a717bf007d..b1406d79b271 100644
>> --- a/tools/perf/util/probe-event.c
>> +++ b/tools/perf/util/probe-event.c
>> @@ -2193,18 +2193,18 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
>>  	return ret;
>>  }
>>  
>> -static char *looking_function_name;
>> -static int num_matched_functions;
>> -
>> -static int probe_function_filter(struct map *map __maybe_unused,
>> -				      struct symbol *sym)
>> +static int find_probe_functions(struct map *map, char *name)
>>  {
>> -	if ((sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL) &&
>> -	    strcmp(looking_function_name, sym->name) == 0) {
>> -		num_matched_functions++;
>> -		return 0;
>> +	struct symbol *sym, *link = NULL;
>> +	int found = 0;
>> +
>> +	while ((sym = map__find_symbol_by_name(map, name, NULL, link)) != NULL) {
>> +		if (sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL)
>> +			found++;
>> +		link = sym;
>>  	}
>> -	return 1;
>> +
>> +	return found;
>>  }
> 
> How about using the "from" (that you called "link") to follow the list.h
> style and provide: 
> 
> 	map__find_symbol_by_name_from(map, sym, filter, from);
> 
> And use it to implement map__find_symbol_by_name():
> 
> 	map__find_symbol_by_name(map, sym, filter)
> 	{
> 		return map__find_symbol_by_name_from(map, sym, filter, NULL);
> 	}
> 
> Your loop would then become:
> 
> 	link = NULL;
> 
> 	while ((sym = map__find_symbol_by_name_from(map, name, NULL, link)) != NULL) {
> 		if (sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL)
> 			found++;
> 		link = sym;
> 	}

+1 ;)

Would it be nicer to rename "link" local variable to "from" ?

> 
> And no map__find_symbol_by_name() callsites would have to be touched.

BTW, such other callsites has no similar issues?

Thank you,

> 
> - Arnaldo
>   
>>  #define strdup_or_goto(str, label)	\
>> @@ -2221,11 +2221,11 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
>>  	struct map *map = NULL;
>>  	struct kmap *kmap = NULL;
>>  	struct ref_reloc_sym *reloc_sym = NULL;
>> -	struct symbol *sym;
>> -	struct rb_node *nd;
>> +	struct symbol *sym, *link = NULL;
>>  	struct probe_trace_event *tev;
>>  	struct perf_probe_point *pp = &pev->point;
>>  	struct probe_trace_point *tp;
>> +	int num_matched_functions;
>>  	int ret, i;
>>  
>>  	/* Init maps of given executable or kernel */
>> @@ -2242,10 +2242,8 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
>>  	 * Load matched symbols: Since the different local symbols may have
>>  	 * same name but different addresses, this lists all the symbols.
>>  	 */
>> -	num_matched_functions = 0;
>> -	looking_function_name = pp->function;
>> -	ret = map__load(map, probe_function_filter);
>> -	if (ret || num_matched_functions == 0) {
>> +	num_matched_functions = find_probe_functions(map, pp->function);
>> +	if (num_matched_functions == 0) {
>>  		pr_err("Failed to find symbol %s in %s\n", pp->function,
>>  			target ? : "kernel");
>>  		ret = -ENOENT;
>> @@ -2275,7 +2273,7 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
>>  	}
>>  
>>  	ret = 0;
>> -	map__for_each_symbol(map, sym, nd) {
>> +	while ((sym = map__find_symbol_by_name(map, pp->function, NULL, link))) {
>>  		tev = (*tevs) + ret;
>>  		tp = &tev->point;
>>  		if (ret == num_matched_functions) {
>> -- 
>> 2.2.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


