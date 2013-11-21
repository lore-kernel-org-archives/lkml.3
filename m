Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab3KUCw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 21:52:57 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:51056 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3KUCw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 21:52:56 -0500
MIME-Version: 1.0
In-Reply-To: <1384976824-32624-1-git-send-email-ddstreet@ieee.org>
References: <1384976824-32624-1-git-send-email-ddstreet@ieee.org>
Date: Thu, 21 Nov 2013 10:52:55 +0800
Message-ID: <CAL1ERfNNAZCS58K9mT85wxQfH8B3AyR4aLE8r745me1dJRmPfg@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: remove unneeded zswap_rb_erase calls
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

On Thu, Nov 21, 2013 at 3:47 AM, Dan Streetman <ddstreet@ieee.org> wrote:
> Since zswap_rb_erase was added to the final (when refcount == 0)
> zswap_put_entry, there is no need to call zswap_rb_erase before
> calling zswap_put_entry.
>
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
> ---
>  mm/zswap.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index e154f1e..f4fbbd5 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -711,8 +711,6 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
>                 ret = zswap_rb_insert(&tree->rbroot, entry, &dupentry);
>                 if (ret == -EEXIST) {
>                         zswap_duplicate_entry++;
> -                       /* remove from rbtree */
> -                       zswap_rb_erase(&tree->rbroot, dupentry);
>                         zswap_entry_put(tree, dupentry);
>                 }
>         } while (ret == -EEXIST);

If remove zswap_rb_erase, it would loop until free this dupentry. This
would cause 2 proplems:
1.  zswap_duplicate_entry counter is not correct
2. trigger BUG_ON in zswap_entry_put when this dupentry is being writeback,
   because zswap_writeback_entry will call zswap_entry_put either.

So, I don't think it is a good idea to remove zswap_rb_erase call.

> @@ -787,9 +785,6 @@ static void zswap_frontswap_invalidate_page(unsigned type, pgoff_t offset)
>                 return;
>         }
>
> -       /* remove from rbtree */
> -       zswap_rb_erase(&tree->rbroot, entry);
> -
>         /* drop the initial reference from entry creation */
>         zswap_entry_put(tree, entry);

I think it is better not to remove the zswap_rb_erase call.

>From frontswap interface view, if invalidate is called, the page(and
entry) should never visible to upper.
If remove the zswap_rb_erase call, it is not fit this semantic.

Consider the following scenario:
1. thread 0: entry A is being writeback
2. thread 1: invalidate entry A, as refcount != 0, it will still exist
on rbtree.
3. thread 1: reuse  entry A 's swp_entry_t, do a frontswap_store
   it will conflict with the  entry A on the rbtree, it is not a
normal duplicate store.

If we place the zswap_rb_erase call in zswap_frontswap_invalidate_page,
we can avoid the above scenario.

So, I don't think it is a good idea to remove zswap_rb_erase call.

Regards,

> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
