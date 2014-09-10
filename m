Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaIJCqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 22:46:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:25017 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbaIJCqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 22:46:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,495,1406617200"; 
   d="scan'208";a="570912420"
Message-ID: <540FBB93.4020509@linux.intel.com>
Date: Wed, 10 Sep 2014 10:46:43 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Prarit Bhargava <prarit@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [Patch v4 14/16] x86, irq: Introduce helper to check whether
 an IOAPIC has been registered
References: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com> <1409192561-19744-15-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.10.1409091433150.11037@nanos>
In-Reply-To: <alpine.DEB.2.10.1409091433150.11037@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/9/9 20:37, Thomas Gleixner wrote:
> On Thu, 28 Aug 2014, Jiang Liu wrote:
> 
>> Introduce acpi_ioapic_registered() to check whether an IOAPIC has already
>> been registered, it will be used when enabling IOAPIC hotplug.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>>  arch/x86/include/asm/io_apic.h |    1 +
>>  arch/x86/kernel/acpi/boot.c    |   11 +++++++++++
>>  arch/x86/kernel/apic/io_apic.c |   11 +++++++++++
>>  include/linux/acpi.h           |    1 +
>>  4 files changed, 24 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
>> index ce63cf34c93c..0db2b7037e4b 100644
>> --- a/arch/x86/include/asm/io_apic.h
>> +++ b/arch/x86/include/asm/io_apic.h
>> @@ -191,6 +191,7 @@ extern void mp_unmap_irq(int irq);
>>  extern int mp_register_ioapic(int id, u32 address, u32 gsi_base,
>>  			      struct ioapic_domain_cfg *cfg);
>>  extern int mp_unregister_ioapic(u32 gsi_base);
>> +extern int mp_ioapic_registered(u32 gsi_base);
>>  extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
>>  			    irq_hw_number_t hwirq);
>>  extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
>> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
>> index 560a6d1cb0f4..6aa796f77b71 100644
>> --- a/arch/x86/kernel/acpi/boot.c
>> +++ b/arch/x86/kernel/acpi/boot.c
>> @@ -810,6 +810,17 @@ int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base)
>>  }
>>  EXPORT_SYMBOL(acpi_unregister_ioapic);
>>  
>> +int acpi_ioapic_registered(acpi_handle handle, u32 gsi_base)
>> +{
>> +	int ret;
>> +
>> +	down_write(&acpi_ioapic_rwsem);
> 
> Why down_write? You are merily checking whether the thing is
> registered already.
Yeah, a down_read() should be enough:)

>> +	ret  = mp_ioapic_registered(gsi_base);
>> +	up_write(&acpi_ioapic_rwsem);
>> +
>> +	return ret;
>> +}
> 
> So I assume that this is for a particular caller in the apci ioapic
> hotplug code and that call site has its own serialization. Otherwise
> the return value is not protected at all.
> 
> Please add a Docbook comment to that function, and document the
> locking rules as thats pretty non obvious.
How about this comments about locking rules?
/*
 * Locks related to IOAPIC hotplug
 * Hotplug side:
 *      ->lock_device_hotplug() //device_hotplug_lock
 *              ->acpi_ioapic_rwsem
 *                      ->ioapic_lock
 * Interrupt mapping side:
 *      ->acpi_ioapic_rwsem
 *              ->ioapic_mutex
 *                      ->ioapic_lock
 */
Regards!
Gerry
> 
> The such is missing in some other patches as well.
> 
> Thanks,
> 
> 	tglx
> 
