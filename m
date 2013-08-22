Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab3HVOlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:41:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20950 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3HVOls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:41:48 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=xQuigt2pMRoA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Jp2RfDP34KgA:10 a=pGLkceISAAAA:8 a=DpmWWS9lAAAA:8 a=t0DuJbGfD2PC23SIALsA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 22 Aug 2013 10:41:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/8] rcu: eliminate deadlock for rcu read site
Message-ID: <20130822104147.06f26190@gandalf.local.home>
In-Reply-To: <20130822103431.7abc09ab@gandalf.local.home>
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
	<1375871104-10688-6-git-send-email-laijs@cn.fujitsu.com>
	<20130808204020.GA31127@linux.vnet.ibm.com>
	<5205B6FF.7060502@cn.fujitsu.com>
	<20130812135309.GF27162@twins.programming.kicks-ass.net>
	<20130812101008.27048d83@gandalf.local.home>
	<CACvQF51-oAGkdxwku+orKSQ=SZd1A4saXzkrgcRGi+KnZUZYxQ@mail.gmail.com>
	<20130822103431.7abc09ab@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013 10:34:31 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 22 Aug 2013 22:23:09 +0800
> Lai Jiangshan <eag0628@gmail.com> wrote:
> 
> 
> > > By making it a irq-safe lock, we need to disable interrupts every time
> > > it is taken, which means the entire pi-chain walk in
> > > rt_mutex_adjust_prio_chain() will pretty much be with interrupts
> > > disabled.
> > 
> > 
> > I didn't catch your meaning.
> > rt_mutex_adjust_prio_chain() is called without wait_lock held.
> > current C.S. of wait_lock are really short.
> > 
> 
> There is quite a bit of overhead to enable and disable interrupts. If
> we are doing this in a very fast path, it's going to slow down -rt even
> more.

Looking at the rt_mutex_adjust_prio_chain(), it's not that bad because
the pi_lock needs irqs disabled too, and we would just extend that
section.

But it still extends irqs off.

But in -rt, it is used in the rt_spin_lock_slowlock() where it can exit
out of the code without ever having to disable interrupts.

> 
> It would be really nice to avoid making wait_lock be irq safe.

I still would like to exhaust other options before just making
wait_lock irq safe.

-- Steve
