Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbbACVhf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 16:37:35 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:62446 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbbACVhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 16:37:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] of/pci: add of_pci_dma_configure() update dma configuration
Date: Sat, 03 Jan 2015 22:37:09 +0100
Message-ID: <2019516.ehiuEv0rdL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54A71CD1.4070107@ti.com>
References: <1419459099-6667-1-git-send-email-m-karicheri2@ti.com> <CAL_Jsq+krOUA3BPvMCdaOBhALoi+pzWbw3YndXqR8x52OJogZg@mail.gmail.com> <54A71CD1.4070107@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:2cRorP2QVCH1BwwVSAqglNk3REO6aYkp+d7CWobI7xxNtw5X71G
 HhcDbBjTiz0Uvo/R0A8yX/zvB0yYFzvWZGTFIXUMRbGCNQ3hknHV/o+Pmolyg80wbytA2o0
 xAG9DnwQIg2hLGoczEH893NIVL0i48IZZ/bqk3lQyAC2nVfzHxWrUGNBoCLWF6QHYPs7QZb
 RuvK8smqDiAEAmImTX4Zg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 January 2015 17:33:53 Murali Karicheri wrote:
> 
> I have no experience with IOMMU and may not offer much help here as I 
> originally wrote above. Will Deacon has added this API and probably able 
> to offer some help in this discussion.
> 
> Will Deacon,
> 
> Any comment?

It's complicated :(

> Looking at the iommu documentation and of_iommu.c, I get a feeling that 
> this API is not really used at present as there are no callers of 
> of_iommu_set_ops() and I assume this is a WIP.

Right, but we have patches for some iommu drivers based on this API,
and we should migrate all of them eventually.

> I believe the way it is 
> expected to work is to have the iommu driver of the master IOMMU devices 
> call of_iommu_set_ops(). The device node of this master IOMMU device is 
> specified as a phandle in the OF node of the device (various bus devices 
> such as platform, PCI etc). This allow to retrieve the iommu ops though 
> the of_iommu_configure() API and use it in arch_setup_dma_ops(). So my 
> gut feeling is that for PCI devices, as there are no DT node, the root 
> bus node may specify iommus phandle to IOMMU master OF nodes.

Yes, but we also need to pass a PCI device specific identifier along
with the root bus node, because some iommu drivers take the PCI
bus/device/function number into account for creating per-function
i/o page tables.

> W.r.t your comment "We may want to address the comment in
> of_iommu_configure about parent nodes. We should be sure these changes 
> work with how we would do searching parent nodes",
> 
> I believe, the parent node search itself should work the same way in the 
> case of PCI as with platform bus case. PCI's case, we are providing the 
> OF node of the root bus host bridge. Why should this be any different in 
> terms of search?
> 
> I see a potential issue with dma-ranges as described in the notes below.
> As noted below the usage of dma-range for iommu is to be determined. For 
> keystone, the of_iommu_configure() always return false as we don't use 
> the iommu. But don't know if this has any consequences for other 
> platforms. Or I got your questions wrong. Any help here from others on 
> the list?
> 
> ========================================================================
> One possible extension to the above is to use an "iommus" property along 
> with a "dma-ranges" property in a bus device node (such as PCI host 
> bridges). This can be useful to describe how children on the bus relate 
> to the IOMMU if they are not explicitly listed in the device tree (e.g. 
> PCI devices). However, the requirements of that use-case haven't been 
> fully determined yet. Implementing this is therefore not recommended 
> without further discussion and extension of this binding.
> =========================================================================

This probably won't ever apply to PCI devices, so let's ignore it for now.
For the moment (and for PCI), we should assume that we either configure
an iommu directly or we use dma-ranges if no iommu is in use.

	Arnd
