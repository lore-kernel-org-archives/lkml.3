Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974AbaERJgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 05:36:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:17147 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaERJgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 05:36:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,861,1392192000"; 
   d="scan'208";a="533706246"
Message-ID: <53787F09.9000200@linux.intel.com>
Date: Sun, 18 May 2014 17:36:09 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, sfi-devel@simplefirmware.org
Subject: Re: [RFC Patch Part1 V1 00/30] use irqdomain to dynamically allocate
 IRQ for IOAPIC pin
References: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.02.1405161601060.4039@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1405161601060.4039@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
	Thanks for review and please refer to inline comments below.

On 2014/5/16 23:28, Thomas Gleixner wrote:
> Jiang,
> 
> On Fri, 16 May 2014, Jiang Liu wrote:
> 
>> On x86 platforms, IRQ number are statically allocated to IOAPIC pins at boot.
>> There are two issues with this design. First it causes trouble to IOAPIC
>> hotplug because we need to allocate a block of IRQ numbers for each IOAPIC.
>> Second it may waste IRQ nubmers even if some IOAPIC pins are not used because
>> IRQ numbers are statically assigned.
>>
>> This patchset tries to enable dynamic IRQ number allocation for IOAPIC
>> by adopting the irqdomain framework, it solves the two issues mentioned
>> above. It also simplifies the IOAPIC driver by consolidating ways to
>> program IOAPIC pins with the irqdomain map interface.
>>
>> We will enhance the IOAPIC driver core to support ACPI based IOAPIC hotplug
>> once the IOAPIC driver has been converted to irqdomain.
> 
> Thanks for tackling this!
>  
>> This patchset applies to v3.15-rc4-260-g38583f095c5a and has been tested
> 
> That's a bit unfortunate, as there are conflicting changes in the tip
> tree irq/core branch. Can you please rebase on top of that.
I have rebased onto tip/irq/core. The conflict is easy to solve.

> 
>> TODO list:
>> 1) check whether it affects Xen or not
>>
>> Patch 1-17 are trivial code improvements, bugfixes and preparation.
> 
> Can you please move the bugfixes before the other changes, so we can
> pick them up independently from the outcome?
Sure, will reorder the patch set in next version.

>  
>> Patch 18-24 enable basic irqdomain support and IRQ number dynamic
>> allocation.
>>
>> Patch 25-29 consoldate the way to program IOAPIC pins by using
>> irqdomain map() interface.
>>
>> Patch 30 cleans up unused interfaces and functions in IOAPIC driver.
>>
>> Tests and comments are warmly welcomed!
> 
> I like the general approach, but we have now a mixture of legacy irq
> handling and irq domains. We really want to cleanup the legacy PIC no
> ioapic case as well. That will cleanup the code further.
> 
> The other thing we discussed here: https://lkml.org/lkml/2014/5/7/901
> in several places of the thread is to move the vector allocation into
> a irqdomain with a generic matrix allocator as well. We have other use
> cases for this as well. It would be nice if you could look at that as
> well.
I have read through the thread, it's an interesting discussion.

After my first thought, I have gotten some ideas about how to reorganize
x86 interrupt subsystem using irqdomain framework based on ideas from
the thread. Because I'm newbie to interrupt subsystem, I will share my
naive ideas first and RFC for whether it's the right direction.

We may build hierarchy irqdomains as below for x86,
[IOAPIC]      [MSI/MSI-x]  [HPET]  [DMAR] [Legacy]
    |            |           |       |       |
    v            v           v       |       |
[           Remapping           ]    |       |
                 |                   |       |
                 v                   v       v
[                   Root/vector                ]

The remapping domain is optional and used to support IRQ remapping unit.
We abstract remapping entry as hardware interrupt pin and will extend
irqdomain interface to support automatic assignment of hardware
interrupt pin.

The root/vector domain is used to manage per CPU vector numbers and
CPU vector is abstracted as hardware interrupt pin. It will support
automatic vector number assignment. To support root/vector domain,
we need to extend irqdomain interface to pass down information
or constraints about the IRQ allocation.

So how about following extension to current irqdomain interfaces?
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index c983ed18c332..2fd7e50cde32 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -42,6 +42,13 @@ struct of_device_id;
 /* Number of irqs reserved for a legacy isa controller */
 #define NUM_ISA_INTERRUPTS     16

+#define        IRQDOMAIN_AUTO_ASSIGN_HWIRQ     ULONG_MAX
+#ifdef arch_irq_alloc_info_t
+typedef        arch_irq_alloc_info_t irq_alloc_info_t;
+#else
+typedef        void irq_alloc_info_t;
+#endif
+
 /**
  * struct irq_domain_ops - Methods for irq_domain objects
  * @match: Match an interrupt controller device node to a host, returns
@@ -59,7 +66,11 @@ struct of_device_id;
  */
 struct irq_domain_ops {
        int (*match)(struct irq_domain *d, struct device_node *node);
-       int (*map)(struct irq_domain *d, unsigned int virq,
irq_hw_number_t hw);
+       int (*alloc)(struct irq_domain *d, irq_hw_number_t hw,
+                    irq_alloc_info_t *info);
+       int (*free)(struct irq_domain *d, unsigned int virq);
+       int (*map)(struct irq_domain *d, unsigned int virq,
irq_hw_number_t hw,
+                  irq_alloc_info_t *info);
        void (*unmap)(struct irq_domain *d, unsigned int virq);
        int (*xlate)(struct irq_domain *d, struct device_node *node,
                     const u32 *intspec, unsigned int intsize,

alloc()/free() interfaces will be used allocate/free IRQ from parent
domain. And irq_alloc_info_t structure is used to host parameters
and constraints for IRQ allocation.

For x86, irq_alloc_info_t structure will be used to host CPU mask,
device pointer, IOAPIC pin attributes, NUMA node info etc.
But I still more thoughts about how to convert set_affinity() to
use irqdomain interfaces.

Any comments about the proposal?
Best regards!
Gerry
> 
> Thanks,
> 
> 	tglx
> 
> 
> 
> 
