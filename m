Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935551Ab3DHRHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:07:13 -0400
Received: from relay3.sgi.com ([192.48.152.1]:50340 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934191Ab3DHRHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:07:10 -0400
Date: Mon, 8 Apr 2013 12:07:09 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Do not force shutdown/reboot to boot cpu.
Message-ID: <20130408170709.GA1367@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130403193743.GB29151@sgi.com> <20130408155701.GB19974@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408155701.GB19974@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 05:57:01PM +0200, Ingo Molnar wrote:
> 
> * Robin Holt <holt@sgi.com> wrote:
> 
> > We noticed that recently, reboot of a 1024 cpu machine takes approx 16
> > minutes of just stopping the cpus.  The slowdown was tracked to commit
> > f96972f which went into v3.7 and then to the stable trees.
> > 
> > x86 does not need to be running the boot cpu to pull reset and I don't
> > think it is really needed for shutdown either.
> > 
> > I decided to go the "simple" way and make this a config option that is
> > selected by the x86 arch.  I don't know which other arch's would also
> > benefit, if any.
> > 
> > Signed-off-by: Robin Holt <holt@sgi.com>
> > To: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Russ Anderson <rja@sgi.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Shawn Guo <shawn.guo@linaro.org>
> > Cc: <stable@vger.kernel.org>
> > 
> > ---
> >  arch/x86/Kconfig        | 3 +++
> >  kernel/Kconfig.shutdown | 3 +++
> >  kernel/sys.c            | 4 ++++
> >  3 files changed, 10 insertions(+)
> >  create mode 100644 kernel/Kconfig.shutdown
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 70c0f3d..9611942 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -120,6 +120,7 @@ config X86
> >  	select OLD_SIGSUSPEND3 if X86_32 || IA32_EMULATION
> >  	select OLD_SIGACTION if X86_32
> >  	select COMPAT_OLD_SIGACTION if IA32_EMULATION
> > +	select ARCH_SHUTDOWN_TO_ANY_CPU
> >  
> >  config INSTRUCTION_DECODER
> >  	def_bool y
> > @@ -839,6 +840,8 @@ config SCHED_MC
> >  	  making when dealing with multi-core CPU chips at a cost of slightly
> >  	  increased overhead in some places. If unsure say N here.
> >  
> > +source "kernel/Kconfig.shutdown"
> > +
> >  source "kernel/Kconfig.preempt"
> >  
> >  config X86_UP_APIC
> > diff --git a/kernel/Kconfig.shutdown b/kernel/Kconfig.shutdown
> > new file mode 100644
> > index 0000000..d79fc04
> > --- /dev/null
> > +++ b/kernel/Kconfig.shutdown
> > @@ -0,0 +1,3 @@
> > +
> > +config ARCH_SHUTDOWN_TO_ANY_CPU
> > +	bool
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index 39c9c4a..c0b8880 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -369,7 +369,9 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
> >  void kernel_restart(char *cmd)
> >  {
> >  	kernel_restart_prepare(cmd);
> > +#ifndef CONFIG_ARCH_SHUTDOWN_TO_ANY_CPU
> >  	disable_nonboot_cpus();
> > +#endif
> >  	if (!cmd)
> >  		printk(KERN_EMERG "Restarting system.\n");
> >  	else
> > @@ -413,7 +415,9 @@ void kernel_power_off(void)
> >  	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
> >  	if (pm_power_off_prepare)
> >  		pm_power_off_prepare();
> > +#ifndef CONFIG_ARCH_SHUTDOWN_TO_ANY_CPU
> >  	disable_nonboot_cpus();
> > +#endif
> >  	syscore_shutdown();
> >  	printk(KERN_EMERG "Power down.\n");
> >  	kmsg_dump(KMSG_DUMP_POWEROFF);
> 
> Hm, the 'fix' is a pretty ugly workaround that does not fix much IMHO.
> 
> I think the original commit:
> 
>   f96972f2dc63 kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()
> 
> actually regressed your 1024 CPU systems, and should possibly be reverted or fixed 
> in some other fashion - such as by migrating to the primary CPU (on architectures 
> that require that), instead of hotplug offlining every secondary CPU on every 
> architecture!

Sure.  There are multiple ways to fix this.
 
> Alternatively, disable_nonboot_cpus() could perhaps be improved to down CPUs in 
> parallel: issue the CPU-down requests to every CPU, then wait for them to complete 
> - instead of the loop over every CPU?

I took a look at this.  disable_nonboot_cpus() loops through all online cpus,
shutting them down one cpu thread at a time.  More frustrating, it ends up 
calling __stop_machine() to stop all the cpus, then loops back up to stop
the next thread.  The underlying code takes a cpu bitmask, so changing
disable_nonboot_cpus() to pass in a cpu bitmask and changing _cpu_down()
to accept it allows __stop_machine() to be called just once.  This change
reduced the shutdown time on a 1024 cpus system from 16 minutes down to 4.
A significant improvement, but not good enough.

The next significant bottleneck is __cpu_notify().  Tried creating worker
threads to parallelize the shutdown, but the problem is __cpu_notify() is
not thread safe.  Putting a lock around it caused all the worker threads
to fight over the lock.

Wondered if __cpu_notify() needed to be called for all cpus being shut down,
and it does because the cpu_chain notifier call chain has cpu as a parameter.
So the delema is that cpu_chain notifiers need to be called on all cpus, but
cannot be done in parallel due to __cpu_notify() not being thread safe.
Spinning through the notifier chain sequentially for all cpus just takes a
long time.

The real fix would be to make the &cpu_chain notifier per cpu, or at
least thread safe, so that all the cpus being shut down could do so
in parallel.  That is a significant change with ramifications on
other code.

> This would be the conceptual counter part to parallel boot up of CPUs - something 
> SGI might be interested in as well?

Yes, which is why I spent some time digging into this.  I can clean
up my patch for the first part.  The second part needs more discussion.

> Thanks,
> 
> 	Ingo

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
