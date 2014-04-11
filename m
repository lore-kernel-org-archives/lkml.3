Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaDKEZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 00:25:32 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:64562 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaDKEZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 00:25:30 -0400
Message-ID: <1397190327.5139.36.camel@marge.simpson.net>
Subject: Re: [RFC PATCH RT] rwsem: The return of multi-reader PI rwsems
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Date: Fri, 11 Apr 2014 06:25:27 +0200
In-Reply-To: <1397188356.5139.33.camel@marge.simpson.net>
References: <20140409151922.5fa5d999@gandalf.local.home>
	 <1397139510.5137.92.camel@marge.simpson.net>
	 <1397140123.5137.99.camel@marge.simpson.net>
	 <1397184626.5139.24.camel@marge.simpson.net>
	 <20140410232542.23ee9920@gandalf.local.home>
	 <1397188356.5139.33.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-11 at 05:52 +0200, Mike Galbraith wrote: 
> On Thu, 2014-04-10 at 23:25 -0400, Steven Rostedt wrote: 
> > On Fri, 11 Apr 2014 04:50:26 +0200
> > Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> > 
> > > Oh, there was another useful bit. 
> > > 
> > > 3.12.17-rt25       403991     384216     377786
> > >                    405466     394011     392850
> > > 
> > > 3.12.17-nopreempt  109049     186133     118766  !?!.. ew, TTWU_QUEUE
> > >                    350385     318786     367336  !TTWU_QUEUE
> > >                    326009     356939     378215  !TTWU_QUEUE
> > > 
> > > IPI == low-pass filter.
> > 
> > I'm sorry, but I don't have the foggiest clue to what the above means.
> 
> It means..
> 
> # Overhead                                                                                                                                                                                   Symbol
> # ........  .......................................................................................................................................................................................
> #
>     17.33%  [k] native_write_msr_safe
>             |
>             |--88.45%-- __x2apic_send_IPI_mask
>             |          |
>             |          |--97.89%-- try_to_wake_up
>             |          |          |
>             |          |          |--99.91%-- wake_futex
>             |          |          |          |
>             |          |          |          |--99.77%-- futex_wake_op
>             |          |          |          |          do_futex
>             |          |          |          |          sys_futex
>             |          |          |          |          system_call_fastpath
> 
> ..wakeup frequency is restricted by the IPI.

Turn TTWU_QUEUE off, bottleneck goes away.

# Overhead                                                                                                                                                                                   Symbol
# ........  .......................................................................................................................................................................................
#
     6.12%  [.] _ZN13ObjectMonitor20TrySpin_VaryDurationEP6Thread
            |
            |--61.27%-- _ZN13ObjectMonitor5enterEP6Thread
            |          |
            |          |--99.96%-- _ZN13SharedRuntime26complete_monitor_locking_CEP7oopDescP9BasicLockP10JavaThread
            |          |          0x7f93149b2748
            |          |          |
            |          |          |--99.76%-- 0xf1a02b30
            |          |          |          0xbaba00000000fc24
            |          |           --0.24%-- [...]
            |           --0.04%-- [...]
            |
            |--38.40%-- _ZN13ObjectMonitor6EnterIEP6Thread
            |          _ZN13ObjectMonitor5enterEP6Thread
            |          |
            |          |--99.98%-- _ZN13SharedRuntime26complete_monitor_locking_CEP7oopDescP9BasicLockP10JavaThread
            |          |          0x7f93149b2748
            |          |          |
            |          |          |--99.89%-- 0xf1a02b30
            |          |          |          0xbaba00000000fc24
            |          |           --0.11%-- [...]
            |           --0.02%-- [...]
             --0.32%-- [...]

     3.59%  [k] intel_idle
            |
            --- cpuidle_enter_state
                cpuidle_idle_call
                arch_cpu_idle
                cpu_startup_entry


