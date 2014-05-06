Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbaEFNS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:18:29 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36079 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaEFNS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:18:27 -0400
MIME-Version: 1.0
In-Reply-To: <1399344142.2164.67.camel@dabdike.int.hansenpartnership.com>
References: <20140430203321.30056.14833.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <CAErSpo7zjXg8xrV7=q36rNp_g573P93HiXTB72Z1cZfjGeeBmg@mail.gmail.com>
 <1399011100.2174.45.camel@dabdike> <11081303.OBX0h8mIfH@wuerfel>
 <20140505230104.GB8883@google.com> <1399344142.2164.67.camel@dabdike.int.hansenpartnership.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 6 May 2014 07:18:06 -0600
Message-ID: <CAErSpo7wJTP+GyM4sNN6gAA69cV_j3m=nOsgJasi1XYFZMA2YA@mail.gmail.com>
Subject: Re: [PATCH] DMA-API: Change dma_declare_coherent_memory() CPU address
 to phys_addr_t
To: James Bottomley <jbottomley@parallels.com>
Cc: "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 8:42 PM, James Bottomley
<jbottomley@parallels.com> wrote:
> On Mon, 2014-05-05 at 17:01 -0600, Bjorn Helgaas wrote:
>> On Fri, May 02, 2014 at 10:42:18AM +0200, Arnd Bergmann wrote:
>
>> > I don't know about NCR_Q720, but all others are only used on machines
>> > where physical addresses and bus addresses are in the same space.
>>
>> In general, the driver doesn't know whether physical and bus addresses
>> are in the same space.  At least, I *hope* it doesn't have to know,
>> because it can't be very generic if it does.
>
> The API was designed for the case where the memory resides on a PCI
> device (the Q720 case), the card config gives us a bus address, but if
> the system has an IOMMU, we'd have to do a dma_map of the entire region
> to set up the IOMMU before we can touch it.  The address it gets back
> from the dma_map (the dma_addr_t handle for the IOMMU mapping) is what
> we pass into dma_declare_coherent_memory().

The IOMMU (if any) is only involved for DMA to system memory, and
there is no system memory in this picture.  The device does DMA to its
own memory; no dma_map is required for this.  We use
dma_declare_coherent_memory() to set things up so the CPU can also do
programmed I/O to the memory.

> The reason it does an
> ioremap is because this IOMMU mapped address is now physical to the CPU
> and we want to make the region available to virtual space.  Essentially
> the memory the allocator hands out behaves as proper virtual memory but
> it's backed by physical memory on the card behind the PCI bridge.

Yep, the programmed I/O depends on the ioremap().  But I don't think
it depends on any IOMMU mapping.

> I'm still not that fussed about the difference between phys_addr_t and
> dma_addr_t, but if the cookie returned from a dma_map is a dma_addr_t
> then that's what dma_declare_coherent_memory() should use.  If it's a
> phys_addr_t, then likewise.
>
> James
>
