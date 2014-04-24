Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbaDXQkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:40:49 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:54889 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758462AbaDXQkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:40:47 -0400
MIME-Version: 1.0
X-Originating-IP: [217.156.156.35]
In-Reply-To: <1397805849-4913-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1397805849-4913-1-git-send-email-iamjoonsoo.kim@lge.com>
Date: Thu, 24 Apr 2014 17:40:46 +0100
X-Google-Sender-Auth: m4qhbBCKfRHuqhDll7pVXqrL1A0
Message-ID: <CAAG0J9-8WbO48jXpUfOq6CmHinL9dMg5Ee9-J9qndBEtZgWYJg@mail.gmail.com>
Subject: Re: [PATCH] slab: fix the type of the index on freelist index accessor
From: James Hogan <james.hogan@imgtec.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        David Rientjes <rientjes@google.com>, Steven King <sfking@fdwdc.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 April 2014 08:24, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> commit 8dcc774 (slab: introduce byte sized index for the freelist of
> a slab) changes the size of freelist index and also changes prototype
> of accessor function to freelist index. And there was a mistake.
>
> The mistake is that although it changes the size of freelist index
> correctly, it changes the size of the index of freelist index incorrectly.
> With patch, freelist index can be 1 byte or 2 bytes, that means that
> num of object on on a slab can be more than 255. So we need more than 1
> byte for the index to find the index of free object on freelist. But,
> above patch makes this index type 1 byte, so slab which have more than
> 255 objects cannot work properly and in consequence of it, the system
> cannot boot.
>
> This issue was reported by Steven King on m68knommu which would use
> 2 bytes freelist index. Please refer following link.
>
> https://lkml.org/lkml/2014/4/16/433
>
> To fix it is so easy. To change the type of the index of freelist index
> on accessor functions is enough to fix this bug. Although 2 bytes is
> enough, I use 4 bytes since it have no bad effect and make things
> more easier. This fix was suggested and tested by Steven in his
> original report.
>
> Reported-by: Steven King <sfking@fdwdc.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

I also hit this problem on MIPS with v3.15-rc2 and 16K pages. With
this patch it boots fine.

Tested-by: James Hogan <james.hogan@imgtec.com>

Thanks
James

> ---
> Hello, Pekka.
>
> Could you send this for v3.15-rc2?
> Without this patch, many architecture using 2 bytes freelist index cannot
> work properly, I guess.
>
> This patch is based on v3.15-rc1.
>
> Thanks.
>
> diff --git a/mm/slab.c b/mm/slab.c
> index 388cb1a..d7f9f44 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2572,13 +2572,13 @@ static void *alloc_slabmgmt(struct kmem_cache *cachep,
>         return freelist;
>  }
>
> -static inline freelist_idx_t get_free_obj(struct page *page, unsigned char idx)
> +static inline freelist_idx_t get_free_obj(struct page *page, unsigned int idx)
>  {
>         return ((freelist_idx_t *)page->freelist)[idx];
>  }
>
>  static inline void set_free_obj(struct page *page,
> -                                       unsigned char idx, freelist_idx_t val)
> +                                       unsigned int idx, freelist_idx_t val)
>  {
>         ((freelist_idx_t *)(page->freelist))[idx] = val;
>  }
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
