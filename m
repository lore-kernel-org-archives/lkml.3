Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaJGFrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 01:47:42 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50930 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaJGFrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 01:47:21 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, jolsa@redhat.com, acme@redhat.com,
        peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com
Subject: Re: [PATCH v2] perf tools: fix off-by-one error in maps
References: <20141006083532.GA4850@quad>
Date: Tue, 07 Oct 2014 14:47:19 +0900
In-Reply-To: <20141006083532.GA4850@quad> (Stephane Eranian's message of "Mon,
	6 Oct 2014 10:35:32 +0200")
Message-ID: <8761fwh1nc.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Mon, 6 Oct 2014 10:35:32 +0200, Stephane Eranian wrote:
> This patch fixes off-by-one errors in the management of maps.
> A map is defined by start address and length as implemented by map__new():
>
> map__init(map, type, start, start + len, pgoff, dso);
>
> map->start = addr;
> map->end = end;
>
> Consequently, the actual address range is ]start; end[
> map->end is the first byte outside the range. This patch
> fixes two bugs where upper bound checking was off-by-one.
>
> In V2, we fix map_groups__fixup_overlappings() some more
> where map->start was off-by-one as reported by Jiri.

It seems we also need to fix maps__find():


diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index b7090596ac50..107a8c90785b 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -752,7 +752,7 @@ struct map *maps__find(struct rb_root *maps, u64 ip)
                m = rb_entry(parent, struct map, rb_node);
                if (ip < m->start)
                        p = &(*p)->rb_left;
-               else if (ip > m->end)
+               else if (ip >= m->end)
                        p = &(*p)->rb_right;
                else
                        return m;

Thanks,
Namhyung


>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/util/map.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index b709059..186418b 100644
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
> @@ -664,7 +664,7 @@ int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
>  				goto move_map;
>  			}
>  
> -			before->end = map->start - 1;
> +			before->end = map->start;
>  			map_groups__insert(mg, before);
>  			if (verbose >= 2)
>  				map__fprintf(before, fp);
> @@ -678,7 +678,7 @@ int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
>  				goto move_map;
>  			}
>  
> -			after->start = map->end + 1;
> +			after->start = map->end;
>  			map_groups__insert(mg, after);
>  			if (verbose >= 2)
>  				map__fprintf(after, fp);
