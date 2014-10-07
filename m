Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaJGIlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:41:01 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:56847 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaJGIk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:40:57 -0400
MIME-Version: 1.0
In-Reply-To: <8761fwh1nc.fsf@sejong.aot.lge.com>
References: <20141006083532.GA4850@quad>
	<8761fwh1nc.fsf@sejong.aot.lge.com>
Date: Tue, 7 Oct 2014 10:40:56 +0200
Message-ID: <CABPqkBR30utE1aQd5f=CKY5fJOai0GabJ=ryXro+HV12qwp_4Q@mail.gmail.com>
Subject: Re: [PATCH v2] perf tools: fix off-by-one error in maps
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 7:47 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi Stephane,
>
> On Mon, 6 Oct 2014 10:35:32 +0200, Stephane Eranian wrote:
>> This patch fixes off-by-one errors in the management of maps.
>> A map is defined by start address and length as implemented by map__new():
>>
>> map__init(map, type, start, start + len, pgoff, dso);
>>
>> map->start = addr;
>> map->end = end;
>>
>> Consequently, the actual address range is ]start; end[
>> map->end is the first byte outside the range. This patch
>> fixes two bugs where upper bound checking was off-by-one.
>>
>> In V2, we fix map_groups__fixup_overlappings() some more
>> where map->start was off-by-one as reported by Jiri.
>
> It seems we also need to fix maps__find():
>
>
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index b7090596ac50..107a8c90785b 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -752,7 +752,7 @@ struct map *maps__find(struct rb_root *maps, u64 ip)
>                 m = rb_entry(parent, struct map, rb_node);
>                 if (ip < m->start)
>                         p = &(*p)->rb_left;
> -               else if (ip > m->end)
> +               else if (ip >= m->end)
>                         p = &(*p)->rb_right;
>                 else
>                         return m;
>
> Thanks,
> Namhyung
>
Yep, missing that one too. Hope there aren't any others....
Thanks.
