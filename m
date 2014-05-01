Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaEAHsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 03:48:40 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:47902 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbaEAHsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 03:48:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140501000750.GB21775@kroah.com>
References: <20140430203321.30056.14833.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140501000750.GB21775@kroah.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 1 May 2014 01:48:17 -0600
Message-ID: <CAErSpo4saE6+BxWBr_=CaPXtBXGgmV83ueEvMsB+oPdrBSHCOg@mail.gmail.com>
Subject: Re: [PATCH] DMA-API: Change dma_declare_coherent_memory() CPU address
 to phys_addr_t
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 6:07 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Apr 30, 2014 at 02:33:21PM -0600, Bjorn Helgaas wrote:
>> dma_declare_coherent_memory() takes two addresses for a region of memory: a
>> "bus_addr" and a "device_addr".  I think the intent is that "bus_addr" is
>> the physical address a *CPU* would use to access the region, and
>> "device_addr" is the bus address the *device* would use to address the
>> region.
>>
>> Rename "bus_addr" to "phys_addr" and change its type to phys_addr_t.
>
> Isn't this going to cause problems with the callers of this function?
> You aren't changing them...

Sorry, I should have mentioned that in the changelog.

This could cause a problem if it changed "bus_addr" to a smaller type,
e.g., in a config where dma_addr_t was 64 bits but phys_addr_t was
only 32.  In that config (if it exists), this change would truncate
the address if a caller  supplied a 64-bit dma_addr_t.  But most of
the callers in the tree already supply a phys_addr_t (or the
equivalent resource_size_t), and the rest supply 32-bit int values, so
I don't think there's a problem here.

This change could theoretically *fix* a problem in a config with
32-bit dma_addr_t and 64-bit phys_addr_t.  In that case we could
previously have truncated a phys_addr_t, and this change would fix it.
 But I don't know of any issues like this.

Here are the 16 callers in the tree:

4 in arch/arm/mach-imx/mach-imx27_visstrim_m10.c (phys_addr_t)
3 in arch/arm/mach-imx/mach-mx31_3ds.c (phys_addr_t)
1 in arch/arm/mach-imx/mach-pcm037.c (phys_addr_t)
1 in arch/arm/plat-samsung/s5p-dev-mfc.c (phys_addr_t)
1 in arch/sh/drivers/pci/fixups-dreamcast.c (#define constant)
2 in drivers/media/platform/s5p-mfc/s5p_mfc.c (unsigned int from OF property)
1 in drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c (struct
resource.start)
1 in drivers/scsi/NCR_Q720.c (__u32 memory address computed from I/O
port values)
1 in drivers/usb/host/ohci-sm501.c (struct resource.start)
1 in drivers/usb/host/ohci-tmio.c (struct resource.start)

Bjorn
