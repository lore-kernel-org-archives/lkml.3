Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaG2PuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:50:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52641 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaG2PuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:50:03 -0400
Date: Tue, 29 Jul 2014 17:49:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        jhladky@redhat.com, ktkhai@parallels.com, tim.c.chen@linux.intel.com,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 1/2] sched: fix and clean up calculate_imbalance
Message-ID: <20140729154956.GJ3935@laptop>
References: <1406571388-3227-1-git-send-email-riel@redhat.com>
 <1406571388-3227-2-git-send-email-riel@redhat.com>
 <CAKfTPtDuFLOf3Kzt4PSdox3HpBoz9aWXb-QzkibAL-Z4xBm=tw@mail.gmail.com>
 <20140729145910.GH3935@laptop>
 <53D7BAA5.8080404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D7BAA5.8080404@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 11:15:49AM -0400, Rik van Riel wrote:

> > Right, so we want that code for overloaded -> overloaded migrations
> > such as not to cause idle cpus in an attempt to balance things.
> > Idle cpus are worse than imbalance.
> > 
> > But in case of overloaded/imb -> !overloaded migrations we can
> > allow it, and in fact want to allow it in order to balance idle
> > cpus.
> 
> In case the destination is over the average load, or the source is under
> the average load, fix_small_imbalance() determines env->imbalance.
> 
> The "load_above_capacity" calculation is only reached when busiest is
> busier than average, and the destination is under the average load.
> In that case, env->imbalance ends up as the minimum of busiest - avg
> and avg - target.
> 
> Is there any case where limiting it further to "load - capacity" from
> the busiest domain makes a difference?

sadly yes; suppose 8 cpus in 2 groups and 9 tasks, 8 tasks of weight 10,
1 of 1024. The local group will have 5 tasks of 10, the busiest will
have the remaining 4.

The sd avg is 138, local avg is 12, busiest avg is 263.

This gives: busiest-avg = 122, avg - local = 110

So an imbalance of 110.

Without limiting it further, we would migrate all 3 10 tasks over to
local and run 3 cpus idle.

Now running all 8 10 tasks on a single cpu and the 1 1024 task on
another and keeping 6 cpus idle is the 'fairest' solution, but that's
not the only goal, we also try and be work-conserving, iow. keep as many
cpus busy as possible.
