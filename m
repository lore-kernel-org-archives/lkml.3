Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbaCZOXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:23:14 -0400
Received: from mail1.windriver.com ([147.11.146.13]:44397 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbaCZOXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:23:12 -0400
Message-ID: <5332E2D3.8030809@windriver.com>
Date: Wed, 26 Mar 2014 10:23:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: sparclinux <sparclinux@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparc32: make copy_to/from_user_page() usable from modular
 code
References: <1392326101-20388-1-git-send-email-paul.gortmaker@windriver.com> <CAMuHMdUNvSahqcHPo9eO44d6opQXTvQq_HbUbFM2qhXTOj7LJQ@mail.gmail.com>
In-Reply-To: <CAMuHMdUNvSahqcHPo9eO44d6opQXTvQq_HbUbFM2qhXTOj7LJQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-03-26 04:41 AM, Geert Uytterhoeven wrote:
> On Thu, Feb 13, 2014 at 10:15 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> While copy_to/from_user_page() users are uncommon, there is one in
>> drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c which leads
>> to the following:
>>
>> ERROR: "sparc32_cachetlb_ops" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!
>>
>> during routine allmodconfig build coverage.  The reason this happens
>> is as follows:
>>
>> In arch/sparc/include/asm/cacheflush_32.h we have:
>>
>>  #define flush_cache_page(vma,addr,pfn) \
>>         sparc32_cachetlb_ops->cache_page(vma, addr)
>>
>>  #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
>>         do {                                                    \
>>                 flush_cache_page(vma, vaddr, page_to_pfn(page));\
>>                 memcpy(dst, src, len);                          \
>>         } while (0)
>>  #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
>>         do {                                                    \
>>                 flush_cache_page(vma, vaddr, page_to_pfn(page));\
>>                 memcpy(dst, src, len);                          \
>>         } while (0)
>>
>> However, sparc32_cachetlb_ops isn't exported and hence the error.
>>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> Sorry for only noticing now. A similar fix for pa-risc was reverted:
> 
> "Christoph Hellwig <hch@infradead.org> commented:
>  This one shouldn't go in - Geert sent it a bit prematurely, as Lustre
>  shouldn't use it just to reimplement core VM functionality (which it
>  shouldn't use either, but that's a separate story)."

Generally speaking I agree, and every time I touch lustre, I feel
like I need to go home and have a shower.  However, in this case,
lustre wasn't actually directly calling flush_cache_page type core
VM ops directly, and I couldn't convince myself of an argument
of why a modular driver should be forbidden from using either
of copy_to/from_user_page()...

Either way is fine with me.  If a revert is desired and we want
to make lustre depend on CONFIG_BROKEN (okay, a bit harsh) or
don't allow lustre to be modular, that is also fine.

Paul.
--

> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=a446e72bc15c7bfd2c953e56064ace3566c79b0e
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 
