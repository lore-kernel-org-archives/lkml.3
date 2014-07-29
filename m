Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaG2NfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:35:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:37001 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaG2NfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:35:16 -0400
Date: Tue, 29 Jul 2014 15:35:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
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
Message-ID: <20140729133510.GF3935@laptop>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
 <CAKfTPtAoer-c7Hynr-VhvF112MaoUybM8zhaQKrc+n0CJ3Z47g@mail.gmail.com>
 <20140727173616.GA22986@intel.com>
 <CAKfTPtBR1dK-8nFGAMvEa2AC6ByZgOskkZpWEOXwzDrUD6xBDg@mail.gmail.com>
 <20140729093911.GU20603@laptop.programming.kicks-ass.net>
 <20140729015344.GF5203@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729015344.GF5203@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 09:53:44AM +0800, Yuyang Du wrote:
> On Tue, Jul 29, 2014 at 11:39:11AM +0200, Peter Zijlstra wrote:
> > > > For task, assuming its load.weight does not change much, yes, we can. But in theory, task's
> > > 
> > > I would even say that the load_avg of a task should not be impacted by
> > > an old priority value. Once, the priority of a task is changed, we
> > > should only take into account this new priority to weight the load_avg
> > > of the task
> > 
> > So for tasks I would immediately agree, and I think for groups too,
> > seeing how the group weight is based off of this avg, if you then
> > include the old weight we'll get a feedback loop. This might not be
> > desired as it would counteract the SMP movement of tasks.
> 
> Including the old weight can we get the *right* feedback. Because say until
> weight is changed, we are balanced, changed weight leads to imbalance. Without
> old weight, the imbalance is multiplied by the history, like we have never been
> balanced.

Does not compute, sorry. How would delaying the effect of migrations
help?

Suppose we have 2 cpus and 6 tasks. cpu0 has 2 tasks, cpu1 has 4 tasks.
the group weights are resp. 341 and 682. We compute we have an imbalance
of 341 and need to migrate 170 to equalize. We achieve this by moving
the 1 task, such that both cpus end up with 4 tasks.

After that we want to find weights of 512 and 512. But if we were to
consider old weights, we'd find 426 and 597 making it appear there is
still an imbalance. We could end up migrating more, only to later find
we overshot and now need to go back.

This is the classical ringing problem.

I also don't see any up-sides from doing this.
