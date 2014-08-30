Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206AbaH3CpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 22:45:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:5924 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaH3CpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 22:45:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,429,1406617200"; 
   d="scan'208";a="591981611"
Message-ID: <54013AA8.8050200@linux.intel.com>
Date: Sat, 30 Aug 2014 10:44:56 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>
CC: EmanueL Czirai <amanual@openmailbox.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [Patch v4] x86, irq, PCI: Keep IRQ assignment for runtime power
 management
References: <1409304383-18806-1-git-send-email-jiang.liu@linux.intel.com> <CAJZ5v0ikimRs4XJihULUdS-ZtU=xBMJECbKmzpUf1ZnzXijihQ@mail.gmail.com> <8823237.zCdVqYrZ5W@vostro.rjw.lan>
In-Reply-To: <8823237.zCdVqYrZ5W@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/8/30 7:24, Rafael J. Wysocki wrote:
> On Friday, August 29, 2014 04:42:34 PM Rafael J. Wysocki wrote:
>> On Fri, Aug 29, 2014 at 11:26 AM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
>>> Now IOAPIC driver dynamically allocates IRQ numbers for IOAPIC pins.
>>> We need to keep IRQ assignment for PCI devices during runtime power
>>> management, otherwise it may cause failure of device wakeups.
>>>
>>> Commit 3eec595235c17a7 "x86, irq, PCI: Keep IRQ assignment for PCI
>>> devices during suspend/hibernation" has fixed the issue for suspend/
>>> hibernation, we also need the same fix for runtime device sleep too.
>>>
>>> Fix: https://bugzilla.kernel.org/show_bug.cgi?id=83271
>>> Reported-and-Tested-by: EmanueL Czirai <amanual@openmailbox.org>
>>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>>> ---
>>>  arch/x86/include/asm/io_apic.h |    2 ++
>>>  arch/x86/kernel/apic/io_apic.c |   12 ++++++++++++
>>>  arch/x86/pci/intel_mid_pci.c   |    2 +-
>>>  arch/x86/pci/irq.c             |    2 +-
>>>  drivers/acpi/pci_irq.c         |    4 ++++
>>>  5 files changed, 20 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
>>> index 0aeed5ca356e..478c490f3654 100644
>>> --- a/arch/x86/include/asm/io_apic.h
>>> +++ b/arch/x86/include/asm/io_apic.h
>>> @@ -227,6 +227,8 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
>>>
>>>  extern void io_apic_eoi(unsigned int apic, unsigned int vector);
>>>
>>> +extern bool mp_should_keep_irq(struct device *dev);
>>> +
>>>  #else  /* !CONFIG_X86_IO_APIC */
>>>
>>>  #define io_apic_assign_pci_irqs 0
>>> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>>> index 29290f554e79..1e9a921d9701 100644
>>> --- a/arch/x86/kernel/apic/io_apic.c
>>> +++ b/arch/x86/kernel/apic/io_apic.c
>>> @@ -3946,6 +3946,18 @@ int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
>>>         return ret;
>>>  }
>>>
>>> +bool mp_should_keep_irq(struct device *dev)
>>> +{
>>> +       if (dev->power.is_prepared)
>>> +               return true;
>>> +#ifdef CONFIG_PM_RUNTIME
>>> +       if (dev->power.runtime_status == RPM_SUSPENDING)
>>> +               return true;
>>> +#endif
>>
>> No, you can't do that.  It is racy and incorrect.
> 
> Well, maybe not.
> 
>> Please give me some time for looking into this.
> 
> So I guess the intended check is "Am I running in a suspend callback"?
Hi Rafael,
	Yes, we are trying to check whether it's called for suspend.
Function pci_disable_device() may be called when:
1) unbinding PCI driver
2) destroying PCI device
3) suspending for runtime power management or sleep
For case 1 and 2, we should release IRQ assigned. But we need to
keep assigned IRQ for case 3.

So is it safe to check runtime_status and is_prepared flags to detect
case 3? Any better ways?

Regards!
Gerry


> 
> Rafael
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
