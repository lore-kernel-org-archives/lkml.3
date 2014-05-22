Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaEVMyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:54:15 -0400
Received: from smtp.citrix.com ([66.165.176.89]:25228 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbaEVMyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:54:13 -0400
X-IronPort-AV: E=Sophos;i="4.98,887,1392163200"; 
   d="scan'208,223";a="134544216"
Message-ID: <537DF36F.5070909@citrix.com>
Date: Thu, 22 May 2014 14:54:07 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>, <felipe.franciosi@citrix.com>,
        <jerry.snitselaar@oracle.com>, <axboe@kernel.dk>
Subject: Re: Backport request to stable of two performance related fixes for
 xen-blkfront (3.13 fixes to earlier trees)
References: <20140514191122.GA7659@phenom.dumpdata.com> <20140520031938.GA30126@kroah.com>
In-Reply-To: <20140520031938.GA30126@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/mixed;
	boundary="------------070401020106050100000006"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------070401020106050100000006
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 20/05/14 05:19, Greg KH wrote:
> On Wed, May 14, 2014 at 03:11:22PM -0400, Konrad Rzeszutek Wilk wrote:
>> Hey Greg
>>
>> This email is in regards to backporting two patches to stable that
>> fall under the 'performance' rule:
>>
>>  bfe11d6de1c416cea4f3f0f35f864162063ce3fa
>>  fbe363c476afe8ec992d3baf682670a4bd1b6ce6
>>
>> I've copied Jerry - the maintainer of the Oracle's kernel. I don't have
>> the emails of the other distros maintainers but the bugs associated with it are:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=1096909
>> (RHEL7)
>> https://bugs.launchpad.net/ubuntu/+bug/1319003
>> (Ubuntu 13.10)
>>
>> The following distros are affected:
>>
>> (x) Ubuntu 13.04 and derivatives (3.8)
>> (v) Ubuntu 13.10 and derivatives (3.11), supported until 2014-07
>> (x) Fedora 17 (3.8 and 3.9 in updates)
>> (x) Fedora 18 (3.8, 3.9, 3.10, 3.11 in updates)
>> (v) Fedora 19 (3.9; 3.10, 3.11, 3.12 in updates; fixed with latest update to 3.13), supported until TBA
>> (v) Fedora 20 (3.11; 3.12 in updates; fixed with latest update to 3.13), supported until TBA
>> (v) RHEL 7 and derivatives (3.10), expected to be supported until about 2025
>> (v) openSUSE 13.1 (3.11), expected to be supported until at least 2016-08
>> (v) SLES 12 (3.12), expected to be supported until about 2024
>> (v) Mageia 3 (3.8), supported until 2014-11-19
>> (v) Mageia 4 (3.12), supported until 2015-08-01
>> (v) Oracle Enterprise Linux with Unbreakable Enterprise Kernel Release 3 (3.8), supported until TBA
>>
>> Here is the analysis of the problem and what was put in the RHEL7 bug.
>> The Oracle bug does not exist (as I just backport them in the kernel and
>> send a GIT PULL to Jerry) - but if you would like I can certainly furnish
>> you with one (it would be identical to what is mentioned below).
>>
>> If you are OK with the backport, I am volunteering Roger and Felipe to assist
>> in jamming^H^H^H^Hbackporting the patches into earlier kernels.
> 
> Sure, can you provide backported patches?  As-is, they don't apply to
> the 3.10-stable kernel.

Here are the backported patches to 3.10 stable, I would like however to
get some testing/benchmarking on them before applying, since it's not a
trivial backport. Could you please give them a spin Felipe?

Roger.


--------------070401020106050100000006
Content-Type: text/plain; charset="UTF-8"; x-mac-type=0; x-mac-creator=0;
	name="0001-backport-of-fbe363-to-stable-3.10.y-branch.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
	filename="0001-backport-of-fbe363-to-stable-3.10.y-branch.patch"

>From 8db2b1bff4b54dc01592f9e14b9dae32c341f435 Mon Sep 17 00:00:00 2001
From: Roger Pau Monne <roger.pau@citrix.com>
Date: Wed, 21 May 2014 16:51:47 +0200
Subject: [PATCH 1/2] backport of fbe363 to stable 3.10.y branch
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

xen-blkfront: revoke foreign access for grants not mapped by the backend

There's no need to keep the foreign access in a grant if it is not
persistently mapped by the backend. This allows us to free grants that
are not mapped by the backend, thus preventing blkfront from hoarding
all grants.

The main effect of this is that blkfront will only persistently map
the same grants as the backend, and it will always try to use grants
that are already mapped by the backend. Also the number of persistent
grants in blkfront is the same as in blkback (and is controlled by the
value in blkback).

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Acked-by: Matt Wilson <msw@amazon.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/xen-blkfront.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 1735b0d..cbd9f6b 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -894,9 +894,27 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 		}
 	}
 	/* Add the persistent grant into the list of free grants */
-	for (i = 0; i < s->req.u.rw.nr_segments; i++) {
-		list_add(&s->grants_used[i]->node, &info->persistent_gnts);
-		info->persistent_gnts_c++;
+	for (i = 0; i < nseg; i++) {
+		if (gnttab_query_foreign_access(s->grants_used[i]->gref)) {
+			/*
+			 * If the grant is still mapped by the backend (the
+			 * backend has chosen to make this grant persistent)
+			 * we add it at the head of the list, so it will be
+			 * reused first.
+			 */
+			list_add(&s->grants_used[i]->node, &info->persistent_gnts);
+			info->persistent_gnts_c++;
+		} else {
+			/*
+			 * If the grant is not mapped by the backend we end the
+			 * foreign access and add it to the tail of the list,
+			 * so it will not be picked again unless we run out of
+			 * persistent grants.
+			 */
+			gnttab_end_foreign_access(s->grants_used[i]->gref, 0, 0UL);
+			s->grants_used[i]->gref = GRANT_INVALID_REF;
+			list_add_tail(&s->grants_used[i]->node, &info->persistent_gnts);
+		}
 	}
 }
 
-- 
1.7.7.5 (Apple Git-26)


--------------070401020106050100000006
Content-Type: text/plain; charset="UTF-8"; x-mac-type=0; x-mac-creator=0;
	name="0002-backport-of-bfe11d-to-stable-3.10.y-branch.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
	filename="0002-backport-of-bfe11d-to-stable-3.10.y-branch.patch"

>From 0cb3ce2b6838aa9a28b81dacf497a4ae11610826 Mon Sep 17 00:00:00 2001
From: Roger Pau Monne <roger.pau@citrix.com>
Date: Wed, 21 May 2014 16:57:58 +0200
Subject: [PATCH 2/2] backport of bfe11d to stable 3.10.y branch
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

xen-blkfront: restore the non-persistent data path

When persistent grants were added they were always used, even if the
backend doesn't have this feature (there's no harm in always using the
same set of pages). This restores the old data path when the backend
doesn't have persistent grants, removing the burden of doing a memcpy
when it is not actually needed.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reported-by: Felipe Franciosi <felipe.franciosi@citrix.com>
Cc: Felipe Franciosi <felipe.franciosi@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[v2: Fix up whitespace issues]
---
 drivers/block/xen-blkfront.c |  105 +++++++++++++++++++++++++++++------------
 1 files changed, 74 insertions(+), 31 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index cbd9f6b..ddd9a09 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -104,7 +104,7 @@ struct blkfront_info
 	struct work_struct work;
 	struct gnttab_free_callback callback;
 	struct blk_shadow shadow[BLK_RING_SIZE];
-	struct list_head persistent_gnts;
+	struct list_head grants;
 	unsigned int persistent_gnts_c;
 	unsigned long shadow_free;
 	unsigned int feature_flush;
@@ -175,15 +175,17 @@ static int fill_grant_buffer(struct blkfront_info *info, int num)
 		if (!gnt_list_entry)
 			goto out_of_memory;
 
-		granted_page = alloc_page(GFP_NOIO);
-		if (!granted_page) {
-			kfree(gnt_list_entry);
-			goto out_of_memory;
+		if (info->feature_persistent) {
+			granted_page = alloc_page(GFP_NOIO);
+			if (!granted_page) {
+				kfree(gnt_list_entry);
+				goto out_of_memory;
+			}
+			gnt_list_entry->pfn = page_to_pfn(granted_page);
 		}
 
-		gnt_list_entry->pfn = page_to_pfn(granted_page);
 		gnt_list_entry->gref = GRANT_INVALID_REF;
-		list_add(&gnt_list_entry->node, &info->persistent_gnts);
+		list_add(&gnt_list_entry->node, &info->grants);
 		i++;
 	}
 
@@ -191,9 +193,10 @@ static int fill_grant_buffer(struct blkfront_info *info, int num)
 
 out_of_memory:
 	list_for_each_entry_safe(gnt_list_entry, n,
-	                         &info->persistent_gnts, node) {
+	                         &info->grants, node) {
 		list_del(&gnt_list_entry->node);
-		__free_page(pfn_to_page(gnt_list_entry->pfn));
+		if (info->feature_persistent)
+			__free_page(pfn_to_page(gnt_list_entry->pfn));
 		kfree(gnt_list_entry);
 		i--;
 	}
@@ -202,14 +205,14 @@ out_of_memory:
 }
 
 static struct grant *get_grant(grant_ref_t *gref_head,
+                               unsigned long pfn,
                                struct blkfront_info *info)
 {
 	struct grant *gnt_list_entry;
 	unsigned long buffer_mfn;
 
-	BUG_ON(list_empty(&info->persistent_gnts));
-	gnt_list_entry = list_first_entry(&info->persistent_gnts, struct grant,
-	                                  node);
+	BUG_ON(list_empty(&info->grants));
+	gnt_list_entry = list_first_entry(&info->grants, struct grant, node);
 	list_del(&gnt_list_entry->node);
 
 	if (gnt_list_entry->gref != GRANT_INVALID_REF) {
@@ -220,6 +223,10 @@ static struct grant *get_grant(grant_ref_t *gref_head,
 	/* Assign a gref to this page */
 	gnt_list_entry->gref = gnttab_claim_grant_reference(gref_head);
 	BUG_ON(gnt_list_entry->gref == -ENOSPC);
+	if (!info->feature_persistent) {
+		BUG_ON(!pfn);
+		gnt_list_entry->pfn = pfn;
+	}
 	buffer_mfn = pfn_to_mfn(gnt_list_entry->pfn);
 	gnttab_grant_foreign_access_ref(gnt_list_entry->gref,
 	                                info->xbdev->otherend_id,
@@ -430,12 +437,12 @@ static int blkif_queue_request(struct request *req)
 			fsect = sg->offset >> 9;
 			lsect = fsect + (sg->length >> 9) - 1;
 
-			gnt_list_entry = get_grant(&gref_head, info);
+			gnt_list_entry = get_grant(&gref_head, page_to_pfn(sg_page(sg)), info);
 			ref = gnt_list_entry->gref;
 
 			info->shadow[id].grants_used[i] = gnt_list_entry;
 
-			if (rq_data_dir(req)) {
+			if (rq_data_dir(req) && info->feature_persistent) {
 				char *bvec_data;
 				void *shared_data;
 
@@ -828,16 +835,17 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 		blk_stop_queue(info->rq);
 
 	/* Remove all persistent grants */
-	if (!list_empty(&info->persistent_gnts)) {
+	if (!list_empty(&info->grants)) {
 		list_for_each_entry_safe(persistent_gnt, n,
-		                         &info->persistent_gnts, node) {
+		                         &info->grants, node) {
 			list_del(&persistent_gnt->node);
 			if (persistent_gnt->gref != GRANT_INVALID_REF) {
 				gnttab_end_foreign_access(persistent_gnt->gref,
 				                          0, 0UL);
 				info->persistent_gnts_c--;
 			}
-			__free_page(pfn_to_page(persistent_gnt->pfn));
+			if (info->feature_persistent)
+				__free_page(pfn_to_page(persistent_gnt->pfn));
 			kfree(persistent_gnt);
 		}
 	}
@@ -874,7 +882,7 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 
 	nseg = s->req.u.rw.nr_segments;
 
-	if (bret->operation == BLKIF_OP_READ) {
+	if (bret->operation == BLKIF_OP_READ && info->feature_persistent) {
 		/*
 		 * Copy the data received from the backend into the bvec.
 		 * Since bv_offset can be different than 0, and bv_len different
@@ -902,7 +910,10 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 			 * we add it at the head of the list, so it will be
 			 * reused first.
 			 */
-			list_add(&s->grants_used[i]->node, &info->persistent_gnts);
+			if (!info->feature_persistent)
+				pr_alert_ratelimited("backed has not unmapped grant: %u\n",
+						     s->grants_used[i]->gref);
+			list_add(&s->grants_used[i]->node, &info->grants);
 			info->persistent_gnts_c++;
 		} else {
 			/*
@@ -913,7 +924,7 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 			 */
 			gnttab_end_foreign_access(s->grants_used[i]->gref, 0, 0UL);
 			s->grants_used[i]->gref = GRANT_INVALID_REF;
-			list_add_tail(&s->grants_used[i]->node, &info->persistent_gnts);
+			list_add_tail(&s->grants_used[i]->node, &info->grants);
 		}
 	}
 }
@@ -1052,12 +1063,6 @@ static int setup_blkring(struct xenbus_device *dev,
 	for (i = 0; i < BLK_RING_SIZE; i++)
 		sg_init_table(info->shadow[i].sg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
 
-	/* Allocate memory for grants */
-	err = fill_grant_buffer(info, BLK_RING_SIZE *
-	                              BLKIF_MAX_SEGMENTS_PER_REQUEST);
-	if (err)
-		goto fail;
-
 	err = xenbus_grant_ring(dev, virt_to_mfn(info->ring.sring));
 	if (err < 0) {
 		free_page((unsigned long)sring);
@@ -1216,7 +1221,7 @@ static int blkfront_probe(struct xenbus_device *dev,
 	spin_lock_init(&info->io_lock);
 	info->xbdev = dev;
 	info->vdevice = vdevice;
-	INIT_LIST_HEAD(&info->persistent_gnts);
+	INIT_LIST_HEAD(&info->grants);
 	info->persistent_gnts_c = 0;
 	info->connected = BLKIF_STATE_DISCONNECTED;
 	INIT_WORK(&info->work, blkif_restart_queue);
@@ -1245,7 +1250,8 @@ static int blkif_recover(struct blkfront_info *info)
 	int i;
 	struct blkif_request *req;
 	struct blk_shadow *copy;
-	int j;
+	unsigned int persistent;
+	int j, rc;
 
 	/* Stage 1: Make a safe copy of the shadow state. */
 	copy = kmemdup(info->shadow, sizeof(info->shadow),
@@ -1260,6 +1266,24 @@ static int blkif_recover(struct blkfront_info *info)
 	info->shadow_free = info->ring.req_prod_pvt;
 	info->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
 
+	/* Check if the backend supports persistent grants */
+	rc = xenbus_gather(XBT_NIL, info->xbdev->otherend,
+			   "feature-persistent", "%u", &persistent,
+			   NULL);
+	if (rc)
+		info->feature_persistent = 0;
+	else
+		info->feature_persistent = persistent;
+
+	/* Allocate memory for grants */
+	rc = fill_grant_buffer(info, BLK_RING_SIZE *
+	                             BLKIF_MAX_SEGMENTS_PER_REQUEST);
+	if (rc) {
+		xenbus_dev_fatal(info->xbdev, rc, "setting grant buffer failed");
+		kfree(copy);
+		return rc;
+	}
+
 	/* Stage 3: Find pending requests and requeue them. */
 	for (i = 0; i < BLK_RING_SIZE; i++) {
 		/* Not in use? */
@@ -1324,8 +1348,12 @@ static int blkfront_resume(struct xenbus_device *dev)
 	blkif_free(info, info->connected == BLKIF_STATE_CONNECTED);
 
 	err = talk_to_blkback(dev, info);
-	if (info->connected == BLKIF_STATE_SUSPENDED && !err)
-		err = blkif_recover(info);
+
+	/*
+	 * We have to wait for the backend to switch to
+	 * connected state, since we want to read which
+	 * features it supports.
+	 */
 
 	return err;
 }
@@ -1429,9 +1457,16 @@ static void blkfront_connect(struct blkfront_info *info)
 		       sectors);
 		set_capacity(info->gd, sectors);
 		revalidate_disk(info->gd);
+		return;
 
-		/* fall through */
 	case BLKIF_STATE_SUSPENDED:
+		/*
+		 * If we are recovering from suspension, we need to wait
+		 * for the backend to announce it's features before
+		 * reconnecting, we need to know if the backend supports
+		 * persistent grants.
+		 */
+		blkif_recover(info);
 		return;
 
 	default:
@@ -1499,6 +1534,14 @@ static void blkfront_connect(struct blkfront_info *info)
 	else
 		info->feature_persistent = persistent;
 
+	/* Allocate memory for grants */
+	err = fill_grant_buffer(info, BLK_RING_SIZE *
+	                              BLKIF_MAX_SEGMENTS_PER_REQUEST);
+	if (err) {
+		xenbus_dev_fatal(info->xbdev, err, "setting grant buffer failed");
+		return;
+	}
+
 	err = xlvbd_alloc_gendisk(sectors, info, binfo, sector_size);
 	if (err) {
 		xenbus_dev_fatal(info->xbdev, err, "xlvbd_add at %s",
-- 
1.7.7.5 (Apple Git-26)


--------------070401020106050100000006--
