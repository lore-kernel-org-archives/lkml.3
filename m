Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaCBC7g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 21:59:36 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:56772 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbaCBC7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 21:59:35 -0500
From: Surendra Patil <surendra.tux@gmail.com>
To: rupesh.gujare@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        surendra.tux@gmail.com
Subject: [PATCH] Drivers:staging:ozwpan Replaced wrapper functions with actual spin lock function calls
Date: Sat,  1 Mar 2014 18:59:20 -0800
Message-Id: <1393729160-23931-1-git-send-email-surendra.tux@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced all the spin lock/unlock wrappers from oz_polling_lock_bh()
and oz_polllin_unlock_bh() with spin_lock_bh(&g_polling_lock) and
spin_unlock_bh(&g_polling_lock).Completely erased the wrappers defination
and declaration.
Module builded successfully with sparse without warnings.

Signed-off-by: Surendra Patil <surendra.tux@gmail.com>
---
 drivers/staging/ozwpan/ozpd.c    | 29 +++++++++++++++--------------
 drivers/staging/ozwpan/ozproto.c |  9 ---------
 drivers/staging/ozwpan/ozproto.h |  2 --
 3 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 7436950..66c3a2c 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -22,6 +22,7 @@
 
 #define OZ_MAX_TX_POOL_SIZE	6
 
+static DEFINE_SPINLOCK(g_polling_lock);
 static struct oz_tx_frame *oz_tx_frame_alloc(struct oz_pd *pd);
 static void oz_tx_frame_free(struct oz_pd *pd, struct oz_tx_frame *f);
 static void oz_tx_isoc_free(struct oz_pd *pd, struct oz_tx_frame *f);
@@ -284,11 +285,11 @@ int oz_services_start(struct oz_pd *pd, u16 apps, int resume)
 					  ai->app_id);
 				break;
 			}
-			oz_polling_lock_bh();
+			spin_lock_bh(&g_polling_lock);
 			pd->total_apps |= (1<<ai->app_id);
 			if (resume)
 				pd->paused_apps &= ~(1<<ai->app_id);
-			oz_polling_unlock_bh();
+			spin_unlock_bh(&g_polling_lock);
 		}
 	}
 	return rc;
@@ -304,14 +305,14 @@ void oz_services_stop(struct oz_pd *pd, u16 apps, int pause)
 	oz_pd_dbg(pd, ON, "%s: (0x%x) pause(%d)\n", __func__, apps, pause);
 	for (ai = g_app_if; ai < &g_app_if[OZ_APPID_MAX]; ai++) {
 		if (apps & (1<<ai->app_id)) {
-			oz_polling_lock_bh();
+			spin_lock_bh(&g_polling_lock);
 			if (pause) {
 				pd->paused_apps |= (1<<ai->app_id);
 			} else {
 				pd->total_apps &= ~(1<<ai->app_id);
 				pd->paused_apps &= ~(1<<ai->app_id);
 			}
-			oz_polling_unlock_bh();
+			spin_unlock_bh(&g_polling_lock);
 			ai->stop(pd, pause);
 		}
 	}
@@ -349,17 +350,17 @@ void oz_pd_stop(struct oz_pd *pd)
 
 	oz_dbg(ON, "oz_pd_stop() State = 0x%x\n", pd->state);
 	oz_pd_indicate_farewells(pd);
-	oz_polling_lock_bh();
+	spin_lock_bh(&g_polling_lock);
 	stop_apps = pd->total_apps;
 	pd->total_apps = 0;
 	pd->paused_apps = 0;
-	oz_polling_unlock_bh();
+	spin_unlock_bh(&g_polling_lock);
 	oz_services_stop(pd, stop_apps, 0);
-	oz_polling_lock_bh();
+	spin_lock_bh(&g_polling_lock);
 	oz_pd_set_state(pd, OZ_PD_S_STOPPED);
 	/* Remove from PD list.*/
 	list_del(&pd->link);
-	oz_polling_unlock_bh();
+	spin_unlock_bh(&g_polling_lock);
 	oz_dbg(ON, "pd ref count = %d\n", atomic_read(&pd->ref_count));
 	oz_pd_put(pd);
 }
@@ -372,9 +373,9 @@ int oz_pd_sleep(struct oz_pd *pd)
 	int do_stop = 0;
 	u16 stop_apps;
 
-	oz_polling_lock_bh();
+	spin_lock_bh(&g_polling_lock);
 	if (pd->state & (OZ_PD_S_SLEEP | OZ_PD_S_STOPPED)) {
-		oz_polling_unlock_bh();
+		spin_unlock_bh(&g_polling_lock);
 		return 0;
 	}
 	if (pd->keep_alive && pd->session_id)
@@ -383,7 +384,7 @@ int oz_pd_sleep(struct oz_pd *pd)
 		do_stop = 1;
 
 	stop_apps = pd->total_apps;
-	oz_polling_unlock_bh();
+	spin_unlock_bh(&g_polling_lock);
 	if (do_stop) {
 		oz_pd_stop(pd);
 	} else {
@@ -999,15 +1000,15 @@ void oz_pd_indicate_farewells(struct oz_pd *pd)
 	const struct oz_app_if *ai = &g_app_if[OZ_APPID_USB-1];
 
 	while (1) {
-		oz_polling_lock_bh();
+		spin_lock_bh(&g_polling_lock);
 		if (list_empty(&pd->farewell_list)) {
-			oz_polling_unlock_bh();
+			spin_unlock_bh(&g_polling_lock);
 			break;
 		}
 		f = list_first_entry(&pd->farewell_list,
 				struct oz_farewell, link);
 		list_del(&f->link);
-		oz_polling_unlock_bh();
+		spin_unlock_bh(&g_polling_lock);
 		if (ai->farewell)
 			ai->farewell(pd, f->ep_num, f->report, f->len);
 		kfree(f);
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index e7138ed..b68aef3 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -794,12 +794,3 @@ int oz_get_pd_list(struct oz_mac_addr *addr, int max_count)
 	return count;
 }
 
-void oz_polling_lock_bh(void)
-{
-	spin_lock_bh(&g_polling_lock);
-}
-
-void oz_polling_unlock_bh(void)
-{
-	spin_unlock_bh(&g_polling_lock);
-}
diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
index 0c49c8a..cb38e02 100644
--- a/drivers/staging/ozwpan/ozproto.h
+++ b/drivers/staging/ozwpan/ozproto.h
@@ -59,8 +59,6 @@ void oz_binding_remove(const char *net_dev);
 void oz_timer_add(struct oz_pd *pd, int type, unsigned long due_time);
 void oz_timer_delete(struct oz_pd *pd, int type);
 void oz_pd_request_heartbeat(struct oz_pd *pd);
-void oz_polling_lock_bh(void);
-void oz_polling_unlock_bh(void);
 void oz_pd_heartbeat_handler(unsigned long data);
 void oz_pd_timeout_handler(unsigned long data);
 enum hrtimer_restart oz_pd_heartbeat_event(struct hrtimer *timer);
-- 
1.8.3.2

