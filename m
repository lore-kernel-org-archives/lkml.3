Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab3HWEb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 00:31:27 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:45449 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3HWEb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 00:31:26 -0400
Message-ID: <5216E59B.20109@hitachi.com>
Date: Fri, 23 Aug 2013 13:31:23 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH 0/3] kprobes: add new dma insn slot cache for s390
References: <1377086465-6471-1-git-send-email-heiko.carstens@de.ibm.com> <521575C2.7050504@hitachi.com> <20130822055254.GA4293@osiris>
In-Reply-To: <20130822055254.GA4293@osiris>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/22 14:52), Heiko Carstens wrote:
> Hi Masami,
> 
>> (2013/08/21 21:01), Heiko Carstens wrote:
>>> The current kpropes insn caches allocate memory areas for insn slots with
>>> module_alloc(). The assumption is that the kernel image and module area
>>> are both within the same +/- 2GB memory area.
>>> This however is not true for s390 where the kernel image resides within
>>> the first 2GB (DMA memory area), but the module area is far away in the
>>> vmalloc area, usually somewhere close below the 4TB area.
>>>
>>> For new pc relative instructions s390 needs insn slots that are within
>>> +/- 2GB of each area. That way we can patch displacements of pc-relative
>>> instructions within the insn slots just like x86 and powerpc.
>>>
>>> The module area works already with the normal insn slot allocator, however
>>> there is currently no way to get insn slots that are within the first 2GB
>>> on s390 (aka DMA area).
>>
>> The reason why we allocate instruction buffers from module area is
>> to execute a piece of code on the buffer, which should be executable.
>> I'm not good for s390, is that allows kernel to execute the code
>> on such DMA buffer?
> 
> Yes, the kernel image itself resides in DMA capable memory and it is all
> executable.
> 
>>> Therefore this patch set introduces a third insn slot cache besides the
>>> normal insn and optinsn slot caches: the dmainsn slot cache. Slots can be
>>> allocated and freed with get_dmainsn_slot() and free_dmainsn_slot().
>>
>> OK, but it seems that your patch introduced unneeded complexity. Perhaps,
>> you just have to introduce 2 weak functions to allocate/release such
>> executable and jump-able buffers, like below,
>>
>> void * __weak arch_allocate_executable_page(void)
>> {
>> 	return module_alloc(PAGE_SIZE);
>> }
>>
>> void __weak arch_free_executable_page(void *page)
>> {
>> 	module_free(NULL, page);
>> }
>>
>> Thus, all you need to do is implementing dmaalloc() version of above
>> functions on s390. No kconfig, no ifdefs are needed. :)
> 
> Hm, I don't see how that can work, or maybe I just don't get your idea ;)
> Or maybe my intention was not clear? So let me try again:
> 
> If the to be probed instruction resides within the first 2GB of memory
> (aka DMA memory, aka kernel image) the insn slot must be within the first
> 2GB as well, otherwise I can't patch pc-relative instructions.
> 
> On the other hand if the to be probed instruction resides in a module
> (aka part of the vmalloc area), the insn slot must reside within the same
> 2GB area as well.
> 
> Therefore I need to different insn slot caches, where the slots are either
> allocated with __get_free_page(GFP_KERNEL | GFP_DMA) (for the kernel image)
> or module_alloc(PAGE_SIZE) for modules.
> 
> I can't have a single cache which satifies both areas.

Oh, I see.
Indeed, that enough reason to add a new cache... By the way, is there
any way to implement it without new kconfig like DMAPROBE and dma flag?
AFAICS, since such flag is strongly depends on the s390 arch, I don't
like to put it in kernel/kprobes.c.

Perhaps, we can make insn slot more generic, e.g. create new slot type
with passing page allocator.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


