Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaHIA2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 20:28:12 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54370 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaHIA2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 20:28:09 -0400
Message-ID: <53E56B16.5030402@codeaurora.org>
Date: Fri, 08 Aug 2014 17:28:06 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Jon Medhurst <tixy@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V." <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 0/4] CMA & device tree, once again
References: <1405321966-28184-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1405321966-28184-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/14/2014 12:12 AM, Marek Szyprowski wrote:
> Hello,
> 
> This is one more respin of the patches which add support for creating
> reserved memory regions defined in device tree. The last attempt
> (http://lists.linaro.org/pipermail/linaro-mm-sig/2014-February/003738.html)
> ended in merging only half of the code, so right now we have complete
> documentation merged and only basic code, which implements a half of it
> is written in the documentation. Although the merged patches allow to
> reserve memory, there is no way of using it for devices and drivers.
> 
> This situation makes CMA rather useless, as the main architecture (ARM),
> which used it, has been converted from board-file based system
> initialization to device tree. Thus there is no place to use direct
> calls to dma_declare_contiguous() and some new solution, which bases on
> device tree, is urgently needed.
> 
> This patch series fixes this issue. It provides two, already widely
> discussed and already present in the kernel, drivers for reserved
> memory: first based on DMA-coherent allocator, second using Contiguous
> Memory Allocator. The first one nicely implements typical 'carved out'
> reserved memory way of allocating contiguous buffers in a kernel-style
> way. The memory is used exclusively by devices assigned to the given
> memory region. The second one allows to reuse reserved memory for
> movable kernel pages (like disk buffers, anonymous memory) and migrates
> it out when device to allocates contiguous memory buffer. Both driver
> provides memory buffers via standard dma-mapping API.
> 
> The patches have been rebased on top of latest CMA and mm changes merged
> to akmp kernel tree.
> 
> To define a 64MiB CMA region following node is needed:
> 
> multimedia_reserved: multimedia_mem_region {
> 	compatible = "shared-dma-pool";
> 	reusable;
> 	size = <0x4000000>;
> 	alignment = <0x400000>;
> };
> 
> Similarly, one can define 64MiB region with DMA coherent memory:
> 
> multimedia_reserved: multimedia_mem_region {
> 	compatible = "shared-dma-pool";
> 	no-map;
> 	size = <0x4000000>;
> 	alignment = <0x400000>;
> };
> 

Longer term, I think it would be good if we didn't have to use no-map with
the coherent memory. With no-map and dma-coherent.c right now, not only
do you lose out on the physical memory space, you also have to give up
the same amount of vmalloc space for mapping. On arm32, if you have the default
240MB vmalloc space, 64M is ~25% of the vmalloc space. At least on arm you can
make this up by remapping the memory as coherent.

I haven't seen this picked up anywhere yet so you are welcome to add

Tested-by: Laura Abbott <lauraa@codeaurora.org>

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
