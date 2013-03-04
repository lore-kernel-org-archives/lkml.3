Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3CDTjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:39:13 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47341 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab3CDTjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:39:12 -0500
Date: Mon, 4 Mar 2013 14:39:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [PATCH RFC 04/12] xen-blkfront: pre-allocate pages for requests
Message-ID: <20130304193904.GI15386@phenom.dumpdata.com>
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
 <1362047335-26402-5-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1362047335-26402-5-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 11:28:47AM +0100, Roger Pau Monne wrote:
> This prevents us from having to call alloc_page while we are preparing
> the request. Since blkfront was calling alloc_page with a spinlock
> held we used GFP_ATOMIC, which can fail if we are requesting a lot of
> pages since it is using the emergency memory pools.
> 
> Allocating all the pages at init prevents us from having to call
> alloc_page, thus preventing possible failures.
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: xen-devel@lists.xen.org
> ---
>  drivers/block/xen-blkfront.c |  120 +++++++++++++++++++++++++++--------------
>  1 files changed, 79 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 2e39eaf..5ba6b87 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -165,6 +165,69 @@ static int add_id_to_freelist(struct blkfront_info *info,
>  	return 0;
>  }
>  
> +static int fill_grant_buffer(struct blkfront_info *info, int num)
> +{
> +	struct page *granted_page;
> +	struct grant *gnt_list_entry, *n;
> +	int i = 0;
> +
> +	while(i < num) {
> +		gnt_list_entry = kzalloc(sizeof(struct grant), GFP_NOIO);

GFP_NORMAL ?

> +		if (!gnt_list_entry)
> +			goto out_of_memory;

Hmm, I guess another patch could be to convert this to a fail-safe
mechanism. Meaning if we fail here, we just cap our maximum amount of
grants we have up to 'i'.


> +
> +		granted_page = alloc_page(GFP_NOIO);

GFP_NORMAL

> +		if (!granted_page) {
> +			kfree(gnt_list_entry);
> +			goto out_of_memory;
> +		}
> +
> +		gnt_list_entry->pfn = page_to_pfn(granted_page);
> +		gnt_list_entry->gref = GRANT_INVALID_REF;
> +		list_add(&gnt_list_entry->node, &info->persistent_gnts);
> +		i++;
> +	}
> +
> +	return 0;
> +
> +out_of_memory:
> +	list_for_each_entry_safe(gnt_list_entry, n,
> +	                         &info->persistent_gnts, node) {
> +		list_del(&gnt_list_entry->node);
> +		__free_page(pfn_to_page(gnt_list_entry->pfn));
> +		kfree(gnt_list_entry);
> +		i--;
> +	}
> +	BUG_ON(i != 0);
> +	return -ENOMEM;
> +}
> +
> +static struct grant *get_grant(grant_ref_t *gref_head,
> +                               struct blkfront_info *info)
> +{
> +	struct grant *gnt_list_entry;
> +	unsigned long buffer_mfn;
> +
> +	BUG_ON(list_empty(&info->persistent_gnts));
> +	gnt_list_entry = list_first_entry(&info->persistent_gnts, struct grant,
> +	                                  node);
> +	list_del(&gnt_list_entry->node);
> +
> +	if (gnt_list_entry->gref != GRANT_INVALID_REF) {
> +		info->persistent_gnts_c--;
> +		return gnt_list_entry;
> +	}
> +
> +	/* Assign a gref to this page */
> +	gnt_list_entry->gref = gnttab_claim_grant_reference(gref_head);
> +	BUG_ON(gnt_list_entry->gref == -ENOSPC);
> +	buffer_mfn = pfn_to_mfn(gnt_list_entry->pfn);
> +	gnttab_grant_foreign_access_ref(gnt_list_entry->gref,
> +	                                info->xbdev->otherend_id,
> +	                                buffer_mfn, 0);
> +	return gnt_list_entry;
> +}
> +
>  static const char *op_name(int op)
>  {
>  	static const char *const names[] = {
> @@ -306,7 +369,6 @@ static int blkif_queue_request(struct request *req)
>  	 */
>  	bool new_persistent_gnts;
>  	grant_ref_t gref_head;
> -	struct page *granted_page;
>  	struct grant *gnt_list_entry = NULL;
>  	struct scatterlist *sg;
>  
> @@ -370,42 +432,9 @@ static int blkif_queue_request(struct request *req)
>  			fsect = sg->offset >> 9;
>  			lsect = fsect + (sg->length >> 9) - 1;
>  
> -			if (info->persistent_gnts_c) {
> -				BUG_ON(list_empty(&info->persistent_gnts));
> -				gnt_list_entry = list_first_entry(
> -				                      &info->persistent_gnts,
> -				                      struct grant, node);
> -				list_del(&gnt_list_entry->node);
> -
> -				ref = gnt_list_entry->gref;
> -				buffer_mfn = pfn_to_mfn(gnt_list_entry->pfn);
> -				info->persistent_gnts_c--;
> -			} else {
> -				ref = gnttab_claim_grant_reference(&gref_head);
> -				BUG_ON(ref == -ENOSPC);
> -
> -				gnt_list_entry =
> -					kmalloc(sizeof(struct grant),
> -							 GFP_ATOMIC);
> -				if (!gnt_list_entry)
> -					return -ENOMEM;
> -
> -				granted_page = alloc_page(GFP_ATOMIC);
> -				if (!granted_page) {
> -					kfree(gnt_list_entry);
> -					return -ENOMEM;
> -				}
> -
> -				gnt_list_entry->pfn =
> -					page_to_pfn(granted_page);
> -				gnt_list_entry->gref = ref;
> -
> -				buffer_mfn = pfn_to_mfn(page_to_pfn(
> -								granted_page));
> -				gnttab_grant_foreign_access_ref(ref,
> -					info->xbdev->otherend_id,
> -					buffer_mfn, 0);
> -			}
> +			gnt_list_entry = get_grant(&gref_head, info);
> +			ref = gnt_list_entry->gref;
> +			buffer_mfn = pfn_to_mfn(gnt_list_entry->pfn);
>  
>  			info->shadow[id].grants_used[i] = gnt_list_entry;
>  
> @@ -803,17 +832,20 @@ static void blkif_free(struct blkfront_info *info, int suspend)
>  		blk_stop_queue(info->rq);
>  
>  	/* Remove all persistent grants */
> -	if (info->persistent_gnts_c) {
> +	if (!list_empty(&info->persistent_gnts)) {
>  		list_for_each_entry_safe(persistent_gnt, n,
>  		                         &info->persistent_gnts, node) {
>  			list_del(&persistent_gnt->node);
> -			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
> +			if (persistent_gnt->gref != GRANT_INVALID_REF) {
> +				gnttab_end_foreign_access(persistent_gnt->gref,
> +				                          0, 0UL);
> +				info->persistent_gnts_c--;
> +			}
>  			__free_page(pfn_to_page(persistent_gnt->pfn));
>  			kfree(persistent_gnt);
> -			info->persistent_gnts_c--;
>  		}
> -		BUG_ON(info->persistent_gnts_c != 0);
>  	}
> +	BUG_ON(info->persistent_gnts_c != 0);

So if the guest _never_ sent any I/Os and just attached/detached the device - won't
we fail here?.
>  
>  	/* No more gnttab callback work. */
>  	gnttab_cancel_free_callback(&info->callback);
> @@ -1088,6 +1120,12 @@ again:
>  		goto destroy_blkring;
>  	}
>  
> +	/* Allocate memory for grants */
> +	err = fill_grant_buffer(info, BLK_RING_SIZE *
> +	                              BLKIF_MAX_SEGMENTS_PER_REQUEST);
> +	if (err)
> +		goto out;

That looks to be in the wrong function - talk_to_blkback function is
to talk to the blkback. Not do initialization type operations.

Also I think this means that on resume - we would try to allocate
again the grants?
> +
>  	xenbus_switch_state(dev, XenbusStateInitialised);
>  
>  	return 0;
> -- 
> 1.7.7.5 (Apple Git-26)
> 
