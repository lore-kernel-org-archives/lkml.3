Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaBCQ7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:59:13 -0500
Received: from smtp.citrix.com ([66.165.176.89]:61984 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbaBCQ7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:59:12 -0500
X-IronPort-AV: E=Sophos;i="4.95,773,1384300800"; 
   d="scan'208";a="99292323"
Message-ID: <52EFCACF.6080604@citrix.com>
Date: Mon, 3 Feb 2014 17:58:55 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Matt Rushton <mrushton@amazon.com>, Matt Wilson <msw@amazon.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen-blkback: fix shutdown race
References: <1390931015-5490-1-git-send-email-roger.pau@citrix.com> <1390931015-5490-4-git-send-email-roger.pau@citrix.com> <52E8CF540200007800117D88@nat28.tlf.novell.com>
In-Reply-To: <52E8CF540200007800117D88@nat28.tlf.novell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/01/14 09:52, Jan Beulich wrote:
>>>> On 28.01.14 at 18:43, Roger Pau Monne <roger.pau@citrix.com> wrote:
>> --- a/drivers/block/xen-blkback/blkback.c
>> +++ b/drivers/block/xen-blkback/blkback.c
>> @@ -985,17 +985,31 @@ static void __end_block_io_op(struct pending_req 
>> *pending_req, int error)
>>  	 * the proper response on the ring.
>>  	 */
>>  	if (atomic_dec_and_test(&pending_req->pendcnt)) {
>> -		xen_blkbk_unmap(pending_req->blkif,
>> +		struct xen_blkif *blkif = pending_req->blkif;
>> +
>> +		xen_blkbk_unmap(blkif,
>>  		                pending_req->segments,
>>  		                pending_req->nr_pages);
>> -		make_response(pending_req->blkif, pending_req->id,
>> +		make_response(blkif, pending_req->id,
>>  			      pending_req->operation, pending_req->status);
>> -		xen_blkif_put(pending_req->blkif);
>> -		if (atomic_read(&pending_req->blkif->refcnt) <= 2) {
>> -			if (atomic_read(&pending_req->blkif->drain))
>> -				complete(&pending_req->blkif->drain_complete);
>> +		free_req(blkif, pending_req);
>> +		/*
>> +		 * Make sure the request is freed before releasing blkif,
>> +		 * or there could be a race between free_req and the
>> +		 * cleanup done in xen_blkif_free during shutdown.
>> +		 *
>> +		 * NB: The fact that we might try to wake up pending_free_wq
>> +		 * before drain_complete (in case there's a drain going on)
>> +		 * it's not a problem with our current implementation
>> +		 * because we can assure there's no thread waiting on
>> +		 * pending_free_wq if there's a drain going on, but it has
>> +		 * to be taken into account if the current model is changed.
>> +		 */
>> +		xen_blkif_put(blkif);
>> +		if (atomic_read(&blkif->refcnt) <= 2) {
>> +			if (atomic_read(&blkif->drain))
>> +				complete(&blkif->drain_complete);
>>  		}
>> -		free_req(pending_req->blkif, pending_req);
>>  	}
>>  }
> 
> The put is still too early imo - you're explicitly accessing field in the
> structure immediately afterwards. This may not be an issue at
> present, but I think it's at least a latent one.
> 
> Apart from that, the two if()s would - at least to me - be more
> clear if combined into one.

In order to get rid of the race I had to introduce yet another atomic_t 
in xen_blkif struct, which is something I don't really like, but I 
could not see any other way to solve this. If that's fine I will resend 
the series, here is the reworked patch:

---
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index dcfe49f..d9b8cd3 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -945,7 +945,7 @@ static void xen_blk_drain_io(struct xen_blkif *blkif)
 	do {
 		/* The initial value is one, and one refcnt taken at the
 		 * start of the xen_blkif_schedule thread. */
-		if (atomic_read(&blkif->refcnt) <= 2)
+		if (atomic_read(&blkif->inflight) == 0)
 			break;
 		wait_for_completion_interruptible_timeout(
 				&blkif->drain_complete, HZ);
@@ -985,17 +985,30 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
 	 * the proper response on the ring.
 	 */
 	if (atomic_dec_and_test(&pending_req->pendcnt)) {
-		xen_blkbk_unmap(pending_req->blkif,
+		struct xen_blkif *blkif = pending_req->blkif;
+
+		xen_blkbk_unmap(blkif,
 		                pending_req->segments,
 		                pending_req->nr_pages);
-		make_response(pending_req->blkif, pending_req->id,
+		make_response(blkif, pending_req->id,
 			      pending_req->operation, pending_req->status);
-		xen_blkif_put(pending_req->blkif);
-		if (atomic_read(&pending_req->blkif->refcnt) <= 2) {
-			if (atomic_read(&pending_req->blkif->drain))
-				complete(&pending_req->blkif->drain_complete);
+		free_req(blkif, pending_req);
+		/*
+		 * Make sure the request is freed before releasing blkif,
+		 * or there could be a race between free_req and the
+		 * cleanup done in xen_blkif_free during shutdown.
+		 *
+		 * NB: The fact that we might try to wake up pending_free_wq
+		 * before drain_complete (in case there's a drain going on)
+		 * it's not a problem with our current implementation
+		 * because we can assure there's no thread waiting on
+		 * pending_free_wq if there's a drain going on, but it has
+		 * to be taken into account if the current model is changed.
+		 */
+		if (atomic_dec_and_test(&blkif->inflight) && atomic_read(&blkif->drain)) {
+			complete(&blkif->drain_complete);
 		}
-		free_req(pending_req->blkif, pending_req);
+		xen_blkif_put(blkif);
 	}
 }
 
@@ -1249,6 +1262,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	 * below (in "!bio") if we are handling a BLKIF_OP_DISCARD.
 	 */
 	xen_blkif_get(blkif);
+	atomic_inc(&blkif->inflight);
 
 	for (i = 0; i < nseg; i++) {
 		while ((bio == NULL) ||
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index f733d76..e40326a 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -278,6 +278,7 @@ struct xen_blkif {
 	/* for barrier (drain) requests */
 	struct completion	drain_complete;
 	atomic_t		drain;
+	atomic_t		inflight;
 	/* One thread per one blkif. */
 	struct task_struct	*xenblkd;
 	unsigned int		waiting_reqs;
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 8afef67..84973c6 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -128,6 +128,7 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	INIT_LIST_HEAD(&blkif->persistent_purge_list);
 	blkif->free_pages_num = 0;
 	atomic_set(&blkif->persistent_gnt_in_use, 0);
+	atomic_set(&blkif->inflight, 0);
 
 	INIT_LIST_HEAD(&blkif->pending_free);
 


