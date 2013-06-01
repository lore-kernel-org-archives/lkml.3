Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab3FAELv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 00:11:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59453 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752369Ab3FAELl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 00:11:41 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 1/8] pktcdvd: Convert ZONE macro to static function get_zone()
Date: Fri, 31 May 2013 21:11:22 -0700
Message-Id: <cffa2f13c7621e38d2ecfbd5d8ea02920e1d4afb.1370048648.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370048648.git.joe@perches.com>
References: <1369978679.10556.36.camel@joe-AO722> <cover.1370048648.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macros should be converted to functions where feasible to
verify arguments and the like.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/pktcdvd.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 09142c4..9dcb601 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
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

