Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaGKD4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 23:56:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:47553 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbaGKD4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 23:56:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="568273688"
Date: Fri, 11 Jul 2014 03:53:48 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: bsegall@google.com
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, fengguang.wu@intel.com
Subject: Re: [PATCH 2/2] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140710195348.GA12984@intel.com>
References: <1404268256-3019-2-git-send-email-yuyang.du@intel.com>
 <20140707104646.GK6758@twins.programming.kicks-ass.net>
 <xm26r41wyfgc.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140708000840.GB25653@intel.com>
 <xm26k37nye7d.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140709010753.GD25653@intel.com>
 <20140709184543.GI9918@twins.programming.kicks-ass.net>
 <xm26bnsyxsf7.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140710100859.GW3935@laptop>
 <xm267g3lxi4p.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xm267g3lxi4p.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 10:01:42AM -0700, bsegall@google.com wrote:
> > The problem with that is that last_update_time is measured in
> > clock_task, and you cannot transfer these values between CPUs.
> > clock_task can drift unbounded between CPUs.
> 
> Yes, but we don't need to - we just use the remote last_update_time to
> do a final update on p->se.avg, and then subtract that from cfs_rq->avg
> with atomics (and then set p->se.avg.last_update_time to 0 as now). This
> throws away any time since last_update_time, but that's no worse than
> current, which throws away any time since decay_counter, and they're
> both called from enqueue/dequeue/tick/update_blocked_averages.

Yes, old CPU clock_task will not go to new CPU, we set last_update_time to 0,
and on new CPU, when enqueued, it will start with new clock. Just throw some time
way as Ben said.

Actually, this throwing away is not bad after a second thought, because it results in
less decaying the wakee load, which effectively add some load/weight to the wakee,
sounds good.

Thanks,
Yuyang
