Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaHGGv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:51:26 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60604 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaHGGvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:51:24 -0400
Date: Wed, 6 Aug 2014 23:50:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Hansen <dave@sr71.net>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Brown, Len" <len.brown@intel.com>
Subject: Re: suspicious RCU usage. (TLB flush tracepoints)
Message-ID: <20140807065055.GA5821@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140806181801.GA4605@redhat.com>
 <53E29712.7050203@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E29712.7050203@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080706-0928-0000-0000-000003F12847
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 01:58:58PM -0700, Dave Hansen wrote:
> On 08/06/2014 11:18 AM, Dave Jones wrote:
> > ===============================
> > [ INFO: suspicious RCU usage. ]
> > 3.16.0+ #34 Not tainted
> > -------------------------------
> > include/trace/events/tlb.h:35 suspicious rcu_dereference_check() usage!
> > 
> > other info that might help us debug this:
> > 
> > RCU used illegally from idle CPU!
> > rcu_scheduler_active = 1, debug_locks = 1
> > RCU used illegally from extended quiescent state!
> > no locks held by swapper/1/0.
> > 
> > stack backtrace:
> > CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.16.0+ #34
> >  0000000000000001 e7d0f46a57e60fc7 ffff880243357db0 ffffffff8a7f1e37
> >  ffff880243360000 ffff880243357de0 ffffffff8a0cc6c5 ffff8801753693f8
> >  ffff88023e2e2a40 0000000000000001 ffff88023e2e2a40 ffff880243357e10
> > Call Trace:
> >  [<ffffffff8a7f1e37>] dump_stack+0x4e/0x7a
> >  [<ffffffff8a0cc6c5>] lockdep_rcu_suspicious+0xd5/0x110
> >  [<ffffffff8a049f05>] leave_mm+0x1a5/0x200
> >  [<ffffffff8a3ec8df>] intel_idle+0x16f/0x190
> >  [<ffffffff8a6623da>] cpuidle_enter_state+0x3a/0xd0
> >  [<ffffffff8a662557>] cpuidle_enter+0x17/0x20
> >  [<ffffffff8a0c719c>] cpu_startup_entry+0x43c/0x800
> >  [<ffffffff8a03232d>] start_secondary+0x29d/0x3b0
> 
> Wow, this is quite the trainwreck of subsystems.  We've got idle, RCU,
> tracing and the VM all fighting with each other.  How fun!
> 
> The end result is that we can't use tracepoints in parts of the idle
> thread?  That's kinda a bummer.  I'm curious why we don't see this more
> widely.  We have a tracepoint *IMMEDIATELY* After one of the
> rcu_idle_enter():
> 
> > static inline int cpu_idle_poll(void)
> > {
> >         rcu_idle_enter();
> >         trace_cpu_idle_rcuidle(0, smp_processor_id());
> 
> Surely there are some more.

Actually, the _rcuidle suffix prevents this splat.  I bet that the one
added by the commit that Dave Jones pointed out omitted the _rcuidle
suffix.  If so, just add _rcuidle to the end of the trace function
you invoke, and it should clean things right up.

							Thanx, Paul

> The intel_idle and acpi_idle drivers both do this TLB trick, although
> the ACPI one is needlessly obfuscated:
> 
> 	#define acpi_unlazy_tlb(x)      leave_mm(x)
> 
> vs the direct call in intel_idle:
> 
> 	if (state->flags & CPUIDLE_FLAG_TLB_FLUSHED)
> 		leave_mm(cpu);
> 
> Can we just move the leave_mm() to be outside the rcu_idle_enter()?  If
> not, I'm just inclined to axe the tracepoint.
> 

