Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbaAPEcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:32:07 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:45769 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbaAPEcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:32:02 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>
Subject: [PATCH 05/15] w1: continue slave search where previous left off
Date: Wed, 15 Jan 2014 22:29:16 -0600
Message-Id: <1389846566-28862-6-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389846566-28862-1-git-send-email-David@Fries.net>
References: <1389846566-28862-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 22:31:55 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Search will detect at most max_slave_count devices per run, if there
are more pick up the next search where the previous left off.

Signed-off-by: David Fries <David@Fries.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/w1.c |   18 +++++++++++++++---
 drivers/w1/w1.h |    3 +++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 34ffdc6..4c89f85 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -918,7 +918,8 @@ void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb
 	u8  triplet_ret = 0;
 
 	search_bit = 0;
-	rn = last_rn = 0;
+	rn = dev->search_id;
+	last_rn = 0;
 	last_device = 0;
 	last_zero = -1;
 
@@ -989,16 +990,27 @@ void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb
 		mutex_unlock(&dev->bus_mutex);
 
 		if ( (triplet_ret & 0x03) != 0x03 ) {
-			if ( (desc_bit == last_zero) || (last_zero < 0))
+			if ((desc_bit == last_zero) || (last_zero < 0)) {
 				last_device = 1;
+				dev->search_id = 0;
+			} else {
+				dev->search_id = rn;
+			}
 			desc_bit = last_zero;
 			cb(dev, rn);
 		}
 
 		if (!last_device && slave_count == dev->max_slave_count &&
 			!test_bit(W1_WARN_MAX_COUNT, &dev->flags)) {
+			/* Only max_slave_count will be scanned in a search,
+			 * but it will start where it left off next search
+			 * until all ids are identified and then it will start
+			 * over.  A continued search will report the previous
+			 * last id as the first id (provided it is still on the
+			 * bus).
+			 */
 			dev_info(&dev->dev, "%s: max_slave_count %d reached, "
-				"additional sensors ignored\n", __func__,
+				"will continue next search.\n", __func__,
 				dev->max_slave_count);
 			set_bit(W1_WARN_MAX_COUNT, &dev->flags);
 		}
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index bd10b3c..80fbdf9 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -150,6 +150,7 @@ struct w1_bus_master
 
 	/** Really nice hardware can handles the different types of ROM search
 	 *  w1_master* is passed to the slave found callback.
+	 *  u8 is search_type, W1_SEARCH or W1_ALARM_SEARCH
 	 */
 	void		(*search)(void *, struct w1_master *,
 		u8, w1_slave_found_callback);
@@ -177,6 +178,8 @@ struct w1_master
 	int			initialized;
 	u32			id;
 	int			search_count;
+	/* id to start searching on, to continue a search or 0 to restart */
+	u64			search_id;
 
 	atomic_t		refcnt;
 
-- 
1.7.10.4

