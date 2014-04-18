Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaDROky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 10:40:54 -0400
Received: from smtp106.biz.mail.gq1.yahoo.com ([98.137.12.181]:36941 "HELO
	smtp106.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751314AbaDROkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 10:40:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Z.gvIZQVM1ncNRQDbUv6KzTfPlm9iQHTu1zYuXdyD02yjLg
 PmbO5Vuwf2PXt0WhLWfAGyb2llM9IQots2MSLERKHi1fJX6Xp0HxIMKHQ.7u
 NIXSAda3Xyptt7YqItilOp.LfDjEo_3jEtEbPDVNreqz.dN4T.tHdfUl981H
 iMjVCsQWvqzcE4oSM7apUdrUJquH4DzsTFD0.X7qDJ5.dIzp4KrumBdcVSke
 VY.GzqarZEHGsj.i_iH_UAcbswRx1uu7f4u6FkfprvBtdmlhj5PLL.xEZUx1
 7WjhrTAbwO3ky9Q.qgn0eaBZB5c06sTNjkTr3ZsnpleZyK_fOYxm3ljY6nXB
 qE9gb34CJMyB5fMFMch_L2tu.PYAyqxyWctzOeAHUZRtBHNhUL9AYf9KNYog
 cQ.QShSn6MXd1w8KpSMmI4TCk6GlEBcns5JOuIR84ARa1lHKsBly2K5mQIO4
 .KViTdRWZ5IAEGDekWhzHBOvYi00ys.ilpDIWjgAkKiXIcHE.wHsAi_gkVH7
 VDkYCXZ8GwpvWWdqAcUD1gdV82v1yHoTR8k26O516JqsNAFvkGigYSuRIQ17
 BIDT1jxxiATlG0ADeqayRQVTH6_avPZbJ8Zr6EwyM
X-Yahoo-SMTP: qGLgp.mswBDSnFfWmYVMF5Rmg6NJ
X-Rocket-Received: from fdwdc.com (sfking@67.139.206.186 with plain [208.71.40.208])
        by smtp106.biz.mail.gq1.yahoo.com with SMTP; 18 Apr 2014 14:40:50 +0000 UTC
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH] slab: fix the type of the index on freelist index accessor
Date: Fri, 18 Apr 2014 07:40:47 -0700
User-Agent: KMail/1.9.9
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <1397805849-4913-1-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1397805849-4913-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201404180740.48445.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 April 2014 12:24:09 am Joonsoo Kim wrote:
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
> @@ -2572,13 +2572,13 @@ static void *alloc_slabmgmt(struct kmem_cache
> *cachep, return freelist;
>  }
>
> -static inline freelist_idx_t get_free_obj(struct page *page, unsigned char
> idx) +static inline freelist_idx_t get_free_obj(struct page *page, unsigned
> int idx) {
>  	return ((freelist_idx_t *)page->freelist)[idx];
>  }
>
>  static inline void set_free_obj(struct page *page,
> -					unsigned char idx, freelist_idx_t val)
> +					unsigned int idx, freelist_idx_t val)
>  {
>  	((freelist_idx_t *)(page->freelist))[idx] = val;
>  }

Acked-by: Steven King <sfking@fdwdc.com>
