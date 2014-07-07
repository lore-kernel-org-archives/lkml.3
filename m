Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaGGWwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:52:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaGGWwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:52:53 -0400
Date: Mon, 7 Jul 2014 15:52:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gioh Kim <gioh.kim@lge.com>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonsoo Kim <js1304@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?=EC=9D=B4=EA=B1=B4=ED=98=B8?= <gunho.lee@lge.com>,
        Gi-Oh Kim <gurugio@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] [RFC] CMA: clear buffer-head lru before page migration
Message-Id: <20140707155252.15e81dff6683393ba3590478@linux-foundation.org>
In-Reply-To: <53B664E5.5060102@lge.com>
References: <53B664E5.5060102@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jul 2014 17:25:09 +0900 Gioh Kim <gioh.kim@lge.com> wrote:

> From: Gioh Kim <gioh.kim@lge.com>
> Date: Fri, 4 Jul 2014 16:53:22 +0900
> Subject: [PATCH] [RFC] CMA: clear buffer-head lru before page migration
> 
> When CMA try to migrate page, some buffer-heads can exist on lru.
> The bh on lru has non-zero count value so that it cannot be dropped
> even-if it is not used. We can drop only buffers related to the
> migrated page, but it can take long time more than dropping all
> because of searching list. There all buffers in lru are dropped.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> ---
>  fs/buffer.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index eba6e4f..4f11b7a 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3233,6 +3233,19 @@ int try_to_free_buffers(struct page *page)
>         if (PageWriteback(page))
>                 return 0;
> 
> +#ifdef CONFIG_CMA
> +       /*
> +        * When CMA try to migrate page, some buffer-heads can exist on lru.
> +        * The bh on lru has non-zero count value so that it cannot
> +        * be dropped even-if it is not used.
> +        * We can drop only buffers related to the migrated page,
> +        * but it can take long time more than dropping all
> +        * because of searching list.
> +        * There all buffers in lru are dropped first.
> +        */
> +       invalidate_bh_lrus();
> +#endif

No, this will be tremendously expensive.

What I proposed is that CMA call invalidate_bh_lrus() right at the
outset.  Something along the lines of

--- a/mm/page_alloc.c~a
+++ a/mm/page_alloc.c
@@ -6329,6 +6329,14 @@ int alloc_contig_range(unsigned long sta
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
 
+#ifdef CONFIG_CMA
+	/*
+	 * Comment goes here
+	 */
+	if (migratetype == MIGRATE_CMA)
+		invalidate_bh_lrus();
+#endif
+
 	/*
 	 * What we do here is we mark all pageblocks in range as
 	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may


- I'd have thought that it would make sense to do this for huge pages
  as well (MIGRATE_MOVABLE) but nobody really seems to know.

- There's a patch floating around ("Allow increasing the buffer-head
  per-CPU LRU size") which will double the size of the bh lrus, so this
  all becomes more important.

- alloc_contig_range() does lru_add_drain_all() and drain_all_pages()
  *after* performing the allocation.  I can't work out why this is the
  case and of course it is undocumented.  If this is indeed not a bug
  then probably the invalidate_bh_lrus() should happen in the same
  place.
