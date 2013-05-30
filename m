Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab3E3U6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:58:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53315 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758251Ab3E3U6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:58:02 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] pktcdvd: Convert ZONE macro to static function get_zone()
Date: Thu, 30 May 2013 13:57:49 -0700
Message-Id: <6942a36d1fe0ba9ee6ad20f0ef5c5c9177353e7d.1369947186.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1369947186.git.joe@perches.com>
References: <alpine.LNX.2.00.1305291537120.30576@pobox.suse.cz> <cover.1369947186.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macros should be converted to functions where feasible to
verify arguments and the like.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/pktcdvd.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 09142c4..635f6cb 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -60,7 +60,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_ioctl.h>
+l#include <scsi/scsi_ioctl.h>
 #include <scsi/scsi.h>
 #include <linux/debugfs.h>
 #include <linux/device.h>
@@ -83,9 +83,6 @@
 
 #define MAX_SPEED 0xffff
 
-#define ZONE(sector, pd) (((sector) + (pd)->offset) & \
-			~(sector_t)((pd)->settings.size - 1))
-
 static DEFINE_MUTEX(pktcdvd_mutex);
 static struct pktcdvd_device *pkt_devs[MAX_WRITERS];
 static struct proc_dir_entry *pkt_proc;
@@ -103,7 +100,10 @@ static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev);
 static int pkt_remove_dev(dev_t pkt_dev);
 static int pkt_seq_show(struct seq_file *m, void *p);
 
-
+static sector_t get_zone(sector_t sector, struct pktcdvd_device *pd)
+{
+	return (sector + pd->offset) & ~(sector_t)(pd->settings.size - 1);
+}
 
 /*
  * create and register a pktcdvd kernel object.
@@ -1226,7 +1226,7 @@ static int pkt_handle_queue(struct pktcdvd_device *pd)
 	node = first_node;
 	while (node) {
 		bio = node->bio;
-		zone = ZONE(bio->bi_sector, pd);
+		zone = get_zone(bio->bi_sector, pd);
 		list_for_each_entry(p, &pd->cdrw.pkt_active_list, list) {
 			if (p->sector == zone) {
 				bio = NULL;
@@ -1266,8 +1266,8 @@ try_next_bio:
 	while ((node = pkt_rbtree_find(pd, zone)) != NULL) {
 		bio = node->bio;
 		VPRINTK("pkt_handle_queue: found zone=%llx\n",
-			(unsigned long long)ZONE(bio->bi_sector, pd));
-		if (ZONE(bio->bi_sector, pd) != zone)
+			(unsigned long long)get_zone(bio->bi_sector, pd));
+		if (get_zone(bio->bi_sector, pd) != zone)
 			break;
 		pkt_rbtree_erase(pd, node);
 		spin_lock(&pkt->lock);
@@ -2397,7 +2397,7 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 
 	blk_queue_bounce(q, &bio);
 
-	zone = ZONE(bio->bi_sector, pd);
+	zone = get_zone(bio->bi_sector, pd);
 	VPRINTK("pkt_make_request: start = %6llx stop = %6llx\n",
 		(unsigned long long)bio->bi_sector,
 		(unsigned long long)bio_end_sector(bio));
@@ -2408,7 +2408,7 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 		sector_t last_zone;
 		int first_sectors;
 
-		last_zone = ZONE(bio_end_sector(bio) - 1, pd);
+		last_zone = get_zone(bio_end_sector(bio) - 1, pd);
 		if (last_zone != zone) {
 			BUG_ON(last_zone != zone + pd->settings.size);
 			first_sectors = last_zone - bio->bi_sector;
@@ -2503,7 +2503,7 @@ static int pkt_merge_bvec(struct request_queue *q, struct bvec_merge_data *bmd,
 			  struct bio_vec *bvec)
 {
 	struct pktcdvd_device *pd = q->queuedata;
-	sector_t zone = ZONE(bmd->bi_sector, pd);
+	sector_t zone = get_zone(bmd->bi_sector, pd);
 	int used = ((bmd->bi_sector - zone) << 9) + bmd->bi_size;
 	int remaining = (pd->settings.size << 9) - used;
 	int remaining2;
-- 
1.8.1.2.459.gbcd45b4.dirty

