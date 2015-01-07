Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbbAGPiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:38:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:59093 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbbAGPiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:38:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="508784740"
Message-ID: <54AD52D0.5050303@linux.intel.com>
Date: Wed, 07 Jan 2015 23:37:52 +0800
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
References: <1420611244-25624-1-git-send-email-jiang.liu@linux.intel.com> <20150107145050.GC30457@l.oracle.com>
In-Reply-To: <20150107145050.GC30457@l.oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/7 22:50, Konrad Rzeszutek Wilk wrote:
> On Wed, Jan 07, 2015 at 02:13:49PM +0800, Jiang Liu wrote:
>> Commit b81975eade8c ("x86, irq: Clean up irqdomain transition code")
>> breaks xen IRQ allocation because xen_smp_prepare_cpus() doesn't invoke
>> setup_IO_APIC(), so no irqdomains created for IOAPICs and
>> mp_map_pin_to_irq() fails at the very beginning.
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -2369,31 +2369,29 @@ static void ioapic_destroy_irqdomain(int idx)
>>  	ioapics[idx].pin_info = NULL;
>>  }
>>  
>> -void __init setup_IO_APIC(void)
>> +void __init setup_IO_APIC(bool xen_smp)
>>  {
>>  	int ioapic;
>>  
>> -	/*
>> -	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
>> -	 */
>> -	io_apic_irqs = nr_legacy_irqs() ? ~PIC_IRQS : ~0UL;
>> +	if (!xen_smp) {
>> +		apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
>> +		io_apic_irqs = nr_legacy_irqs() ? ~PIC_IRQS : ~0UL;
>> +
>> +		/* Set up IO-APIC IRQ routing. */
>> +		x86_init.mpparse.setup_ioapic_ids();
>> +		sync_Arb_IDs();
>> +	}
> 
> 
> Is there a specific reason that this cannot run in all cases?
> 
> What I am asking is why are we doing a special case here? The description
> at the top implied that we were just missing an call to
> setup_IO_APIC.. 
Hi Konrad,
	I'm not very familiar with Xen IRQ yet, so I just enabled the
code to create irqdomains for IOAPICs and keep other part as is. I will
try to check whether we could enable other part all together:)
Regards!
Gerry

> 
>>  
>> -	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
>>  	for_each_ioapic(ioapic)
>>  		BUG_ON(mp_irqdomain_create(ioapic));
>> -
>> -	/*
>> -         * Set up IO-APIC IRQ routing.
>> -         */
>> -	x86_init.mpparse.setup_ioapic_ids();
>> -
>> -	sync_Arb_IDs();
>>  	setup_IO_APIC_irqs();
>> -	init_IO_APIC_traps();
>> -	if (nr_legacy_irqs())
>> -		check_timer();
>> -
>>  	ioapic_initialized = 1;
>> +
>> +	if (!xen_smp) {
>> +		init_IO_APIC_traps();
>> +		if (nr_legacy_irqs())
>> +			check_timer();
>> +	}
>>  }
>>  
>>  /*
>> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
>> index 4c071aeb8417..7eb0283901fa 100644
>> --- a/arch/x86/xen/smp.c
>> +++ b/arch/x86/xen/smp.c
>> @@ -326,7 +326,10 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
>>  
>>  		xen_raw_printk(m);
>>  		panic(m);
>> +	} else {
>> +		setup_IO_APIC(true);
>>  	}
>> +
>>  	xen_init_lock_cpu(0);
>>  
>>  	smp_store_boot_cpu_info();
>> -- 
>> 1.7.10.4
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
