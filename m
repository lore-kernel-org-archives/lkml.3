Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaHDNDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:03:04 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.103]:41707 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbaHDNDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:03:00 -0400
From: Christoph Jaeger <email@christophjaeger.info>
To: shigekatsu.tateno@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <email@christophjaeger.info>
Subject: [PATCH 06/10] staging: ozwpan: Simplify app interface
Date: Mon,  4 Aug 2014 14:54:52 +0200
Message-Id: <1407156896-3246-7-git-send-email-email@christophjaeger.info>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
References: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the somewhat overcomplicated application interface; improves
readability and saves a bunch of lines.

Use designated struct initializers for clarity.

Signed-off-by: Christoph Jaeger <email@christophjaeger.info>
---
 drivers/staging/ozwpan/ozcdev.c     |  30 +++----
 drivers/staging/ozwpan/ozpd.c       | 151 ++++++++++--------------------------
 drivers/staging/ozwpan/ozpd.h       |   4 +-
 drivers/staging/ozwpan/ozproto.c    |   2 +-
 drivers/staging/ozwpan/ozproto.h    |   1 -
 drivers/staging/ozwpan/ozprotocol.h |   2 -
 drivers/staging/ozwpan/ozusbsvc.c   |  30 +++----
 drivers/staging/ozwpan/ozusbsvc1.c  |  12 +--
 8 files changed, 82 insertions(+), 150 deletions(-)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index f82e12c..c73d396 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -49,11 +49,11 @@ static struct oz_serial_ctx *oz_cdev_claim_ctx(struct oz_pd *pd)
 {
 	struct oz_serial_ctx *ctx;
 
-	spin_lock_bh(&pd->app_lock[OZ_APPID_SERIAL-1]);
-	ctx = (struct oz_serial_ctx *)pd->app_ctx[OZ_APPID_SERIAL-1];
+	spin_lock_bh(&pd->app_lock[OZ_APPID_SERIAL]);
+	ctx = (struct oz_serial_ctx *) pd->app_ctx[OZ_APPID_SERIAL];
 	if (ctx)
 		atomic_inc(&ctx->ref_count);
-	spin_unlock_bh(&pd->app_lock[OZ_APPID_SERIAL-1]);
+	spin_unlock_bh(&pd->app_lock[OZ_APPID_SERIAL]);
 	return ctx;
 }
 
@@ -182,8 +182,8 @@ static ssize_t oz_cdev_write(struct file *filp, const char __user *buf,
 	app_hdr->app_id = OZ_APPID_SERIAL;
 	if (copy_from_user(app_hdr+1, buf, count))
 		goto out;
-	spin_lock_bh(&pd->app_lock[OZ_APPID_USB-1]);
-	ctx = (struct oz_serial_ctx *)pd->app_ctx[OZ_APPID_SERIAL-1];
+	spin_lock_bh(&pd->app_lock[OZ_APPID_USB]);
+	ctx = (struct oz_serial_ctx *) pd->app_ctx[OZ_APPID_SERIAL];
 	if (ctx) {
 		app_hdr->elt_seq_num = ctx->tx_seq_num++;
 		if (ctx->tx_seq_num == 0)
@@ -193,7 +193,7 @@ static ssize_t oz_cdev_write(struct file *filp, const char __user *buf,
 			ei = NULL;
 		spin_unlock(&eb->lock);
 	}
-	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB-1]);
+	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB]);
 out:
 	if (ei) {
 		count = 0;
@@ -436,14 +436,14 @@ int oz_cdev_start(struct oz_pd *pd, int resume)
 		return -ENOMEM;
 	atomic_set(&ctx->ref_count, 1);
 	ctx->tx_seq_num = 1;
-	spin_lock_bh(&pd->app_lock[OZ_APPID_SERIAL-1]);
-	old_ctx = pd->app_ctx[OZ_APPID_SERIAL-1];
+	spin_lock_bh(&pd->app_lock[OZ_APPID_SERIAL]);
+	old_ctx = pd->app_ctx[OZ_APPID_SERIAL];
 	if (old_ctx) {
-		spin_unlock_bh(&pd->app_lock[OZ_APPID_SERIAL-1]);
+		spin_unlock_bh(&pd->app_lock[OZ_APPID_SERIAL]);
 		kfree(ctx);
 	} else {
-		pd->app_ctx[OZ_APPID_SERIAL-1] = ctx;
-		spin_unlock_bh(&pd->app_lock[OZ_APPID_SERIAL-1]);
+		pd->app_ctx[OZ_APPID_SERIAL] = ctx;
+		spin_unlock_bh(&pd->app_lock[OZ_APPID_SERIAL]);
 	}
 	spin_lock(&g_cdev.lock);
 	if ((g_cdev.active_pd == NULL) &&
@@ -468,10 +468,10 @@ void oz_cdev_stop(struct oz_pd *pd, int pause)
 		oz_dbg(ON, "Serial service paused\n");
 		return;
 	}
-	spin_lock_bh(&pd->app_lock[OZ_APPID_SERIAL-1]);
-	ctx = (struct oz_serial_ctx *)pd->app_ctx[OZ_APPID_SERIAL-1];
-	pd->app_ctx[OZ_APPID_SERIAL-1] = NULL;
-	spin_unlock_bh(&pd->app_lock[OZ_APPID_SERIAL-1]);
+	spin_lock_bh(&pd->app_lock[OZ_APPID_SERIAL]);
+	ctx = (struct oz_serial_ctx *) pd->app_ctx[OZ_APPID_SERIAL];
+	pd->app_ctx[OZ_APPID_SERIAL] = NULL;
+	spin_unlock_bh(&pd->app_lock[OZ_APPID_SERIAL]);
 	if (ctx)
 		oz_cdev_release_ctx(ctx);
 	spin_lock(&g_cdev.lock);
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index a27c603..6c4b13f 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -32,11 +32,6 @@ static void oz_retire_frame(struct oz_pd *pd, struct oz_tx_frame *f);
 static void oz_isoc_stream_free(struct oz_isoc_stream *st);
 static int oz_send_next_queued_frame(struct oz_pd *pd, int more_data);
 static void oz_isoc_destructor(struct sk_buff *skb);
-static int oz_def_app_init(void);
-static void oz_def_app_term(void);
-static int oz_def_app_start(struct oz_pd *pd, int resume);
-static void oz_def_app_stop(struct oz_pd *pd, int pause);
-static void oz_def_app_rx(struct oz_pd *pd, struct oz_elt *elt);
 
 /*
  * Counts the uncompleted isoc frames submitted to netcard.
@@ -45,80 +40,25 @@ static atomic_t g_submitted_isoc = ATOMIC_INIT(0);
 
 /* Application handler functions.
  */
-static const struct oz_app_if g_app_if[OZ_APPID_MAX] = {
-	{oz_usb_init,
-	oz_usb_term,
-	oz_usb_start,
-	oz_usb_stop,
-	oz_usb_rx,
-	oz_usb_heartbeat,
-	oz_usb_farewell,
-	OZ_APPID_USB},
-
-	{oz_def_app_init,
-	oz_def_app_term,
-	oz_def_app_start,
-	oz_def_app_stop,
-	oz_def_app_rx,
-	NULL,
-	NULL,
-	OZ_APPID_UNUSED1},
-
-	{oz_def_app_init,
-	oz_def_app_term,
-	oz_def_app_start,
-	oz_def_app_stop,
-	oz_def_app_rx,
-	NULL,
-	NULL,
-	OZ_APPID_UNUSED2},
-
-	{oz_cdev_init,
-	oz_cdev_term,
-	oz_cdev_start,
-	oz_cdev_stop,
-	oz_cdev_rx,
-	NULL,
-	NULL,
-	OZ_APPID_SERIAL},
+static const struct oz_app_if g_app_if[OZ_NB_APPS] = {
+	[OZ_APPID_USB] = {
+		.init      = oz_usb_init,
+		.term      = oz_usb_term,
+		.start     = oz_usb_start,
+		.stop      = oz_usb_stop,
+		.rx        = oz_usb_rx,
+		.heartbeat = oz_usb_heartbeat,
+		.farewell  = oz_usb_farewell,
+	},
+	[OZ_APPID_SERIAL] = {
+		.init      = oz_cdev_init,
+		.term      = oz_cdev_term,
+		.start     = oz_cdev_start,
+		.stop      = oz_cdev_stop,
+		.rx        = oz_cdev_rx,
+	},
 };
 
-/*
- * Context: process
- */
-static int oz_def_app_init(void)
-{
-	return 0;
-}
-
-/*
- * Context: process
- */
-static void oz_def_app_term(void)
-{
-}
-
-/*
- * Context: softirq
- */
-static int oz_def_app_start(struct oz_pd *pd, int resume)
-{
-	return 0;
-}
-
-/*
- * Context: softirq
- */
-static void oz_def_app_stop(struct oz_pd *pd, int pause)
-{
-}
-
-/*
- * Context: softirq
- */
-static void oz_def_app_rx(struct oz_pd *pd, struct oz_elt *elt)
-{
-}
 
 /*
  * Context: softirq or process
@@ -169,7 +109,7 @@ struct oz_pd *oz_pd_alloc(const u8 *mac_addr)
 	if (pd) {
 		int i;
 		atomic_set(&pd->ref_count, 2);
-		for (i = 0; i < OZ_APPID_MAX; i++)
+		for (i = 0; i < OZ_NB_APPS; i++)
 			spin_lock_init(&pd->app_lock[i]);
 		pd->last_rx_pkt_num = 0xffffffff;
 		oz_pd_set_state(pd, OZ_PD_S_IDLE);
@@ -269,23 +209,21 @@ void oz_pd_destroy(struct oz_pd *pd)
  */
 int oz_services_start(struct oz_pd *pd, u16 apps, int resume)
 {
-	const struct oz_app_if *ai;
-	int rc = 0;
+	int i, rc = 0;
 
 	oz_pd_dbg(pd, ON, "%s: (0x%x) resume(%d)\n", __func__, apps, resume);
-	for (ai = g_app_if; ai < &g_app_if[OZ_APPID_MAX]; ai++) {
-		if (apps & (1<<ai->app_id)) {
-			if (ai->start(pd, resume)) {
+	for (i = 0; i < OZ_NB_APPS; i++) {
+		if (g_app_if[i].start && (apps & (1 << i))) {
+			if (g_app_if[i].start(pd, resume)) {
 				rc = -1;
 				oz_pd_dbg(pd, ON,
-					  "Unable to start service %d\n",
-					  ai->app_id);
+					  "Unable to start service %d\n", i);
 				break;
 			}
 			spin_lock_bh(&g_polling_lock);
-			pd->total_apps |= (1<<ai->app_id);
+			pd->total_apps |= (1 << i);
 			if (resume)
-				pd->paused_apps &= ~(1<<ai->app_id);
+				pd->paused_apps &= ~(1 << i);
 			spin_unlock_bh(&g_polling_lock);
 		}
 	}
@@ -297,20 +235,20 @@ int oz_services_start(struct oz_pd *pd, u16 apps, int resume)
  */
 void oz_services_stop(struct oz_pd *pd, u16 apps, int pause)
 {
-	const struct oz_app_if *ai;
+	int i;
 
 	oz_pd_dbg(pd, ON, "%s: (0x%x) pause(%d)\n", __func__, apps, pause);
-	for (ai = g_app_if; ai < &g_app_if[OZ_APPID_MAX]; ai++) {
-		if (apps & (1<<ai->app_id)) {
+	for (i = 0; i < OZ_NB_APPS; i++) {
+		if (g_app_if[i].stop && (apps & (1 << i))) {
 			spin_lock_bh(&g_polling_lock);
 			if (pause) {
-				pd->paused_apps |= (1<<ai->app_id);
+				pd->paused_apps |=  (1 << i);
 			} else {
-				pd->total_apps &= ~(1<<ai->app_id);
-				pd->paused_apps &= ~(1<<ai->app_id);
+				pd->total_apps  &= ~(1 << i);
+				pd->paused_apps &= ~(1 << i);
 			}
 			spin_unlock_bh(&g_polling_lock);
-			ai->stop(pd, pause);
+			g_app_if[i].stop(pd, pause);
 		}
 	}
 }
@@ -320,12 +258,11 @@ void oz_services_stop(struct oz_pd *pd, u16 apps, int pause)
  */
 void oz_pd_heartbeat(struct oz_pd *pd, u16 apps)
 {
-	const struct oz_app_if *ai;
-	int more = 0;
+	int i, more = 0;
 
-	for (ai = g_app_if; ai < &g_app_if[OZ_APPID_MAX]; ai++) {
-		if (ai->heartbeat && (apps & (1<<ai->app_id))) {
-			if (ai->heartbeat(pd))
+	for (i = 0; i < OZ_NB_APPS; i++) {
+		if (g_app_if[i].heartbeat && (apps & (1 << i))) {
+			if (g_app_if[i].heartbeat(pd))
 				more = 1;
 		}
 	}
@@ -957,9 +894,10 @@ void oz_apps_init(void)
 {
 	int i;
 
-	for (i = 0; i < OZ_APPID_MAX; i++)
+	for (i = 0; i < OZ_NB_APPS; i++) {
 		if (g_app_if[i].init)
 			g_app_if[i].init();
+	}
 }
 
 /*
@@ -970,9 +908,10 @@ void oz_apps_term(void)
 	int i;
 
 	/* Terminate all the apps. */
-	for (i = 0; i < OZ_APPID_MAX; i++)
+	for (i = 0; i < OZ_NB_APPS; i++) {
 		if (g_app_if[i].term)
 			g_app_if[i].term();
+	}
 }
 
 /*
@@ -980,12 +919,8 @@ void oz_apps_term(void)
  */
 void oz_handle_app_elt(struct oz_pd *pd, u8 app_id, struct oz_elt *elt)
 {
-	const struct oz_app_if *ai;
-
-	if (app_id == 0 || app_id > OZ_APPID_MAX)
-		return;
-	ai = &g_app_if[app_id-1];
-	ai->rx(pd, elt);
+	if (app_id < OZ_NB_APPS && g_app_if[app_id].rx)
+		g_app_if[app_id].rx(pd, elt);
 }
 
 /*
@@ -994,7 +929,7 @@ void oz_handle_app_elt(struct oz_pd *pd, u8 app_id, struct oz_elt *elt)
 void oz_pd_indicate_farewells(struct oz_pd *pd)
 {
 	struct oz_farewell *f;
-	const struct oz_app_if *ai = &g_app_if[OZ_APPID_USB-1];
+	const struct oz_app_if *ai = &g_app_if[OZ_APPID_USB];
 
 	while (1) {
 		spin_lock_bh(&g_polling_lock);
diff --git a/drivers/staging/ozwpan/ozpd.h b/drivers/staging/ozwpan/ozpd.h
index ad5fe7a..3b3b3ce 100644
--- a/drivers/staging/ozwpan/ozpd.h
+++ b/drivers/staging/ozwpan/ozpd.h
@@ -81,8 +81,8 @@ struct oz_pd {
 	unsigned long	presleep;
 	unsigned long	keep_alive;
 	struct oz_elt_buf elt_buff;
-	void		*app_ctx[OZ_APPID_MAX];
-	spinlock_t	app_lock[OZ_APPID_MAX];
+	void		*app_ctx[OZ_NB_APPS];
+	spinlock_t	app_lock[OZ_NB_APPS];
 	int		max_tx_size;
 	u8		mode;
 	u8		ms_per_isoc;
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 4aebe16..549fe7f 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -614,7 +614,7 @@ struct oz_pd *oz_pd_find(const u8 *mac_addr)
  */
 void oz_app_enable(int app_id, int enable)
 {
-	if (app_id <= OZ_APPID_MAX) {
+	if (app_id < OZ_NB_APPS) {
 		spin_lock_bh(&g_polling_lock);
 		if (enable)
 			g_apps |= (1<<app_id);
diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
index 378b737..f1d30c4 100644
--- a/drivers/staging/ozwpan/ozproto.h
+++ b/drivers/staging/ozwpan/ozproto.h
@@ -46,7 +46,6 @@ struct oz_app_if {
 	oz_app_rx_fn_t		rx;
 	oz_app_heartbeat_fn_t	heartbeat;
 	oz_app_farewell_fn_t	farewell;
-	int			app_id;
 };
 
 int oz_protocol_init(char *devs);
diff --git a/drivers/staging/ozwpan/ozprotocol.h b/drivers/staging/ozwpan/ozprotocol.h
index 9bbb182..4642072 100644
--- a/drivers/staging/ozwpan/ozprotocol.h
+++ b/drivers/staging/ozwpan/ozprotocol.h
@@ -139,8 +139,6 @@ struct oz_app_hdr {
 /* Values for app_id.
  */
 #define OZ_APPID_USB				0x1
-#define OZ_APPID_UNUSED1			0x2
-#define OZ_APPID_UNUSED2			0x3
 #define OZ_APPID_SERIAL				0x4
 #define OZ_APPID_MAX				OZ_APPID_SERIAL
 #define OZ_NB_APPS				(OZ_APPID_MAX+1)
diff --git a/drivers/staging/ozwpan/ozusbsvc.c b/drivers/staging/ozwpan/ozusbsvc.c
index edd44c4..db4a387 100644
--- a/drivers/staging/ozwpan/ozusbsvc.c
+++ b/drivers/staging/ozwpan/ozusbsvc.c
@@ -73,12 +73,12 @@ int oz_usb_start(struct oz_pd *pd, int resume)
 	 * If it does already have one then destroy the one we have just
 	 * created.
 	 */
-	spin_lock_bh(&pd->app_lock[OZ_APPID_USB-1]);
-	old_ctx = pd->app_ctx[OZ_APPID_USB-1];
+	spin_lock_bh(&pd->app_lock[OZ_APPID_USB]);
+	old_ctx = pd->app_ctx[OZ_APPID_USB];
 	if (old_ctx == NULL)
-		pd->app_ctx[OZ_APPID_USB-1] = usb_ctx;
-	oz_usb_get(pd->app_ctx[OZ_APPID_USB-1]);
-	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB-1]);
+		pd->app_ctx[OZ_APPID_USB] = usb_ctx;
+	oz_usb_get(pd->app_ctx[OZ_APPID_USB]);
+	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB]);
 	if (old_ctx) {
 		oz_dbg(ON, "Already have USB context\n");
 		kfree(usb_ctx);
@@ -99,9 +99,9 @@ int oz_usb_start(struct oz_pd *pd, int resume)
 		usb_ctx->hport = oz_hcd_pd_arrived(usb_ctx);
 		if (usb_ctx->hport == NULL) {
 			oz_dbg(ON, "USB hub returned null port\n");
-			spin_lock_bh(&pd->app_lock[OZ_APPID_USB-1]);
-			pd->app_ctx[OZ_APPID_USB-1] = NULL;
-			spin_unlock_bh(&pd->app_lock[OZ_APPID_USB-1]);
+			spin_lock_bh(&pd->app_lock[OZ_APPID_USB]);
+			pd->app_ctx[OZ_APPID_USB] = NULL;
+			spin_unlock_bh(&pd->app_lock[OZ_APPID_USB]);
 			oz_usb_put(usb_ctx);
 			rc = -1;
 		}
@@ -122,10 +122,10 @@ void oz_usb_stop(struct oz_pd *pd, int pause)
 		oz_dbg(ON, "USB service paused\n");
 		return;
 	}
-	spin_lock_bh(&pd->app_lock[OZ_APPID_USB-1]);
-	usb_ctx = (struct oz_usb_ctx *)pd->app_ctx[OZ_APPID_USB-1];
-	pd->app_ctx[OZ_APPID_USB-1] = NULL;
-	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB-1]);
+	spin_lock_bh(&pd->app_lock[OZ_APPID_USB]);
+	usb_ctx = (struct oz_usb_ctx *) pd->app_ctx[OZ_APPID_USB];
+	pd->app_ctx[OZ_APPID_USB] = NULL;
+	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB]);
 	if (usb_ctx) {
 		struct timespec ts, now;
 		getnstimeofday(&ts);
@@ -187,11 +187,11 @@ int oz_usb_heartbeat(struct oz_pd *pd)
 	struct oz_usb_ctx *usb_ctx;
 	int rc = 0;
 
-	spin_lock_bh(&pd->app_lock[OZ_APPID_USB-1]);
-	usb_ctx = (struct oz_usb_ctx *)pd->app_ctx[OZ_APPID_USB-1];
+	spin_lock_bh(&pd->app_lock[OZ_APPID_USB]);
+	usb_ctx = (struct oz_usb_ctx *) pd->app_ctx[OZ_APPID_USB];
 	if (usb_ctx)
 		oz_usb_get(usb_ctx);
-	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB-1]);
+	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB]);
 	if (usb_ctx == NULL)
 		return rc;
 	if (usb_ctx->stopped)
diff --git a/drivers/staging/ozwpan/ozusbsvc1.c b/drivers/staging/ozwpan/ozusbsvc1.c
index f32d014..12bb236 100644
--- a/drivers/staging/ozwpan/ozusbsvc1.c
+++ b/drivers/staging/ozwpan/ozusbsvc1.c
@@ -364,11 +364,11 @@ void oz_usb_rx(struct oz_pd *pd, struct oz_elt *elt)
 	struct oz_usb_hdr *usb_hdr = (struct oz_usb_hdr *)(elt + 1);
 	struct oz_usb_ctx *usb_ctx;
 
-	spin_lock_bh(&pd->app_lock[OZ_APPID_USB-1]);
-	usb_ctx = (struct oz_usb_ctx *)pd->app_ctx[OZ_APPID_USB-1];
+	spin_lock_bh(&pd->app_lock[OZ_APPID_USB]);
+	usb_ctx = (struct oz_usb_ctx *)pd->app_ctx[OZ_APPID_USB];
 	if (usb_ctx)
 		oz_usb_get(usb_ctx);
-	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB-1]);
+	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB]);
 	if (usb_ctx == NULL)
 		return; /* Context has gone so nothing to do. */
 	if (usb_ctx->stopped)
@@ -434,11 +434,11 @@ void oz_usb_farewell(struct oz_pd *pd, u8 ep_num, u8 *data, u8 len)
 {
 	struct oz_usb_ctx *usb_ctx;
 
-	spin_lock_bh(&pd->app_lock[OZ_APPID_USB-1]);
-	usb_ctx = (struct oz_usb_ctx *)pd->app_ctx[OZ_APPID_USB-1];
+	spin_lock_bh(&pd->app_lock[OZ_APPID_USB]);
+	usb_ctx = (struct oz_usb_ctx *)pd->app_ctx[OZ_APPID_USB];
 	if (usb_ctx)
 		oz_usb_get(usb_ctx);
-	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB-1]);
+	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB]);
 	if (usb_ctx == NULL)
 		return; /* Context has gone so nothing to do. */
 	if (!usb_ctx->stopped) {
-- 
1.9.1

