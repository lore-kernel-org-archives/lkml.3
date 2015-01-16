Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbbAPUr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 15:47:57 -0500
Received: from mail.kernel.org ([198.145.29.136]:53126 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbbAPUr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 15:47:56 -0500
Date: Fri, 16 Jan 2015 17:47:51 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH v3 1/3] perf tools: Add from argument to
 dso__find_symbol_by_name()
Message-ID: <20150116204751.GC18698@kernel.org>
References: <1421279302-7105-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421279302-7105-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 15, 2015 at 08:48:20AM +0900, Namhyung Kim escreveu:
> When a dso contains multiple symbols which have same name, current
> dso__find_symbol_by_name() only finds an one of them and there's no way
> to get the all symbols without going through the rbtree.
> 
> So add the new 'from' argument to dso__find_symbol_by_name() to remember
> current symbol position and returns next symbol if it provided.  For the
> first call the from should be NULL and the returned symbol should be
> used as from to the next call.  It will return NULL if there's no symbol
> that has given name anymore.

I had some issues with this patch that made me to split it into multiple
ones and use a slightly different approach, I put those patches in a
tmp.perf/urgent branch at my tree:

https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/log/?h=tmp.perf/urgent

I tested it with a ret probe for do_fork and it work well, thanks for
fixing this up!

See below for the issues:
 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/map.c    | 13 ++++++++++---
>  tools/perf/util/map.h    |  3 +++
>  tools/perf/util/symbol.c | 41 ++++++++++++++++++++++++++++++++++++-----
>  tools/perf/util/symbol.h |  2 +-
>  4 files changed, 50 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index 62ca9f2607d5..01e2696ca8b5 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -301,8 +301,9 @@ struct symbol *map__find_symbol(struct map *map, u64 addr,
>  	return dso__find_symbol(map->dso, map->type, addr);
>  }
>  
> -struct symbol *map__find_symbol_by_name(struct map *map, const char *name,
> -					symbol_filter_t filter)
> +struct symbol *map__find_symbol_by_name_from(struct map *map, const char *name,
> +					     symbol_filter_t filter,
> +					     struct symbol *from)
>  {
>  	if (map__load(map, filter) < 0)
>  		return NULL;
> @@ -310,7 +311,13 @@ struct symbol *map__find_symbol_by_name(struct map *map, const char *name,
>  	if (!dso__sorted_by_name(map->dso, map->type))
>  		dso__sort_by_name(map->dso, map->type);
>  
> -	return dso__find_symbol_by_name(map->dso, map->type, name);
> +	return dso__find_symbol_by_name(map->dso, map->type, name, from);
> +}
> +
> +struct symbol *map__find_symbol_by_name(struct map *map, const char *name,
> +					symbol_filter_t filter)
> +{
> +	return map__find_symbol_by_name_from(map, name, filter, NULL);
>  }
>  
>  struct map *map__clone(struct map *map)
> diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
> index 6951a9d42339..69acc58e6f9a 100644
> --- a/tools/perf/util/map.h
> +++ b/tools/perf/util/map.h
> @@ -138,6 +138,9 @@ struct symbol *map__find_symbol(struct map *map,
>  				u64 addr, symbol_filter_t filter);
>  struct symbol *map__find_symbol_by_name(struct map *map, const char *name,
>  					symbol_filter_t filter);
> +struct symbol *map__find_symbol_by_name_from(struct map *map, const char *name,
> +					     symbol_filter_t filter,
> +					     struct symbol *from);
>  void map__fixup_start(struct map *map);
>  void map__fixup_end(struct map *map);
>  
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index c24c5b83156c..e5800497ca61 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -396,6 +396,7 @@ static struct symbol *symbols__find_by_name(struct rb_root *symbols,
>  					    const char *name)
>  {
>  	struct rb_node *n;
> +	struct symbol_name_rb_node *s;
>  
>  	if (symbols == NULL)
>  		return NULL;
> @@ -403,7 +404,6 @@ static struct symbol *symbols__find_by_name(struct rb_root *symbols,
>  	n = symbols->rb_node;
>  
>  	while (n) {
> -		struct symbol_name_rb_node *s;
>  		int cmp;
>  
>  		s = rb_entry(n, struct symbol_name_rb_node, rb_node);
> @@ -414,10 +414,24 @@ static struct symbol *symbols__find_by_name(struct rb_root *symbols,
>  		else if (cmp > 0)
>  			n = n->rb_right;
>  		else
> -			return &s->sym;
> +			break;
>  	}
>  
> -	return NULL;
> +	if (n == NULL)
> +		return NULL;
> +
> +	/* return first symbol that has same name (if any) */
> +	for (n = rb_prev(n); n; n = rb_prev(n)) {
> +		struct symbol_name_rb_node *tmp;
> +
> +		tmp = rb_entry(n, struct symbol_name_rb_node, rb_node);
> +		if (strcmp(tmp->sym.name, s->sym.name))
> +			break;
> +
> +		s = tmp;
> +	}
> +
> +	return &s->sym;
>  }

Up to here we have a standalone patch, one that fixes
symbols__find_by_name to return the first entry with the given symbol
name, so I split it as-is and kept your authorship credit.
>  
>  struct symbol *dso__find_symbol(struct dso *dso,
> @@ -436,10 +450,27 @@ struct symbol *dso__next_symbol(struct symbol *sym)
>  	return symbols__next(sym);
>  }
>  
> +/*
> + * When @from is NULL, returns first symbol that matched with @name.
> + * Otherwise, returns next symbol after @from in case some (local) symbols
> + * have same name, or NULL.
> + */
>  struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
> -					const char *name)
> +					const char *name, struct symbol *from)


Here I think this method should've been renamed
dso__find_symbol_by_name_from(), to keep the semantic coherent, matching
the map__find_symbol_by_name_from() counterpart.

But then, since when from is !NULL, it is not about finding anything,
instead it is about asking for the next entry in the sorted-by-name
rbtree, so instead I introduced a symbol__next_by_name() that does just
that.

The callers then will see if there is a next entry (sorted by name) and
if that entry has the same name.

I.e. keeping the name "find_symbol_by_name" when there is no "find"
operation being made is confusing.

Then, after introducing it, I further introduced a
map__for_each_symbol_with_name(map, sym_name, sym) that wraps it all up
and provides all the symbols with a given name for the loop block in
front of it.

Also:

>  {
> -	return symbols__find_by_name(&dso->symbol_names[type], name);
> +	struct rb_node *n;
> +	struct symbol_name_rb_node *s;
> +
> +	if (from == NULL)
> +		return symbols__find_by_name(&dso->symbol_names[type], name);
> +
> +	s = container_of(from, struct symbol_name_rb_node, sym);
> +	n = rb_prev(&s->rb_node);

Why are you going backwards here? Since you above stated that
"Otherwise, returns next symbol after @from".

And since you, in symbols__find_by_name as well go on backwards
(rb_prev), rightly, to find the first entry with a given name?

> +	if (n == NULL)
> +		return NULL;
> +
> +	s = rb_entry(n, struct symbol_name_rb_node, rb_node);
> +	return strcmp(s->sym.name, name) ? NULL : &s->sym;
>  }
>  
>  void dso__sort_by_name(struct dso *dso, enum map_type type)
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 9d602e9c6f59..cd4f51d95bd0 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -230,7 +230,7 @@ int dso__load_kallsyms(struct dso *dso, const char *filename, struct map *map,
>  struct symbol *dso__find_symbol(struct dso *dso, enum map_type type,
>  				u64 addr);
>  struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
> -					const char *name);
> +					const char *name, struct symbol *from);
>  
>  struct symbol *dso__first_symbol(struct dso *dso, enum map_type type);
>  struct symbol *dso__next_symbol(struct symbol *sym);
> -- 
> 2.2.1
