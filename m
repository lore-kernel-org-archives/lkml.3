Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaJFT51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:57:27 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:55896 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaJFT5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:57:25 -0400
MIME-Version: 1.0
In-Reply-To: <20141006151823.GA2256@redhat.com>
References: <20141003104707.GA4435@quad>
	<20141006151823.GA2256@redhat.com>
Date: Mon, 6 Oct 2014 21:57:24 +0200
Message-ID: <CABPqkBRVW4emWoBB5EcvRmUNhm5DB8ix=sJ+rRk_qjn0oVJ7Lw@mail.gmail.com>
Subject: Re: [PATCH] perf tools: fix off-by-one error in maps
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

On Mon, Oct 6, 2014 at 5:18 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Fri, Oct 03, 2014 at 12:47:07PM +0200, Stephane Eranian escreveu:
>>
>> This patch fixes off-by-one errors in the management
>> of maps.  A map is defined by start address and length
>> as implemented by map__new():
>>
>> map__init(map, type, start, start + len, pgoff, dso);
>>
>> map__init()
>> {
>>   map->start = addr;
>>   map->end = end;
>> }
>>
>> Consequently, the actual address range is ]start; end[
>> map->end is the first byte outside the range. This patch
>
> I thought map->end should be the end of the range, not something after
> the end, is that really the case?
>
map->start = start;
map->end = start + len;

Thus map->end is the first byte after the end.


> I.e. the bug would be in that call to map__init, that should instead be:
>
>         map__init(map, type, start, start + len - 1, pgoff, dso);

Yeah, that is the alternative. But are you sure this is the only place
where a map
is initialized. And this is not really C like.

>
> no? Isn't that clearer, i.e. to keep the semantics of 'end'?
>
Yeah, it all depends on what you meant by end: last byte or first byte after.
But then everything needs to be consistent. That is what I am trying to fix
in this patch.

> - Arnaldo
>
>> fixes two bugs where upper bounds were off-by-one.
>>
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
