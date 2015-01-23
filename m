Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbbAWKPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:15:52 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32583 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbbAWKPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:15:46 -0500
From: Bob Liu <bob.liu@oracle.com>
To: xen-devel@lists.xen.org
Cc: david.vrabel@citrix.com, linux-kernel@vger.kernel.org,
        roger.pau@citrix.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, wei.liu2@citrix.com,
        Bob Liu <bob.liu@oracle.com>
Subject: [PATCH 2/2] drivers: xen/block: add multi-page ring support
Date: Fri, 23 Jan 2015 18:14:31 +0800
Message-Id: <1422008071-27643-2-git-send-email-bob.liu@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1422008071-27643-1-git-send-email-bob.liu@oracle.com>
References: <1422008071-27643-1-git-send-email-bob.liu@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend xen/block to support multi-page ring.
 * xen-blkback notify blkfront with feature-multi-ring-pages
 * xen-blkfront write to xenstore about how many pages are used as the ring

If using 4 pages as the ring, inflight requests inscreased from 32 to 128 and
IOPS improved nearly 400% on our system.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/block/xen-blkback/xenbus.c |   86 +++++++++++++++++++++++++--------
 drivers/block/xen-blkfront.c       |   94 ++++++++++++++++++++++++++----------
 2 files changed, 133 insertions(+), 47 deletions(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index cbd13c9..a5c9c62 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -193,8 +193,8 @@ fail:
 	return ERR_PTR(-ENOMEM);
 }
 
-static int xen_blkif_map(struct xen_blkif *blkif, grant_ref_t gref,
-			 unsigned int evtchn)
+static int xen_blkif_map(struct xen_blkif *blkif, grant_ref_t *gref,
+			unsigned int nr_grefs, unsigned int evtchn)
 {
 	int err;
 
@@ -202,7 +202,7 @@ static int xen_blkif_map(struct xen_blkif *blkif, grant_ref_t gref,
 	if (blkif->irq)
 		return 0;
 
-	err = xenbus_map_ring_valloc(blkif->be->dev, &gref, 1,
+	err = xenbus_map_ring_valloc(blkif->be->dev, gref, nr_grefs,
 			&blkif->blk_ring);
 	if (err < 0)
 		return err;
@@ -212,21 +212,21 @@ static int xen_blkif_map(struct xen_blkif *blkif, grant_ref_t gref,
 	{
 		struct blkif_sring *sring;
 		sring = (struct blkif_sring *)blkif->blk_ring;
-		BACK_RING_INIT(&blkif->blk_rings.native, sring, PAGE_SIZE);
+		BACK_RING_INIT(&blkif->blk_rings.native, sring, PAGE_SIZE * nr_grefs);
 		break;
 	}
 	case BLKIF_PROTOCOL_X86_32:
 	{
 		struct blkif_x86_32_sring *sring_x86_32;
 		sring_x86_32 = (struct blkif_x86_32_sring *)blkif->blk_ring;
-		BACK_RING_INIT(&blkif->blk_rings.x86_32, sring_x86_32, PAGE_SIZE);
+		BACK_RING_INIT(&blkif->blk_rings.x86_32, sring_x86_32, PAGE_SIZE * nr_grefs);
 		break;
 	}
 	case BLKIF_PROTOCOL_X86_64:
 	{
 		struct blkif_x86_64_sring *sring_x86_64;
 		sring_x86_64 = (struct blkif_x86_64_sring *)blkif->blk_ring;
-		BACK_RING_INIT(&blkif->blk_rings.x86_64, sring_x86_64, PAGE_SIZE);
+		BACK_RING_INIT(&blkif->blk_rings.x86_64, sring_x86_64, PAGE_SIZE * nr_grefs);
 		break;
 	}
 	default:
@@ -588,6 +588,13 @@ static int xen_blkbk_probe(struct xenbus_device *dev,
 	if (err)
 		goto fail;
 
+	err = xenbus_printf(XBT_NIL, dev->nodename,
+			"feature-multi-ring-pages", "%u", 1);
+	if (err) {
+		pr_debug("Error writing feature-multi-ring-pages\n");
+		goto fail;
+	}
+
 	err = xenbus_switch_state(dev, XenbusStateInitWait);
 	if (err)
 		goto fail;
@@ -852,23 +859,61 @@ again:
 static int connect_ring(struct backend_info *be)
 {
 	struct xenbus_device *dev = be->dev;
-	unsigned long ring_ref;
-	unsigned int evtchn;
+	unsigned int ring_ref[XENBUS_MAX_RING_PAGES];
+	unsigned int evtchn, nr_grefs;
 	unsigned int pers_grants;
 	char protocol[64] = "";
 	int err;
 
 	DPRINTK("%s", dev->otherend);
-
-	err = xenbus_gather(XBT_NIL, dev->otherend, "ring-ref", "%lu",
-			    &ring_ref, "event-channel", "%u", &evtchn, NULL);
-	if (err) {
-		xenbus_dev_fatal(dev, err,
-				 "reading %s/ring-ref and event-channel",
-				 dev->otherend);
+	err = xenbus_scanf(XBT_NIL, dev->otherend, "event-channel", "%u",
+			&evtchn);
+	if (err != 1) {
+		err = -EINVAL;
+		xenbus_dev_fatal(dev, err, "reading %s/event-channel",
+				dev->otherend);
 		return err;
 	}
 
+	err = xenbus_scanf(XBT_NIL, dev->otherend, "max-ring-pages", "%u",
+			&nr_grefs);
+	if (err != 1) {
+		err = xenbus_scanf(XBT_NIL, dev->otherend, "ring-ref",
+				"%u", &ring_ref[0]);
+		if (err != 1) {
+			err = -EINVAL;
+			xenbus_dev_fatal(dev, err, "reading %s/ring-ref",
+					dev->otherend);
+			return err;
+		}
+		nr_grefs = 1;
+		pr_debug("%s:using one-page ring with ref: %d\n",
+				dev->otherend, ring_ref[0]);
+	} else {
+		unsigned int i;
+
+		if (nr_grefs > XENBUS_MAX_RING_PAGES) {
+			err = -EINVAL;
+			xenbus_dev_fatal(dev, err,
+				"%s/ring-pages:%d too big", dev->otherend, nr_grefs);
+			return err;
+		}
+		for (i = 0; i < nr_grefs; i++) {
+			char ring_ref_name[15];
+			snprintf(ring_ref_name, sizeof(ring_ref_name),
+					"ring-ref%u", i);
+			err = xenbus_scanf(XBT_NIL, dev->otherend,
+					ring_ref_name, "%d", &ring_ref[i]);
+			if (err != 1) {
+				err = -EINVAL;
+				xenbus_dev_fatal(dev, err, "reading %s/%s",
+						dev->otherend, ring_ref_name);
+				return err;
+			}
+			pr_debug("blkback: ring-ref%u: %d\n", i, ring_ref[i]);
+		}
+	}
+
 	be->blkif->blk_protocol = BLKIF_PROTOCOL_NATIVE;
 	err = xenbus_gather(XBT_NIL, dev->otherend, "protocol",
 			    "%63s", protocol, NULL);
@@ -893,15 +938,14 @@ static int connect_ring(struct backend_info *be)
 	be->blkif->vbd.feature_gnt_persistent = pers_grants;
 	be->blkif->vbd.overflow_max_grants = 0;
 
-	pr_info(DRV_PFX "ring-ref %ld, event-channel %d, protocol %d (%s) %s\n",
-		ring_ref, evtchn, be->blkif->blk_protocol, protocol,
-		pers_grants ? "persistent grants" : "");
+	pr_info(DRV_PFX "ring-pages:%d, event-channel %d, protocol %d (%s) %s\n",
+			nr_grefs, evtchn, be->blkif->blk_protocol, protocol,
+			pers_grants ? "persistent grants" : "");
 
 	/* Map the shared frame, irq etc. */
-	err = xen_blkif_map(be->blkif, ring_ref, evtchn);
+	err = xen_blkif_map(be->blkif, ring_ref, nr_grefs, evtchn);
 	if (err) {
-		xenbus_dev_fatal(dev, err, "mapping ring-ref %lu port %u",
-				 ring_ref, evtchn);
+		xenbus_dev_fatal(dev, err, "mapping ring-ref port %u", evtchn);
 		return err;
 	}
 
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2fcf75d..dec9fe7 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -98,7 +98,12 @@ static unsigned int xen_blkif_max_segments = 32;
 module_param_named(max, xen_blkif_max_segments, int, S_IRUGO);
 MODULE_PARM_DESC(max, "Maximum amount of segments in indirect requests (default is 32)");
 
-#define BLK_RING_SIZE __CONST_RING_SIZE(blkif, PAGE_SIZE)
+static unsigned int xen_blkif_max_ring_pages = 1;
+module_param_named(max_ring_pages, xen_blkif_max_ring_pages, int, 0);
+MODULE_PARM_DESC(max_ring_pages, "Maximum amount of pages to be used as the ring");
+
+#define BLK_RING_SIZE __CONST_RING_SIZE(blkif, PAGE_SIZE * info->nr_ring_pages)
+#define BLK_MAX_RING_SIZE __CONST_RING_SIZE(blkif, PAGE_SIZE * XENBUS_MAX_RING_PAGES)
 
 /*
  * We have one of these per vbd, whether ide, scsi or 'other'.  They
@@ -114,13 +119,14 @@ struct blkfront_info
 	int vdevice;
 	blkif_vdev_t handle;
 	enum blkif_state connected;
-	int ring_ref;
+	int ring_ref[XENBUS_MAX_RING_PAGES];
+	int nr_ring_pages;
 	struct blkif_front_ring ring;
 	unsigned int evtchn, irq;
 	struct request_queue *rq;
 	struct work_struct work;
 	struct gnttab_free_callback callback;
-	struct blk_shadow shadow[BLK_RING_SIZE];
+	struct blk_shadow shadow[BLK_MAX_RING_SIZE];
 	struct list_head grants;
 	struct list_head indirect_pages;
 	unsigned int persistent_gnts_c;
@@ -139,8 +145,6 @@ static unsigned int nr_minors;
 static unsigned long *minors;
 static DEFINE_SPINLOCK(minor_lock);
 
-#define MAXIMUM_OUTSTANDING_BLOCK_REQS \
-	(BLKIF_MAX_SEGMENTS_PER_REQUEST * BLK_RING_SIZE)
 #define GRANT_INVALID_REF	0
 
 #define PARTS_PER_DISK		16
@@ -1033,12 +1037,15 @@ free_shadow:
 	flush_work(&info->work);
 
 	/* Free resources associated with old device channel. */
-	if (info->ring_ref != GRANT_INVALID_REF) {
-		gnttab_end_foreign_access(info->ring_ref, 0,
-					  (unsigned long)info->ring.sring);
-		info->ring_ref = GRANT_INVALID_REF;
-		info->ring.sring = NULL;
+	for (i = 0; i < info->nr_ring_pages; i++) {
+		if (info->ring_ref[i] != GRANT_INVALID_REF) {
+			gnttab_end_foreign_access(info->ring_ref[i], 0, 0);
+			info->ring_ref[i] = GRANT_INVALID_REF;
+		}
 	}
+	free_pages((unsigned long)info->ring.sring, get_order(info->nr_ring_pages * PAGE_SIZE));
+	info->ring.sring = NULL;
+
 	if (info->irq)
 		unbind_from_irqhandler(info->irq, info);
 	info->evtchn = info->irq = 0;
@@ -1245,26 +1252,30 @@ static int setup_blkring(struct xenbus_device *dev,
 			 struct blkfront_info *info)
 {
 	struct blkif_sring *sring;
-	int err;
-	grant_ref_t gref;
+	int err, i;
+	unsigned long ring_size = info->nr_ring_pages * PAGE_SIZE;
+	grant_ref_t gref[XENBUS_MAX_RING_PAGES];
 
-	info->ring_ref = GRANT_INVALID_REF;
+	for (i = 0; i < XENBUS_MAX_RING_PAGES; i++)
+		info->ring_ref[i] = GRANT_INVALID_REF;
 
-	sring = (struct blkif_sring *)__get_free_page(GFP_NOIO | __GFP_HIGH);
+	sring = (struct blkif_sring *)__get_free_pages(GFP_NOIO | __GFP_HIGH,
+						get_order(ring_size));
 	if (!sring) {
 		xenbus_dev_fatal(dev, -ENOMEM, "allocating shared ring");
 		return -ENOMEM;
 	}
 	SHARED_RING_INIT(sring);
-	FRONT_RING_INIT(&info->ring, sring, PAGE_SIZE);
+	FRONT_RING_INIT(&info->ring, sring, ring_size);
 
-	err = xenbus_grant_ring(dev, info->ring.sring, 1, &gref);
+	err = xenbus_grant_ring(dev, info->ring.sring, info->nr_ring_pages, gref);
 	if (err < 0) {
 		free_page((unsigned long)sring);
 		info->ring.sring = NULL;
 		goto fail;
 	}
-	info->ring_ref = gref;
+	for (i = 0; i < info->nr_ring_pages; i++)
+		info->ring_ref[i] = gref[i];
 
 	err = xenbus_alloc_evtchn(dev, &info->evtchn);
 	if (err)
@@ -1292,7 +1303,14 @@ static int talk_to_blkback(struct xenbus_device *dev,
 {
 	const char *message = NULL;
 	struct xenbus_transaction xbt;
-	int err;
+	int err, i, multi_ring_pages = 0;
+
+	err = xenbus_scanf(XBT_NIL, info->xbdev->otherend,
+			   "feature-multi-ring-pages", "%u", &multi_ring_pages);
+	if (err != 1)
+		info->nr_ring_pages = 1;
+	else
+		info->nr_ring_pages = xen_blkif_max_ring_pages;
 
 	/* Create shared ring, alloc event channel. */
 	err = setup_blkring(dev, info);
@@ -1306,12 +1324,33 @@ again:
 		goto destroy_blkring;
 	}
 
-	err = xenbus_printf(xbt, dev->nodename,
-			    "ring-ref", "%u", info->ring_ref);
-	if (err) {
-		message = "writing ring-ref";
-		goto abort_transaction;
+	if (info->nr_ring_pages == 1) {
+		err = xenbus_printf(xbt, dev->nodename,
+				"ring-ref", "%u", info->ring_ref[0]);
+		if (err) {
+			message = "writing ring-ref";
+			goto abort_transaction;
+		}
+	} else {
+		err = xenbus_printf(xbt, dev->nodename,
+				"max-ring-pages", "%u", info->nr_ring_pages);
+		if (err) {
+			message = "writing max-ring-pages";
+			goto abort_transaction;
+		}
+
+		for (i = 0; i < info->nr_ring_pages; i++) {
+			char ring_ref_name[15];
+			sprintf(ring_ref_name, "ring-ref%d", i);
+			err = xenbus_printf(xbt, dev->nodename,
+					ring_ref_name, "%d", info->ring_ref[i]);
+			if (err) {
+				message = "writing ring-ref";
+				goto abort_transaction;
+			}
+		}
 	}
+
 	err = xenbus_printf(xbt, dev->nodename,
 			    "event-channel", "%u", info->evtchn);
 	if (err) {
@@ -1422,9 +1461,8 @@ static int blkfront_probe(struct xenbus_device *dev,
 	info->connected = BLKIF_STATE_DISCONNECTED;
 	INIT_WORK(&info->work, blkif_restart_queue);
 
-	for (i = 0; i < BLK_RING_SIZE; i++)
+	for (i = 0; i < BLK_MAX_RING_SIZE; i++)
 		info->shadow[i].req.u.rw.id = i+1;
-	info->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
 
 	/* Front end dir is a number, which is used as the id. */
 	info->handle = simple_strtoul(strrchr(dev->nodename, '/')+1, NULL, 0);
@@ -1436,6 +1474,7 @@ static int blkfront_probe(struct xenbus_device *dev,
 		dev_set_drvdata(&dev->dev, NULL);
 		return err;
 	}
+	info->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
 
 	return 0;
 }
@@ -1476,7 +1515,7 @@ static int blkif_recover(struct blkfront_info *info)
 
 	/* Stage 2: Set up free list. */
 	memset(&info->shadow, 0, sizeof(info->shadow));
-	for (i = 0; i < BLK_RING_SIZE; i++)
+	for (i = 0; i < BLK_MAX_RING_SIZE; i++)
 		info->shadow[i].req.u.rw.id = i+1;
 	info->shadow_free = info->ring.req_prod_pvt;
 	info->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
@@ -2088,6 +2127,9 @@ static int __init xlblk_init(void)
 {
 	int ret;
 
+	if (xen_blkif_max_ring_pages > XENBUS_MAX_RING_PAGES)
+		return -EINVAL;
+
 	if (!xen_domain())
 		return -ENODEV;
 
-- 
1.7.10.4

