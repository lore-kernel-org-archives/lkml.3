Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbaJNS6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 14:58:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601AbaJNS6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 14:58:34 -0400
Date: Tue, 14 Oct 2014 15:58:29 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH v2] perf tools: fix off-by-one error in maps
Message-ID: <20141014185829.GA3839@redhat.com>
References: <20141006083532.GA4850@quad>
 <8761fwh1nc.fsf@sejong.aot.lge.com>
 <20141007140050.GB2256@redhat.com>
 <CABPqkBSMapWzo5k7WXpt8Ejtdvk_znX1P6xV0eYRpK7rcTjjZw@mail.gmail.com>
 <20141007151035.GC2256@redhat.com>
 <CABPqkBR2FzTvkRsTH91hYbt7H-BDZ2kcnF1xDqKBB0h=2HSapw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBR2FzTvkRsTH91hYbt7H-BDZ2kcnF1xDqKBB0h=2HSapw@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 07, 2014 at 05:17:12PM +0200, Stephane Eranian escreveu:
> On Tue, Oct 7, 2014 at 5:10 PM, Arnaldo Carvalho de Melo
> <acme@redhat.com> wrote:
> > Em Tue, Oct 07, 2014 at 04:17:41PM +0200, Stephane Eranian escreveu:
> >> On Tue, Oct 7, 2014 at 4:00 PM, Arnaldo Carvalho de Melo
> >> >> +++ b/tools/perf/util/map.c
> >> >> @@ -752,7 +752,7 @@ struct map *maps__find(struct rb_root *maps, u64 ip)
> >> >>                 m = rb_entry(parent, struct map, rb_node);
> >> >>                 if (ip < m->start)
> >> >>                         p = &(*p)->rb_left;
> >> >> -               else if (ip > m->end)
> >> >> +               else if (ip >= m->end)
> >> >>                         p = &(*p)->rb_right;
> >> >>                 else
> >> >>                         return m;

> >> > I keep thinking that this change is making things unclear.

> >> > I.e. the _start_ of a map (map->start) is _in_ the map, and the _end_
> >> > of a map (map->end) is _in_ the map as well.

> >> >         if (addr > m->end)

> >> > is shorter than:

> >> >         if (addr >= m->end)

> >> > "start" and "end" should have the same rule applied, i.e. if one is in,
> >> > the other is in as well.

> >> It is okay but then we need to be consistent all across. This is not
> >> the case today.
> >> I mentioned the cases I ran into.

> > Ok, and provided a patch doing the way I thought was confusing, now its
> > my turn to use that info and come up with a patch, ok, will do that.

> You got it! ;->

struct vm_area_struct {
        /* The first cache line has the info for VMA tree walking. */

        unsigned long vm_start;         /* Our start address within vm_mm. */
        unsigned long vm_end;           /* The first byte after our end address
                                           within vm_mm. */

So these guys have been doing this far longer than me, I guess I'll bow
to this convention.

But by renaming map->end to map->end_ and looking at all the usage of
it, there are some inconsistencies...

Like symbol->{start,end} is of the [start,end] case, and to be
consistent with above needs to also move to [start,end[, will cook a
patch and send for review.

- Arnaldo



