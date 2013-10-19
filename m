Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3JSRtr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 13:49:47 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37781 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3JSRtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 13:49:46 -0400
Date: Sat, 19 Oct 2013 10:49:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: int3 doing rcu_read_lock()
Message-ID: <20131019174939.GC4118@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131018231351.28c2036d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131018231351.28c2036d@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101917-7164-0000-0000-000002970796
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 11:13:51PM -0400, Steven Rostedt wrote:
> Hey Paul,
> 
> I hit this in my tests:
> 
> [ 1597.688015] ===============================
> [ 1597.688015] [ INFO: suspicious RCU usage. ]
> [ 1597.688015] 3.12.0-rc4-test+ #48 Not tainted
> [ 1597.688015] -------------------------------
> [ 1597.688015] /home/rostedt/work/git/linux-trace.git/include/linux/rcupdate.h:775 rcu_read_lock() used illegally while idle!
> [ 1597.688015] 
> [ 1597.688015] other info that might help us debug this:
> [ 1597.688015] 
> [ 1597.688015] 
> [ 1597.688015] RCU used illegally from idle CPU!
> [ 1597.688015] rcu_scheduler_active = 1, debug_locks = 0
> [ 1597.688015] RCU used illegally from extended quiescent state!
> [ 1597.688015] 1 lock held by swapper/0/0:
> [ 1597.688015]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff810689ab>] rcu_lock_acquire+0x0/0x29
> [ 1597.688015] 
> [ 1597.688015] stack backtrace:
> [ 1597.688015] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-rc4-test+ #48
> [ 1597.688015] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
> [ 1597.688015]  0000000000000001 ffff88007a609e78 ffffffff8151125f ffffffff81a44f38
> [ 1597.688015]  ffffffff81a10490 ffff88007a609ea8 ffffffff8109abbe ffff88007a609f08
> [ 1597.688015]  ffffffff81a407d0 0000000000000002 00000000ffffffff ffff88007a609ee8
> [ 1597.688015] Call Trace:
> [ 1597.688015]  <#DB>  [<ffffffff8151125f>] dump_stack+0x52/0x8b
> [ 1597.688015]  [<ffffffff8109abbe>] lockdep_rcu_suspicious+0x109/0x112
> [ 1597.688015]  [<ffffffff81519596>] __atomic_notifier_call_chain+0x70/0xee
> [ 1597.688015]  [<ffffffff81519628>] atomic_notifier_call_chain+0x14/0x16
> [ 1597.688015]  [<ffffffff81519658>] notify_die+0x2e/0x30
> [ 1597.688015]  [<ffffffff81516e60>] do_int3+0x4f/0x9c
> [ 1597.688015]  [<ffffffff815166c4>] int3+0x34/0x50
> [ 1597.688015]  [<ffffffff8109a221>] ? trace_hardirqs_off_caller+0x3f/0xac
> [ 1597.688015]  [<ffffffff8151ea61>] ? do_IRQ+0x1/0xa4
> [ 1597.688015]  <<EOE>>  <IRQ>  [<ffffffff8151646f>] ? common_interrupt+0x6f/0x6f
> [ 1597.688015]  <EOI>  [<ffffffff8109dff0>] ? trace_hardirqs_on+0xd/0xf
> [ 1597.688015]  [<ffffffff8109a221>] ? trace_hardirqs_off_caller+0x3f/0xac
> [ 1597.688015]  [<ffffffff8100b60f>] ? default_idle+0x21/0x32
> [ 1597.688015]  [<ffffffff8100b60d>] ? default_idle+0x1f/0x32
> [ 1597.688015]  [<ffffffff8100bd90>] arch_cpu_idle+0x18/0x22
> [ 1597.688015]  [<ffffffff8108a28b>] cpu_startup_entry+0x10b/0x16c
> [ 1597.688015]  [<ffffffff81509876>] rest_init+0x13a/0x141
> [ 1597.688015]  [<ffffffff8150973c>] ? csum_partial_copy_generic+0x16c/0x16c
> [ 1597.688015]  [<ffffffff81cc4d91>] start_kernel+0x41c/0x429
> [ 1597.688015]  [<ffffffff81cc46e9>] ? repair_env_string+0x56/0x56
> [ 1597.688015]  [<ffffffff81cc448d>] x86_64_start_reservations+0x2a/0x2c
> [ 1597.688015]  [<ffffffff81cc457a>] x86_64_start_kernel+0xeb/0xf2
> 
> When function tracing is being enabled, to avoid stop machine we add a
> break point to all functions that are about to be traced, convert them,
> and then remove them. ftrace adds a breakpoint handler to be called by
> int3 that simply skips the code.
> 
> The problem is that the do_int3 calls notify_die which does the notify
> handler which does a rcu_read_lock().
> 
> The problem is if do_IRQ gets called during this transition (as it was
> above) from idle. The breakpoint is hit at the beginning of do_IRQ()
> before it gets to call irq_enter(), which means rcu_irq_enter() isn't
> called either.
> 
> I wonder if we should have a rcu_bp_enter(), that basically does what
> rcu_irq_enter() does, but it would not be traced.

Something like that might be good.  Alternatively, if you need an RCU-like
thing that can be used from idle and offline, there is always SRCU.

> Thinking about this more, it seems that because breakpoints are used
> everywhere function tracing can be used, we may need to fix the
> breakpoint code not to call rcu_read_lock() as it can be just as
> dangerous to have as function tracing. We may need to have a different
> kind of notifier that breakpoints use :-/
> 
> Something to talk about in Edinburgh ;-)

Sounds like a plan!

							Thanx, Paul

