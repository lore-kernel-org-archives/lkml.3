Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077Ab3BOS50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 13:57:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18565 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3BOS5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 13:57:24 -0500
Date: Fri, 15 Feb 2013 13:56:44 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [PATCH] xen-blkfront: switch from llist to list
Message-ID: <20130215185644.GB29539@phenom.dumpdata.com>
References: <1360951381-26313-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1360951381-26313-1-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Should be backported to 3.8 stable.

Lets do one thing at a time.

The patch I have in the tree (and that I've asked Jens to pull for 3.9 - so
he might have already in his tree) is the old hybrid where we still use llist
but change the loop from 'for' to 'while'.

This is the stable/for-jens-3.8 tree in git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git 

Could you rebase your patch on top of that tree and just simplify the loop?

Sorry about the mess about this - but I had already pulled the trigger
so to say - hoping that Jens would pull the tree and do a git pull to Linus.

And you are absolutly sure that we don't need any extra locking when switching
over to list_head? Say if blkif_completion is called while we are
processing in blkif_queue_request and doing ?

> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> [Part of the description]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: xen-devel@lists.xen.org
> ---
>  drivers/block/xen-blkfront.c |   27 ++++++++++++++-------------
>  include/linux/llist.h        |   25 -------------------------
>  2 files changed, 14 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 11043c1..01b91a5 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -44,7 +44,7 @@
>  #include <linux/mutex.h>
>  #include <linux/scatterlist.h>
>  #include <linux/bitmap.h>
> -#include <linux/llist.h>
> +#include <linux/list.h>
>  
>  #include <xen/xen.h>
>  #include <xen/xenbus.h>
> @@ -68,7 +68,7 @@ enum blkif_state {
>  struct grant {
>  	grant_ref_t gref;
>  	unsigned long pfn;
> -	struct llist_node node;
> +	struct list_head node;
>  };
>  
>  struct blk_shadow {
> @@ -105,7 +105,7 @@ struct blkfront_info
>  	struct work_struct work;
>  	struct gnttab_free_callback callback;
>  	struct blk_shadow shadow[BLK_RING_SIZE];
> -	struct llist_head persistent_gnts;
> +	struct list_head persistent_gnts;
>  	unsigned int persistent_gnts_c;
>  	unsigned long shadow_free;
>  	unsigned int feature_flush;
> @@ -371,10 +371,11 @@ static int blkif_queue_request(struct request *req)
>  			lsect = fsect + (sg->length >> 9) - 1;
>  
>  			if (info->persistent_gnts_c) {
> -				BUG_ON(llist_empty(&info->persistent_gnts));
> -				gnt_list_entry = llist_entry(
> -					llist_del_first(&info->persistent_gnts),
> -					struct grant, node);
> +				BUG_ON(list_empty(&info->persistent_gnts));
> +				gnt_list_entry = list_first_entry(
> +				                      &info->persistent_gnts,
> +				                      struct grant, node);
> +				list_del(&gnt_list_entry->node);
>  
>  				ref = gnt_list_entry->gref;
>  				buffer_mfn = pfn_to_mfn(gnt_list_entry->pfn);
> @@ -790,9 +791,8 @@ static void blkif_restart_queue(struct work_struct *work)
>  
>  static void blkif_free(struct blkfront_info *info, int suspend)
>  {
> -	struct llist_node *all_gnts;
>  	struct grant *persistent_gnt;
> -	struct llist_node *n;
> +	struct grant *n;
>  
>  	/* Prevent new requests being issued until we fix things up. */
>  	spin_lock_irq(&info->io_lock);
> @@ -804,8 +804,9 @@ static void blkif_free(struct blkfront_info *info, int suspend)
>  
>  	/* Remove all persistent grants */
>  	if (info->persistent_gnts_c) {
> -		all_gnts = llist_del_all(&info->persistent_gnts);
> -		llist_for_each_entry_safe(persistent_gnt, n, all_gnts, node) {
> +		list_for_each_entry_safe(persistent_gnt, n,
> +		                         &info->persistent_gnts, node) {
> +			list_del(&persistent_gnt->node);
>  			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
>  			__free_page(pfn_to_page(persistent_gnt->pfn));
>  			kfree(persistent_gnt);
> @@ -868,7 +869,7 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
>  	}
>  	/* Add the persistent grant into the list of free grants */
>  	for (i = 0; i < s->req.u.rw.nr_segments; i++) {
> -		llist_add(&s->grants_used[i]->node, &info->persistent_gnts);
> +		list_add(&s->grants_used[i]->node, &info->persistent_gnts);
>  		info->persistent_gnts_c++;
>  	}
>  }
> @@ -1164,7 +1165,7 @@ static int blkfront_probe(struct xenbus_device *dev,
>  	spin_lock_init(&info->io_lock);
>  	info->xbdev = dev;
>  	info->vdevice = vdevice;
> -	init_llist_head(&info->persistent_gnts);
> +	INIT_LIST_HEAD(&info->persistent_gnts);
>  	info->persistent_gnts_c = 0;
>  	info->connected = BLKIF_STATE_DISCONNECTED;
>  	INIT_WORK(&info->work, blkif_restart_queue);
> diff --git a/include/linux/llist.h b/include/linux/llist.h
> index d0ab98f..a5199f6 100644
> --- a/include/linux/llist.h
> +++ b/include/linux/llist.h
> @@ -125,31 +125,6 @@ static inline void init_llist_head(struct llist_head *list)
>  	     (pos) = llist_entry((pos)->member.next, typeof(*(pos)), member))
>  
>  /**
> - * llist_for_each_entry_safe - iterate safely against remove over some entries
> - * of lock-less list of given type.
> - * @pos:	the type * to use as a loop cursor.
> - * @n:		another type * to use as a temporary storage.
> - * @node:	the fist entry of deleted list entries.
> - * @member:	the name of the llist_node with the struct.
> - *
> - * In general, some entries of the lock-less list can be traversed
> - * safely only after being removed from list, so start with an entry
> - * instead of list head. This variant allows removal of entries
> - * as we iterate.
> - *
> - * If being used on entries deleted from lock-less list directly, the
> - * traverse order is from the newest to the oldest added entry.  If
> - * you want to traverse from the oldest to the newest, you must
> - * reverse the order by yourself before traversing.
> - */
> -#define llist_for_each_entry_safe(pos, n, node, member)		\
> -	for ((pos) = llist_entry((node), typeof(*(pos)), member),	\
> -	     (n) = (pos)->member.next;					\
> -	     &(pos)->member != NULL;					\
> -	     (pos) = llist_entry(n, typeof(*(pos)), member),		\
> -	     (n) = (&(pos)->member != NULL) ? (pos)->member.next : NULL)
> -
> -/**
>   * llist_empty - tests whether a lock-less list is empty
>   * @head:	the list to test
>   *
> -- 
> 1.7.7.5 (Apple Git-26)
> 
