Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbaG3HKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:10:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:13865 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbaG3HKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:10:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="569295995"
Date: Wed, 30 Jul 2014 07:08:29 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        arjan.van.de.ven@intel.com, Len Brown <len.brown@intel.com>,
        rafael.j.wysocki@intel.com, alan.cox@intel.com,
        "Gross, Mark" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140729230829.GB28673@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
 <CAKfTPtAoer-c7Hynr-VhvF112MaoUybM8zhaQKrc+n0CJ3Z47g@mail.gmail.com>
 <20140727173616.GA22986@intel.com>
 <CAKfTPtBR1dK-8nFGAMvEa2AC6ByZgOskkZpWEOXwzDrUD6xBDg@mail.gmail.com>
 <20140729093911.GU20603@laptop.programming.kicks-ass.net>
 <20140729015344.GF5203@intel.com>
 <20140729133510.GF3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729133510.GF3935@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 03:35:10PM +0200, Peter Zijlstra wrote:
> 
> Does not compute, sorry. How would delaying the effect of migrations
> help?
> 
> Suppose we have 2 cpus and 6 tasks. cpu0 has 2 tasks, cpu1 has 4 tasks.
> the group weights are resp. 341 and 682. We compute we have an imbalance
> of 341 and need to migrate 170 to equalize. We achieve this by moving
> the 1 task, such that both cpus end up with 4 tasks.
> 
> After that we want to find weights of 512 and 512. But if we were to
> consider old weights, we'd find 426 and 597 making it appear there is
> still an imbalance. We could end up migrating more, only to later find
> we overshot and now need to go back.
> 
> This is the classical ringing problem.
> 
> I also don't see any up-sides from doing this.

I am not sure I understand your example, but it seems it is group weight
distribution. Since in migration, we migrate the load with task, 170 will be
utterly moved. So the new weight/share distribution would be immediate
512 and 512.

But for the group entity's parent cfs_rq in terms of how this group entity
contributes to load in the infinite decaying series, it would be
e.g., 341 and before, migration, then 512 thereafter.

Hope this graph helps:

CPU1 <--> cfs_rq1                         CPU2 <--> cfs_rq2
             |                                         |
      |------------|                            |------------|
tsk_entity1   tg_entity1 <--> tg_cfs_rq1  tsk_entity2   tg_entity2 <--> tg_cfs_rq2
                                  |                                         |
                            tsk_entity3                               tsk_entity4

Then On CPU1:

cfs_rq1->avg.load_avg = tsk_entity1->avg.load_avg + tg_entity1->avg.load_avg

tg_cfs_rq1->avg.load_avg = tsk_entity3->avg.load_avg

tg_entity1's weight = tg_cfs_rq1->avg.load_avg / (tg_cfs_rq1->avg.load_avg + tg_cfs_rq2->avg.load_avg)

Same for things on CPU2.

