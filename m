Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab3HTAHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 20:07:04 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53690 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3HTAHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 20:07:00 -0400
X-AuditID: 85900ec0-cff26b9000001514-16-5212b31c85f0
Message-ID: <5212B31A.6090504@hitachi.com>
Date: Tue, 20 Aug 2013 09:06:50 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
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
Subject: Re: Re: [PATCH] [BUGFIX] crash/ioapic: Prevent crash_kexec() from
 deadlocking of ioapic_lock
References: <20130819081220.24406.15846.stgit@yunodevel> <20130819094623.GA30389@gmail.com>
In-Reply-To: <20130819094623.GA30389@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Thank you for fixing typos!
OK, I'll fix them and rename to ioapic_zap_locks().

Thank you again!

Yoshihiro YUNOMAE

(2013/08/19 18:46), Ingo Molnar wrote:
>
> * Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
>
>> Prevent crash_kexec() from deadlocking of ioapic_lock.
>
> s/of/on
>
>> When crash_kexec() is executed on a cpu, the cpu will get
>> ioapic_lock in disable_IO_APIC(). So if the cpu gets NMI
>> while locking ioapic_lock, a deadlock wiil happen. In
>
> s/will
>
>> this patch, ioapic_lock is initialized before
>> disable_IO_APIC().
>>
>> To confirm this deadlocking, you'll set up as follows:
>
> s/deadlocking/deadlock
>
>> 1. Add mdelay(1000) after raw_spin_lock_irqsave() in
>>     native_ioapic_set_affinity()@arch/x86/kernel/apic/io_apic.c
>>
>>     Although the deadlocking can occur without this modification, it will
>>    increase the potential of the deadlocking problem.
>
> s/deadlocking/deadlock
>
>>
>> 2. Build and install the kernel
>>
>> 3. Set up the OS which will run panic() and kexec when NMI is injected
>>      # echo "kernel.unknown_nmi_panic=1" >> /etc/sysctl.conf
>>      # vim /etc/default/grub
>>        add "nmi_watchdog=0 crashkernel=256M" in GRUB_CMDLINE_LINUX line
>>      # grub2-mkconfig
>>
>> 4. Reboot the OS
>>
>> 5. Run following command for each vcpu on the guest
>>      # while true; do echo <CPU num> > /proc/irq/<IO-APIC-edge or IO-APIC-fasteoi>/smp_affinitity; done;
>>     By running this command, cpus will get ioapic_lock for setting affinity.
>>
>> 6. Inject NMI (push a dump button or execute 'virsh inject-nmi <domain>' if you
>>     use VM)
>>     After injecting NMI, panic() is called in an nmi-handler context.
>>     Then, kexec will normally run in panic(), but the operation will be stopped
>>     by deadlock of ioapic_lock in crash_kexec()->machine_crash_shutdown()->
>
> s/of/on
>
>>     native_machine_crash_shutdown()->disable_IO_APIC()->clear_IO_APIC()->
>>     clear_IO_APIC_pin()->ioapic_read_entry().
>
> I suppose we could do this patch if it's a common
> occurance.
>
> A few minor details need fixing:
>
>>
>> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: x86@kernel.org
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Andi Kleen <ak@linux.intel.com>
>> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
>> Cc: Joerg Roedel <joro@8bytes.org>
>> Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
>> Cc: Gleb Natapov <gleb@redhat.com>
>> Cc: Marcelo Tosatti <mtosatti@redhat.com>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: stable@vger.kernel.org
>> ---
>>   arch/x86/include/asm/apic.h    |    2 ++
>>   arch/x86/kernel/apic/io_apic.c |    5 +++++
>>   arch/x86/kernel/crash.c        |    4 ++++
>>   3 files changed, 11 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
>> index f8119b5..ddb06af 100644
>> --- a/arch/x86/include/asm/apic.h
>> +++ b/arch/x86/include/asm/apic.h
>> @@ -715,4 +715,6 @@ static inline void exiting_ack_irq(void)
>>   	ack_APIC_irq();
>>   }
>>
>> +extern void ioapic_lock_init(void);
>> +
>>   #endif /* _ASM_X86_APIC_H */
>> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>> index 9ed796c..2816c07 100644
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -1534,6 +1534,11 @@ void intel_ir_io_apic_print_entries(unsigned int apic,
>>   	}
>>   }
>>
>> +void ioapic_lock_init(void)
>> +{
>> +	raw_spin_lock_init(&ioapic_lock);
>> +}
>
> Please name this ioapic_zap_locks() to make clear that this
> is crash handling related.
>
>> +
>>   __apicdebuginit(void) print_IO_APIC(int ioapic_idx)
>>   {
>>   	union IO_APIC_reg_00 reg_00;
>> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
>> index 74467fe..ea039d5 100644
>> --- a/arch/x86/kernel/crash.c
>> +++ b/arch/x86/kernel/crash.c
>> @@ -129,6 +129,10 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
>>
>>   	lapic_shutdown();
>>   #if defined(CONFIG_X86_IO_APIC)
>
> Please enhance this #ifdef while at it.
>
>> +	/*
>> +	 * Prevent crash_kexec() from deadlocking of ioapic_lock.
>> +	 */
>
> s/of/on.
>
> Also, single-line comment can go /* here */.
>
>> +	ioapic_lock_init();
>>   	disable_IO_APIC();
>>   #endif
>>   #ifdef CONFIG_HPET_TIMER
>>
>
> Thanks,
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


