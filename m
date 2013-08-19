Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137Ab3HSJqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:46:31 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:36694 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3HSJq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:46:29 -0400
Date: Mon, 19 Aug 2013 11:46:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org, stable@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Ingo Molnar <mingo@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [BUGFIX] crash/ioapic: Prevent crash_kexec() from
 deadlocking of ioapic_lock
Message-ID: <20130819094623.GA30389@gmail.com>
References: <20130819081220.24406.15846.stgit@yunodevel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819081220.24406.15846.stgit@yunodevel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:

> Prevent crash_kexec() from deadlocking of ioapic_lock. 

s/of/on

> When crash_kexec() is executed on a cpu, the cpu will get 
> ioapic_lock in disable_IO_APIC(). So if the cpu gets NMI 
> while locking ioapic_lock, a deadlock wiil happen. In 

s/will

> this patch, ioapic_lock is initialized before 
> disable_IO_APIC().
> 
> To confirm this deadlocking, you'll set up as follows:

s/deadlocking/deadlock

> 1. Add mdelay(1000) after raw_spin_lock_irqsave() in
>    native_ioapic_set_affinity()@arch/x86/kernel/apic/io_apic.c
> 
>    Although the deadlocking can occur without this modification, it will
>   increase the potential of the deadlocking problem.

s/deadlocking/deadlock

> 
> 2. Build and install the kernel
> 
> 3. Set up the OS which will run panic() and kexec when NMI is injected
>     # echo "kernel.unknown_nmi_panic=1" >> /etc/sysctl.conf
>     # vim /etc/default/grub
>       add "nmi_watchdog=0 crashkernel=256M" in GRUB_CMDLINE_LINUX line
>     # grub2-mkconfig
> 
> 4. Reboot the OS
> 
> 5. Run following command for each vcpu on the guest
>     # while true; do echo <CPU num> > /proc/irq/<IO-APIC-edge or IO-APIC-fasteoi>/smp_affinitity; done;
>    By running this command, cpus will get ioapic_lock for setting affinity.
> 
> 6. Inject NMI (push a dump button or execute 'virsh inject-nmi <domain>' if you
>    use VM)
>    After injecting NMI, panic() is called in an nmi-handler context.
>    Then, kexec will normally run in panic(), but the operation will be stopped
>    by deadlock of ioapic_lock in crash_kexec()->machine_crash_shutdown()->

s/of/on

>    native_machine_crash_shutdown()->disable_IO_APIC()->clear_IO_APIC()->
>    clear_IO_APIC_pin()->ioapic_read_entry().

I suppose we could do this patch if it's a common 
occurance.

A few minor details need fixing:

> 
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/include/asm/apic.h    |    2 ++
>  arch/x86/kernel/apic/io_apic.c |    5 +++++
>  arch/x86/kernel/crash.c        |    4 ++++
>  3 files changed, 11 insertions(+)
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index f8119b5..ddb06af 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -715,4 +715,6 @@ static inline void exiting_ack_irq(void)
>  	ack_APIC_irq();
>  }
>  
> +extern void ioapic_lock_init(void);
> +
>  #endif /* _ASM_X86_APIC_H */
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 9ed796c..2816c07 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1534,6 +1534,11 @@ void intel_ir_io_apic_print_entries(unsigned int apic,
>  	}
>  }
>  
> +void ioapic_lock_init(void)
> +{
> +	raw_spin_lock_init(&ioapic_lock);
> +}

Please name this ioapic_zap_locks() to make clear that this 
is crash handling related.

> +
>  __apicdebuginit(void) print_IO_APIC(int ioapic_idx)
>  {
>  	union IO_APIC_reg_00 reg_00;
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index 74467fe..ea039d5 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -129,6 +129,10 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
>  
>  	lapic_shutdown();
>  #if defined(CONFIG_X86_IO_APIC)

Please enhance this #ifdef while at it.

> +	/*
> +	 * Prevent crash_kexec() from deadlocking of ioapic_lock.
> +	 */

s/of/on.

Also, single-line comment can go /* here */.

> +	ioapic_lock_init();
>  	disable_IO_APIC();
>  #endif
>  #ifdef CONFIG_HPET_TIMER
> 

Thanks,

	Ingo
