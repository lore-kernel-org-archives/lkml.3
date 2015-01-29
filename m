Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbbA2NXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:23:46 -0500
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:58609 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757257AbbA2NXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:23:43 -0500
X-Greylist: delayed 60989 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2015 08:23:43 EST
X-SMTPDoctor-Processed: csmtpprox beta
X-Sender-Id: markh@compro.net
Message-ID: <54CA345D.4010502@compro.net>
Date: Thu, 29 Jan 2015 08:23:41 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: dma_alloc_coherent - cma - and IOMMU question
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the noise. I've read everything DMA in the kernel Doc dir and 
searched the web to no avail. So I thought I might get some useful info 
here.

I'm currently using a 3.18.3 (x86_64) kernel on an AMD platform. I am 
currently doing 8MB DMAs to and from our device using the in kernel CMA 
"cma=64M@0-4G" with no problems. This device is not DAC or 
scatter/gather capable so the in kernel CMA has been great and replaced 
our old bigphysarea usage.

We simply use dma_alloc_coherent and pass the dma_addr_t *dma_handle 
returned from the dma_alloc_coherent function to our device as the 
"bus/pci" address to use.
We also use remap_pfn_range on that dma_addr_t *dma_handle returned from 
  the dma_alloc_coherent function to mmap userland to the buffer. All is 
good until I enable the IOMMU. I then either get IO_PAGE_FAULTs, the DMA 
just quietly never completes or the system gets borked.

[  106.115725] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 
domain=0x001b address=0x00000000aa500000 flags=0x0010]
[  106.115729] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 
domain=0x001b address=0x00000000aa500040 flags=0x0010]

Here are the IOMMU settings in my kernel config:

#grep IOMMU .config
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_IOMMU_HELPER=y
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_AMD_IOMMU=y
# CONFIG_AMD_IOMMU_STATS is not set
CONFIG_AMD_IOMMU_V2=m
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
# CONFIG_IOMMU_STRESS is not set


 From reading the in kernel doc it would appear that we could in fact, 
using the IOMMU and the dma_map_sg function, get rid of the CMA 
requirement and our device could DMA anywhere, even above the 4GB 
address space limit of our device. But before going through this larger 
change to our GPL driver, I want to understand if and/or why the 
dma_alloc_coherent function does not appear to set up the IOMMU for me. 
Is the IOMMU only supported for "streaming" DMA type and not for 
"coherent"? I read no reference to this in the kernel doc?

Any hints would be greatly appreciated. Again, sorry for the noise.

Regards
Mark




