Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbaKTHkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:40:10 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:61008 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbaKTHkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:40:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: For the problem when using swiotlb
Date: Thu, 20 Nov 2014 08:40 +0100
Message-ID: <2522857.bNQToYpBNt@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <546D58B1.60108@huawei.com>
References: <5469E26B.2010905@huawei.com> <1535751.CcvIi3DN4F@wuerfel> <546D58B1.60108@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:hJwckUcfblQ7DPmB9vcq6T//648aHXsN7Tq20GrAiVf
 qdCqgIHzM9VNbKvIYBFS1M21snXeSTN7XvC1owz1RBPCS4CqtP
 6dULipAWS3KKh+vTHYwIa0D56KHsBLB9cD8xUd2wEzj5OzEPFd
 mZIueZgFVAOTStnKT2jfm4bw91tNsDfRlYMWJmsXafWEc3TR8L
 yVGnxQD9IOA+n1ZG2YX+kJgMtNmAfvtV2dlVZS1DjrJdU+TxXw
 8HxTAU5AsxhGVgdKCqXGFz8nDrbdVLcaZe11O1owmYbQhifTTO
 MnR3Yme4Clpjlcy3wzc1kJaGC18MqlLOkWPwJqpVX6exwLoNnl
 7q1Arp6MChHTh0oEhzVU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2014 10:57:53 Ding Tianhong wrote:
> On 2014/11/19 16:45, Arnd Bergmann wrote:
> > On Wednesday 19 November 2014 11:17:15 Ding Tianhong wrote:
> >> On 2014/11/18 2:09, Catalin Marinas wrote:
> >>> On Mon, Nov 17, 2014 at 12:18:42PM +0000, Arnd Bergmann wrote:
> >> Thanks everyone, I think I found the way to fix it, need to enable DMA_CMA, to reserve a big memory
> >> for CMA and set coherent mask for dev, then dma_alloc and dma_mapping will not use the swiotlb until
> >> the memory out of mask or swiotlb_force is enabled.
> >>
> >> If I still understand uncorrectly, please inform me.
> >>
> > 
> > Please do not use CMA to work around the problem, but fix the underlying bug
> > instead.
> > 
> > The driver should call 'dma_set_mask_and_coherent()' with the appropriate
> > dma mask, and check whether that succeeded. However, the code implementing
> > dma_set_mask_and_coherent on arm64 also needs to be changed to look up
> > the dma-ranges property (see of_dma_configure()), and check if the mask
> > is possible.
> > 
> The dma_pfn_offset looks only support arm32, but my platform is aarch64 and I check the latest kernel version, 
> I think the dma-rangs still could not work for aarch64, so maybe we should add dma_pfn_offset for aarch64 first.
> 

I didn't mean the dma_pfn_offset. The problem is that the of_dma_configure
code currently doesn't look at the mask. As I explained in my reply to
Catalin, it should set the mask to the size of the dma-ranges if that is
32-bit or smaller, and dma_set_mask should look at the same dma-ranges
property to decide what to set the mask to when a driver asks for a
mask larger than 64-bit.

	Arnd
