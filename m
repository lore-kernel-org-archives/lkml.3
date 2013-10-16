Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155Ab3JPIH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:07:56 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:58260 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3JPIHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:07:53 -0400
MIME-Version: 1.0
In-Reply-To: <1381428359-14843-20-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1381428359-14843-20-git-send-email-kirill.shutemov@linux.intel.com>
Date: Wed, 16 Oct 2013 10:07:52 +0200
X-Google-Sender-Auth: EsLcjf7NWSHAVrlNM5knFzZgQYc
Message-ID: <CAMuHMdUqQVphjUbvPg+47ZjFmS8WUK_70VMb43w4jaBOcGfNxA@mail.gmail.com>
Subject: Re: [PATCH 19/34] m68k: handle pgtable_page_ctor() fail
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Linux-Arch <linux-arch@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 8:05 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  arch/m68k/include/asm/motorola_pgalloc.h | 5 ++++-
>  arch/m68k/include/asm/sun3_pgalloc.h     | 5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/arch/m68k/include/asm/motorola_pgalloc.h b/arch/m68k/include/asm/motorola_pgalloc.h
> index 2f02f264e6..dd254eeb03 100644
> --- a/arch/m68k/include/asm/motorola_pgalloc.h
> +++ b/arch/m68k/include/asm/motorola_pgalloc.h
> @@ -40,7 +40,10 @@ static inline pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long addres
>         flush_tlb_kernel_page(pte);
>         nocache_page(pte);
        ^^^^^^^^^^^^^^^^^^
>         kunmap(page);
> -       pgtable_page_ctor(page);
> +       if (!pgtable_page_ctor(page)) {
> +               __free_page(page);

Shouldn't you mark the page cacheable again, like is done in pte_free()?

> +               return NULL;
> +       }
>         return page;
>  }
>
> diff --git a/arch/m68k/include/asm/sun3_pgalloc.h b/arch/m68k/include/asm/sun3_pgalloc.h
> index 48d80d5a66..f868506e33 100644
> --- a/arch/m68k/include/asm/sun3_pgalloc.h
> +++ b/arch/m68k/include/asm/sun3_pgalloc.h
> @@ -59,7 +59,10 @@ static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
>                 return NULL;
>
>         clear_highpage(page);
> -       pgtable_page_ctor(page);
> +       if (!pgtable_page_ctor(page)) {
> +               __free_page(page);
> +               return NULL;
> +       }
>         return page;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
