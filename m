Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaJNTDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 15:03:09 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:50208 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbaJNTDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 15:03:05 -0400
MIME-Version: 1.0
In-Reply-To: <20141014185829.GA3839@redhat.com>
References: <20141006083532.GA4850@quad>
	<8761fwh1nc.fsf@sejong.aot.lge.com>
	<20141007140050.GB2256@redhat.com>
	<CABPqkBSMapWzo5k7WXpt8Ejtdvk_znX1P6xV0eYRpK7rcTjjZw@mail.gmail.com>
	<20141007151035.GC2256@redhat.com>
	<CABPqkBR2FzTvkRsTH91hYbt7H-BDZ2kcnF1xDqKBB0h=2HSapw@mail.gmail.com>
	<20141014185829.GA3839@redhat.com>
Date: Tue, 14 Oct 2014 21:03:02 +0200
Message-ID: <CABPqkBRCYgEo=4zS4dZDbdnbA_+4otKFA5oFgczdWqpahM0smg@mail.gmail.com>
Subject: Re: [PATCH v2] perf tools: fix off-by-one error in maps
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 8:58 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Tue, Oct 07, 2014 at 05:17:12PM +0200, Stephane Eranian escreveu:
>> On Tue, Oct 7, 2014 at 5:10 PM, Arnaldo Carvalho de Melo
>> <acme@redhat.com> wrote:
>> > Em Tue, Oct 07, 2014 at 04:17:41PM +0200, Stephane Eranian escreveu:
>> >> On Tue, Oct 7, 2014 at 4:00 PM, Arnaldo Carvalho de Melo
>> >> >> +++ b/tools/perf/util/map.c
>> >> >> @@ -752,7 +752,7 @@ struct map *maps__find(struct rb_root *maps, u64 ip)
>> >> >>                 m = rb_entry(parent, struct map, rb_node);
>> >> >>                 if (ip < m->start)
>> >> >>                         p = &(*p)->rb_left;
>> >> >> -               else if (ip > m->end)
>> >> >> +               else if (ip >= m->end)
>> >> >>                         p = &(*p)->rb_right;
>> >> >>                 else
>> >> >>                         return m;
>
>> >> > I keep thinking that this change is making things unclear.
>
>> >> > I.e. the _start_ of a map (map->start) is _in_ the map, and the _end_
>> >> > of a map (map->end) is _in_ the map as well.
>
>> >> >         if (addr > m->end)
>
>> >> > is shorter than:
>
>> >> >         if (addr >= m->end)
>
>> >> > "start" and "end" should have the same rule applied, i.e. if one is in,
>> >> > the other is in as well.
>
>> >> It is okay but then we need to be consistent all across. This is not
>> >> the case today.
>> >> I mentioned the cases I ran into.
>
>> > Ok, and provided a patch doing the way I thought was confusing, now its
>> > my turn to use that info and come up with a patch, ok, will do that.
>
>> You got it! ;->
>
> struct vm_area_struct {
>         /* The first cache line has the info for VMA tree walking. */
>
>         unsigned long vm_start;         /* Our start address within vm_mm. */
>         unsigned long vm_end;           /* The first byte after our end address
>                                            within vm_mm. */
>
> So these guys have been doing this far longer than me, I guess I'll bow
> to this convention.
>
> But by renaming map->end to map->end_ and looking at all the usage of
> it, there are some inconsistencies...
>
> Like symbol->{start,end} is of the [start,end] case, and to be
> consistent with above needs to also move to [start,end[, will cook a
> patch and send for review.
>
Yes, there were some inconsistencies (or confusions) that I noticed when
I started fixing the maps. I can believe that this off-by-one error exist with
other data types. That could cause wrong symbol correlations in borderline
cases (which are really rare).
