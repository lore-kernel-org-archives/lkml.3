Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbaGVXvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 19:51:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51294 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaGVXvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 19:51:07 -0400
Message-ID: <53CEF8E8.3080607@codeaurora.org>
Date: Tue, 22 Jul 2014 16:51:04 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        David Riley <davidriley@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>
Subject: Re: [PATCHv4 5/5] arm64: Add atomic pool for non-coherent and CMA
 allocations.
References: <1404324218-4743-1-git-send-email-lauraa@codeaurora.org> <1404324218-4743-6-git-send-email-lauraa@codeaurora.org> <201407222006.44666.arnd@arndb.de> <20140722210352.GA10604@arm.com>
In-Reply-To: <20140722210352.GA10604@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/22/2014 2:03 PM, Catalin Marinas wrote:
> On Tue, Jul 22, 2014 at 07:06:44PM +0100, Arnd Bergmann wrote:
[...]
>>> +               if (!addr)
>>> +                       goto destroy_genpool;
>>> +
>>> +               memset(addr, 0, atomic_pool_size);
>>> +               __dma_flush_range(addr, addr + atomic_pool_size);
>>
>> It also seems weird to flush the cache on a virtual address of
>> an uncacheable mapping. Is that well-defined?
> 
> Yes. According to D5.8.1 (Data and unified caches), "if cache
> maintenance is performed on a memory location, the effect of that cache
> maintenance is visible to all aliases of that physical memory location.
> These properties are consistent with implementing all caches that can
> handle data accesses as Physically-indexed, physically-tagged (PIPT)
> caches".
> 

This was actually unintentional on my part. I'm going to clean this up
to flush via the existing cached mapping to make it clearer what's going
on.

>> In the CMA case, the
>> original mapping should already be uncached here, so you don't need
>> to flush it.
> 
> I don't think it is non-cacheable already, at least not for arm64 (CMA
> can be used on coherent architectures as well).
> 

Memory allocated via dma_alloc_from_contiguous is not guaranteed to be
uncached. On arm, we allocate the page of memory and the remap it as
appropriate.

>> In the alloc_pages() case, I think you need to unmap
>> the pages from the linear mapping instead.
> 
> Even if unmapped, it would not remove dirty cache lines (which are
> associated with physical addresses anyway). But we don't need to worry
> about unmapping anyway, see above (that's unless we find some
> architecture implementation where having such cacheable/non-cacheable
> aliases is not efficient enough, the efficiency is not guaranteed by the
> ARM ARM, just the correct behaviour).
> 

Let's hope that never happens.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
