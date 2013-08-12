Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab3HLOKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:10:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10665 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3HLOKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:10:11 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=xQuigt2pMRoA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Jp2RfDP34KgA:10 a=JfrnYn6hAAAA:8 a=2xFVwgrMa7_j-gW2pIwA:9 a=CjuIK1q_8ugA:10 a=3Rfx1nUSh_UA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 12 Aug 2013 10:10:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/8] rcu: eliminate deadlock for rcu read site
Message-ID: <20130812101008.27048d83@gandalf.local.home>
In-Reply-To: <20130812135309.GF27162@twins.programming.kicks-ass.net>
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
	<1375871104-10688-6-git-send-email-laijs@cn.fujitsu.com>
	<20130808204020.GA31127@linux.vnet.ibm.com>
	<5205B6FF.7060502@cn.fujitsu.com>
	<20130812135309.GF27162@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Aug 2013 15:53:10 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, Aug 10, 2013 at 11:43:59AM +0800, Lai Jiangshan wrote:
> > Hi, Steven
> > 
> > I was considering rtmutex's lock->wait_lock is a scheduler lock,
> > But it is not, and it is just a spinlock of process context.
> > I hope you change it to a spinlock of irq context.
> 
> rwmutex::wait_lock is irq-safe; it had better be because its taken under
> task_struct::pi_lock. 

It is? I thought it was the other way around. That is, pi_lock is taken
under wait_lock.

task_blocks_on_rt_mutex() is called with wait_lock held. The first
thing it does is to grab the pi_lock.

The wait_lock is the mutex internal lock. Currently, no interrupt
context should take that lock, or should there be an interrupt lock
held when it is taken. The lock should be taken in the same contexts
that a mutex can be taken in.

By making it a irq-safe lock, we need to disable interrupts every time
it is taken, which means the entire pi-chain walk in
rt_mutex_adjust_prio_chain() will pretty much be with interrupts
disabled. I really would like to avoid making wait_lock irq-safe if we
can avoid it. I'm sure it will have a large impact to the -rt kernel if
we convert it.


-- Steve
