Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbbAHGgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 01:36:47 -0500
Received: from mga03.intel.com ([134.134.136.65]:26646 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbbAHGgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 01:36:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,719,1413270000"; 
   d="scan'208";a="634173560"
Message-ID: <54AE2576.5020209@linux.intel.com>
Date: Thu, 08 Jan 2015 14:36:38 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <JBeulich@suse.com>, David Rientjes <rientjes@google.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Richard Weinberger <richard@nod.at>, Oren Twaig <oren@scalemp.com>,
        Grant Likely <grant.likely@linaro.org>,
        Prarit Bhargava <prarit@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ingo Molnar <mingo@kernel.org>, xen-devel@lists.xenproject.org
Subject: Re: [Bugfix] x86/apic: Fix xen IRQ allocation failure caused by commit
 b81975eade8c
References: <1420611244-25624-1-git-send-email-jiang.liu@linux.intel.com> <20150107145050.GC30457@l.oracle.com> <54AD52D0.5050303@linux.intel.com> <20150107154416.GB30955@l.oracle.com>
In-Reply-To: <20150107154416.GB30955@l.oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/7 23:44, Konrad Rzeszutek Wilk wrote:
> On Wed, Jan 07, 2015 at 11:37:52PM +0800, Jiang Liu wrote:
>> On 2015/1/7 22:50, Konrad Rzeszutek Wilk wrote:
>>> On Wed, Jan 07, 2015 at 02:13:49PM +0800, Jiang Liu wrote:
>>>> Commit b81975eade8c ("x86, irq: Clean up irqdomain transition code")
>>>> breaks xen IRQ allocation because xen_smp_prepare_cpus() doesn't invoke
>>>> setup_IO_APIC(), so no irqdomains created for IOAPICs and
>>>> mp_map_pin_to_irq() fails at the very beginning.
>>>> --- a/arch/x86/kernel/apic/io_apic.c
>>>> +++ b/arch/x86/kernel/apic/io_apic.c
>>>> @@ -2369,31 +2369,29 @@ static void ioapic_destroy_irqdomain(int idx)
>>>>  	ioapics[idx].pin_info = NULL;
>>>>  }
>>>>  
>>>> -void __init setup_IO_APIC(void)
>>>> +void __init setup_IO_APIC(bool xen_smp)
>>>>  {
>>>>  	int ioapic;
>>>>  
>>>> -	/*
>>>> -	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
>>>> -	 */
>>>> -	io_apic_irqs = nr_legacy_irqs() ? ~PIC_IRQS : ~0UL;
>>>> +	if (!xen_smp) {
>>>> +		apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
>>>> +		io_apic_irqs = nr_legacy_irqs() ? ~PIC_IRQS : ~0UL;
>>>> +
>>>> +		/* Set up IO-APIC IRQ routing. */
>>>> +		x86_init.mpparse.setup_ioapic_ids();
>>>> +		sync_Arb_IDs();
>>>> +	}
Hi Konrad,
	Enabling above code for Xen dom0 will cause following warning
because it writes a special value to ICR register.
[    3.394981] ------------[ cut here ]------------
[    3.394985] WARNING: CPU: 0 PID: 1 at arch/x86/xen/enlighten.c:968
xen_apic_write+0x15/0x20()
[    3.394988] Modules linked in:
[    3.394991] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.19.0-rc3+ #5
[    3.394993] Hardware name: Dell Inc. OptiPlex 9020/0DNKMN, BIOS A03
09/17/2013
[    3.394996]  00000000000003c8 ffff88003056bdd8 ffffffff817611bb
00000000000003c8
[    3.395000]  0000000000000000 ffff88003056be18 ffffffff8106f4ea
0000000000000008
[    3.395004]  ffffffff81fc1120 ffff880030561348 000000000000a108
000000000000a101
[    3.395008] Call Trace:
[    3.395012]  [<ffffffff817611bb>] dump_stack+0x4f/0x6c
[    3.395015]  [<ffffffff8106f4ea>] warn_slowpath_common+0xaa/0xd0
[    3.395018]  [<ffffffff8106f525>] warn_slowpath_null+0x15/0x20
[    3.395021]  [<ffffffff81003e25>] xen_apic_write+0x15/0x20
[    3.395026]  [<ffffffff81ef606b>] sync_Arb_IDs+0x84/0x86
[    3.395029]  [<ffffffff81ef7f7a>] setup_IO_APIC+0x7f/0x8e3
[    3.395033]  [<ffffffff810b275d>] ? trace_hardirqs_on+0xd/0x10
[    3.395036]  [<ffffffff8176858a>] ? _raw_spin_unlock_irqrestore+0x8a/0xa0
[    3.395040]  [<ffffffff81ee841b>] xen_smp_prepare_cpus+0x5d/0x184
[    3.395044]  [<ffffffff81ee1ba3>] kernel_init_freeable+0x149/0x293
[    3.395047]  [<ffffffff81758d49>] ? kernel_init+0x9/0xf0
[    3.395049]  [<ffffffff81758d40>] ? rest_init+0xd0/0xd0
[    3.395052]  [<ffffffff81758d49>] kernel_init+0x9/0xf0
[    3.395054]  [<ffffffff8176887c>] ret_from_fork+0x7c/0xb0
[    3.395057]  [<ffffffff81758d40>] ? rest_init+0xd0/0xd0
[    3.395066] ---[ end trace 7c4371c8ba33d5d0 ]---

<snit>
>>>>  	ioapic_initialized = 1;
>>>> +
>>>> +	if (!xen_smp) {
>>>> +		init_IO_APIC_traps();
>>>> +		if (nr_legacy_irqs())
>>>> +			check_timer();
>>>> +	}
>>>>  }
And enabling above code causes Xen dom0 reboots.
Haven't test HVM and PV kernel yet.
So seems we still need special treatment for xen here.
Regards!
Gerry

>>>>  
>>>>  /*
>>>> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
>>>> index 4c071aeb8417..7eb0283901fa 100644
>>>> --- a/arch/x86/xen/smp.c
>>>> +++ b/arch/x86/xen/smp.c
>>>> @@ -326,7 +326,10 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
>>>>  
>>>>  		xen_raw_printk(m);
>>>>  		panic(m);
>>>> +	} else {
>>>> +		setup_IO_APIC(true);
>>>>  	}
>>>> +
>>>>  	xen_init_lock_cpu(0);
>>>>  
>>>>  	smp_store_boot_cpu_info();
>>>> -- 
>>>> 1.7.10.4
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
