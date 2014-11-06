Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbaKFEbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:31:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:34721 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbaKFEbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:31:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="484950190"
Message-ID: <545AF986.1040903@linux.intel.com>
Date: Thu, 06 Nov 2014 12:31:02 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch Part2 v4 20/31] PCI/MSI: Kill redundant calling for irq_set_msi_desc()
 for MSIx interrupts
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com> <1415102525-9898-21-git-send-email-jiang.liu@linux.intel.com> <20141105224504.GG6168@google.com> <545ACFC7.9090204@huawei.com>
In-Reply-To: <545ACFC7.9090204@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/6 9:32, Yijing Wang wrote:
> On 2014/11/6 6:45, Bjorn Helgaas wrote:
>> On Tue, Nov 04, 2014 at 08:01:54PM +0800, Jiang Liu wrote:
>>> It's arch_setup_msi_irq()/arch_setup_msi_irqs()'s responsibility to call
>>> irq_set_msi_desc() to associate IRQ descriptors and MSI descriptors,
>>> so kill the redundant call of irq_set_msi_desc() for MSIx interrupts
>>> in PCI MSI core.
>>
>> "MSI-X" in English text, "msix" in code.
>>
>> The default arch_setup_msi_irq() in drivers/pci/msi.c doesn't call
>> irq_set_msi_desc().  Does it happen somewhere inside chip->setup_irq()?
> 
> Yes.
> 
> I also found this.
> http://www.spinics.net/lists/linux-pci/msg34256.html
> 
>>
>> I don't know how to verify that there are calls in all the places needed.
>> That makes me wonder if the factoring is wrong -- maybe irq_set_msi_desc()
>> could be done in some common place.
> 
> In my idea, place the irq_set_msi_desc() in common MSI core is ok, but currently almost
> all MSI arch code call irq_set_msi_desc() in arch code. So a lot of code need to change.
> And arch code setup MSI and MSI-X in the same way, so if MSI work happy without irq_set_msi_desc(entry->irq, entry)
> in common MSI code, MSI-X should be the same.
Hi Bjorn and Yijing,
	I originally plan was to move irq_set_msi_desc() into common
PCI MSI code. But when implementing this, I found every
arch_setup_msi_irq()/arch_setup_msi_irqs() needs to set msidesc->irq,
thus need to lock the irq descriptor. So I realized we should
rely on arch_setup_msi_irq() to call irq_set_msi_desc():)
Regards!
Gerry

> 
>>
>>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>>> ---
>>>  drivers/pci/msi.c |    1 -
>>>  1 file changed, 1 deletion(-)
>>>
>>> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>>> index afe974600c7d..da181c59394b 100644
>>> --- a/drivers/pci/msi.c
>>> +++ b/drivers/pci/msi.c
>>> @@ -685,7 +685,6 @@ static void msix_program_entries(struct pci_dev *dev,
>>>  						PCI_MSIX_ENTRY_VECTOR_CTRL;
>>>  
>>>  		entries[i].vector = entry->irq;
>>> -		irq_set_msi_desc(entry->irq, entry);
>>>  		entry->masked = readl(entry->mask_base + offset);
>>>  		msix_mask_irq(entry, 1);
>>>  		i++;
>>> -- 
>>> 1.7.10.4
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> .
>>
> 
> 
