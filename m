Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaLOJ4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 04:56:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:37688 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaLOJ4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 04:56:05 -0500
Date: Mon, 15 Dec 2014 10:55:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: linux-kernel@vger.kernel.org, eranian@google.com, ak@linux.intel.com
Subject: Re: [PATCH 1/1] perf, core: Use sample period avg as child event's
 initial period
Message-ID: <20141215095551.GU29390@twins.programming.kicks-ass.net>
References: <1418397035-7014-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418397035-7014-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 10:10:35AM -0500, kan.liang@intel.com wrote:

> That's because, in the inherit_event, the period
> for child event is inherit from parent's parent's event, which is
> usually the default sample_period 1. Each child event has to recaculate
> the period from 1 everytime. That brings high overhead.
> 
> This patch keeps the sample period average in original parent event.

That's going to make an even worse nightmare of the refcounting :/

> Each new child event can use it as its initial sample period.
> Adding a ori_parent in struct perf_event to help child event access the
> original parent. For each new child event, the parent event refcount++.
> Parent will not go away until all children go away. So the stored
> pointer is safe to be accessed.

So going by the above you only use this once, during fork, which already
guarantees the existence of the parent.

Now looking at the code you actually use it again in
perf_adjust_period() and push period adjustments into the parent.

This doesn't seem to make any kind of sense, and its weirdly
implemented.

So why would you push anything to the original parent? Your description
states that the parent event usually has 1, and then you argue about
fixing that by using the orig parent, but then you need to update the
orig parent. Did you go in circles and confuse yourself? Why not push
things into the regular parent event if you're going to push things up.

Also, since you can have multiple child events, on many CPUs local64_t
is the wrong data type, furthermore its going to be a scalability issue
on big hardware.

So please, try again. And try and explain what you're actually doing.
