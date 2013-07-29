Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab3G3PXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:23:48 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:55518 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab3G3PXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:23:46 -0400
Date: Mon, 29 Jul 2013 10:08:05 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 5/5] mm/zswap: use postorder iteration when destroying
 rbtree
Message-ID: <20130729150805.GC4381@variantweb.net>
References: <1374873223-25557-1-git-send-email-cody@linux.vnet.ibm.com>
 <1374873223-25557-6-git-send-email-cody@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374873223-25557-6-git-send-email-cody@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073015-1618-0000-0000-0000045EB44B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 02:13:43PM -0700, Cody P Schafer wrote:
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  mm/zswap.c | 15 ++-------------
>  1 file changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index deda2b6..98d99c4 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -791,25 +791,14 @@ static void zswap_frontswap_invalidate_area(unsigned type)
>  {
>  	struct zswap_tree *tree = zswap_trees[type];
>  	struct rb_node *node;

Getting used variable warning on this now.  Just need to remove it.

Seth

> -	struct zswap_entry *entry;
> +	struct zswap_entry *entry, *n;
> 
>  	if (!tree)
>  		return;
> 
>  	/* walk the tree and free everything */
>  	spin_lock(&tree->lock);
> -	/*
> -	 * TODO: Even though this code should not be executed because
> -	 * the try_to_unuse() in swapoff should have emptied the tree,
> -	 * it is very wasteful to rebalance the tree after every
> -	 * removal when we are freeing the whole tree.
> -	 *
> -	 * If post-order traversal code is ever added to the rbtree
> -	 * implementation, it should be used here.
> -	 */
> -	while ((node = rb_first(&tree->rbroot))) {
> -		entry = rb_entry(node, struct zswap_entry, rbnode);
> -		rb_erase(&entry->rbnode, &tree->rbroot);
> +	rbtree_postorder_for_each_entry_safe(entry, n, &tree->rbroot, rbnode) {
>  		zbud_free(tree->pool, entry->handle);
>  		zswap_entry_cache_free(entry);
>  		atomic_dec(&zswap_stored_pages);
> -- 
> 1.8.3.4
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

