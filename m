Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaJFPSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:18:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbaJFPSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:18:43 -0400
Date: Mon, 6 Oct 2014 12:18:23 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, jolsa@redhat.com, namhyung@kernel.org,
        peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com
Subject: Re: [PATCH] perf tools: fix off-by-one error in maps
Message-ID: <20141006151823.GA2256@redhat.com>
References: <20141003104707.GA4435@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141003104707.GA4435@quad>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 03, 2014 at 12:47:07PM +0200, Stephane Eranian escreveu:
> 
> This patch fixes off-by-one errors in the management
> of maps.  A map is defined by start address and length
> as implemented by map__new():
> 
> map__init(map, type, start, start + len, pgoff, dso);
> 
> map__init()
> {
>   map->start = addr;
>   map->end = end;
> }
> 
> Consequently, the actual address range is ]start; end[
> map->end is the first byte outside the range. This patch

I thought map->end should be the end of the range, not something after
the end, is that really the case?

I.e. the bug would be in that call to map__init, that should instead be:

	map__init(map, type, start, start + len - 1, pgoff, dso);

no? Isn't that clearer, i.e. to keep the semantics of 'end'?

- Arnaldo

> fixes two bugs where upper bounds were off-by-one.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index b709059..9e2c71e 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -556,7 +556,7 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
>  
>  int map_groups__find_ams(struct addr_map_symbol *ams, symbol_filter_t filter)
>  {
> -	if (ams->addr < ams->map->start || ams->addr > ams->map->end) {
> +	if (ams->addr < ams->map->start || ams->addr >= ams->map->end) {
>  		if (ams->map->groups == NULL)
>  			return -1;
>  		ams->map = map_groups__find(ams->map->groups, ams->map->type,
> @@ -678,7 +678,7 @@ int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
>  				goto move_map;
>  			}
>  
> -			after->start = map->end + 1;
> +			after->start = map->end;
>  			map_groups__insert(mg, after);
>  			if (verbose >= 2)
>  				map__fprintf(after, fp);
