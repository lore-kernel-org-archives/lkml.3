Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3CSMwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 08:52:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30036 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab3CSMv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 08:51:58 -0400
Date: Tue, 19 Mar 2013 08:51:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] xen-blkfront: switch from llist to list
Message-ID: <20130319125149.GA32432@phenom.dumpdata.com>
References: <1363625376-35612-1-git-send-email-roger.pau@citrix.com>
 <1363625376-35612-4-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1363625376-35612-4-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 05:49:34PM +0100, Roger Pau Monne wrote:
> Replace the use of llist with list.
> 
> llist_for_each_entry_safe can trigger a bug in GCC 4.1, so it's best
> to remove it and use a doubly linked list, which is used extensively
> in the kernel already.
> 
> Specifically this bug can be triggered by hot-unplugging a disk,
> either by doing xm block-detach or by save/restore cycle.
> 
> BUG: unable to handle kernel paging request at fffffffffffffff0
> IP: [<ffffffffa0047223>] blkif_free+0x63/0x130 [xen_blkfront]
> The crash call trace is:
> 	...
> bad_area_nosemaphore+0x13/0x20
> do_page_fault+0x25e/0x4b0
> page_fault+0x25/0x30
> ? blkif_free+0x63/0x130 [xen_blkfront]
> blkfront_resume+0x46/0xa0 [xen_blkfront]
> xenbus_dev_resume+0x6c/0x140
> pm_op+0x192/0x1b0
> device_resume+0x82/0x1e0
> dpm_resume+0xc9/0x1a0
> dpm_resume_end+0x15/0x30
> do_suspend+0x117/0x1e0
> 
> When drilling down to the assembler code, on newer GCC it does
> .L29:
>         cmpq    $-16, %r12      #, persistent_gnt check
>         je      .L30    	#, out of the loop
> .L25:
> 	... code in the loop
>         testq   %r13, %r13      # n
>         je      .L29    	#, back to the top of the loop
>         cmpq    $-16, %r12      #, persistent_gnt check
>         movq    16(%r12), %r13  # <variable>.node.next, n
>         jne     .L25    	#,	back to the top of the loop
> .L30:
> 
> While on GCC 4.1, it is:
> L78:
> 	... code in the loop
> 	testq   %r13, %r13      # n
>         je      .L78    #,	back to the top of the loop
>         movq    16(%rbx), %r13  # <variable>.node.next, n
>         jmp     .L78    #,	back to the top of the loop
> 
> Which basically means that the exit loop condition instead of
> being:
> 
> 	&(pos)->member != NULL;
> 
> is:
> 	;
> 
> which makes the loop unbound.
> 
> Since we always manipulate the list while holding the io_lock, there's
> no need for additional locking (llist used previously is safe to use
> concurrently without additional locking).
> 
> Should be backported to 3.8 stable.

I get
konrad@phenom:~/linux$ patch -p1 < /tmp/kk
patching file drivers/block/xen-blkfront.c
Hunk #1 FAILED at 44.
Hunk #2 FAILED at 68.
Hunk #3 FAILED at 105.
Hunk #4 FAILED at 371.
patch: **** malformed patch at line 172: ork)


and idea why? Could you resent the patch as an attachment please?

> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> [Part of the description]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: xen-devel@lists.xen.org
> ---
>  drivers/block/xen-blkfront.c |   41 ++++++++++++++++++-----------------------
>  1 files changed, 18 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 9620644..97324cd1 100644
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
> -	struct grant *persistent_gnt, *tmp;
> -	struct llist_node *n;
> +	struct grant *persistent_gnt;
> +	struct grant *n;
>  
>  	/* Prevent new requests being issued until we fix things up. */
>  	spin_lock_irq(&info->io_lock);
> @@ -804,20 +804,15 @@ static void blkif_free(struct blkfront_info *info, int suspend)
>  
>  	/* Remove all persistent grants */
>  	if (info->persistent_gnts_c) {
> -		all_gnts = llist_del_all(&info->persistent_gnts);
> -		persistent_gnt = llist_entry(all_gnts, typeof(*(persistent_gnt)), node);
> -		while (persistent_gnt) {
> +		list_for_each_entry_safe(persistent_gnt, n,
> +		                         &info->persistent_gnts, node) {
> +			list_del(&persistent_gnt->node);
>  			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
>  			__free_page(pfn_to_page(persistent_gnt->pfn));
> -			tmp = persistent_gnt;
> -			n = persistent_gnt->node.next;
> -			if (n)
> -				persistent_gnt = llist_entry(n, typeof(*(persistent_gnt)), node);
> -			else
> -				persistent_gnt = NULL;
> -			kfree(tmp);
> +			kfree(persistent_gnt);
> +			info->persistent_gnts_c--;
>  		}
> -		info->persistent_gnts_c = 0;
> +		BUG_ON(info->persistent_gnts_c != 0);
>  	}
>  
>  	/* No more gnttab callback work. */
> @@ -875,7 +870,7 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
>  	}
>  	/* Add the persistent grant into the list of free grants */
>  	for (i = 0; i < s->req.u.rw.nr_segments; i++) {
> -		llist_add(&s->grants_used[i]->node, &info->persistent_gnts);
> +		list_add(&s->grants_used[i]->node, &info->persistent_gnts);
>  		info->persistent_gnts_c++;
>  	}
>  }
> @@ -1171,7 +1166,7 @@ static int blkfront_probe(struct xenbus_device *dev,
>  	spin_lock_init(&info->io_lock);
>  	info->xbdev = dev;
>  	info->vdevice = vdevice;
> -	init_llist_head(&info->persistent_gnts);
> +	INIT_LIST_HEAD(&info->persistent_gnts);
>  	info->persistent_gnts_c = 0;
>  	info->connected = BLKIF_STATE_DISCONNECTED;
>  	INIT_WORK(&info->work, blkif_restart_queue);
> -- 
> 1.7.7.5 (Apple Git-26)
> 
