Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaLPMgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 07:36:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:46836 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaLPMgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 07:36:11 -0500
Date: Tue, 16 Dec 2014 13:35:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eranian@google.com" <eranian@google.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH 1/1] perf, core: Use sample period avg as child event's
 initial period
Message-ID: <20141216123558.GX3337@twins.programming.kicks-ass.net>
References: <1418397035-7014-1-git-send-email-kan.liang@intel.com>
 <20141215095551.GU29390@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F0770168DAE9@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F0770168DAE9@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 09:17:33PM +0000, Liang, Kan wrote:
> > This doesn't seem to make any kind of sense, and its weirdly implemented.
> >
> > So why would you push anything to the original parent? Your description
> > states that the parent event usually has 1, and then you argue about fixing
> > that by using the orig parent, but then you need to update the orig parent.
> > Did you go in circles and confuse yourself? Why not push things into the
> > regular parent event if you're going to push things up.
> 
> My thought is that the original parent is the root of the tree.

No parent is the root; I thought your orig parent thing was the event
you forked from, but now I see its not.

See inherit_event(), event->parent is the root event.

> If there is an
> average sample period for nodes, it should be kept in the root node, since
> it's the only node everyone knows.

Right, but, that's also contention central..

> > Also, since you can have multiple child events, on many CPUs local64_t is
> > the wrong data type, furthermore its going to be a scalability issue on big
> > hardware.
> 
> I'd like to have avg_sample_period for each CPU. The similar usage is
> period_left in hw_perf_event.

Well, some events are per cpu, some are per task. The per task events do
not have per-cpu storage and their parent can be on whatever cpu.

> We don't need to share the avg_sample_period between CPUs, after all
> it's only a reference.

Right, some smarts are needed to avoid the worst contention there. Maybe
a jiffy timestamp and don't update more than once every HZ jiffies or
so.
