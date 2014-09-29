Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaI2JhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:37:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:36825 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbaI2JhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:37:03 -0400
Date: Mon, 29 Sep 2014 11:36:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: kan.liang@intel.com, eranian@google.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, paulus@samba.org, acme@kernel.org,
        ak@linux.intel.com, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V5 02/16] perf, core: introduce pmu context switch
 callback
Message-ID: <20140929093657.GD5430@worktop>
References: <978920978-30191-1-git-send-email-kan.liang@intel.com>
 <978920978-30191-3-git-send-email-kan.liang@intel.com>
 <20140927164738.GA21729@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140927164738.GA21729@lerouge>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 06:47:41PM +0200, Frederic Weisbecker wrote:

Trim replies already -- I should really go write that auto-bounce for
excessive quoting already.

> I wonder if it's worth to create such an arch callback and core corner case.
> How about just scheduling out then in the events that have lbr, wouldn't we
> have more simple code in the end?

That depends a bit, the lbr save/restore is indeed very expensive (at
least 16 msr reads and 16 msr writes -- when assuming 16 deep lbr), but
this is still on about the same order of msr writes required to switch 4
counters (esp. if we include the PEBS msrs).

So at that point we still win about half the context switch cost by not
doing an unconditional sched out / sched in.

Also, there are more consumers of this thing.

> Besides, BTS would benefit from that too. I can't seem to find where it is
> flushed when a task context switches inside a same perf context. It seems
> that it doesn't happen, BTS traces are flushed only on event stop (and overflow IRQ)
> and events aren't stopped if a context switch happens in the same perf context.
> Having Y task bts traces from task X event is probably not what we want.

Flushing the BTS is indeed a good point, but that would definitely
benefit from this, draining the BTS buffer is likely faster than doing
all those MSR writes.
