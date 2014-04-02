Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbaDBMgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 08:36:47 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:51781 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758289AbaDBMgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 08:36:45 -0400
Message-ID: <533C0479.5080808@linaro.org>
Date: Wed, 02 Apr 2014 07:37:13 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "shiraz.hashim@gmail.com" <shiraz.hashim@gmail.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "spear-devel@list.st.com" <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/7] ARM: SMP: generic SMP spin-table method routines
References: <1396041180-29897-1-git-send-email-elder@linaro.org> <1396041180-29897-3-git-send-email-elder@linaro.org> <20140331152117.GH6551@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140331152117.GH6551@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 10:21 AM, Mark Rutland wrote:
> Hi Alex,
> 
> On Fri, Mar 28, 2014 at 09:12:55PM +0000, Alex Elder wrote:
>> Implement a centralized version of the spin table (a.k.a. "holding
>> pen") method of secondary CPU initialization.  This is the first
>> step in removing a number of duplicate implementations of this code.
>>
>> The eventual goal is to allow "enable-method" properties in device
>> tree nodes for CPUs to select and use this common code.  As such,
>> some of the names are selected to match the names used in the SMP
>> spin-table code for ARM64.

Thanks for reviewing this Mark.  I'll respond below, but given
that Russell King is not interested in incorporating my changes
into the core code I think it may be moot.  Russell believes
centralizing this code encourages people who don't have a clue
what the hell they're doing to cargo-cult program.

> Given that there is a fundamental difference to the spin-table protocol
> in use on arm64 (in that here we are required to poke an arbitrary
> interrupt controller to send an SGI rather than just issuing a SEV), I
> would prefer that this had a name other than "spin-table" to
> disambiguate the two protocols.

It's possible (but I have no way of knowing) that a SEV is
sufficient to wake up the processor as well.  It is on the
platform I'm working on.  But in any case I would happily
use a different name, maybe "holding-pen" or something.

>> Note:
>> Most implementations examine only the bottom 4 bits of the MPIDR in
>> order to determine a CPU's id.  This version looks at the bottom 24
>> bits instead, based on MPIDR_HWID_BITMASK.  If using only 4 bits is
>> a requirement for most of the platforms that might use it I'll
>> switch this use 4 bits instead.
> 
> Given that we require people to describe all of the MPIDR Aff* fields in
> the DT, and can update any board files as necessary, is this a problem?

You're right, it should not be a problem.  I'm just a little
nervous about changing *any* behavior when I don't have the
hardware available to test the result.  So I wanted to be
sure to call attention to this.

> IMO Using all the Aff bits is preferable.

I agree, absolutely.

Thanks again.

					-Alex

> Cheers,
> Mark.
> 
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>  arch/arm/include/asm/smp.h |    5 +++
>>  arch/arm/kernel/head.S     |   33 +++++++++++++++++++
>>  arch/arm/kernel/smp.c      |   77 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 115 insertions(+)
>>
>> diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
>> index 22a3b9b..83064d1 100644
>> --- a/arch/arm/include/asm/smp.h
>> +++ b/arch/arm/include/asm/smp.h
>> @@ -75,6 +75,11 @@ struct secondary_data {
>>  extern struct secondary_data secondary_data;
>>  extern volatile int pen_release;
>>  
>> +extern volatile u32 secondary_holding_pen_release;
>> +extern void secondary_holding_pen(void);
>> +extern int smp_boot_secondary(unsigned int cpu, struct task_struct *idle);
>> +extern void smp_secondary_init(unsigned int cpu);
>> +
>>  extern int __cpu_disable(void);
>>  
>>  extern void __cpu_die(unsigned int cpu);
>> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
>> index f5f381d..3340f94 100644
>> --- a/arch/arm/kernel/head.S
>> +++ b/arch/arm/kernel/head.S
>> @@ -22,6 +22,7 @@
>>  #include <asm/memory.h>
>>  #include <asm/thread_info.h>
>>  #include <asm/pgtable.h>
>> +#include <asm/cputype.h>
>>  
>>  #if defined(CONFIG_DEBUG_LL) && !defined(CONFIG_DEBUG_SEMIHOSTING)
>>  #include CONFIG_DEBUG_LL_INCLUDE
>> @@ -402,6 +403,38 @@ __secondary_data:
>>  	.long	.
>>  	.long	secondary_data
>>  	.long	__secondary_switched
>> +
>> +
>> +	/*
>> +	 * Secondary cores spin in this "holding pen" until they are
>> +	 * signaled to proceed by jumping to secondary_startup
>> +	 * (above).  A core knows to proceed when it finds that the
>> +	 * value of the secondary_holding_pen_release global matches
>> +	 * its (hardware) CPU ID.  The secondary core acknowledges
>> +	 * it has begun executing by writing an invalid value (-1)
>> +	 * back into secondary_holding_pen_release (in
>> +	 * smp_operations->smp_secondary_init).
>> +	 */
>> +ENTRY(secondary_holding_pen)
>> + ARM_BE8(setend	be)
>> +	mrc	p15, 0, r0, c0, c0, 5	@ Get MPIDR and extract CPU id from it
>> +	and	r0, r0, #MPIDR_HWID_BITMASK
>> +	adr	r4, 1f			@ Get secondary_holding_pen_release
>> +	ldmia	r4, {r5, r6}		@ and compute its physical address
>> +	sub	r4, r4, r5
>> +	add	r6, r6, r4
>> +pen:	ldr	r7, [r6]		@ while secondary_holding_pen_release
>> +	cmp	r7, r0			@ doesn't hold our CPU id, spin
>> +	bne	pen
>> +	/*
>> +	 * At this point we have been released from the holding pen;
>> +	 * secondary_stack now contains the SVC stack for this core.
>> +	 */
>> +	b	secondary_startup
>> +ENDPROC(secondary_holding_pen)
>> +	.align
>> +1:	.long	.
>> +	.long	secondary_holding_pen_release
>>  #endif /* defined(CONFIG_SMP) */
>>  
>>  
>> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
>> index b7b4c86..e18151a 100644
>> --- a/arch/arm/kernel/smp.c
>> +++ b/arch/arm/kernel/smp.c
>> @@ -59,6 +59,8 @@ struct secondary_data secondary_data;
>>   * boot "holding pen"
>>   */
>>  volatile int pen_release = -1;
>> +volatile u32 secondary_holding_pen_release = -1;
>> +static DEFINE_RAW_SPINLOCK(boot_lock);
>>  
>>  enum ipi_msg_type {
>>  	IPI_WAKEUP,
>> @@ -386,6 +388,81 @@ asmlinkage void secondary_start_kernel(void)
>>  	cpu_startup_entry(CPUHP_ONLINE);
>>  }
>>  
>> +static void write_pen_release(int val)
>> +{
>> +	secondary_holding_pen_release = val;
>> +	smp_wmb();
>> +	sync_cache_w(&secondary_holding_pen_release);
>> +}
>> +
>> +/*
>> + * This is a smp_operations->smp_boot_secondary function, called by
>> + * boot_secondary() to signal a secondary core spinning in
>> + * secondary_holding_pen() that it should proceed.  The current
>> + * (boot) core writes the secondary's (hardware) CPU ID into
>> + * secondary_holding_pen_release.  The secondary core signals it has
>> + * started running by rewriting an invalid value (-1) back
>> + * into secondary_holding_pen_release.
>> + */
>> +int smp_boot_secondary(unsigned int cpu, struct task_struct *idle)
>> +{
>> +	unsigned long timeout;
>> +
>> +	/*
>> +	 * The secondary core will wait for this lock after
>> +	 * signaling it has started.  That way we know it won't
>> +	 * proceed until we've recognized the acknowledgement.
>> +	 */
>> +	raw_spin_lock(&boot_lock);
>> +
>> +	/*
>> +	 * Release the secondary core from its holding pen by
>> +	 * writing its CPU ID into secondary_holding_pen_release.
>> +	 */
>> +	write_pen_release(cpu_logical_map(cpu));
>> +
>> +	/*
>> +	 * Send the secondary CPU a soft interrupt, thereby causing
>> +	 * it to jump to its secondary entry point.
>> +	 */
>> +	arch_send_wakeup_ipi_mask(cpumask_of(cpu));
>> +
>> +	/* Give it some time to start running. */
>> +	timeout = jiffies + (1 * HZ);
>> +	while (time_before(jiffies, timeout)) {
>> +		smp_rmb();
>> +		if (secondary_holding_pen_release == -1)
>> +			break;
>> +
>> +		udelay(10);
>> +	}
>> +
>> +	/*
>> +	 * We now know that the secondary core is running (or it
>> +	 * timed out).  Release the lock so it can proceed.
>> +	 */
>> +	raw_spin_unlock(&boot_lock);
>> +
>> +	return secondary_holding_pen_release == -1 ? 0 : -ENOSYS;
>> +}
>> +
>> +/*
>> + * This is a smp_operations->secondary_init function, called by
>> + * secondary_start_kernel() on a newly-booted secondary cpu to do
>> + * some initialization activity.  All we need to do is write
>> + * secondary_holding_pen_release with an invalid value to signal
>> + * we've started executing.  We synchronize with the boot core by
>> + * waiting to acquire the boot lock before continuing.
>> + */
>> +void smp_secondary_init(unsigned int cpu)
>> +{
>> +	/* Let the primary processor know we're out of the pen. */
>> +	write_pen_release(-1);
>> +
>> +	raw_spin_lock(&boot_lock);
>> +	raw_spin_unlock(&boot_lock);
>> +}
>> +
>>  void __init smp_cpus_done(unsigned int max_cpus)
>>  {
>>  	printk(KERN_INFO "SMP: Total of %d processors activated.\n",
>> -- 
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe devicetree" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

