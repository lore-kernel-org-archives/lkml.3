Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbaGXPKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:10:22 -0400
Received: from mail.kernel.org ([198.145.19.201]:45557 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759075AbaGXPKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:10:19 -0400
Date: Thu, 24 Jul 2014 12:10:09 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv3 00/19] perf tools: Factor ordered samples queue
Message-ID: <20140724151009.GD7831@kernel.org>
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
 <53CCB6AE.6020505@intel.com>
 <20140721080219.GA4183@krava.redhat.com>
 <53CCD3A7.5070002@intel.com>
 <20140721095415.GB8865@krava.redhat.com>
 <87d2cy3c7m.fsf@tassilo.jf.intel.com>
 <53CD5AB5.3000307@intel.com>
 <53CD5DC6.3030605@gmail.com>
 <20140724141958.GB7831@kernel.org>
 <20140724145611.GB25165@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724145611.GB25165@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 24, 2014 at 04:56:11PM +0200, Jiri Olsa escreveu:
> On Thu, Jul 24, 2014 at 11:19:58AM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Jul 21, 2014 at 12:36:54PM -0600, David Ahern escreveu:
> > > On 7/21/14, 12:23 PM, Adrian Hunter wrote:
> > > >On 21/07/2014 7:31 p.m., Andi Kleen wrote:
> > > >>Jiri Olsa <jolsa@redhat.com> writes:
> > > >>>
> > > >>>[jolsa@ibm-x3650m4-01 perf]$ sudo ./perf report --stdio
> > > >>>Timestamp below last timeslice flush
> > > >>>0x2276f58 [0x68]: failed to process type: 9
> > > >>
> > > >>FWIW we're seeing this frequently too.
> > > >
> > > >Jiri's example didn't work for me.  Do you have one?
> > > 
> > > $ perf sched record  -m 8192 -- perf bench sched all
> > > # Running sched/messaging benchmark...
> > > # 20 sender and receiver processes per group
> > > # 10 groups == 400 processes run
> > > 
> > >      Total time: 0.087 [sec]
> > > 
> > > # Running sched/pipe benchmark...
> > > # Executed 1000000 pipe operations between two processes
> > > 
> > >      Total time: 12.043 [sec]
> > > 
> > >       12.043779 usecs/op
> > >           83030 ops/sec
> > > 
> > > [ perf record: Woken up 1 times to write data ]
> > > [ perf record: Captured and wrote 289.549 MB perf.data (~12650569 samples) ]
> > > 0x54b4828 [0]: failed to process type: 0
> > > 
> > > No overload condition, no dropped chunks message - yet can't process events.
> > 
> > Appling just the patches 1 and 17 from this series I managed to:
> 
> ok with me..
> 
> I plan to spin new version with better debug messages and without (Adrian):
>   perf tools: Limit the ordered events queue by default to 100MB
> 
> Anyway, I think the rest without (and the one above):
>   perf tools: Add debug prints for ordered events queue
> 
> should be good to go..
> 
> Namhyung pointed out performance implications for patch 17:
>   perf tools: Always force PERF_RECORD_FINISHED_ROUND event

I haven't seen this comment, just saw David, IIUC, having problems using
the whole patchkit, David?

My tests were more to counter what he said, i.e. that:

<quote David Ahern>
No overload condition, no dropped chunks message - yet can't process
events
</>

I see no overload condition, no dropped chunks message, I was pounding
the machine with a big load and could process the events, so all seems
well.

And from the discussion I understood that patch 17 is the most important
one, agreed by you and Adrian, right?

I.e. the other ones are refactorings to make it have better naming and
to allow it being used elsewhere (builtin-trace.c, whee), but still need
some more polishing/testing, is that right?

- Arnaldo
 
> which you seem to test.. but I dont see comparison dow there.. ?
> 
> thanks,
> jirka
> 
> > 
> > [root@zoo ~]# cat /proc/loadavg 
> > 52.13 13.06 5.04 132/977 29522
> > [root@zoo ~]# perf sched record  -m 4096 -- perf bench sched all
> > # Running sched/messaging benchmark...
> > # 20 sender and receiver processes per group
> > # 10 groups == 400 processes run
> > 
> >      Total time: 0.692 [sec]
> > 
> > # Running sched/pipe benchmark...
> > # Executed 1000000 pipe operations between two processes
> > 
> >      Total time: 13.007 [sec]
> > 
> >       13.007582 usecs/op
> >           76878 ops/sec
> > 
> > [ perf record: Woken up 105 times to write data ]
> > [ perf record: Captured and wrote 909.513 MB perf.data (~39737216 samples) ]
> > [root@zoo ~]# cat /proc/loadavg 
> > 80.30 22.82 8.49 132/968 31755
> > [root@zoo ~]# perf script | wc -l
> > 8308492
> > [root@zoo ~]# perf cript | head -10
> >  perf 9897 [01] 1.29678: sched:sched_stat_runtime: comm=perf pid=29897 runtime=916836 [ns] vruntime=1322281938410 [ns]
> >  perf 9897 [01] 1.29683: sched:sched_wakeup: comm=perf pid=29919 prio=120 success=1 target_cpu=001
> >  perf 9897 [01] 1.29688: sched:sched_switch: prev_comm=perf prev_pid=29897 prev_prio=120 prev_state=R ==> next_comm=perf next_pid=29919 next_prio=120
> >  perf 9919 [01] 1.29748: sched:sched_stat_runtime: comm=perf pid=29919 runtime=70430 [ns] vruntime=1322273008840 [ns]
> >   cc1 7110 [03] 1.29748: sched:sched_stat_runtime: comm=cc1 pid=27110 runtime=992012 [ns] vruntime=702438664528 [ns]
> >   cc1 9278 [00] 1.29748: sched:sched_stat_runtime: comm=cc1 pid=29278 runtime=979081 [ns] vruntime=583946650623 [ns]
> >   cc1 7781 [02] 1.29749: sched:sched_stat_runtime: comm=cc1 pid=27781 runtime=989627 [ns] vruntime=714050072391 [ns]
> >   cc1 9278 [00] 1.29756: sched:sched_switch: prev_comm=cc1 prev_pid=29278 prev_prio=120 prev_state=R ==> next_comm=cc1 next_pid=29128 next_prio=120
> >   cc1 7110 [03] 1.29757: sched:sched_switch: prev_comm=cc1 prev_pid=27110 prev_prio=120 prev_state=R ==> next_comm=cc1 next_pid=29586 next_prio=120
> >  perf 9919 [01] 1.29914: sched:sched_wakeup: comm=migration/1 pid=12 prio=0 success=1 target_cpu=001
> > [root@zoo ~]#
> > 
> > While doing a make -j128 allmodconfig on a 4way machine.
> > 
> > David, can I have your Acked-by for just those two while the rest is debated?
> > 
> > Adrian, can I have yours as well?
> > 
> > - Arnaldo
