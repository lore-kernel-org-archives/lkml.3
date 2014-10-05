Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaJETok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 15:44:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36801 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaJEToj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 15:44:39 -0400
MIME-Version: 1.0
In-Reply-To: <20141005192312.GA10245@krava.redhat.com>
References: <20141003104707.GA4435@quad>
	<20141005192312.GA10245@krava.redhat.com>
Date: Sun, 5 Oct 2014 21:44:38 +0200
Message-ID: <CABPqkBT7qQU8tVu3mCW6AnwqtzOMEAjHuDNckTKp-yo_QXHMgg@mail.gmail.com>
Subject: Re: [PATCH] perf tools: fix off-by-one error in maps
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 5, 2014 at 9:23 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Fri, Oct 03, 2014 at 12:47:07PM +0200, Stephane Eranian wrote:
>>
>
> SNIP
>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>>
>> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
>> index b709059..9e2c71e 100644
>> --- a/tools/perf/util/map.c
>> +++ b/tools/perf/util/map.c
>> @@ -556,7 +556,7 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
>>
>>  int map_groups__find_ams(struct addr_map_symbol *ams, symbol_filter_t filter)
>>  {
>> -     if (ams->addr < ams->map->start || ams->addr > ams->map->end) {
>> +     if (ams->addr < ams->map->start || ams->addr >= ams->map->end) {
>>               if (ams->map->groups == NULL)
>>                       return -1;
>>               ams->map = map_groups__find(ams->map->groups, ams->map->type,
>> @@ -678,7 +678,7 @@ int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
>>                               goto move_map;
>>                       }
>>
>> -                     after->start = map->end + 1;
>> +                     after->start = map->end;
>>                       map_groups__insert(mg, after);
>>                       if (verbose >= 2)
>>                               map__fprintf(after, fp);
>
> hum, do we also need this one then?
>
> ---
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index 9e2c71e51fce..186418ba18db 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -664,7 +664,7 @@ int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
>                                 goto move_map;
>                         }
>
> -                       before->end = map->start - 1;
> +                       before->end = map->start;
Start is first byte of next range, so it is pointing to one byte after
the end of the before range.
So, yes, I think we need your fix as well. I missed it. Will repost.

>                         map_groups__insert(mg, before);
>                         if (verbose >= 2)
>                                 map__fprintf(before, fp);
