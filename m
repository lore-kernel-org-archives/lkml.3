Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaLPQHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:07:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:57266 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbaLPQHh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:07:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,587,1413270000"; 
   d="scan'208";a="638449796"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eranian@google.com" <eranian@google.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH 1/1] perf, core: Use sample period avg as child event's
 initial period
Thread-Topic: [PATCH 1/1] perf, core: Use sample period avg as child event's
 initial period
Thread-Index: AQHQFiC1uYsbQKGdm0q1ioqk/SrV4pyP6ECAgADacQCAAOSgAIAAtCbA
Date: Tue, 16 Dec 2014 16:05:33 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F0770168DF57@SHSMSX103.ccr.corp.intel.com>
References: <1418397035-7014-1-git-send-email-kan.liang@intel.com>
 <20141215095551.GU29390@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F0770168DAE9@SHSMSX103.ccr.corp.intel.com>
 <20141216123558.GX3337@twins.programming.kicks-ass.net>
In-Reply-To: <20141216123558.GX3337@twins.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 
> On Mon, Dec 15, 2014 at 09:17:33PM +0000, Liang, Kan wrote:
> > > This doesn't seem to make any kind of sense, and its weirdly
> implemented.
> > >
> > > So why would you push anything to the original parent? Your
> > > description states that the parent event usually has 1, and then you
> > > argue about fixing that by using the orig parent, but then you need to
> update the orig parent.
> > > Did you go in circles and confuse yourself? Why not push things into
> > > the regular parent event if you're going to push things up.
> >
> > My thought is that the original parent is the root of the tree.
> 
> No parent is the root; I thought your orig parent thing was the event you
> forked from, but now I see its not.
> 
> See inherit_event(), event->parent is the root event.
> 
I c. I will keep the information in regular parent event.

> > If there is an
> > average sample period for nodes, it should be kept in the root node,
> > since it's the only node everyone knows.
> 
> Right, but, that's also contention central..
> 
> > > Also, since you can have multiple child events, on many CPUs
> > > local64_t is the wrong data type, furthermore its going to be a
> > > scalability issue on big hardware.
> >
> > I'd like to have avg_sample_period for each CPU. The similar usage is
> > period_left in hw_perf_event.
> 
> Well, some events are per cpu, some are per task. The per task events do
> not have per-cpu storage and their parent can be on whatever cpu.
>

I will use atomic64_t to replace local64_t.
 
> > We don't need to share the avg_sample_period between CPUs, after all
> > it's only a reference.
> 
> Right, some smarts are needed to avoid the worst contention there.
> Maybe a jiffy timestamp and don't update more than once every HZ jiffies
> or so.

perf_adjust_freq_unthr_context will be called each tick. I think we may
only update the avg_sample_period in this function. 
Also, I think we'd better to update the avg_sample_period in first period
adjust. We need to get rid of 1 period as earlier as possible. 
I will change the update part as below.

@@ -2810,8 +2833,10 @@ static void perf_adjust_period(struct perf_event
 *event, u64 nsec, u64 count, bo

        hwc->sample_period = sample_period;

+       if (!disable || (atomic64_read(&head_event->avg_sample_period)
 == 1)) {
+               avg_period = (atomic64_read(&head_event->avg_sample_period
) + sample_period) / 2;
+               atomic64_set(&head_event->avg_sample_period, avg_period);
+       }

        if (local64_read(&hwc->period_left) > 8*sample_period) {
                if (disable)

Thanks,
Kan

