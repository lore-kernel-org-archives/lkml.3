Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3KUB7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 20:59:22 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:58980 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab3KUB7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 20:59:21 -0500
MIME-Version: 1.0
In-Reply-To: <1384976909-32671-1-git-send-email-ddstreet@ieee.org>
References: <1384976909-32671-1-git-send-email-ddstreet@ieee.org>
Date: Thu, 21 Nov 2013 09:59:20 +0800
Message-ID: <CAL1ERfPcAbNyt9hTYKMj9OGK2=ynLrTVm9udEn=hF+bFptC16Q@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: don't allow entry eviction if in use by load
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dan

On Thu, Nov 21, 2013 at 3:48 AM, Dan Streetman <ddstreet@ieee.org> wrote:
> The changes in commit 0ab0abcf511545d1fddbe72a36b3ca73388ac937
> introduce a bug in writeback, if an entry is in use by load
> it will be evicted anyway, which isn't correct (technically,
> the code currently in zbud doesn't actually care much what the
> zswap evict function returns, but that could change).

Thanks for your work. Howerver it is not a bug.

I have thought about this situation, and it will never happen.
If entry is being loaded, its corresponding page must be in swapcache
so zswap_get_swap_cache_page() will return ZSWAP_SWAPCACHE_EXIST

If I miss something, please let me know.

Thanks!

> This changes the check in the writeback function to prevent eviction
> if the entry is still in use (with a nonzero refcount).  The
> refcount is used instead of searching the rb tree beacuse we're
> holding the tree lock (which is required for any changes to refcount)
> and it's faster than a tree search.
>
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
> ---
>  mm/zswap.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index e55bab9..e154f1e 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -600,14 +600,18 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
>         zswap_entry_put(tree, entry);
>
>         /*
> -       * There are two possible situations for entry here:
> +       * There are three possible situations for entry here:
>         * (1) refcount is 1(normal case),  entry is valid and on the tree
>         * (2) refcount is 0, entry is freed and not on the tree
>         *     because invalidate happened during writeback
> -       *  search the tree and free the entry if find entry
> +       * (3) refcount is 2, entry is in use by load, prevent eviction
>         */
> -       if (entry == zswap_rb_search(&tree->rbroot, offset))
> +       if (likely(entry->refcount > 0))
>                 zswap_entry_put(tree, entry);
> +       if (unlikely(entry->refcount > 0)) {
> +               spin_unlock(&tree->lock);
> +               return -EAGAIN;
> +       }
>         spin_unlock(&tree->lock);
>
>         goto end;
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
