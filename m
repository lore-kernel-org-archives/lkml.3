Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab3CAWTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 17:19:12 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:50027 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3CAWTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 17:19:09 -0500
MIME-Version: 1.0
In-Reply-To: <CAO9zADxjoP+R9ccz7vMPmcFvdYwNjErSjaWc_RFkW_FY3+SK=w@mail.gmail.com>
References: <1354533387-4110-1-git-send-email-acooks@gmail.com>
	<1355914703-28576-1-git-send-email-acooks@gmail.com>
	<1362126373-32318-1-git-send-email-acooks@gmail.com>
	<CAO9zADxjoP+R9ccz7vMPmcFvdYwNjErSjaWc_RFkW_FY3+SK=w@mail.gmail.com>
Date: Sat, 2 Mar 2013 06:19:07 +0800
Message-ID: <CAJtEV7Zs2BiwJ9jdDeoceh9hiVXvVaSvj=9H+4+vEzhY72AS9g@mail.gmail.com>
Subject: Re: [PATCH] Quirk to support Marvell 88SE91xx SATA controllers with
 Intel IOMMU.
From: Andrew Cooks <acooks@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Joerg Roedel <joro@8bytes.org>, YingChu <xjtuychu@hotmail.com>,
        Chu Ying <gm.ychu@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 2, 2013 at 1:51 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Fri, Mar 1, 2013 at 3:26 AM, Andrew Cooks <acooks@gmail.com> wrote:
>>
>> This is my third submitted patch to make Marvell 88SE91xx SATA controllers
>> work when IOMMU is enabled.[1][2]
>>
>
> Hi,
>
> Against 3.7.10:
>
> # patch -p1 <
> ../RFC-Fix-Intel-IOMMU-support-for-Marvell-88SE91xx-SATA-controllers..patch
> patching file drivers/iommu/intel-iommu.c
> patching file drivers/pci/quirks.c
> Hunk #1 succeeded at 3230 (offset 3 lines).
> patching file include/linux/pci.h
> #

Thanks for testing!

Patching 3.7.10 looks somewhat different here. I'm using the
linux-3.7.y branch from
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
at commit 356d8c6fb2a7cf49e836742738a8b9a47e77cfea. The output I get
is:

$ patch -p1 < ~/devel/lk_patches_dma_source_maps-20130301/marvell_ghost_funcs.patch
patching file drivers/iommu/intel-iommu.c
Hunk #1 succeeded at 1672 (offset -2 lines).
Hunk #2 succeeded at 1729 (offset -2 lines).
Hunk #3 succeeded at 3833 (offset -2 lines).
patching file drivers/pci/quirks.c
Hunk #1 succeeded at 3210 (offset -39 lines).
Hunk #2 succeeded at 3240 (offset -39 lines).
Hunk #3 succeeded at 3258 (offset -39 lines).
patching file include/linux/pci.h
Hunk #1 succeeded at 1546 (offset -32 lines).
Hunk #2 succeeded at 1555 (offset -32 lines).
patching file include/linux/pci_ids.h

>
> Recompile kernel, reboot..
>
> Shutdown host, re-attach to Marvell Controller w/IOMMU.
>
> The host still failed to boot, dmesg/panic here:
> http://home.comcast.net/~jpiszcz/20130301/boot_failure.JPG
>
> (The root disk is /dev/sdc)

Sorry it doesn't work for you, but I can't really tell what's failing
from the photo you posted. I'm running 3.7.10 with this patch right
now.

According to the dmesg output you posted at
https://home.comcast.net/~jpiszcz/20121128/dmesg.txt and the lspci
output in http://www.kernelhub.org/?p=2&msg=171877, you've run into
two separate DMAR issues:

Problem A - nvidia graphics:
[    2.968248] dmar: DRHD: handling fault status reg 202
[    2.968253] dmar: DMAR:[DMA Read] Request device [04:00.0] fault addr 0
[    2.968253] DMAR:[fault reason 06] PTE Read access is not set

Problem B - Marvell 88SE9123:
[    2.974534] ata9: SATA link down (SStatus 0 SControl 300)
[    2.976297] ata7: SATA link down (SStatus 0 SControl 300)
[    2.977939] ata13: SATA link down (SStatus 0 SControl 300)
[    2.979689] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.981419] dmar: DRHD: handling fault status reg 2
[    2.981431] ata8: SATA link down (SStatus 0 SControl 300)
[    2.981449] ata11: SATA link down (SStatus 0 SControl 300)
[    2.988479] dmar: DMAR:[DMA Read] Request device [84:00.1] fault
addr fff00000
[    2.988479] DMAR:[fault reason 02] Present bit in context entry is clear

Can you capture a full dmesg with this patch applied?

--
a.
