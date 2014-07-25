Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbaGYLer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:34:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbaGYLeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:34:44 -0400
Date: Fri, 25 Jul 2014 13:34:26 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 17/19] perf tools: Always force
 PERF_RECORD_FINISHED_ROUND event
Message-ID: <20140725113426.GC1214@krava.brq.redhat.com>
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
 <1405893363-21967-18-git-send-email-jolsa@kernel.org>
 <20140724213451.GH7831@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724213451.GH7831@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 06:34:51PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Sun, Jul 20, 2014 at 11:56:01PM +0200, Jiri Olsa escreveu:
> > The PERF_RECORD_FINISHED_ROUND governs queue flushing in
> > reporting, so it needs to be stored for any kind of event.
> > 
> > Forcing the PERF_RECORD_FINISHED_ROUND event to be stored any
> > time we finish the round and wrote at least one event.
> 
> This is not just one change, it does two things and it is not clearly
> detailed here.
> 
> The existing code would write a PERF_RECORD_FINISHED_ROUND per call to
> record__mmap_read() for tracepoints were present.
> 
> I.e. if tracepoints and any other type of event type was present, then
> this syntetic PERF_RECORD_FINISHED_ROUND thing is inserted which will be
> handled at report time.
> 
> Now you changed it to not check if tracepoints are present, i.e. it will
> always insert that after processing N events in
> PERF_RECORD_FINISHED_ROUND. (change #1)
> 
> The thing is, before it didn't checked if N was zero, needlessly
> inserting PERF_RECORD_FINISHED_ROUND events in some corner cases.
> 
> Now you, in addition to change #1 you also check that the number of
> bytes written before that event processing loop in record__mmap_read()
> is the same after the loop, i.e. if some events were written to the
> output perf.data file, only inserting the PERF_RECORD_FINISHED_ROUND
> events if so. (change #2)
> 
> I think both changes are OK, but should be split in different patches,

right, I'll split it

> and while testing comparing having the patch applied versus patch
> applied + ignore the PERF_RECORD_FINISHED_ROUND events in the resulting
> perf.data file, I get:
> 
> [root@zoo /]# perf stat -r 5 perf report --no-ordered-samples > /dev/null
> <SNIP symbol stuff>
>  Performance counter stats for 'perf report --no-ordered-samples' (5 runs):
> 
>       30263.033852      task-clock (msec)         #    1.000 CPUs utilized            ( +-  0.48% )
>                346      context-switches          #    0.011 K/sec                    ( +- 54.65% )
>                182      cpu-migrations            #    0.006 K/sec                    ( +- 29.94% )
>             89,951      page-faults               #    0.003 M/sec                    ( +-  0.05% )
>     92,342,939,311      cycles                    #    3.051 GHz                      ( +-  0.46% )
>     50,605,250,178      stalled-cycles-frontend   #   54.80% frontend cycles idle     ( +-  0.88% )
>    <not supported>      stalled-cycles-backend   
>    101,171,572,553      instructions              #    1.10  insns per cycle        
>                                                   #    0.50  stalled cycles per insn  ( +-  0.01% )
>     22,643,469,804      branches                  #  748.222 M/sec                    ( +-  0.01% )
>        284,395,273      branch-misses             #    1.26% of all branches          ( +-  0.45% )
> 
>       30.249514999 seconds time elapsed                                          ( +-  0.48% )
> 
> [root@zoo /]# perf stat -r 5 perf report --ordered-samples > /dev/null
> <SNIP symbol stuff>
>  Performance counter stats for 'perf report --ordered-samples' (5 runs):
> 
>       32665.828429      task-clock (msec)         #    1.001 CPUs utilized            ( +-  0.41% )
>                304      context-switches          #    0.009 K/sec                    ( +- 23.32% )
>                102      cpu-migrations            #    0.003 K/sec                    ( +- 21.70% )
>             79,405      page-faults               #    0.002 M/sec                    ( +-  0.02% )
>    101,761,091,322      cycles                    #    3.115 GHz                      ( +-  0.40% )
>     57,627,138,326      stalled-cycles-frontend   #   56.63% frontend cycles idle     ( +-  0.65% )
>    <not supported>      stalled-cycles-backend   
>    105,982,144,263      instructions              #    1.04  insns per cycle        
>                                                   #    0.54  stalled cycles per insn  ( +-  0.01% )
>     23,493,670,235      branches                  #  719.212 M/sec                    ( +-  0.01% )
>        319,060,575      branch-misses             #    1.36% of all branches          ( +-  0.19% )
> 
>       32.636483981 seconds time elapsed                                          ( +-  0.41% )
> 
> [root@zoo /]#

so those 2 extra seconds is the ordering time, right? sounds ok

jirka
