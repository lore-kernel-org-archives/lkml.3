Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbaENO10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:27:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbaENO1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:27:24 -0400
Message-ID: <1400077631.17639.185.camel@ul30vt.home>
Subject: Re: [PATCH v3 08/15] iommu/amd: Use pci_find_dma_isolation_root()
 for IOMMU groups
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org,
        linux@horizon.com
Date: Wed, 14 May 2014 08:27:11 -0600
In-Reply-To: <20140514103449.GE6026@8bytes.org>
References: <20140510145619.2997.429.stgit@bling.home>
	 <20140510150311.2997.62903.stgit@bling.home>
	 <20140514103449.GE6026@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-14 at 12:34 +0200, Joerg Roedel wrote:
> On Sat, May 10, 2014 at 09:03:11AM -0600, Alex Williamson wrote:
> > The expectation is that the kernel and IVRS will produce the same
> > result for topology based aliases while the kernel will also include
> > device specific DMA quirks.
> 
> Is that expectation really true? There are PCIe devices out there that
> don't use their own device-id for requests but another one that isn't
> even visible as a PCI device (so the kernel has no pci_dev structure for
> it). The IVRS table contains such information, but I am not sure whether
> the PCI core finds the right requestor-id for those devices.
> 
> I've seen this on PCIe cards that where the vendor just used an PCI-X
> chip with a PCIe-to-PCI-X bridge on the card. The PCI-X device is
> visible for the OS but uses the requestor-id of the invisible bridge.

If we rely on the IVRS, then the set of devices with quirked aliases is
fixed by the platform vendor.  More often than not, I think that proves
to be ineffective.  I personally have a 990FX box with a single function
Marvell SATA controller that uses function 1 as the requester ID.  It's
running the latest BIOS and the IVRS isn't helping.  With this series,
we have the ability to add quirks to the kernel to fix those kinds of
issues for both AMD-Vi, VT-d, and any other IOMMU.

Here I've chosen that we get more value from using shared code so we
don't process IOMMU groups in a unique way for AMD-Vi.  Patch 09/15 uses
the PCI core alias when the IVRS doesn't provide one, perhaps a
compromise would be to also do the reverse and update dma_func_alias on
the device when the IVRS knows of a device quirk that the kernel
doesn't.  Then we could still use the common IOMMU group code and print
something to dmesg so that we can update the kernel quirks.  Thanks,

Alex

