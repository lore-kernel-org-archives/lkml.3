Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbaJ3EuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 00:50:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:8607 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbaJ3EuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 00:50:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,283,1413270000"; 
   d="scan'208";a="628079108"
Message-ID: <5451C379.1050508@linux.intel.com>
Date: Thu, 30 Oct 2014 12:50:01 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: Re: [Patch Part2 v3 15/24] x86, MSI: Use hierarchy irqdomain to manage
 MSI interrupts
References: <1414484803-10311-1-git-send-email-jiang.liu@linux.intel.com> <1414484803-10311-16-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.11.1410282046120.5308@nanos> <5450A9D8.108@linux.intel.com> <alpine.DEB.2.11.1410291017180.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410291017180.5308@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/29 17:19, Thomas Gleixner wrote:
>> Hi Thomas,
>> 	Thanks for your great suggestion and I have worked out a draft
>> patch to achieve what you want:)
>> 	I have made following changes to irq core to get rid of remapped
>> irq logic from msi.c:
>> 1) Add IRQ_SET_MASK_OK_DONE in addition to IRQ_SET_MASK_OK and
>> IRQ_SET_MASK_OK_NOCOPY. IRQ_SET_MASK_OK_DONE is the same as
>> IRQ_SET_MASK_OK for irq core and indicates to stacked irqchip that
>> parent irqchips have done all work and skip any handling in descendant
>> irqchips.
>> 2) Add int (*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg
>> *msg) into struct irq_chip. I'm still hesitating to return void or int
>> here. By returning void, irq_chip_compose_msi_msg() will be simpler,
>> but it loses flexibility.
> 
> void should be sufficient. If the chip advertises this function it
> better can provide a proper msi msg :)
>  
>> With above changes to core, we could remove all knowledge of irq
>> remapping from msi.c and the irq remapping interfaces get simpler too.
>> Please refer to following patch for details. The patch passes basic
>> booting tests with irq remapping enabled. If it's OK, I will fold
>> it into the patch set.
> 
> Yes. That looks reasonable. 
>  
>> IOAPIC runs into the same situation, but I need some more time
>> to find a solution:)
> 
> I'm sure you will!
Hi Thomas,
	I have reviewed IOAPIC related change again, but the conclusion
may not be what you expect:(
	Currently IOAPIC driver detects IRQ remapping for following
tasks:
1) Issue different EOI command to IOAPIC chip for unammped and remapped
   interrupts. It uses pin number instead of vector number for remapped
   interrupts.
2) Print different format for IOAPIC entries for unmapped and remapped
   interrupts.
3) ioapic_ack_level() uses different method for unmapped and remapped
   interrupts
4) create different IOAPIC entry content for unmapped and remapped
   interrupts
5) choose different flow handler for unmapped and remapped interrupts

For MSI, it only needs to solve task 4) above. For IOAPIC, it needs
to solve all five tasks above, which may cause big changes to irq_chip.
And it even may cause IRQ remapping driver call back into IOAPIC driver,
which breaks another rules that only the driver touches corresponding
interrupt controller.

On the other hand, MSI is almost platform independent, so it's
reasonable to change public struct irq_chip to support MSI.
But IOAPIC is a sort of platform dependent (x86 and IA64), so it
doesn't sound good to make great change to struct irq_chip to support
IOAPIC.

So I prefer keeping IOAPIC driver sensing interrupt remapping and
acting different for unmapped and remapped interrupts.
This breaks the layered design, but it does make code simpler.

What's your thoughts?
Regards!
Gerry


> 
> Thanks,
> 
> 	tglx
> 
