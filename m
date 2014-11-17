Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaKQSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:09:57 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:59566 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaKQSJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:09:56 -0500
Date: Mon, 17 Nov 2014 18:09:47 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ding Tianhong <dingtianhong@huawei.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: For the problem when using swiotlb
Message-ID: <20141117180947.GI29595@e104818-lin.cambridge.arm.com>
References: <5469E26B.2010905@huawei.com>
 <1650523.IrjSXzxF5O@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1650523.IrjSXzxF5O@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 12:18:42PM +0000, Arnd Bergmann wrote:
> On Monday 17 November 2014 19:56:27 Ding Tianhong wrote:
> >         The commit 3690951fc6d42f3a0903987677d0e592c49dd8db(arm64: Use swiotlb late initialisation)
> > switches the DMA mapping code to swiotlb_tlb_late_init_with_default_size(), this will occur a problem
> > when I run the scsi stress tests, the message as below:
> > 
> >         sas_controller b1000000.sas: swiotlb buffer is full (sz: 65536 bytes)..
> >         DMA: Out of SW-IOMMU space for 65536 bytes at device b1000000.sas
> > 
> > The reason is that the swiotlb_tlb_late_init_with_default_size() could only alloc 16M memory for DMA-mapping,
> > and the param in cmdline "swiotlb=xxx" is useless because the get_free_pages() only use the buddy to assigned a
> > maximum memory of 16M(The MAX_ORDER is 13 for 4k pages), obviously 16M is too small in many scenes, but
> > the swiotlb_init() which could reserved a bigger memory as wished could work well for most drivers.
> > 
> > I could not get a better way to fix this problem except to revert this patch, so could you please give me some
> > advise and help me, thanks very much.
> 
> In general, you should not need to use swiotlb for most devices, in
> particular for high-performance devices like network or block.
> 
> Please make sure that you have set up the dma-ranges properties in
> your DT properly to allow 64-bit DMA if the device supports it.

That's the problem indeed, the DMA API ends up using swiotlb bounce
buffers because the physical address of the pages passed to (or
allocated by) the driver are beyond 32-bit limit (which is the default
dma mask).

-- 
Catalin
