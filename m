Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab3KIAPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 19:15:55 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:5296 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087Ab3KIAPx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 19:15:53 -0500
From: "Rowand, Frank" <Frank.Rowand@sonymobile.com>
To: Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
CC: Alex Shi <alex.shi@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Ingo Molnar <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Paul Walmsley <paul@pwsan.com>, Mel Gorman <mgorman@suse.de>,
        Juri Lelli <juri.lelli@gmail.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        Kevin Hilman <khilman@linaro.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 9 Nov 2013 01:15:50 +0100
Subject: RE: Bench for testing scheduler
Thread-Topic: Bench for testing scheduler
Thread-Index: Ac7b4MDMpe05M22+SuysU1SZ9/rYNgA+0i5R
Message-ID: <8251B150E4DF5041A62C3EA9F0AB2E060255308A9E80@SELDMBX99.corpusers.net>
References: <CAKfTPtCh+f1FZxkWqU5=2PjGtfRaN8jVV3WdTCzLDAWSjMP7yw@mail.gmail.com>,<20131107174214.GB25590@e103034-lin>
In-Reply-To: <20131107174214.GB25590@e103034-lin>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, sv-SE
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 07, 2013 9:42 AM, Morten Rasmussen [morten.rasmussen@arm.com] wrote:
> 
> Hi Vincent,
> 
> On Thu, Nov 07, 2013 at 10:54:30AM +0000, Vincent Guittot wrote:
> > Hi,
> >
> > During the Energy-aware scheduling mini-summit, we spoke about benches
> > that should be used to evaluate the modifications of the scheduler.
> > I’d like to propose a bench that uses cyclictest to measure the wake
> > up latency and the power consumption. The goal of this bench is to
> > exercise the scheduler with various sleeping period and get the
> > average wakeup latency. The range of the sleeping period must cover
> > all residency times of the idle state table of the platform. I have
> > run such tests on a tc2 platform with the packing tasks patchset.
> > I have use the following command:
> > #cyclictest -t <number of cores> -q -e 10000000 -i <500-12000> -d 150 -l 2000
> 
> I think cyclictest is a useful model small(er) periodic tasks for
> benchmarking energy related patches. However, it doesn't have a
> good-enough-performance criteria as it is. I think that is a strict
> requirement for all energy related benchmarks.
> 
> Measuring latency gives us a performance metric while the energy tells
> us how energy efficient we are. But without a latency requirement we
> can't really say if a patch helps energy-awareness unless it improves
> both energy _and_ performance. That is the case for your packing patches
> for this particular benchmark with this specific configuration. That is
> a really good result. However, in the general case patches may trade a
> bit of performance to get better energy, which is also good if
> performance still meets the requirement of the application/user. So we
> need a performance criteria to tells us when we sacrifice too much
> performance when trying to save power. Without it it is just a
> performance benchmark where we measure power.
> 
> Coming up with a performance criteria for cyclictest is not so easy as
> it doesn't really model any specific application. I guess sacrificing a
> bit of latency is acceptable if it comes with significant energy
> savings. But a huge performance impact might not be, even if it comes
> with massive energy savings. So maybe the criteria would consist of both
> a minimum latency requirement (e.g. up to 10% increase) and a
> requirement for improved energy per work.
> 
> As I see it, it the only way we can validate energy efficiency of
> patches that trade performance for improved energy.

I think those comments capture some of the additional complexity of
the power vs performance tradeoff that need to be considered.

One thing not well-defined is what "performance" is.  The session at the
kernel discussed throughput and latency.  I'm not sure if people are
combining two different things into the name of latency.  To me, latency
is wake up latency; the elapsed time from when an event occurred to when
the process handling the event is executing instructions (where I think of
the process typically as user space code, but it could sometimes instead
be kernel space code).  The second thing people might think of as latency
is how long from the triggering event until when work is completed on
behalf of the consumer event (where the consumer could be a machine, but
is often a human being, eg if a packet from google arrives, how long until
I see the search result on my screen).  This second thing I call response time.

Then "wake up latency" is also probably a mis-nomer.  The cyclictest wake up
latency ends when the cyclictest thread is both woken, and then is actually
executing code on the cpu ("running").

Wake up latency is a fine thing to focus on (especially since power management
can have a large impact on wake up latency) but I hope we remember to pay
attention to response time as one of the important performance metrics.

Onward to cyclictest...  Cyclictest is commonly referred to as a benchmark
(which it is), but it is at the core more like instrumentation, providing
a measure of some types of wake up latency.  Cyclictest is normally used
in conjunction with a separate workload.  (Even though cyclictest has
enough tuning knobs that it can also be used as a workload.)  There are some
ways that perf and cyclictest can be compared as sources of performance data:

  -----  cyclictest

  - Measures wake up latency of only cyclictest threads.
  - Captures _entire_ latency, including coming out of low power mode to
    service the (timer) interrupt that results in the task wake up.

  -----  perf sched

  - Measures all processes (this can be sliced and diced in post-processing
    to include any desired set of processes).
  - Captures latency from when task is _woken_ to when task is _executing code_
    on a cpu.

I think both cyclictest and perf sched are valuable tools, that can each
contribute to understanding system behavior.

-Frank