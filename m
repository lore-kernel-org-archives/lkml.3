Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaJGPKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:10:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbaJGPKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:10:46 -0400
Date: Tue, 7 Oct 2014 12:10:35 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2] perf tools: fix off-by-one error in maps
Message-ID: <20141007151035.GC2256@redhat.com>
References: <20141006083532.GA4850@quad>
 <8761fwh1nc.fsf@sejong.aot.lge.com>
 <20141007140050.GB2256@redhat.com>
 <CABPqkBSMapWzo5k7WXpt8Ejtdvk_znX1P6xV0eYRpK7rcTjjZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSMapWzo5k7WXpt8Ejtdvk_znX1P6xV0eYRpK7rcTjjZw@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 07, 2014 at 04:17:41PM +0200, Stephane Eranian escreveu:
> On Tue, Oct 7, 2014 at 4:00 PM, Arnaldo Carvalho de Melo
> <acme@redhat.com> wrote:
> > Em Tue, Oct 07, 2014 at 02:47:19PM +0900, Namhyung Kim escreveu:
> >> On Mon, 6 Oct 2014 10:35:32 +0200, Stephane Eranian wrote:
> >> > This patch fixes off-by-one errors in the management of maps.
> >> > A map is defined by start address and length as implemented by map__new():
> >
> >> > map__init(map, type, start, start + len, pgoff, dso);
> >
> >> > map->start = addr;
> >> > map->end = end;
> >
> >> > Consequently, the actual address range is ]start; end[
> >> > map->end is the first byte outside the range. This patch
> >> > fixes two bugs where upper bound checking was off-by-one.
> >
> >> > In V2, we fix map_groups__fixup_overlappings() some more
> >> > where map->start was off-by-one as reported by Jiri.
> >
> >> It seems we also need to fix maps__find():
> >
> >> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> >> index b7090596ac50..107a8c90785b 100644
> >> --- a/tools/perf/util/map.c
> >> +++ b/tools/perf/util/map.c
> >> @@ -752,7 +752,7 @@ struct map *maps__find(struct rb_root *maps, u64 ip)
> >>                 m = rb_entry(parent, struct map, rb_node);
> >>                 if (ip < m->start)
> >>                         p = &(*p)->rb_left;
> >> -               else if (ip > m->end)
> >> +               else if (ip >= m->end)
> >>                         p = &(*p)->rb_right;
> >>                 else
> >>                         return m;
> >
> > I keep thinking that this change is making things unclear.
> >
> > I.e. the _start_ of a map (map->start) is _in_ the map, and the _end_
> > of a map (map->end) is _in_ the map as well.
> >
> >         if (addr > m->end)
> >
> > is shorter than:
> >
> >         if (addr >= m->end)
> >
> > "start" and "end" should have the same rule applied, i.e. if one is in,
> > the other is in as well.
> >
> It is okay but then we need to be consistent all across. This is not
> the case today.
> I mentioned the cases I ran into.

Ok, and provided a patch doing the way I thought was confusing, now its
my turn to use that info and come up with a patch, ok, will do that.

- Arnaldo
