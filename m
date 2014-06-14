Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaFNKRA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 06:17:00 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:33971 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaFNKQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 06:16:57 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2 06/10] CMA: generalize CMA reserved area management functionality
In-Reply-To: <1402543307-29800-7-git-send-email-iamjoonsoo.kim@lge.com>
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <1402543307-29800-7-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.18~rc0+2~gbc64cdc (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Sat, 14 Jun 2014 15:46:44 +0530
Message-ID: <87a99fg5ir.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061410-7014-0000-0000-0000051293A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> Currently, there are two users on CMA functionality, one is the DMA
> subsystem and the other is the kvm on powerpc. They have their own code
> to manage CMA reserved area even if they looks really similar.
> From my guess, it is caused by some needs on bitmap management. Kvm side
> wants to maintain bitmap not for 1 page, but for more size. Eventually it
> use bitmap where one bit represents 64 pages.
>
> When I implement CMA related patches, I should change those two places
> to apply my change and it seem to be painful to me. I want to change
> this situation and reduce future code management overhead through
> this patch.
>
> This change could also help developer who want to use CMA in their
> new feature development, since they can use CMA easily without
> copying & pasting this reserved area management code.
>
> In previous patches, we have prepared some features to generalize
> CMA reserved area management and now it's time to do it. This patch
> moves core functions to mm/cma.c and change DMA APIs to use
> these functions.
>
> There is no functional change in DMA APIs.
>
> v2: There is no big change from v1 in mm/cma.c. Mostly renaming.
>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>

.....

> +
> +	mask = cma_bitmap_aligned_mask(cma, align);
> +	bitmap_maxno = cma_bitmap_maxno(cma);
> +	nr_bits = cma_bitmap_pages_to_bits(cma, count);
> +
> +	for (;;) {
> +		mutex_lock(&cma->lock);
> +		bitmapno = bitmap_find_next_zero_area(cma->bitmap,
> +					bitmap_maxno, start, nr_bits, mask);
> +		if (bitmapno >= bitmap_maxno) {
> +			mutex_unlock(&cma->lock);
> +			break;
> +		}
> +		bitmap_set(cma->bitmap, bitmapno, nr_bits);
> +		/*
> +		 * It's safe to drop the lock here. We've marked this region for
> +		 * our exclusive use. If the migration fails we will take the
> +		 * lock again and unmark it.
> +		 */
> +		mutex_unlock(&cma->lock);
> +
> +		pfn = cma->base_pfn + (bitmapno << cma->order_per_bit);
> +		mutex_lock(&cma_mutex);
> +		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA);
> +		mutex_unlock(&cma_mutex);
> +		if (ret == 0) {
> +			page = pfn_to_page(pfn);
> +			break;
> +		} else if (ret != -EBUSY) {
> +			clear_cma_bitmap(cma, pfn, count);
> +			break;
> +		}
> +		


For setting bit map we do
		bitmap_set(cma->bitmap, bitmapno, nr_bits);
                alloc_contig()..
                if (error)
                        clear_cma_bitmap(cma, pfn, count);

Why ?

why not bitmap_clear() ?

-aneesh

