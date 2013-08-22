Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3HVCV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:21:59 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33842 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab3HVCV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:21:58 -0400
Message-ID: <521575C2.7050504@hitachi.com>
Date: Thu, 22 Aug 2013 11:21:54 +0900
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
Subject: Re: [PATCH 0/3] kprobes: add new dma insn slot cache for s390
References: <1377086465-6471-1-git-send-email-heiko.carstens@de.ibm.com>
In-Reply-To: <1377086465-6471-1-git-send-email-heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

(2013/08/21 21:01), Heiko Carstens wrote:
> The current kpropes insn caches allocate memory areas for insn slots with
> module_alloc(). The assumption is that the kernel image and module area
> are both within the same +/- 2GB memory area.
> This however is not true for s390 where the kernel image resides within
> the first 2GB (DMA memory area), but the module area is far away in the
> vmalloc area, usually somewhere close below the 4TB area.
> 
> For new pc relative instructions s390 needs insn slots that are within
> +/- 2GB of each area. That way we can patch displacements of pc-relative
> instructions within the insn slots just like x86 and powerpc.
> 
> The module area works already with the normal insn slot allocator, however
> there is currently no way to get insn slots that are within the first 2GB
> on s390 (aka DMA area).

The reason why we allocate instruction buffers from module area is
to execute a piece of code on the buffer, which should be executable.
I'm not good for s390, is that allows kernel to execute the code
on such DMA buffer?

> Therefore this patch set introduces a third insn slot cache besides the
> normal insn and optinsn slot caches: the dmainsn slot cache. Slots can be
> allocated and freed with get_dmainsn_slot() and free_dmainsn_slot().

OK, but it seems that your patch introduced unneeded complexity. Perhaps,
you just have to introduce 2 weak functions to allocate/release such
executable and jump-able buffers, like below,

void * __weak arch_allocate_executable_page(void)
{
	return module_alloc(PAGE_SIZE);
}

void __weak arch_free_executable_page(void *page)
{
	module_free(NULL, page);
}

Thus, all you need to do is implementing dmaalloc() version of above
functions on s390. No kconfig, no ifdefs are needed. :)

> 
> Patch 1 unifies the current insn and optinsn caches implementation so we
> don't end up with a lot of code duplication when adding a third cache.
> 
> Patch 2 simply adds the new dmainsn slot cache.
> 
> Patch 3 is the s390 usage of the new cache.
> 
> Looking at the last couple of sign-off chains I'm not sure how kprobes
> patches should go upstream.. Andrew, Ingo, or simply via the s390 tree?

Hmm, AFAIK, currently all noarch kprobes works go to -tip tree, and
the arch dependent parts go to each arch tree (only x86 goes to -tip tree).

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


