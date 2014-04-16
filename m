Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaDPFVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:21:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56457 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbaDPFVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:21:53 -0400
Date: Wed, 16 Apr 2014 07:21:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>, cl@linux.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, tj@kernel.org, grygorii.strashko@ti.com
Subject: Re: How do I increment a per-CPU variable without warning?
Message-ID: <20140416052147.GK26782@laptop.programming.kicks-ass.net>
References: <20140415221755.GA27188@linux.vnet.ibm.com>
 <20140415222951.GA742@redhat.com>
 <20140415224725.GS4496@linux.vnet.ibm.com>
 <20140416035419.GA30105@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416035419.GA30105@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 08:54:19PM -0700, Paul E. McKenney wrote:
> But falling back on the old ways of doing this at least looks a bit
> nicer:
> 
> 	static inline bool rcu_should_resched(void)
> 	{
> 		int t;
> 		int *tp = &per_cpu(rcu_cond_resched_count, raw_smp_processor_id());
> 
> 		t = ACCESS_ONCE(*tp) + 1;
> 		if (t < RCU_COND_RESCHED_LIM) {

<here>

> 			ACCESS_ONCE(*tp) = t;
> 			return false;
> 		}
> 		return true;
> 	}
> 
> Other thoughts?

Still broken, if A starts out on CPU1, gets migrated to CPU0 at <here>,
then B starts the same on CPU1. It is possible for both CPU0 and CPU1 to
write a different value into your rcu_cond_resched_count.

You really want to disable preemption around there. The proper old way
would've been get_cpu_var()/put_cpu_var().

