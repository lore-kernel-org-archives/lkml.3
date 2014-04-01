Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbaDAXSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 19:18:33 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36721 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaDAXS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 19:18:27 -0400
Date: Tue, 1 Apr 2014 16:18:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_prempt stalls / lockup
Message-ID: <20140401231822.GC4284@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140331232220.GP4284@linux.vnet.ibm.com>
 <20140331233552.GB30019@redhat.com>
 <20140401004801.GQ4284@linux.vnet.ibm.com>
 <20140401150849.GA14757@redhat.com>
 <20140401153032.GT4284@linux.vnet.ibm.com>
 <20140401172244.GA10363@redhat.com>
 <20140401175545.GV4284@linux.vnet.ibm.com>
 <20140401180414.GA12326@redhat.com>
 <20140401183245.GA12473@linux.vnet.ibm.com>
 <20140401221616.GA961@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401221616.GA961@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040123-3532-0000-0000-000000B9EE21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 06:16:16PM -0400, Dave Jones wrote:
> On Tue, Apr 01, 2014 at 11:32:45AM -0700, Paul E. McKenney wrote:
> 
>  > >  > Given that you have CONFIG_RCU_TRACE=y, could you please enable the
>  > >  > following trace events and dump the trace before things hang?
>  > >  > 
>  > >  > 	trace_event=rcu:rcu_grace_period,rcu:rcu_grace_period_init
>  > >  > 
>  > >  > If it is not feasible to dump the trace before things hang, let me
>  > >  > know, and I will work out some other diagnostic regime.
>  > > 
>  > > I'll give that a shot when I get back in a few hours.
> 
> ok, this is tricky, and I'm not sure how helpful the below is.
> because I don't know when the hang is going to happen, in parallel to my usual workload
> I did this..
> while [ 1 ];
> do
>   cat trace
>   echo > trace
> done
> 
> and got this...
> 
> 
> 
> # entries-in-buffer/entries-written: 7/7   #P:4
> #
> #                              _-----=> irqs-off
> #                             / _----=> need-resched
> #                            | / _---=> hardirq/softirq
> #                            || / _--=> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>           <idle>-0     [000] dNs3   851.748475: rcu_grace_period: rcu_preempt 21342 cpuend
>           <idle>-0     [000] dNs3   851.748477: rcu_grace_period: rcu_preempt 21343 cpustart
>           <idle>-0     [000] dNs3   851.748477: rcu_grace_period: rcu_sched 20080 cpuend
>           <idle>-0     [000] dN.2   851.748480: rcu_grace_period: rcu_preempt 21343 cpuqs
>      rcu_preempt-9     [000] ...1   851.748485: rcu_grace_period: rcu_preempt 21343 fqsstart
>      rcu_preempt-9     [000] ...1   851.748487: rcu_grace_period: rcu_preempt 21343 fqsend
>      rcu_preempt-9     [000] ...1   851.748487: rcu_grace_period: rcu_preempt 21343 fqswait
> # tracer: nop
> #
> # entries-in-buffer/entries-written: 13/13   #P:4
> #
> #                              _-----=> irqs-off
> #                             / _----=> need-resched
> #                            | / _---=> hardirq/softirq
> #                            || / _--=> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>      rcu_preempt-9     [003] d..2   851.878457: rcu_grace_period: rcu_preempt 21349 end
>      rcu_preempt-9     [003] d..2   851.878459: rcu_grace_period: rcu_preempt 21349 newreq
>      rcu_preempt-9     [003] ...1   851.878459: rcu_grace_period: rcu_preempt 21349 reqwait
>      rcu_preempt-9     [003] d..2   851.878460: rcu_grace_period: rcu_preempt 21350 start
>      rcu_preempt-9     [003] d..2   851.878461: rcu_grace_period: rcu_preempt 21350 cpustart
>      rcu_preempt-9     [003] d..2   851.878462: rcu_grace_period_init: rcu_preempt 21350 0 0 7 f
>      rcu_preempt-9     [003] ...1   851.878463: rcu_grace_period: rcu_preempt 21350 fqswait
>      rcu_preempt-9     [003] d..2   851.878464: rcu_grace_period: rcu_preempt 21350 cpuqs
>           <idle>-0     [000] dNs3   851.878482: rcu_grace_period: rcu_preempt 21349 cpuend
>           <idle>-0     [000] dNs3   851.878483: rcu_grace_period: rcu_preempt 21350 cpustart
>           <idle>-0     [000] dNs3   851.878484: rcu_grace_period: rcu_sched 20086 cpuend
>           <idle>-0     [000] .N.2   851.878486: rcu_grace_period: rcu_sched 20086 cpuqs
>           <idle>-0     [000] dN.2   851.878487: rcu_grace_period: rcu_preempt 21350 cpuqs
> 
> 
> followed by a half dozen 'empty' traces before it totally locked up.

Cool, thank you!

Could you please also send the RCU CPU stall warning messages?

							Thanx, Paul

