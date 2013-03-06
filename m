Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3CFG73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:59:29 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:44172 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3CFG7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:59:25 -0500
MIME-Version: 1.0
In-Reply-To: <1362542675.22132.86.camel@bling.home>
References: <1354533387-4110-1-git-send-email-acooks@gmail.com>
	<1355914703-28576-1-git-send-email-acooks@gmail.com>
	<1362126373-32318-1-git-send-email-acooks@gmail.com>
	<1362542675.22132.86.camel@bling.home>
Date: Wed, 6 Mar 2013 14:59:23 +0800
Message-ID: <CAJtEV7b4eyvWe36ttxR3mDVqNoQQM3BZ-LVn0BTxZCbPSY_o6w@mail.gmail.com>
Subject: Re: [PATCH] Quirk to support Marvell 88SE91xx SATA controllers with
 Intel IOMMU.
From: Andrew Cooks <acooks@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>, YingChu <xjtuychu@hotmail.com>,
        Chu Ying <gm.ychu@gmail.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Justin Piszcz <jpiszcz@lucidpixels.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 12:04 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Fri, 2013-03-01 at 16:26 +0800, Andrew Cooks wrote:
>
>> +
>> +     for (fn = 1; fn < 8; fn++) {
>
> Wouldn't you want to do 0 to 7, then add:
>
> if (fn == PCI_FUNC(pdev->devfn))
>         continue;
>
> You could also get more creative with the loop using shifts and exit
> when the remaining map is 0.

Thanks, I'll use a shift instead.

Up to now I've assumed that function 0 will always be the real device
and that function 1-7 may be ghost functions, but as we saw in the
case of the Marvell 88NV9143 in the Super Talent CoreStore MV 64GB
mini-PCIe SSD, that assumption is probably wrong.

To handle the case where the real device is function 1 and function 0
needs to be mapped as a ghost function, would it be acceptable to
iterate over 0 to 7 and let domain_context_mapping_one take care of
preventing duplicates, or should I duplicate the
device_to_context_entry and context_present function calls?

>
>> +             if (fn_map & (1 << fn)) {
>> +                     err = domain_context_mapping_one(domain,
>> +                                     pci_domain_nr(pdev->bus),
>> +                                     pdev->bus->number,
>> +                                     PCI_DEVFN(PCI_SLOT(pdev->devfn), fn),
>> +                                     translation);
>> +                     if (err)
>> +                             return err;
>
> I'd be worried that there's missing cleanup here, what if you were
> mapping multiple ghost functions and the 2nd one failed, leaving one
> attached?

I don't understand the failure cases sufficiently, but I understand
that it's better to have all mappings succeed or fail together. Will
fix it.

>> +/* Table of multiple (ghost) source functions. This is similar to the
>> + * translated sources above, but with the following differences:
>> + * 1. the device may use multiple functions as DMA sources,
>> + * 2. these functions cannot be assumed to be actual devices,
>> + * 3. the specific ghost function for a request can not be exactly predicted.
>> + * The bitmap only contains the additional quirk functions.
>> + */
>> +static const struct pci_dev_dma_multi_func_sources {
>> +     u16 vendor;
>> +     u16 device;
>> +     u8 func_map;    /* bit map. lsb is fn 0. */
>> +} pci_dev_dma_multi_func_sources[] = {
>> +     { PCI_VENDOR_ID_MARVELL_2, 0x9123, (1<<0)|(1<<1)},
>> +     { PCI_VENDOR_ID_MARVELL_2, 0x9125, (1<<0)|(1<<1)},
>> +     { PCI_VENDOR_ID_MARVELL_2, 0x9128, (1<<0)|(1<<1)},
>> +     { PCI_VENDOR_ID_MARVELL_2, 0x9130, (1<<0)|(1<<1)},
>> +     { PCI_VENDOR_ID_MARVELL_2, 0x9172, (1<<0)|(1<<1)},
>
> Links to bug reports in the comments might be useful for future
> workarounds.  I'm also not sure what you mean in the 3rd bullet, the
> non-ghost function of some of these is sometimes 0, sometimes 1?  And
> the ghost function is the other?

The ghost function is the one that doesn't correspond to an actual
device, but the actual device could be either 0 or 1 and it could use
both 0 and 1 for different requests, with no obvious way to tell when
it will use 0 and when it will use 1. I'll reword the bullet.

> Skipping fn 0 above, I assume all
> cases are fn 0 exists and fn 1 is the ghost function, right?  If so,
> then we probably only want bit 1 set.  I'm afraid to ask whether there
> are configurations of this vendor/device that have a fn 1.

See comment about Marvell 88NV9143 above.

Thanks for reviewing!

a.
