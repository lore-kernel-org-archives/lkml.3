Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaAPRfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:35:07 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:42484 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaAPRfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:35:02 -0500
Date: Thu, 16 Jan 2014 18:34:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf tools: Spare double comparison of callchain
 first entry
Message-ID: <20140116173454.GA5328@localhost.localdomain>
References: <1389713836-13375-1-git-send-email-fweisbec@gmail.com>
 <1389713836-13375-3-git-send-email-fweisbec@gmail.com>
 <87y52h930t.fsf@sejong.aot.lge.com>
 <20140115165927.GA21574@localhost.localdomain>
 <87d2js9132.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2js9132.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 10:17:53AM +0900, Namhyung Kim wrote: 
> I think if the sort key doesn't contain "symbol", unmatch case would be
> increased as more various callchains would go into a same entry.

You mean -g fractal,0.5,callee,address ?

Hmm, actually I haven't seen much difference there.

> >
> >> 
> >> >
> >> > This results in less comparisons performed by the CPU.
> >> 
> >> Do you have any numbers?  I suspect it'd not be a big change, but just
> >> curious.
> >
> > So I compared before/after the patchset (which include the cursor restore removal)
> > with:
> >
> > 	1) Some big hackbench-like load that generates > 200 MB perf.data
> >
> > 	perf record -g -- perf bench sched messaging -l $SOME_BIG_NUMBER
> >
> > 	2) Compare before/after with the following reports:
> >
> > 	perf stat perf report --stdio > /dev/null
> > 	perf stat perf report --stdio -s sym > /dev/null
> > 	perf stat perf report --stdio -G > /dev/null
> > 	perf stat perf report --stdio -g fractal,0.5,caller,address > /dev/null 
> >
> > And most of the time I had < 0.01% difference on time completion in favour of the patchset
> > (which may be due to the removed cursor restore patch eventually).
> >
> > So, all in one, there was no real interesting difference. If you want the true results I can definetly relaunch the tests.
> 
> So as an extreme case, could you please also test "-s cpu" case and
> share the numbers?

There is indeed a tiny difference here.

Before the patchset:

fweisbec@Aivars:~/linux-2.6-tip/tools/perf$ sudo ./perf stat -r 20 ./perf report --stdio -s cpu > /dev/null

 Performance counter stats for './perf report --stdio -s cpu' (20 runs):

       3343,047232      task-clock (msec)         #    0,999 CPUs utilized            ( +-  0,12% )
                 6      context-switches          #    0,002 K/sec                    ( +-  3,82% )
                 0      cpu-migrations            #    0,000 K/sec                  
           128 076      page-faults               #    0,038 M/sec                    ( +-  0,00% )
    13 044 840 323      cycles                    #    3,902 GHz                      ( +-  0,12% )
   <not supported>      stalled-cycles-frontend  
   <not supported>      stalled-cycles-backend   
    16 341 506 514      instructions              #    1,25  insns per cycle          ( +-  0,00% )
     4 042 448 707      branches                  # 1209,211 M/sec                    ( +-  0,00% )
        26 819 441      branch-misses             #    0,66% of all branches          ( +-  0,09% )

       3,345286450 seconds time elapsed                                          ( +-  0,12% )

After the patchset:

fweisbec@Aivars:~/linux-2.6-tip/tools/perf$ sudo ./perf stat -r 20 ./perf report --stdio -s cpu > /dev/null

 Performance counter stats for './perf report --stdio -s cpu' (20 runs):

       3365,739972      task-clock (msec)         #    0,999 CPUs utilized            ( +-  0,12% )
                 6      context-switches          #    0,002 K/sec                    ( +-  2,99% )
                 0      cpu-migrations            #    0,000 K/sec                  
           128 076      page-faults               #    0,038 M/sec                    ( +-  0,00% )
    13 133 593 870      cycles                    #    3,902 GHz                      ( +-  0,12% )
   <not supported>      stalled-cycles-frontend  
   <not supported>      stalled-cycles-backend   
    16 626 286 378      instructions              #    1,27  insns per cycle          ( +-  0,00% )
     4 119 555 502      branches                  # 1223,967 M/sec                    ( +-  0,00% )
        28 687 283      branch-misses             #    0,70% of all branches          ( +-  0,09% )

       3,367984867 seconds time elapsed                                          ( +-  0,12% )


Which makes about 0.6% difference on the overhead.
Now it had less overhead in common cases (default sorting, -s sym, -G, etc...).
I guess it's not really worrysome, it's mostly unvisible at this scale.
