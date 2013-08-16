Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab3HPEMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 00:12:22 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45902 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3HPEMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 00:12:15 -0400
From: Won Kang <wkang77@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        yongjun_wei@trendmicro.com.cn, joe@perches.com,
        sachin.kamat@linaro.org, Won Kang <wonkang@gctsemi.com>
Subject: [PATCH 2/2] staging: gdm7240: a TTY rewrite according to the latest TTY APIs
Date: Fri, 16 Aug 2013 13:13:44 +0900
Message-Id: <1376626424-2919-2-git-send-email-wonkang@gctsemi.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376626424-2919-1-git-send-email-wonkang@gctsemi.com>
References: <1376036357-7216-1-git-send-email-wonkang@gctsemi.com>
 <1376626424-2919-1-git-send-email-wonkang@gctsemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed mis-use of mutex for gdm_table. gdm_table is refered to only
inside tty_install and port destrcut, and usb callbacks use internal
reference which was saved during urb submission

Signed-off-by: Won Kang <wonkang@gctsemi.com>
---
 drivers/staging/gdm724x/gdm_mux.c |    9 ++++----
 drivers/staging/gdm724x/gdm_mux.h |   14 +++++++++---
 drivers/staging/gdm724x/gdm_tty.c |   45 ++++++++++++++++---------------------
 drivers/staging/gdm724x/gdm_tty.h |   33 ++++++++++++++++++---------
 4 files changed, 56 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_mux.c b/drivers/staging/gdm724x/gdm_mux.c
index b630bab..9e217ff 100644
--- a/drivers/staging/gdm724x/gdm_mux.c
+++ b/drivers/staging/gdm724x/gdm_mux.c
@@ -25,7 +25,6 @@
 #include <linux/usb/cdc.h>
 
 #include "gdm_mux.h"
-#include "gdm_tty.h"
 
 struct workqueue_struct *mux_rx_wq;
 
@@ -196,7 +195,7 @@ static int up_to_host(struct mux_rx *r)
 		ret = r->callback(mux_header->data,
 				payload_size,
 				index,
-				mux_dev->minor[index],
+				mux_dev->tty_dev,
 				RECV_PACKET_PROCESS_CONTINUE
 				);
 		if (ret == TO_HOST_BUFFER_REQUEST_FAIL) {
@@ -209,7 +208,7 @@ static int up_to_host(struct mux_rx *r)
 			ret = r->callback(NULL,
 					0,
 					index,
-					mux_dev->minor[index],
+					mux_dev->tty_dev,
 					RECV_PACKET_PROCESS_COMPLETE
 					);
 			break;
@@ -283,7 +282,7 @@ static void gdm_mux_rcv_complete(struct urb *urb)
 }
 
 static int gdm_mux_recv(void *priv_dev,
-			int (*cb)(void *data, int len, int tty_index, int minor, int complete)
+			int (*cb)(void *data, int len, int tty_index, struct tty_dev *tty_dev, int complete)
 			)
 {
 	struct mux_dev *mux_dev = priv_dev;
@@ -562,7 +561,7 @@ static int gdm_mux_probe(struct usb_interface *intf, const struct usb_device_id
 		goto out;
 	}
 	for (i = 0; i < TTY_MAX_COUNT; i++)
-		mux_dev->minor[i] = tty_dev->minor[i];
+		mux_dev->tty_dev = tty_dev;
 
 out:
 	if (ret < 0) {
diff --git a/drivers/staging/gdm724x/gdm_mux.h b/drivers/staging/gdm724x/gdm_mux.h
index d5b0b54..0163b24 100644
--- a/drivers/staging/gdm724x/gdm_mux.h
+++ b/drivers/staging/gdm724x/gdm_mux.h
@@ -18,6 +18,8 @@
 #include <linux/usb.h>
 #include <linux/list.h>
 
+#include "gdm_tty.h"
+
 #define PM_NORMAL 0
 #define PM_SUSPEND 1
 
@@ -57,7 +59,10 @@ struct mux_rx {
 	void *mux_dev;
 	u32 offset;
 	u32 len;
-	int (*callback)(void *data, int len, int tty_index, int minor,
+	int (*callback)(void *data,
+			int len,
+			int tty_index,
+			struct tty_dev *tty_dev,
 			int complete);
 };
 
@@ -78,10 +83,13 @@ struct mux_dev {
 	struct delayed_work work_rx;
 	struct usb_interface *intf;
 	int usb_state;
-	int (*rx_cb)(void *data, int len, int tty_index, int minor,
+	int (*rx_cb)(void *data,
+		     int len,
+		     int tty_index,
+		     struct tty_dev *tty_dev,
 		     int complete);
 	spinlock_t write_lock;
-	u8 minor[2];
+	struct tty_dev *tty_dev;
 };
 
 #endif /* _GDM_MUX_H_ */
diff --git a/drivers/staging/gdm724x/gdm_tty.c b/drivers/staging/gdm724x/gdm_tty.c
index 5bcf882..c1530b7 100644
--- a/drivers/staging/gdm724x/gdm_tty.c
+++ b/drivers/staging/gdm724x/gdm_tty.c
@@ -89,19 +89,22 @@ static int gdm_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 
 	mutex_lock(&gdm_table_lock);
 	gdm = gdm_table[i][j];
-	mutex_unlock(&gdm_table_lock);
-	if (gdm == NULL)
+	if (gdm == NULL) {
+		mutex_unlock(&gdm_table_lock);
 		return -ENODEV;
+	}
 
 	tty_port_get(&gdm->port);
 
 	ret = tty_standard_install(driver, tty);
 	if (ret) {
 		tty_port_put(&gdm->port);
+		mutex_unlock(&gdm_table_lock);
 		return ret;
 	}
 
 	tty->driver_data = gdm;
+	mutex_unlock(&gdm_table_lock);
 
 	return 0;
 }
@@ -130,14 +133,13 @@ static void gdm_tty_close(struct tty_struct *tty, struct file *filp)
 	tty_port_close(&gdm->port, tty, filp);
 }
 
-static int gdm_tty_recv_complete(void *data, int len, int index, int minor, int complete)
+static int gdm_tty_recv_complete(void *data,
+				 int len,
+				 int index,
+				 struct tty_dev *tty_dev,
+				 int complete)
 {
-	struct gdm *gdm;
-
-	mutex_lock(&gdm_table_lock);
-	gdm = gdm_table[index][minor];
-	mutex_unlock(&gdm_table_lock);
-
+	struct gdm *gdm = tty_dev->gdm[index];
 	if (!GDM_TTY_READY(gdm)) {
 		if (complete == RECV_PACKET_PROCESS_COMPLETE)
 			gdm_tty_recv(gdm, gdm_tty_recv_complete);
@@ -223,31 +225,29 @@ int register_lte_tty_device(struct tty_dev *tty_dev, struct device *device)
 			return -ENOMEM;
 
 		mutex_lock(&gdm_table_lock);
-
 		for (j = 0; j < GDM_TTY_MINOR; j++) {
 			if (!gdm_table[i][j])
 				break;
 		}
 
 		if (j == GDM_TTY_MINOR) {
-			tty_dev->minor[i] = GDM_TTY_MINOR;
+			kfree(gdm);
 			mutex_unlock(&gdm_table_lock);
 			return -EINVAL;
 		}
 
 		gdm_table[i][j] = gdm;
-
 		mutex_unlock(&gdm_table_lock);
 
-		tty_dev->minor[i] = j;
-
+		tty_dev->gdm[i] = gdm;
 		tty_port_init(&gdm->port);
+
 		gdm->port.ops = &gdm_port_ops;
 		gdm->index = i;
 		gdm->minor = j;
 		gdm->tty_dev = tty_dev;
 
-		tty_port_register_device(&gdm->port, gdm_driver[i], j, device);
+		tty_port_register_device(&gdm->port, gdm_driver[i], gdm->minor, device);
 	}
 
 	for (i = 0; i < MAX_ISSUE_NUM; i++)
@@ -261,31 +261,24 @@ void unregister_lte_tty_device(struct tty_dev *tty_dev)
 	struct gdm *gdm;
 	struct tty_struct *tty;
 	int i;
-	int j;
 
 	for (i = 0; i < TTY_MAX_COUNT; i++) {
-
-		j = tty_dev->minor[i];
-
-		if (j >= GDM_TTY_MINOR)
+		gdm = tty_dev->gdm[i];
+		if (!gdm)
 			continue;
 
 		mutex_lock(&gdm_table_lock);
-		gdm = gdm_table[i][j];
+		gdm_table[gdm->index][gdm->minor] = NULL;
 		mutex_unlock(&gdm_table_lock);
 
-		if (!gdm)
-			continue;
-
 		tty = tty_port_tty_get(&gdm->port);
 		if (tty) {
 			tty_vhangup(tty);
 			tty_kref_put(tty);
 		}
 
-		tty_unregister_device(gdm_driver[i], j);
+		tty_unregister_device(gdm_driver[i], gdm->minor);
 		tty_port_put(&gdm->port);
-
 	}
 }
 
diff --git a/drivers/staging/gdm724x/gdm_tty.h b/drivers/staging/gdm724x/gdm_tty.h
index 64db5e6..297438b 100644
--- a/drivers/staging/gdm724x/gdm_tty.h
+++ b/drivers/staging/gdm724x/gdm_tty.h
@@ -33,17 +33,6 @@ enum RECV_PACKET_PROCESS {
 	RECV_PACKET_PROCESS_CONTINUE = 1,
 };
 
-struct tty_dev {
-	void *priv_dev;
-	int (*send_func)(void *priv_dev, void *data, int len, int tty_index,
-			void (*cb)(void *cb_data), void *cb_data);
-	int (*recv_func)(void *priv_dev, int (*cb)(void *data, int len,
-			 int tty_index, int minor, int complete));
-	int (*send_control)(void *priv_dev, int request, int value, void *data,
-			    int len);
-	u8 minor[2];
-};
-
 struct gdm {
 	struct tty_dev *tty_dev;
 	struct tty_port port;
@@ -51,6 +40,28 @@ struct gdm {
 	unsigned int minor;
 };
 
+struct tty_dev {
+	void *priv_dev;
+	int (*send_func)(void *priv_dev,
+			 void *data,
+			 int len,
+			 int tty_index,
+			 void (*cb)(void *cb_data),
+			 void *cb_data);
+	int (*recv_func)(void *priv_dev,
+			 int (*cb)(void *data,
+				   int len,
+				   int tty_index,
+				   struct tty_dev *tty_dev,
+				   int complete));
+	int (*send_control)(void *priv_dev,
+			    int request,
+			    int value,
+			    void *data,
+			    int len);
+	struct gdm *gdm[2];
+};
+
 int register_lte_tty_driver(void);
 void unregister_lte_tty_driver(void);
 int register_lte_tty_device(struct tty_dev *tty_dev, struct device *dev);
-- 
1.7.10.4

