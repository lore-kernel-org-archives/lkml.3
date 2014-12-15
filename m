Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750876AbaLOVRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:17:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:16301 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbaLOVRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:17:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,581,1413270000"; 
   d="scan'208";a="637960932"
From: "Liang, Kan" <kan.liang@intel.com>
To: "'Peter Zijlstra'" <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eranian@google.com" <eranian@google.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH 1/1] perf, core: Use sample period avg as child event's
 initial period
Thread-Topic: [PATCH 1/1] perf, core: Use sample period avg as child event's
 initial period
Thread-Index: AQHQFiC1uYsbQKGdm0q1ioqk/SrV4pyP6ECAgADacQA=
Date: Mon, 15 Dec 2014 21:17:33 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F0770168DAE9@SHSMSX103.ccr.corp.intel.com>
References: <1418397035-7014-1-git-send-email-kan.liang@intel.com>
 <20141215095551.GU29390@twins.programming.kicks-ass.net>
In-Reply-To: <20141215095551.GU29390@twins.programming.kicks-ass.net>
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

> On Fri, Dec 12, 2014 at 10:10:35AM -0500, kan.liang@intel.com wrote:
>
> > That's because, in the inherit_event, the period for child event is
> > inherit from parent's parent's event, which is usually the default
> > sample_period 1. Each child event has to recaculate the period from 1
> > everytime. That brings high overhead.
> >
> > This patch keeps the sample period average in original parent event.
>
> That's going to make an even worse nightmare of the refcounting :/

It will not change the refcount. Current mechanism has already
guarantee the original parent event doesn't go away until all children
events go away, doesn't it?

>
> > Each new child event can use it as its initial sample period.
> > Adding a ori_parent in struct perf_event to help child event access
> > the original parent. For each new child event, the parent event
> refcount++.
> > Parent will not go away until all children go away. So the stored
> > pointer is safe to be accessed.
>
> So going by the above you only use this once, during fork, which already
> guarantees the existence of the parent.
>
> Now looking at the code you actually use it again in
> perf_adjust_period() and push period adjustments into the parent.

The original parent is the last event to be released. It is safe to keep
children's average period in original parent struct.

Yes, there are two places to access the average sample period.
In inherit_event, the stored average sample period in ori parent will pass
to child event. In perf_adjust_period, the average sample period will be
recalculated and stored in ori parent event.

I can add the description about updating period avg in perf_adjust_period

>
> This doesn't seem to make any kind of sense, and its weirdly implemented.
>
> So why would you push anything to the original parent? Your description
> states that the parent event usually has 1, and then you argue about fixing
> that by using the orig parent, but then you need to update the orig parent.
> Did you go in circles and confuse yourself? Why not push things into the
> regular parent event if you're going to push things up.

My thought is that the original parent is the root of the tree. If there is an
average sample period for nodes, it should be kept in the root node, since
it's the only node everyone knows.
Yes, it's OK to put the average sample period in the regular parent event.
Because what we need is a reference for initial sample period of new child.
No matter it's from all event or just sibling/direct parent event average, the
average sample period is more larger than 1.
So I think either is fine. I can push things to the regular parent event.

>
> Also, since you can have multiple child events, on many CPUs local64_t is
> the wrong data type, furthermore its going to be a scalability issue on big
> hardware.

I'd like to have avg_sample_period for each CPU. The similar usage is
period_left in hw_perf_event.
We don't need to share the avg_sample_period between CPUs, after all
it's only a reference.


Thanks,
Kan

>
> So please, try again. And try and explain what you're actually doing.
