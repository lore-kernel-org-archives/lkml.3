Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaDGInD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 04:43:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:65128 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbaDGIm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 04:42:59 -0400
Message-ID: <1396860030.5170.4.camel@marge.simpson.net>
Subject: Re: [tip:sched/core] sched/numa: Move task_numa_free() to
 __put_task_struct()
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mgorman@suse.com, akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, Dave Jones <davej@redhat.com>
Date: Mon, 07 Apr 2014 10:40:30 +0200
In-Reply-To: <20140407081644.GD11096@twins.programming.kicks-ass.net>
References: <1393568591.6018.27.camel@marge.simpson.net>
	 <tip-156654f491dd8d52687a5fbe1637f472a52ce75b@git.kernel.org>
	 <5341A84C.4050902@oracle.com> <1396848585.5218.27.camel@marge.simpson.net>
	 <1396855830.28539.10.camel@marge.simpson.net>
	 <20140407081644.GD11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:NLV/1UGEknInxzTQy0t3z3rtya3P1aA91tsUHhgRLvk
 7tBU06FO9ZS4wdPlLvUp0olAT9HAMXE1gJHAHTddkU1zcgPBeh
 PgA/mWSVnqflKE3AZ9FlgAwXCuk6tiGcSPIjsP6ESC38PcB1uO
 5GoW3FtGdtyokohb0BQlMV3TX83VYoy11wRd+cdudTBy6PM6/1
 IOBJDtkq6SBMUnLeamX6mb+6ldVmqZJUTGGAaIMT8tCW+9FJZF
 fVGARnGhytbBzTBpKBlx7tfkHibcpvkFGBytZ8TXkqezOaq9HJ
 bXHTGZrOzxbOO++wmXVvpPWav+nVh9sK0gAka8jJ+r5s5XBcbc
 9OX+3xMg7rH33uCg/oaGryi1Y/qApJO6lJJI7jxhc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 10:16 +0200, Peter Zijlstra wrote: 
> On Mon, Apr 07, 2014 at 09:30:30AM +0200, Mike Galbraith wrote:
> > -	double_lock(&my_grp->lock, &grp->lock);
> > +	BUG_ON(irqs_disabled());
> > +	double_lock_irq(&my_grp->lock, &grp->lock);
> 
> So either make this:
> 
> 	local_irq_disable();
> 	double_lock();
> 
> or
> 
> >  
> >  	for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++) {
> >  		my_grp->faults[i] -= p->numa_faults_memory[i];
> > @@ -1692,6 +1693,7 @@ static void task_numa_group(struct task_
> >  
> >  	spin_unlock(&my_grp->lock);
> >  	spin_unlock(&grp->lock);
> > +	local_irq_enable();
> 
> use:
> 	spin_unlock()
> 	spin_unlock_irq()

*thwap*  Well duh.

> or so, but this imbalance is making my itch :-)

Yeah, much better.

Before I actually sign that off, mind cluing me in as to why I should
not be sitting here thinking lockdep smoked its breakfast?

-Mike

