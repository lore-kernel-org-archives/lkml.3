Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaIJDN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 23:13:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:8887 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbaIJDNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 23:13:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,495,1406617200"; 
   d="scan'208";a="570921250"
Message-ID: <540FC1C2.40100@linux.intel.com>
Date: Wed, 10 Sep 2014 11:13:06 +0800
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
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        x86@kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [Patch v4 12/16] x86, irq, ACPI: Implement interface to support
 ACPI based IOAPIC hot-addition
References: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com> <1409192561-19744-13-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.10.1409091417120.11037@nanos>
In-Reply-To: <alpine.DEB.2.10.1409091417120.11037@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/9/9 20:20, Thomas Gleixner wrote:
> On Thu, 28 Aug 2014, Jiang Liu wrote:
>>  EXPORT_SYMBOL(acpi_register_ioapic);
>> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>> index 6e67af0c5f99..b286461cabf9 100644
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -3851,7 +3851,13 @@ static int bad_ioapic_register(int idx)
>>  
>>  static int find_free_ioapic_entry(void)
>>  {
>> -	return nr_ioapics;
>> +	int idx;
>> +
>> +	for (idx = 0; idx < MAX_IO_APICS; idx++)
>> +		if (ioapics[idx].nr_registers == 0)
>> +			return idx;
>> +
>> +	return MAX_IO_APICS;
>>  }
>>  
>>  int mp_register_ioapic(int id, u32 address, u32 gsi_base,
>> @@ -3867,8 +3873,15 @@ int mp_register_ioapic(int id, u32 address, u32 gsi_base,
>>  	}
>>  	for_each_ioapic(ioapic)
>>  		if (ioapics[ioapic].mp_config.apicaddr == address) {
>> -			pr_warn("address 0x%x conflicts with IOAPIC%d\n",
>> -				address, ioapic);
>> +			/*
>> +			 * IOAPIC unit may also be visible in PCI scope.
>> +			 * When ioapic PCI driver's probe() is called,
>> +			 * the IOAPIC unit may have already been initialized
>> +			 * at boot time.
>> +			 */
>> +			if (!ioapic_initialized)
>> +				pr_warn("address 0x%x conflicts with IOAPIC%d\n",
>> +					address, ioapic);
> 
> Hmm. This smells fishy. Why do we allow multiple initializations of
> the same IOAPIC in the first place. Either it's done via ACPI or via
> PCI, but not both.
The ACPI subsystem will register and initialize all IOAPICs when walking
ACPI MADT table during boot, before initializing PCI subsystem.
Later when binding ioapic PCI driver to IOAPIC PCI device, it will try
to register the IOAPIC device again.

After this patchset is applied, we could remove the !ioapic_initialized
check. We check acpi_ioapic_register() before calling
acpi_register_ioapic(). So the check becomes redundant.
Or we could remove the temporary code from this patch.

> 
>>  			return -EEXIST;
>>  		}
>>  
>> @@ -3918,6 +3931,14 @@ int mp_register_ioapic(int id, u32 address, u32 gsi_base,
>>  	ioapics[idx].irqdomain = NULL;
>>  	ioapics[idx].irqdomain_cfg = *cfg;
>>  
>> +	if (ioapic_initialized) {
> 
> I have a hard time to understand this conditional. Why can't we do
> that unconditionally?
How about following comments?
/*
 * If mp_register_ioapic() is called during early boot stage when
 * walking ACPI/SFI/DT tables, it's too early to create irqdomain,
 * we are still using bootmem allocator. So delay it to setup_IO_APIC().
 */
Regards!
Gerry
> 
>> +		if (mp_irqdomain_create(idx)) {
>> +			clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
>> +			return -ENOMEM;
>> +		}
>> +		alloc_ioapic_saved_registers(idx);
>> +	}
>> +
>>  	if (gsi_cfg->gsi_end >= gsi_top)
>>  		gsi_top = gsi_cfg->gsi_end + 1;
>>  	if (nr_ioapics <= idx)
> 
> Thanks,
> 
> 	tglx
> 
