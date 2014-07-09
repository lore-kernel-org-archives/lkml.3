Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaGJHdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:33:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:56586 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbaGJHdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:33:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,636,1400050800"; 
   d="scan'208";a="455293394"
Date: Thu, 10 Jul 2014 07:30:49 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: bsegall@google.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        pjt@google.com, fengguang.wu@intel.com
Subject: Re: [PATCH 2/2] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140709233049.GA12024@intel.com>
References: <1404268256-3019-1-git-send-email-yuyang.du@intel.com>
 <1404268256-3019-2-git-send-email-yuyang.du@intel.com>
 <20140707104646.GK6758@twins.programming.kicks-ass.net>
 <xm26r41wyfgc.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140708000840.GB25653@intel.com>
 <xm26k37nye7d.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140709010753.GD25653@intel.com>
 <20140709184543.GI9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140709184543.GI9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Peter.

On Wed, Jul 09, 2014 at 08:45:43PM +0200, Peter Zijlstra wrote:

> Nope :-).. we got rid of that lock for a good reason.
> 
> Also, this is one area where I feel performance really trumps
> correctness, we can fudge the blocked load a little. So the
> sched_clock_cpu() difference is a strict upper bound on the
> rq_clock_task() difference (and under 'normal' circumstances shouldn't
> be much off).

Strictly, migrating wakee task on remote CPU entails two steps:

(1) Catch up with task's queue's last_update_time, and then substract

(2) Cache up with "current" time of remote CPU (for comparable matter), and then
    on new CPU, change to the new timing source (when enqueue)

So I will try sched_clock_cpu(remote_cpu) for step (2). For step (2), maybe we
should not use cfs_rq_clock_task anyway, since the task is about to going
to another CPU/queue. Is this right?

I made another mistake. Should not only track task entity load, group entity
(as an entity) is also needed. Otherwise, task_h_load can't be done correctly...
Sorry for the messup. But this won't make much change in the codes.

Thanks,
Yuyang
 
> So we could simply use a timestamps from dequeue and one from enqueue,
> and use that.
> 
> As to the remote subtraction, a RMW on another cacheline than the
> rq->lock one should be good; esp since we don't actually observe the
> per-rq total often (once per tick or so) I think, no?
> 
> The thing is, we do not want to disturb scheduling on whatever cpu the
> task last ran on if we wake it to another cpu. Taking rq->lock wrecks
> that for sure. 


