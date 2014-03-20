Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbaCTRZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:25:33 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:41124 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755381AbaCTRZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:25:31 -0400
Message-ID: <532B2485.6010005@codethink.co.uk>
Date: Thu, 20 Mar 2014 18:25:25 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-sh@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <damm@opensource.se>, Ben Dooks <ben-linux@fluff.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: Re: DMABOUNCE in pci-rcar
References: <201402241200.21944.arnd@arndb.de> <5527822.QYtFYiIpiW@wuerfel> <532B137B.7010900@codethink.co.uk> <4884083.IuNl44Y6XD@wuerfel>
In-Reply-To: <4884083.IuNl44Y6XD@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/03/14 17:41, Arnd Bergmann wrote:
> On Thursday 20 March 2014 17:12:43 Ben Dooks wrote:
>> On 20/03/14 17:09, Arnd Bergmann wrote:
>>> On Thursday 20 March 2014 16:04:36 Ben Dooks wrote:
>
>>>> As a note, if we now boot a Lager with DT on 3.14-rc3 series the USB
>>>> controllers no longer work with full 2GiB RAM enabled in the device
>>>> tree.
>>>
>>> Did it work before these patches got applied initially?
>>
>> It did, but I cannot remember if we where limiting DRAM to 1GiB
>> or not.
>
> I would assume you did, or you happened to never actually use
> memory higher than that for DMA during tests.
>
>>>> Could we work around this by having 1GiB of memory defined in the
>>>> 32bit memory and then add the rest of the 3GiB from the >32bit
>>>> area via LPAE? Will the kernel ever try to allocate DMA memory from
>>>> anything >32bit?
>>>
>>> You can solve the case for dma_alloc_coherent() this way, or by
>>> setting the mask correctly. It won't help you for dma_map_* though,
>>> which still requires someone to add support for swiotlb or using
>>> an IOMMU if present.
>>
>> We do not have an IOMMU present at the moment. Not sure how
>> to go about setting a mask on a pci-probed device.
>
> Ah, right. The mask is a problem because PCI devices assume that
> they can do DMA to any 32-bit masked address without calling
> dma_set_mask. Your trick to describe the system memory at a different
> physical alias would solve this part. Another option might be to
> add a quirk in the OHCI/EHCI drivers, if you are able to detect
> this special case from the PCI IDs. Whether we can allow the PCI host
> controller to just set a mask is an open question. If we decide to go
> that route, you should be able to do it using the add_bus() callback
> in the host controller driver. However, it would be a departure from
> the normal way of doing PCI DMA, and I can't foresee what the implications
> would be.

So doing:

static void pci_rcar_fixup(struct pci_dev *dev)
{
	if (dev->bus->ops == &rcar_pci_ops) {
		dev_info(&dev->dev, "applying new dma mask\n");
		dev->dma_mask = DMA_BIT_MASK(31);
	}
}

DECLARE_PCI_FIXUP_EARLY(PCI_ANY_ID, PCI_ANY_ID, pci_rcar_fixup);

Did not work for me :(

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
