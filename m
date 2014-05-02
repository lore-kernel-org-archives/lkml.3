Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaEBIWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 04:22:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbaEBIVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 04:21:53 -0400
Date: Fri, 2 May 2014 10:21:20 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, bp@suse.de,
        paul.gortmaker@windriver.com, JBeulich@suse.com, prarit@redhat.com,
        drjones@redhat.com, riel@redhat.com, gong.chen@linux.intel.com,
        andi@firstfloor.org, lenb@kernel.org, rjw@rjwysocki.net,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 5/5] x86: initialize secondary CPU only if master CPU
 will wait for it
Message-ID: <20140502102120.5415bf5b@nial.usersys.redhat.com>
In-Reply-To: <1398985916.1789.75.camel@misato.fc.hp.com>
References: <1397488277-14865-1-git-send-email-imammedo@redhat.com>
	<1397488277-14865-6-git-send-email-imammedo@redhat.com>
	<1398985916.1789.75.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 May 2014 17:11:56 -0600
Toshi Kani <toshi.kani@hp.com> wrote:

> On Mon, 2014-04-14 at 17:11 +0200, Igor Mammedov wrote:
> > Hang is observed on virtual machines during CPU hotplug,
> > especially in big guests with many CPUs. (It reproducible
> > more often if host is over-committed).
> > 
> > It happens because master CPU gives up waiting on
> > secondary CPU and allows it to run wild. As result
> > AP causes locking or crashing system. For example
> > as described here: https://lkml.org/lkml/2014/3/6/257
> > 
> > If master CPU have sent STARTUP IPI successfully,
> > and AP signalled to master CPU that it's ready
> > to start initialization, make master CPU wait
> > indefinitely till AP is onlined.
> > To ensure that AP won't ever run wild, make it
> > wait at early startup till master CPU confirms its
> > intention to wait for AP.
> 
> Please also add description that the master CPU times out when an AP
> does not start initialization within 10 seconds.
added

> 
> > Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> > ---
> > v2:
> >  - ammend comment in cpu_init()
> > v3:
> >  - leave timeouts in do_boot_cpu(), so that master CPU
> >    won't hang if AP doesn't respond, use cpu_initialized_mask
> >    as a way for AP to signal to master CPU that it's ready
> >    to start initialzation.
> > v4:
> >  - move common code in cpu_init() for x32/x64 in shared
> >    helper function wait_for_master_cpu()
> >  - add WARN_ON(cpumask_test_and_set_cpu(cpu, cpu_initialized_mask))
> >    to wait_formaster_cpu()
> > ---
> >  arch/x86/kernel/cpu/common.c |   27 +++++++-----
> >  arch/x86/kernel/smpboot.c    |   98 +++++++++++++-----------------------------
> >  2 files changed, 46 insertions(+), 79 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index a135239..a4bcbac 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -1221,6 +1221,17 @@ static void dbg_restore_debug_regs(void)
> >  #define dbg_restore_debug_regs()
> >  #endif /* ! CONFIG_KGDB */
> >  
> > +static void wait_for_master_cpu(int cpu)
> > +{
> > +	/*
> > +	 * wait for ACK from master CPU before continuing
> > +	 * with AP initialization
> > +	 */
> > +	WARN_ON(cpumask_test_and_set_cpu(cpu, cpu_initialized_mask));
> > +	while (!cpumask_test_cpu(cpu, cpu_callout_mask))
> > +		cpu_relax();
> > +}
> > +
> >  /*
> >   * cpu_init() initializes state that is per-CPU. Some data is already
> >   * initialized (naturally) in the bootstrap process, such as the GDT
> > @@ -1236,16 +1247,17 @@ void cpu_init(void)
> >  	struct task_struct *me;
> >  	struct tss_struct *t;
> >  	unsigned long v;
> > -	int cpu;
> > +	int cpu = stack_smp_processor_id();
> >  	int i;
> >  
> > +	wait_for_master_cpu(cpu);
> > +
> >  	/*
> >  	 * Load microcode on this cpu if a valid microcode is available.
> >  	 * This is early microcode loading procedure.
> >  	 */
> >  	load_ucode_ap();
> >  
> > -	cpu = stack_smp_processor_id();
> >  	t = &per_cpu(init_tss, cpu);
> >  	oist = &per_cpu(orig_ist, cpu);
> >  
> > @@ -1257,9 +1269,6 @@ void cpu_init(void)
> >  
> >  	me = current;
> >  
> > -	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask))
> > -		panic("CPU#%d already initialized!\n", cpu);
> > -
> >  	pr_debug("Initializing CPU#%d\n", cpu);
> >  
> >  	clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
> > @@ -1336,13 +1345,9 @@ void cpu_init(void)
> >  	struct tss_struct *t = &per_cpu(init_tss, cpu);
> >  	struct thread_struct *thread = &curr->thread;
> >  
> > -	show_ucode_info_early();
> > +	wait_for_master_cpu(cpu);
> >  
> > -	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask)) {
> > -		printk(KERN_WARNING "CPU#%d already initialized!\n", cpu);
> > -		for (;;)
> > -			local_irq_enable();
> > -	}
> > +	show_ucode_info_early();
> >  
> >  	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
> >  
> > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> > index ae2fd97..44903ad 100644
> > --- a/arch/x86/kernel/smpboot.c
> > +++ b/arch/x86/kernel/smpboot.c
> > @@ -111,7 +111,6 @@ atomic_t init_deasserted;
> >  static void smp_callin(void)
> >  {
> >  	int cpuid, phys_id;
> > -	unsigned long timeout;
> >  
> >  	/*
> >  	 * If waken up by an INIT in an 82489DX configuration
> > @@ -130,37 +129,6 @@ static void smp_callin(void)
> >  	 * (This works even if the APIC is not enabled.)
> >  	 */
> >  	phys_id = read_apic_id();
> > -	if (cpumask_test_cpu(cpuid, cpu_callin_mask)) {
> > -		panic("%s: phys CPU#%d, CPU#%d already present??\n", __func__,
> > -					phys_id, cpuid);
> > -	}
> > -	pr_debug("CPU#%d (phys ID: %d) waiting for CALLOUT\n", cpuid, phys_id);
> > -
> > -	/*
> > -	 * STARTUP IPIs are fragile beasts as they might sometimes
> > -	 * trigger some glue motherboard logic. Complete APIC bus
> > -	 * silence for 1 second, this overestimates the time the
> > -	 * boot CPU is spending to send the up to 2 STARTUP IPIs
> > -	 * by a factor of two. This should be enough.
> > -	 */
> > -
> > -	/*
> > -	 * Waiting 2s total for startup (udelay is not yet working)
> > -	 */
> > -	timeout = jiffies + 2*HZ;
> > -	while (time_before(jiffies, timeout)) {
> > -		/*
> > -		 * Has the boot CPU finished it's STARTUP sequence?
> > -		 */
> > -		if (cpumask_test_cpu(cpuid, cpu_callout_mask))
> > -			break;
> > -		cpu_relax();
> > -	}
> > -
> > -	if (!time_before(jiffies, timeout)) {
> > -		panic("%s: CPU%d started up but did not get a callout!\n",
> > -		      __func__, cpuid);
> > -	}
> >  
> >  	/*
> >  	 * the boot CPU has finished the init stage and is spinning
> > @@ -750,8 +718,8 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
> >  	unsigned long start_ip = real_mode_header->trampoline_start;
> >  
> >  	unsigned long boot_error = 0;
> > -	int timeout;
> >  	int cpu0_nmi_registered = 0;
> > +	unsigned long timeout;
> >  
> >  	/* Just in case we booted with a single CPU. */
> >  	alternatives_enable_smp();
> > @@ -799,6 +767,14 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
> >  	}
> >  
> >  	/*
> > +	 * AP might wait on cpu_callout_mask in cpu_init() with
> > +	 * cpu_initialized_mask set if previous attempt to online
> > +	 * it timed-out. Clear cpu_initialized_mask so that after
> > +	 * INIT/SIPI it could start with a clean state.
> > +	 */
> > +	cpumask_clear_cpu(cpu, cpu_initialized_mask);
> 
> I think smp_mb() should be added here to ensure that the target AP sees
> this change.
ok

> 
> > +
> > +	/*
> >  	 * Wake up a CPU in difference cases:
> >  	 * - Use the method in the APIC driver if it's defined
> >  	 * Otherwise,
> > @@ -810,55 +786,41 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
> >  		boot_error = wakeup_cpu_via_init_nmi(cpu, start_ip, apicid,
> >  						     &cpu0_nmi_registered);
> >  
> > +
> >  	if (!boot_error) {
> >  		/*
> > -		 * allow APs to start initializing.
> > +		 * Wait 10s total for a response from AP
> >  		 */
> > -		pr_debug("Before Callout %d\n", cpu);
> > -		cpumask_set_cpu(cpu, cpu_callout_mask);
> > -		pr_debug("After Callout %d\n", cpu);
> > +		boot_error = -1;
> > +		timeout = jiffies + 10*HZ;
> > +		while (time_before(jiffies, timeout)) {
> > +			if (cpumask_test_cpu(cpu, cpu_initialized_mask)) {
> > +				/*
> > +				 * Tell AP to proceed with initialization
> > +				 */
> > +				cpumask_set_cpu(cpu, cpu_callout_mask);
> > +				boot_error = 0;
> > +				break;
> > +			}
> > +			udelay(100);
> > +			schedule();
> > +		}
> > +	}
> 
> When 10s passed, the master could set a new flag, ex.
> cpu_callout_error_mask, which wait_for_master_cpu() checks and call
> play_dead() when it is set.  This avoids AP to spin forever when 10s
> becomes not long enough.  But it does not have to be part of this
> patchset, though.
I'm reluctant to add another to already too many cpu_*_mask,
maybe we could reuse cpu_initialized_mask by clearing it on timeout.
This way AP spinning on cpu_callout_mask could notice it and halt itself.

It would be better to make it separate patch on top of this series,
to reduce delay of bugfixes in this series.

> 
> > +	if (!boot_error) {
> >  		/*
> > -		 * Wait 5s total for a response
> > +		 * Wait till AP completes initial initialization
> 
> We should generally avoid such wait w/o a timeout condition, but since
> native_cpu_up() waits till cpu_online(cpu) anyway after this point, this
If we don't wait here and fall through into tight loop waiting on
cpu_online(cpu) in native_cpu_up() or check_tsc_sync_source() then
stop_task for syncing MTTRs initiated from AP won't have a chance
to run on the master CPU.

> seems OK...  I wonder if we need touch_nmi_watchdog(), though.
There wasn't any touch_nmi_watchdog() in the original code and I don't
think we need it here since we are not just spinning on CPU but giving
control back to kernel calling schedule(), which would allow watchdog_task
to do the job if needed.

> Thanks,
> -Toshi
> 
> 

