Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbaKTJDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:03:19 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:57342 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaKTJDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:03:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: For the problem when using swiotlb
Date: Thu, 20 Nov 2014 10:02:38 +0100
Message-ID: <2121725.INdNoXW7GO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <546DA795.9080209@huawei.com>
References: <5469E26B.2010905@huawei.com> <2522857.bNQToYpBNt@wuerfel> <546DA795.9080209@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:XugvtVpKo4IhXqR4xro8PAqJKik3XG8rd3uw45RbVtY
 MDrXPX2Z91H8QQOUnG1iZ0Bvw9tqfV59m/TEIBxTAavfmUNjiB
 7TET4EWTvkGiL2RAQN/CSvS4wnMJzIfguvTXXAEaIAhKW9g6PZ
 XFQrrAV+74TyIsM3lKvD9dTX0CRI8vTrChnH6zVzjUiaARPEoO
 zpLWx7szEjq1TIMu29ceXunBjPcykY2Kx7Csc813h+NzxIwujR
 yt8ldIv70LMuWpCzqw0aDGGUxkY+TGZMOZXNcocBsAbpaG8aSe
 K25Nr4RQMnLXCDNg1UhCzHd/rTMwOCnSNT1OP8HJzRWpUU59nY
 0YoRVU+beG4YkZoBhRd8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2014 16:34:29 Ding Tianhong wrote:
> > 
> > I didn't mean the dma_pfn_offset. The problem is that the of_dma_configure
> > code currently doesn't look at the mask. As I explained in my reply to
> > Catalin, it should set the mask to the size of the dma-ranges if that is
> > 32-bit or smaller, and dma_set_mask should look at the same dma-ranges
> > property to decide what to set the mask to when a driver asks for a
> > mask larger than 64-bit.
> > 
> ok, I think the your reply to catalin is clear, I got it, add a
> appropriate mask for the dev is
> reasonable, I think it should be fixed later.
> 
> But in my case, if I don't use the DMA_CMA, the dma_alloc_coherent
> should use the swiotlb directly which maximum is 16M,
> so unless I use the kmalloc otherwise I have no better idea for that.

But if you just change your driver to set the 64-bit DMA mask,
it will no longer use the swiotlb and work much faster without
that. You have to do it anyway, even once we fix the architecture
code.

The fix in the architecture code is just required so things don't
break if you have a 64-bit DMA capable device on a 32-bit bus.

On a related note, we should really fix the network and scsi core
code not lot just look at PCI_DMA_BUS_IS_PHYS but check the presence
of an IOMMU for devices that are limited to 32-bit DMA, so we fall
back to block bounce and lowmem SKB instead of swiotlb for IOMMU-less
devices.

Which driver are you using BTW?

	Arnd
