Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaGKIrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:47:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:39968 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaGKIrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:47:13 -0400
Date: Fri, 11 Jul 2014 10:47:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: bsegall@google.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        pjt@google.com, fengguang.wu@intel.com
Subject: Re: [PATCH 2/2] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140711084709.GF20603@laptop.programming.kicks-ass.net>
References: <1404268256-3019-2-git-send-email-yuyang.du@intel.com>
 <20140707104646.GK6758@twins.programming.kicks-ass.net>
 <xm26r41wyfgc.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140708000840.GB25653@intel.com>
 <xm26k37nye7d.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140709010753.GD25653@intel.com>
 <20140709184543.GI9918@twins.programming.kicks-ass.net>
 <xm26bnsyxsf7.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140710100859.GW3935@laptop>
 <20140710232207.GC12984@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140710232207.GC12984@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 07:22:07AM +0800, Yuyang Du wrote:
> On Thu, Jul 10, 2014 at 12:08:59PM +0200, Peter Zijlstra wrote:
> > 
> > Since clock_task is the regular clock minus some local amount, the
> > difference between two regular clock reads is always a strict upper
> > bound on clock_task differences.
> > 
> This is inspiring. Regarding the clock source in load avg tracking,
> should we simply use rq_clock_task instead of cfs_rq_clock_task.

Oh *groan* I forgot about that thing. But no, it obviously doesn't
matter for running time, because if you're throttled you're nor running
and therefore it all doesn't matter, but it can make a huge difference
for blocked time accounting I suppose.

> For the bandwidth control case, just update/increase the last_update_time when
> unthrottled by this throttled time, so the time would look like freezed. Am I
> understanding right?

Yes, it stops the clock when throttled.

> Not sure how much bandwidth control is used, but even not used, every time
> we read cfs_rq_clock_task, will burn useless cycles here.

Yep, nothing much you can do about that.

In any case, it is still the case that a normal clock difference is an
upper bound.
