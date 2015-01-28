Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbbA1UxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:53:11 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45532 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbbA1UxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:53:01 -0500
Message-ID: <54C8FFE0.3030007@arm.com>
Date: Wed, 28 Jan 2015 15:27:28 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Fix pcibios_update_irq misuse of irq number
References: <1422456683-797-1-git-send-email-marc.zyngier@arm.com> <54C8FE61.1030304@linux.intel.com>
In-Reply-To: <54C8FE61.1030304@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerry,

On 28/01/15 15:21, Jiang Liu wrote:
> 
> 
> On 2015/1/28 22:51, Marc Zyngier wrote:
>> pcibios_update_irq writes an irq number into the config space
>> of a given PCI device, but ignores the fact that this number
>> is a virtual interrupt number, which might be a very different
>> value from what the underlying hardware is using.
>>
>> The obvious fix is to fetch the HW interrupt number from the
>> corresponding irq_data structure. This is slightly complicated
>> by the fact that this interrupt might be services by a stacked
>> domain.
>>
>> This has been tested on KVM with kvmtool.
>>
>> Reported-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>> Tested-by: Andre Przywara <andre.przywara@arm.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  drivers/pci/setup-irq.c | 12 ++++++++++--
>>  1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/pci/setup-irq.c b/drivers/pci/setup-irq.c
>> index 4e2d595..828cbc9 100644
>> --- a/drivers/pci/setup-irq.c
>> +++ b/drivers/pci/setup-irq.c
>> @@ -15,11 +15,19 @@
>>  #include <linux/errno.h>
>>  #include <linux/ioport.h>
>>  #include <linux/cache.h>
>> +#include <linux/irq.h>
>>  
>>  void __weak pcibios_update_irq(struct pci_dev *dev, int irq)
>>  {
>> -	dev_dbg(&dev->dev, "assigning IRQ %02d\n", irq);
>> -	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
>> +	struct irq_data *d;
>> +
>> +	d = irq_get_irq_data(irq);
>> +#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
>> +	while (d->parent_data)
>> +		d = d->parent_data;
>> +#endif
>> +	dev_dbg(&dev->dev, "assigning IRQ %02ld\n", d->hwirq);
>> +	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, d->hwirq);
>>  }
> Hi Mark,
> 	Instead of modifying the common version, how about
> implementing an arch specific version? Arch may have different
> way to determine the irq number. Above implementation doesn't
> work with x86, for example.

If you look at the Makefile, this file is used on:

obj-$(CONFIG_ALPHA) += setup-irq.o
obj-$(CONFIG_ARM) += setup-irq.o
obj-$(CONFIG_UNICORE32) += setup-irq.o
obj-$(CONFIG_SUPERH) += setup-irq.o
obj-$(CONFIG_MIPS) += setup-irq.o
obj-$(CONFIG_TILE) += setup-irq.o
obj-$(CONFIG_SPARC_LEON) += setup-irq.o
obj-$(CONFIG_M68K) += setup-irq.o

x86 doesn't use that at all.

That aside, do you know any case where this transformation would lead to
an invalid result? Worse case, irq should be equal to hwirq, shouldn't
it? Or are you thinking of something else?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
