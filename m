Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbaENRTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:19:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450AbaENRTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:19:02 -0400
Message-ID: <1400087937.17639.223.camel@ul30vt.home>
Subject: Re: [PATCH v3 00/15] PCI/iommu: Fix DMA alias problems
From: Alex Williamson <alex.williamson@redhat.com>
To: eddy0596 <eddy0596@gmail.com>
Cc: linux-kernel@vger.kernel.org, iommu <iommu@lists.linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci <linux-pci@vger.kernel.org>
Date: Wed, 14 May 2014 11:18:57 -0600
In-Reply-To: <1400020520427-859747.post@n7.nabble.com>
References: <20140510145619.2997.429.stgit@bling.home>
	 <1400020520427-859747.post@n7.nabble.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc original lists]

Hi Edward,

On Tue, 2014-05-13 at 15:35 -0700, eddy0596 wrote:
> Hello Alex,
> 
> Thanks for working on a fix on this long standing issue. I have applied the
> amd portion of the IOMMU patches against the 3.14.3 kernel and found the
> followings:
> 1) The computer would not boot up if it's from a cold start. The kernel log
> shows that it hangs at the point the kernel attempt to attach the scsi disk
> [sdk] that connects to the LSI-SAS2008 controller at pci 04:00.0. I can use
> Ctrl+Alt+Del to reboot the computer. So, I guess the kernel didn't "hang"
> and I don't see any oops either.
> 2) After a warm reboot with Ctrl+Alt+Del, the kernel will boot up fine. And,
> the Marvell controller behaves properly (More stress test needed) and so as
> the two LSI-SAS2008. A warm reboot after a hard reset at BIOS prompt will
> also boot up fine.

Both of these indicate that the hand-off state of the system is
different between a warm an cold reset.  Can you capture the boot
messages (serial console or netconsole) of each case and add the
pci=earlydump option so we can compare the PCI state?

> 3) Removing sdk and perform a cold reboot, the kernel stops after attaching
> all the ST3000DM001 harddisks that connects to the LSI-SAS2008 at pci
> 01:00:0. The kernel stops at "ata12: SATA link down (SStatus 0 SControl
> 300)".
> 4) Removing sda and sdl that connects to the Marvell 88SE9172 at pci
> 09:00.0, the kernel stops after attaching the eight ST3000DM001 that
> connects to the LSI-SAS2008 at pci 01:00:0.

So it's not an issue with those specific disks.  Is it possible to
remove or disable the controller in the BIOS to further isolate?

> 5) Cold start with a kernel without the IOMMU patches starts up fine except
> a number of kernel oops related to the Marvell controller complaining about
> invalid PCI access from the AMD IOMMU.

Is this kernel built from the same source tree as below without the
indicated IOMMU patches applied?

> Attached is the kernel boot log that's obtained with all HDDs attached and
> successfully boot up after a warm reboot and some information on my setup.
> Let me know if you need more information/log to help with debuging. 

The mailing list doesn't like attachments, but it was included in the
re-send to me where it was inline.  An unsuccessful boot log is probably
the most interesting, preferably with the pci=earlydump option (and
continue to use the amd_iommu_dump option as well).  Also, what happens
with amd_iommu=off?  If we're not getting any IOMMU faults, it seems
like the patches are doing their job and I'm at a bit of a loss to
understand how it would fail only on a cold boot.

It might also be useful to test the branch provided in case there's an
issue with backporting the patches to 3.14.

> Best Regards,
> 
> Edward Cheung
> 
> Motherboard: Gigabyte GA-990FXA-UD5 Revision 1.0. Note that the kernel is
> using software IO TLB belief due to broken IVRS table. I am still trying to
> find a fix for this.

What brings you to the conclusion that the IVRS table is broken?  IIRC,
AMD-Vi initializes the swiotlb to support pasthrough devices that can
only do 32bit DMA... or something like that.  So I don't think it's
unusual to see it initialized alongside AMD IOMMU.  Thanks,

Alex


