Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbaGAQT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:19:29 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53109 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013AbaGAQQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 15/20] drbd: cosmetic: change all printk(level, ...) to pr_<level>(...)
Date: Tue,  1 Jul 2014 18:16:45 +0200
Message-Id: <1404231410-29852-16-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Cosmetic change only.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_bitmap.c |  9 ++++-----
 drivers/block/drbd/drbd_int.h    |  4 +---
 drivers/block/drbd/drbd_main.c   | 28 +++++++++++++---------------
 drivers/block/drbd/drbd_nl.c     |  4 +++-
 4 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 3da6730..7e6f924 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -353,9 +353,8 @@ static void bm_free_pages(struct page **pages, unsigned long number)
 
 	for (i = 0; i < number; i++) {
 		if (!pages[i]) {
-			printk(KERN_ALERT "drbd: bm_free_pages tried to free "
-					  "a NULL pointer; i=%lu n=%lu\n",
-					  i, number);
+			pr_alert("bm_free_pages tried to free a NULL pointer; i=%lu n=%lu\n",
+				 i, number);
 			continue;
 		}
 		__free_page(pages[i]);
@@ -592,7 +591,7 @@ static void bm_memset(struct drbd_bitmap *b, size_t offset, int c, size_t len)
 	end = offset + len;
 
 	if (end > b->bm_words) {
-		printk(KERN_ALERT "drbd: bm_memset end > bm_words\n");
+		pr_alert("bm_memset end > bm_words\n");
 		return;
 	}
 
@@ -602,7 +601,7 @@ static void bm_memset(struct drbd_bitmap *b, size_t offset, int c, size_t len)
 		p_addr = bm_map_pidx(b, idx);
 		bm = p_addr + MLPP(offset);
 		if (bm+do_now > p_addr + LWPP) {
-			printk(KERN_ALERT "drbd: BUG BUG BUG! p_addr:%p bm:%p do_now:%d\n",
+			pr_alert("BUG BUG BUG! p_addr:%p bm:%p do_now:%d\n",
 			       p_addr, bm, (int)do_now);
 		} else
 			memset(bm, c, do_now * sizeof(long));
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index b0ab358..c88d6c6 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1467,9 +1467,7 @@ static inline void drbd_generic_make_request(struct drbd_device *device,
 {
 	__release(local);
 	if (!bio->bi_bdev) {
-		printk(KERN_ERR "drbd%d: drbd_generic_make_request: "
-				"bio->bi_bdev == NULL\n",
-		       device_to_minor(device));
+		drbd_err(device, "drbd_generic_make_request: bio->bi_bdev == NULL\n");
 		bio_endio(bio, -ENODEV);
 		return;
 	}
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 7ada5d3..ce387bb 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -26,6 +26,8 @@
 
  */
 
+#define pr_fmt(fmt)	"drbd: " fmt
+
 #include <linux/module.h>
 #include <linux/drbd.h>
 #include <asm/uaccess.h>
@@ -2333,7 +2335,7 @@ static void drbd_cleanup(void)
 
 	idr_destroy(&drbd_devices);
 
-	printk(KERN_INFO "drbd: module cleanup done.\n");
+	pr_info("module cleanup done.\n");
 }
 
 /**
@@ -2869,8 +2871,7 @@ static int __init drbd_init(void)
 	int err;
 
 	if (minor_count < DRBD_MINOR_COUNT_MIN || minor_count > DRBD_MINOR_COUNT_MAX) {
-		printk(KERN_ERR
-		       "drbd: invalid minor_count (%d)\n", minor_count);
+		pr_err("invalid minor_count (%d)\n", minor_count);
 #ifdef MODULE
 		return -EINVAL;
 #else
@@ -2880,8 +2881,7 @@ static int __init drbd_init(void)
 
 	err = register_blkdev(DRBD_MAJOR, "drbd");
 	if (err) {
-		printk(KERN_ERR
-		       "drbd: unable to register block device major %d\n",
+		pr_err("unable to register block device major %d\n",
 		       DRBD_MAJOR);
 		return err;
 	}
@@ -2899,7 +2899,7 @@ static int __init drbd_init(void)
 
 	err = drbd_genl_register();
 	if (err) {
-		printk(KERN_ERR "drbd: unable to register generic netlink family\n");
+		pr_err("unable to register generic netlink family\n");
 		goto fail;
 	}
 
@@ -2910,34 +2910,32 @@ static int __init drbd_init(void)
 	err = -ENOMEM;
 	drbd_proc = proc_create_data("drbd", S_IFREG | S_IRUGO , NULL, &drbd_proc_fops, NULL);
 	if (!drbd_proc)	{
-		printk(KERN_ERR "drbd: unable to register proc file\n");
+		pr_err("unable to register proc file\n");
 		goto fail;
 	}
 
 	retry.wq = create_singlethread_workqueue("drbd-reissue");
 	if (!retry.wq) {
-		printk(KERN_ERR "drbd: unable to create retry workqueue\n");
+		pr_err("unable to create retry workqueue\n");
 		goto fail;
 	}
 	INIT_WORK(&retry.worker, do_retry);
 	spin_lock_init(&retry.lock);
 	INIT_LIST_HEAD(&retry.writes);
 
-	printk(KERN_INFO "drbd: initialized. "
+	pr_info("initialized. "
 	       "Version: " REL_VERSION " (api:%d/proto:%d-%d)\n",
 	       API_VERSION, PRO_VERSION_MIN, PRO_VERSION_MAX);
-	printk(KERN_INFO "drbd: %s\n", drbd_buildtag());
-	printk(KERN_INFO "drbd: registered as block device major %d\n",
-		DRBD_MAJOR);
-
+	pr_info("%s\n", drbd_buildtag());
+	pr_info("registered as block device major %d\n", DRBD_MAJOR);
 	return 0; /* Success! */
 
 fail:
 	drbd_cleanup();
 	if (err == -ENOMEM)
-		printk(KERN_ERR "drbd: ran out of memory\n");
+		pr_err("ran out of memory\n");
 	else
-		printk(KERN_ERR "drbd: initialization failure\n");
+		pr_err("initialization failure\n");
 	return err;
 }
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 81949d6..e2f535f 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -23,6 +23,8 @@
 
  */
 
+#define pr_fmt(fmt)	"drbd: " fmt
+
 #include <linux/module.h>
 #include <linux/drbd.h>
 #include <linux/in.h>
@@ -85,7 +87,7 @@ static void drbd_adm_send_reply(struct sk_buff *skb, struct genl_info *info)
 {
 	genlmsg_end(skb, genlmsg_data(nlmsg_data(nlmsg_hdr(skb))));
 	if (genlmsg_reply(skb, info))
-		printk(KERN_ERR "drbd: error sending genl reply\n");
+		pr_err("error sending genl reply\n");
 }
 
 /* Used on a fresh "drbd_adm_prepare"d reply_skb, this cannot fail: The only
-- 
1.9.1

