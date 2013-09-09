Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3IIRE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:04:56 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33746 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab3IIREz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:04:55 -0400
Date: Mon, 9 Sep 2013 12:03:49 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: minchan@kernel.org, bob.liu@oracle.com, weijie.yang.kh@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm/zswap: bugfix: memory leak when re-swapon
Message-ID: <20130909170349.GD4701@variantweb.net>
References: <000901ceaac0$a5f28420$f1d78c60$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000901ceaac0$a5f28420$f1d78c60$%yang@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090917-0320-0000-0000-000000EFAB77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 01:16:45PM +0800, Weijie Yang wrote:
> zswap_tree is not freed when swapoff, and it got re-kmalloc in swapon,
> so memory-leak occurs.
> 
> Modify: free memory of zswap_tree in zswap_frontswap_invalidate_area().
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
> ---
>  mm/zswap.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index deda2b6..cbd9578 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -816,6 +816,10 @@ static void zswap_frontswap_invalidate_area(unsigned type)
>  	}
>  	tree->rbroot = RB_ROOT;
>  	spin_unlock(&tree->lock);
> +
> +	zbud_destroy_pool(tree->pool);
> +	kfree(tree);
> +	zswap_trees[type] = NULL;

You changed how this works from v1.  Any particular reason?

In this version you free the tree structure, which is fine as long as we
know for sure nothing will try to access it afterward unless there is a
swapon to reactivate it.

I'm just a little worried about a race here between a store and
invalidate_area.  I think there is probably some mechanism to prevent
this, I just haven't been able to demonstrate it to myself.

The situation I'm worried about is:

shrink_page_list()
add_to_swap() then return (gets the swap entry)
try_to_unmap() then return (sets the swap entry in the pte)
pageout()
swap_writepage()
zswap_frontswap_store()

interacting with a swapoff operation.

When zswap_frontswap_store() is called, we continue to hold the page
lock.  I think that might block the loop in try_to_unuse(), called by
swapoff, until we release it after the store.

I think it should be fine.  Just wanted to think it through.

Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

>  }
> 
>  static struct zbud_ops zswap_zbud_ops = {
> -- 
> 1.7.10.4
> 
> 

