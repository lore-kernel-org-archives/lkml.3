Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbaHVOsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:48:39 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54873 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153AbaHVOsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:48:38 -0400
Date: Fri, 22 Aug 2014 07:48:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140822144819.GG2663@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140812214151.GB3106@linux.vnet.ibm.com>
 <20140813054439.GA29913@grmbl.mre>
 <20140813130049.GS4752@linux.vnet.ibm.com>
 <20140815052411.GF1934@grmbl.mre>
 <20140815150402.GD4752@linux.vnet.ibm.com>
 <20140818175345.GD31856@grmbl.mre>
 <20140819040149.GJ4752@linux.vnet.ibm.com>
 <20140822122453.GG16198@grmbl.mre>
 <20140822123651.GH16198@grmbl.mre>
 <20140822125649.GI16198@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822125649.GI16198@grmbl.mre>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082214-9332-0000-0000-000001C5AE84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 06:26:49PM +0530, Amit Shah wrote:
> On (Fri) 22 Aug 2014 [18:06:51], Amit Shah wrote:
> > On (Fri) 22 Aug 2014 [17:54:53], Amit Shah wrote:
> > > On (Mon) 18 Aug 2014 [21:01:49], Paul E. McKenney wrote:
> > > 
> > > > The odds are low over the next few days.  I am adding nastier rcutorture
> > > > testing, however.  It would still be very good to get debug information
> > > > from your setup.  One approach would be to convert the trace function
> > > > calls into printk(), if that would help.
> > > 
> > > I added a few printks on the lines of the traces in cases where
> > > rcu_nocb_poll was checked -- since that reproduces the hang.  Are the
> > > following traces sufficient, or should I keep adding more printks?
> > > 
> > > In the case of rcu-trace-nopoll.txt, the messages stop after a while
> > > (when the guest locks up hard).  That's when I kill the qemu process.
> > 
> > And this is bt from gdb when the endless 
> > 
> >   RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> > 
> > messages are being spewed.
> > 
> > I can't time it, but hope it gives some indication along with the printks.
> 
> ... and after the system 'locks up', this is the state it's in:
> 
> ^C
> Program received signal SIGINT, Interrupt.
> native_safe_halt () at ./arch/x86/include/asm/irqflags.h:50
> 50		 }
> (gdb) bt
> #0  native_safe_halt () at ./arch/x86/include/asm/irqflags.h:50
> #1  0xffffffff8100b9c1 in arch_safe_halt () at ./arch/x86/include/asm/paravirt.h:111
> #2  default_idle () at arch/x86/kernel/process.c:311
> #3  0xffffffff8100c107 in arch_cpu_idle () at arch/x86/kernel/process.c:302
> #4  0xffffffff8106a25a in cpuidle_idle_call () at kernel/sched/idle.c:120
> #5  cpu_idle_loop () at kernel/sched/idle.c:220
> #6  cpu_startup_entry (state=<optimized out>) at kernel/sched/idle.c:268
> #7  0xffffffff813e068b in rest_init () at init/main.c:418
> #8  0xffffffff81a8cf5a in start_kernel () at init/main.c:680
> #9  0xffffffff81a8c4ba in x86_64_start_reservations (real_mode_data=<optimized out>) at arch/x86/kernel/head64.c:193
> #10 0xffffffff81a8c607 in x86_64_start_kernel (real_mode_data=0x13f90 <cpu_lock_stats+29184> <error: Cannot access memory at address 0x13f90>)
>     at arch/x86/kernel/head64.c:182
> #11 0x0000000000000000 in ?? ()
> 
> 
> Wondering why it's doing this.  Am stepping through
> cpu_startup_entry() to see if I get any clues.

This looks to me like normal behavior in the x86 ACPI idle loop.
My guess is that the lockup is caused by indefinite blocking, in
which case we would expect all the CPUs to be in the idle loop.

Of course, this all assumes that your system is using ACPI for idle.
(Is it?)

							Thanx, Paul

