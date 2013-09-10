Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3IJAvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 20:51:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:29261 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755756Ab3IJAvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 20:51:38 -0400
X-IronPort-AV: E=Sophos;i="4.90,874,1371052800"; 
   d="scan'208";a="8466910"
Message-ID: <522E6BF9.4020408@cn.fujitsu.com>
Date: Tue, 10 Sep 2013 08:46:49 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-aio@kvack.org,
        linux-fsdevel@kvack.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH aio-next] aio: fix race in ring buffer page lookup introduced
 by page migration support
References: <20130909160253.GA11250@kvack.org>
In-Reply-To: <20130909160253.GA11250@kvack.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/10 08:49:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/10 08:49:16,
	Serialize complete at 2013/09/10 08:49:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben, Al,

On 09/10/2013 12:02 AM, Benjamin LaHaise wrote:

> Hi Al, Gu,
> 
> I've added this patch to my tree at git://git.kvack.org/~bcrl/aio-next.git 
> to fix the get_user_pages() issue introduced by Gu's changes in the page 
> migration patch.  Thanks Al for spotting this.

Thanks very much for spotting and fixing this issue.

Best regards,
Gu

> 
> 		-ben
> 
> commit d6c355c7dabcd753a75bc77d150d36328a355267
> Author: Benjamin LaHaise <bcrl@kvack.org>
> Date:   Mon Sep 9 11:57:59 2013 -0400
> 
>     aio: fix race in ring buffer page lookup introduced by page migration support
>     
>     Prior to the introduction of page migration support in "fs/aio: Add support
>     to aio ring pages migration" / 36bc08cc01709b4a9bb563b35aa530241ddc63e3,
>     mapping of the ring buffer pages was done via get_user_pages() while
>     retaining mmap_sem held for write.  This avoided possible races with userland
>     racing an munmap() or mremap().  The page migration patch, however, switched
>     to using mm_populate() to prime the page mapping.  mm_populate() cannot be
>     called with mmap_sem held.
>     
>     Instead of dropping the mmap_sem, revert to the old behaviour and simply
>     drop the use of mm_populate() since get_user_pages() will cause the pages to
>     get mapped anyways.  Thanks to Al Viro for spotting this issue.
>     
>     Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 6e26755..f4a27af 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -307,16 +307,25 @@ static int aio_setup_ring(struct kioctx *ctx)
>  		aio_free_ring(ctx);
>  		return -EAGAIN;
>  	}
> -	up_write(&mm->mmap_sem);
> -
> -	mm_populate(ctx->mmap_base, populate);
>  
>  	pr_debug("mmap address: 0x%08lx\n", ctx->mmap_base);
> +
> +	/* We must do this while still holding mmap_sem for write, as we
> +	 * need to be protected against userspace attempting to mremap()
> +	 * or munmap() the ring buffer.
> +	 */
>  	ctx->nr_pages = get_user_pages(current, mm, ctx->mmap_base, nr_pages,
>  				       1, 0, ctx->ring_pages, NULL);
> +
> +	/* Dropping the reference here is safe as the page cache will hold
> +	 * onto the pages for us.  It is also required so that page migration
> +	 * can unmap the pages and get the right reference count.
> +	 */
>  	for (i = 0; i < ctx->nr_pages; i++)
>  		put_page(ctx->ring_pages[i]);
>  
> +	up_write(&mm->mmap_sem);
> +
>  	if (unlikely(ctx->nr_pages != nr_pages)) {
>  		aio_free_ring(ctx);
>  		return -EAGAIN;


