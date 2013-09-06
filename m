Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab3IFSVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:21:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2118 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3IFSVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:21:38 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=VnNF1IyMAAAA:8 a=bbago9hAfINLHI6qlsAA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 6 Sep 2013 14:21:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130906142135.438caba1@gandalf.local.home>
In-Reply-To: <20130906175238.GV3966@linux.vnet.ibm.com>
References: <20130905195234.GA20555@linux.vnet.ibm.com>
	<20130906105934.GF20519@somewhere>
	<20130906151851.GQ3966@linux.vnet.ibm.com>
	<20130906113320.46b2ea3e@gandalf.local.home>
	<20130906164016.GB2706@somewhere>
	<20130906125238.3c5ef919@gandalf.local.home>
	<20130906170006.GC2706@somewhere>
	<20130906131631.6a0a192d@gandalf.local.home>
	<20130906175238.GV3966@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Sep 2013 10:52:38 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
 
> > What exactly does "extended quiescent state" mean? (Note, that's a
> > rhetorical question)
> 
> In which case my rhetorical (and therefore useless) answer has to be
> "it is a quiescent state that is extended".  ;-)
> 
> Sorry, couldn't resist...

Of course you couldn't ;)

> 
> > I wonder if we should change "rcu_cpu_ignore()" for "rcu_eqs_enter()"
> > and "rcu_cpu_heed()" for "rcu_eqs_exit()", as IMHO that's much more
> > straight forward to understand than trying to wrap you head around what
> > a quiescent state is, and why we are entering it or exiting it.
> > 
> > It also flat out explains to people that rcu is not processing that
> > current CPU, and things like rcu_read_lock() should not be used.
> > 
> > Then we can say "rcu_cpu_is_ignored()" for things like
> > "rcu_is_cpu_eqs()".
> 
> Currently, none of RCU's _eqs functions are exported, so they have
> the potential to confuse only people working on the RCU implementation
> itself, who had better understand what "eqs" means.

Yeah, that's what I thought, and never cared about the "eqs" meaning.

> 
> But I do count your vote against "eqs" appearing in the name of any
> function exported by RCU.

Right, their shouldn't be any "eqs" functions that are global to users
outside of the RCU infrastructure.

> 
> How about if I made rcu_is_cpu_idle() be as follows?
> 
> int rcu_is_cpu_idle(void)
> {
> 	int ret;
> 
> 	ret = (atomic_read(&per_cpu(rcu_dynticks.dynticks,
> 				    raw_smp_processor_id())) & 0x1) == 0;
> 	return ret;
> }
> 
> This should allow existing uses to function properly and should allow
> you to use it as well.
>

You already said it wont work, but I still would have been against
using it, because I wouldn't be checking if rcu thinks the CPU is idle,
as NO_HZ_FULL has nothing to do with idle.

-- Steve
