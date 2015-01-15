Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbbAOMSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:18:23 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:53984 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbbAOMSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:18:21 -0500
Message-ID: <54B7B006.4040506@hitachi.com>
Date: Thu, 15 Jan 2015 21:18:14 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v3 1/3] perf tools: Add from argument to dso__find_symbol_by_name()
References: <1421279302-7105-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1421279302-7105-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/15 8:48), Namhyung Kim wrote:
> When a dso contains multiple symbols which have same name, current
> dso__find_symbol_by_name() only finds an one of them and there's no way
> to get the all symbols without going through the rbtree.
> 
> So add the new 'from' argument to dso__find_symbol_by_name() to remember
> current symbol position and returns next symbol if it provided.  For the
> first call the from should be NULL and the returned symbol should be
> used as from to the next call.  It will return NULL if there's no symbol
> that has given name anymore.
> 

Looks good to me

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

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
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


