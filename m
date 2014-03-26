Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaCZIl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 04:41:29 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:45928 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaCZIlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 04:41:24 -0400
MIME-Version: 1.0
In-Reply-To: <1392326101-20388-1-git-send-email-paul.gortmaker@windriver.com>
References: <1392326101-20388-1-git-send-email-paul.gortmaker@windriver.com>
Date: Wed, 26 Mar 2014 09:41:23 +0100
X-Google-Sender-Auth: I7uQz-m-gPi12BIBsGpXQtd9Y-U
Message-ID: <CAMuHMdUNvSahqcHPo9eO44d6opQXTvQq_HbUbFM2qhXTOj7LJQ@mail.gmail.com>
Subject: Re: [PATCH] sparc32: make copy_to/from_user_page() usable from
 modular code
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: sparclinux <sparclinux@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 10:15 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> While copy_to/from_user_page() users are uncommon, there is one in
> drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c which leads
> to the following:
>
> ERROR: "sparc32_cachetlb_ops" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!
>
> during routine allmodconfig build coverage.  The reason this happens
> is as follows:
>
> In arch/sparc/include/asm/cacheflush_32.h we have:
>
>  #define flush_cache_page(vma,addr,pfn) \
>         sparc32_cachetlb_ops->cache_page(vma, addr)
>
>  #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
>         do {                                                    \
>                 flush_cache_page(vma, vaddr, page_to_pfn(page));\
>                 memcpy(dst, src, len);                          \
>         } while (0)
>  #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
>         do {                                                    \
>                 flush_cache_page(vma, vaddr, page_to_pfn(page));\
>                 memcpy(dst, src, len);                          \
>         } while (0)
>
> However, sparc32_cachetlb_ops isn't exported and hence the error.
>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Sorry for only noticing now. A similar fix for pa-risc was reverted:

"Christoph Hellwig <hch@infradead.org> commented:
 This one shouldn't go in - Geert sent it a bit prematurely, as Lustre
 shouldn't use it just to reimplement core VM functionality (which it
 shouldn't use either, but that's a separate story)."

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=a446e72bc15c7bfd2c953e56064ace3566c79b0e

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
