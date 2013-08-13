Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab3HMKow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:44:52 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34867 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147Ab3HMKou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:44:50 -0400
From: Won Kang <wkang77@gmail.com>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, wonkang@gctsemi.com, dan.carpenter@oracle.com,
        yongjun_wei@trendmicro.com.cn, joe@perches.com,
        sachin.kamat@linaro.org
Subject: [PATCH v2] staging: gdm7240: a TTY rewrite according to the latest TTY APIs
Date: Tue, 13 Aug 2013 19:46:01 +0900
Message-Id: <1376390761-31545-1-git-send-email-wonkang@gctsemi.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376036357-7216-1-git-send-email-wonkang@gctsemi.com>
References: <1376036357-7216-1-git-send-email-wonkang@gctsemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the old style reference countings and termios.
Renamed variables to meaninful ones.

Fixed mis-use of mutex for gdm_table. gdm_table is refered to only
inside tty_install and port destrcut, and usb callbacks use internal
reference which was saved during urb submission

Signed-off-by: Won Kang <wonkang@gctsemi.com>
---
v2: fixed mutex bug, added ChangeLog, added missing kfree
 drivers/staging/gdm724x/ChangeLog |   62 ++++++++
 drivers/staging/gdm724x/gdm_mux.c |    9 +-
 drivers/staging/gdm724x/gdm_mux.h |   14 +-
 drivers/staging/gdm724x/gdm_tty.c |  295 +++++++++++++++++--------------------
 drivers/staging/gdm724x/gdm_tty.h |   36 +++--
 5 files changed, 237 insertions(+), 179 deletions(-)
 create mode 100644 drivers/staging/gdm724x/ChangeLog

diff --git a/drivers/staging/gdm724x/ChangeLog b/drivers/staging/gdm724x/ChangeLog
new file mode 100644
index 0000000..506e60e
--- /dev/null
+++ b/drivers/staging/gdm724x/ChangeLog
@@ -0,0 +1,62 @@
+2013-08-13  Won Kang <wonkang@gctsemi.com>
+	* Fixed mis-use of mutex for gdm_table. gdm_table is refered to only
+	* inside tty_install and port destrcut, and usb callbacks use internal
+	* reference which was saved during urb submission
+
+2013-08-09  Won Kang <wonkang@gctsemi.com>
+	* A rewrite was needed to properly use latest TTY AAPI
+	*
+	* Original TTY codes were written from kernel 2.6.x, doing tty reference
+	* counting within the this driver. This is fixed to use tty core APIs.
+	*
+	* The usage count of tty port is no longer handled by the driver.
+	*
+	* termios members of tty_operations as the ports are virtual and
+	* have no real effect.
+	*
+	* Renamed variables to be more clear as they were confusing due to the
+	* similarities with the tty core structures.
+
+2013-07-29 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+	* The driver uses the tty layer, so explicitly say that, to prevent
+	* randomconfig build errors.
+
+2013-07-27 Won Kang <wonkang@gctsemi.com>
+	* Modified function name conflict set_endian
+
+2013-07-29 Wei Yongjun <yongjun_wei@trendmicro.com.cn>
+	* Removed duplicated include from gdm_lte.c
+
+2013-07-26 Wei Yongjun <yongjun_wei@trendmicro.com.cn>
+	* Modified to use GFP_ATOMIC under spin lock
+
+2013-07-25 Sachin Kamat <sachin.kamat@linaro.org>
+	* Remove version.h header inclusion in gdm_usb.h
+	* Remove version.h header inclusion in gdm_usb.c
+	* Remove version.h header inclusion in gdm_tty.h
+	* Remove version.h header inclusion in gdm_tty.c
+	* Remove version.h header inclusion in gdm_mux.c
+	* Remove version.h header inclusion in gdm_lte.h
+	* Remove version.h header inclusion in gdm_lte.c
+
+2013-07-25 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+	* Remove ioctl call
+
+2013-07-24 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+	* Prevent module from being built in
+
+2013-07-24 Joe Perches <joe@perches.com>
+	* Make the logging prefixes match the module names
+	* by adding #define pr_fmt(fmt) KBUILD_MODNAME and
+	* converting printks to netdev_<level> when a
+	* struct netdevice * is available and and pr_<level>
+	* when not.
+
+2013-07-24 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+	* fix up line lengths in the .h files
+	* remove unneeded TO_HOST_SUCCESS enum
+	* add tty stuff to TODO file
+	* gdm_tty: fix tty api build warnings
+
+2013-07-25 Won Kang <wonkang@gctsemi.com>
+	* adding LTE USB driver
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
index 912022b..c1530b7 100644
--- a/drivers/staging/gdm724x/gdm_tty.c
+++ b/drivers/staging/gdm724x/gdm_tty.c
@@ -45,141 +45,140 @@
 #define gdm_tty_send_control(n, r, v, d, l) (\
 	n->tty_dev->send_control(n->tty_dev->priv_dev, r, v, d, l))
 
-#define acm_set_comm_feature(n, v)	\
-	gdm_tty_send_control(n, 0x02, v, NULL, 0)
+#define GDM_TTY_READY(gdm) (gdm && gdm->tty_dev && gdm->port.count)
 
-#define GDM_TTY_READY(tty_str) (tty_str && tty_str->tty_dev && tty_str->port.count)
-
-struct tty_driver *g_tty_drv[TTY_MAX_COUNT] = {NULL, };
-struct tty_str *g_tty_str[TTY_MAX_COUNT][GDM_TTY_MINOR] = {{NULL, }, };
+struct tty_driver *gdm_driver[TTY_MAX_COUNT];
+struct gdm *gdm_table[TTY_MAX_COUNT][GDM_TTY_MINOR];
+static DEFINE_MUTEX(gdm_table_lock);
 
 static char *DRIVER_STRING[TTY_MAX_COUNT] = {"GCTATC", "GCTDM"};
 static char *DEVICE_STRING[TTY_MAX_COUNT] = {"GCT-ATC", "GCT-DM"};
 
-static DEFINE_MUTEX(open_mutex);
+static void gdm_port_destruct(struct tty_port *port)
+{
+	struct gdm *gdm = container_of(port, struct gdm, port);
+
+	mutex_lock(&gdm_table_lock);
+	gdm_table[gdm->index][gdm->minor] = NULL;
+	mutex_unlock(&gdm_table_lock);
+
+	kfree(gdm);
+}
 
-static struct tty_port_operations gdm_tty_port_ops = {
+static struct tty_port_operations gdm_port_ops = {
+	.destruct = gdm_port_destruct,
 };
 
-static int gdm_tty_open(struct tty_struct *tty, struct file *filp)
+static int gdm_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 {
-	struct tty_str *tty_str = NULL;
+	struct gdm *gdm = NULL;
+	int ret;
 	int i;
-	int ret = 0;
-
-	mutex_lock(&open_mutex);
+	int j;
 
+	j = GDM_TTY_MINOR;
 	for (i = 0; i < TTY_MAX_COUNT; i++) {
 		if (!strcmp(tty->driver->driver_name, DRIVER_STRING[i])) {
-			tty_str = g_tty_str[i][tty->index];
+			j = tty->index;
 			break;
 		}
 	}
 
-	if (!tty_str) {
-		pr_info("no tty device\n");
-		mutex_unlock(&open_mutex);
+	if (j == GDM_TTY_MINOR)
+		return -ENODEV;
+
+	mutex_lock(&gdm_table_lock);
+	gdm = gdm_table[i][j];
+	if (gdm == NULL) {
+		mutex_unlock(&gdm_table_lock);
 		return -ENODEV;
 	}
 
-	set_bit(TTY_NO_WRITE_SPLIT, &tty->flags);
+	tty_port_get(&gdm->port);
 
-	tty->driver_data = tty_str;
-	tty_port_tty_set(&tty_str->port, tty);
-	tty_str->port.count++;
-	set_bit(ASYNCB_INITIALIZED, &tty_str->port.flags);
-	ret = tty_port_block_til_ready(&tty_str->port, tty, filp);
+	ret = tty_standard_install(driver, tty);
+	if (ret) {
+		tty_port_put(&gdm->port);
+		mutex_unlock(&gdm_table_lock);
+		return ret;
+	}
 
-	mutex_unlock(&open_mutex);
+	tty->driver_data = gdm;
+	mutex_unlock(&gdm_table_lock);
 
-	return ret;
+	return 0;
 }
 
-static void gdm_tty_close(struct tty_struct *tty, struct file *filp)
+static int gdm_tty_open(struct tty_struct *tty, struct file *filp)
 {
-	struct tty_str *tty_str = tty->driver_data;
-	int i;
-
-	if (!tty_str) {
-		pr_info("tty device already closed\n");
-		return;
-	}
-
-	if (tty_str->port.count != 0) {
-		tty_port_close_start(&tty_str->port, tty, filp);
-		tty_port_close_end(&tty_str->port, tty);
-
-		if (tty_str->port.count == 0)
-			tty_port_tty_set(&tty_str->port, NULL);
-			tty_str->port.tty = NULL;
-	}
+	struct gdm *gdm = tty->driver_data;
+	return tty_port_open(&gdm->port, tty, filp);
+}
 
-	if (!tty_str->tty_dev) {
-		for (i = 0; i < TTY_MAX_COUNT; i++) {
-			if (!strcmp(tty->driver->driver_name, DRIVER_STRING[i]))
-				break;
-		}
+static void gdm_tty_cleanup(struct tty_struct *tty)
+{
+	struct gdm *gdm = tty->driver_data;
+	tty_port_put(&gdm->port);
+}
 
-		if (i < TTY_MAX_COUNT) {
-			tty_unregister_device(g_tty_drv[i], tty->index);
-			tty_port_tty_set(&tty_str->port, NULL);
-			kfree(tty_str);
-			g_tty_str[i][tty->index] = NULL;
-		}
-	}
+static void gdm_tty_hangup(struct tty_struct *tty)
+{
+	struct gdm *gdm = tty->driver_data;
+	tty_port_hangup(&gdm->port);
 }
 
-static int gdm_tty_recv_complete(void *data, int len, int index, int minor, int complete)
+static void gdm_tty_close(struct tty_struct *tty, struct file *filp)
 {
-	struct tty_str *tty_str = g_tty_str[index][minor];
-	struct tty_port *tty_port;
+	struct gdm *gdm = tty->driver_data;
+	tty_port_close(&gdm->port, tty, filp);
+}
 
-	if (!GDM_TTY_READY(tty_str)) {
+static int gdm_tty_recv_complete(void *data,
+				 int len,
+				 int index,
+				 struct tty_dev *tty_dev,
+				 int complete)
+{
+	struct gdm *gdm = tty_dev->gdm[index];
+	if (!GDM_TTY_READY(gdm)) {
 		if (complete == RECV_PACKET_PROCESS_COMPLETE)
-			gdm_tty_recv(tty_str, gdm_tty_recv_complete);
+			gdm_tty_recv(gdm, gdm_tty_recv_complete);
 		return TO_HOST_PORT_CLOSE;
 	}
 
-	if (!data || !len)
-		goto complete_routine;
-
-	tty_port = &tty_str->port;
-
-	if (tty_buffer_request_room(tty_port, len) == len) {
-		tty_insert_flip_string(tty_port, data, len);
-		tty_flip_buffer_push(tty_port);
-	} else {
-		return TO_HOST_BUFFER_REQUEST_FAIL;
+	if (data && len) {
+		if (tty_buffer_request_room(&gdm->port, len) == len) {
+			tty_insert_flip_string(&gdm->port, data, len);
+			tty_flip_buffer_push(&gdm->port);
+		} else {
+			return TO_HOST_BUFFER_REQUEST_FAIL;
+		}
 	}
 
-complete_routine:
 	if (complete == RECV_PACKET_PROCESS_COMPLETE)
-		gdm_tty_recv(tty_str, gdm_tty_recv_complete);
+		gdm_tty_recv(gdm, gdm_tty_recv_complete);
 
 	return 0;
 }
 
 static void gdm_tty_send_complete(void *arg)
 {
-	struct tty_str *tty_str = (struct tty_str *)arg;
-	struct tty_struct *tty;
+	struct gdm *gdm = (struct gdm *)arg;
 
-	if (!GDM_TTY_READY(tty_str))
+	if (!GDM_TTY_READY(gdm))
 		return;
 
-	tty = tty_port_tty_get(&tty_str->port);
-	tty_wakeup(tty);
-	tty_kref_put(tty);
+	tty_port_tty_wakeup(&gdm->port);
 }
 
 static int gdm_tty_write(struct tty_struct *tty, const unsigned char *buf, int len)
 {
-	struct tty_str *tty_str = tty->driver_data;
+	struct gdm *gdm = tty->driver_data;
 	int remain = len;
 	int sent_len = 0;
 	int sending_len = 0;
 
-	if (!GDM_TTY_READY(tty_str))
+	if (!GDM_TTY_READY(gdm))
 		return -ENODEV;
 
 	if (!len)
@@ -187,12 +186,12 @@ static int gdm_tty_write(struct tty_struct *tty, const unsigned char *buf, int l
 
 	while (1) {
 		sending_len = remain > MUX_TX_MAX_SIZE ? MUX_TX_MAX_SIZE : remain;
-		gdm_tty_send(tty_str,
+		gdm_tty_send(gdm,
 			     (void *)(buf+sent_len),
 			     sending_len,
-			     tty_str->tty_drv_index,
+			     gdm->index,
 			     gdm_tty_send_complete,
-			     tty_str
+			     gdm
 			    );
 		sent_len += sending_len;
 		remain -= sending_len;
@@ -205,131 +204,104 @@ static int gdm_tty_write(struct tty_struct *tty, const unsigned char *buf, int l
 
 static int gdm_tty_write_room(struct tty_struct *tty)
 {
-	struct tty_str *tty_str = tty->driver_data;
+	struct gdm *gdm = tty->driver_data;
 
-	if (!GDM_TTY_READY(tty_str))
+	if (!GDM_TTY_READY(gdm))
 		return -ENODEV;
 
 	return WRITE_SIZE;
 }
 
-static int gdm_tty_tiocmget(struct tty_struct *tty)
-{
-	struct tty_str *tty_str = tty->driver_data;
-
-	if (!GDM_TTY_READY(tty_str))
-		return -ENODEV;
-
-	return (0 & ACM_CTRL_DTR ? TIOCM_DTR : 0) |
-	       (0 & ACM_CTRL_RTS ? TIOCM_RTS : 0) |
-	       (0 & ACM_CTRL_DSR ? TIOCM_DSR : 0) |
-	       (0 & ACM_CTRL_RI  ? TIOCM_RI  : 0) |
-	       (0 & ACM_CTRL_DCD ? TIOCM_CD  : 0) |
-	       TIOCM_CTS;
-}
-
-static int gdm_tty_tiocmset(struct tty_struct *tty, unsigned int set, unsigned int clear)
+int register_lte_tty_device(struct tty_dev *tty_dev, struct device *device)
 {
-	struct tty_str *tty_str = tty->driver_data;
-
-	if (!GDM_TTY_READY(tty_str))
-		return -ENODEV;
+	struct gdm *gdm;
+	int i;
+	int j;
 
-	return 1;
-}
+	for (i = 0; i < TTY_MAX_COUNT; i++) {
 
-int register_lte_tty_device(struct tty_dev *tty_dev, struct device *dev)
-{
-	struct tty_str *tty_str;
-	int i, j;
+		gdm = kmalloc(sizeof(struct gdm), GFP_KERNEL);
+		if (!gdm)
+			return -ENOMEM;
 
-	for (i = 0; i < TTY_MAX_COUNT; i++) {
+		mutex_lock(&gdm_table_lock);
 		for (j = 0; j < GDM_TTY_MINOR; j++) {
-			if (!g_tty_str[i][j])
+			if (!gdm_table[i][j])
 				break;
 		}
 
 		if (j == GDM_TTY_MINOR) {
-			tty_dev->minor[i] = j;
-			return -1;
+			kfree(gdm);
+			mutex_unlock(&gdm_table_lock);
+			return -EINVAL;
 		}
 
-		tty_str = kmalloc(sizeof(struct tty_str), GFP_KERNEL);
-		if (!tty_str)
-			return -ENOMEM;
+		gdm_table[i][j] = gdm;
+		mutex_unlock(&gdm_table_lock);
 
-		g_tty_str[i][j] = tty_str;
+		tty_dev->gdm[i] = gdm;
+		tty_port_init(&gdm->port);
 
-		tty_str->tty_dev = tty_dev;
-		tty_str->tty_drv_index = i;
-		tty_dev->minor[i] = j;
-		tty_port_init(&tty_str->port);
-		tty_str->port.ops = &gdm_tty_port_ops;
+		gdm->port.ops = &gdm_port_ops;
+		gdm->index = i;
+		gdm->minor = j;
+		gdm->tty_dev = tty_dev;
 
-		if (strcmp(DEVICE_STRING[i], "GCT-ATC") != 0)
-			dev = NULL;
-		tty_register_device(g_tty_drv[i], j, dev);
+		tty_port_register_device(&gdm->port, gdm_driver[i], gdm->minor, device);
 	}
 
-	acm_set_comm_feature(tty_str, 1);
-
 	for (i = 0; i < MAX_ISSUE_NUM; i++)
-		gdm_tty_recv(tty_str, gdm_tty_recv_complete);
+		gdm_tty_recv(gdm, gdm_tty_recv_complete);
 
 	return 0;
 }
 
 void unregister_lte_tty_device(struct tty_dev *tty_dev)
 {
-	struct tty_str *tty_str;
+	struct gdm *gdm;
+	struct tty_struct *tty;
 	int i;
 
 	for (i = 0; i < TTY_MAX_COUNT; i++) {
-		if (tty_dev->minor[i] >= GDM_TTY_MINOR)
-			continue;
-
-		tty_str = g_tty_str[i][tty_dev->minor[i]];
-		if (!tty_str)
+		gdm = tty_dev->gdm[i];
+		if (!gdm)
 			continue;
 
-		tty_str->tty_dev = NULL;
+		mutex_lock(&gdm_table_lock);
+		gdm_table[gdm->index][gdm->minor] = NULL;
+		mutex_unlock(&gdm_table_lock);
 
-		if (!tty_str->port.count) {
-			tty_unregister_device(g_tty_drv[i], tty_dev->minor[i]);
-			tty_port_tty_set(&tty_str->port, NULL);
-			kfree(tty_str);
-			g_tty_str[i][tty_dev->minor[i]] = NULL;
+		tty = tty_port_tty_get(&gdm->port);
+		if (tty) {
+			tty_vhangup(tty);
+			tty_kref_put(tty);
 		}
-	}
-}
 
-static void gdm_tty_set_termios(struct tty_struct *tty, struct ktermios *termios_old)
-{
-	return;
+		tty_unregister_device(gdm_driver[i], gdm->minor);
+		tty_port_put(&gdm->port);
+	}
 }
 
 static const struct tty_operations gdm_tty_ops = {
-	.open = gdm_tty_open,
-	.close = gdm_tty_close,
-	.write = gdm_tty_write,
-	.write_room = gdm_tty_write_room,
-	.tiocmget = gdm_tty_tiocmget,
-	.tiocmset = gdm_tty_tiocmset,
-	.set_termios = gdm_tty_set_termios,
+	.install =	gdm_tty_install,
+	.open =		gdm_tty_open,
+	.close =	gdm_tty_close,
+	.cleanup =	gdm_tty_cleanup,
+	.hangup =	gdm_tty_hangup,
+	.write =	gdm_tty_write,
+	.write_room =	gdm_tty_write_room,
 };
 
 int register_lte_tty_driver(void)
 {
-	struct tty_driver *tty_driver = NULL;
+	struct tty_driver *tty_driver;
 	int i;
 	int ret;
 
 	for (i = 0; i < TTY_MAX_COUNT; i++) {
 		tty_driver = alloc_tty_driver(GDM_TTY_MINOR);
-		if (!tty_driver) {
-			pr_err("alloc_tty_driver fail\n");
+		if (!tty_driver)
 			return -ENOMEM;
-		}
 
 		tty_driver->owner = THIS_MODULE;
 		tty_driver->driver_name = DRIVER_STRING[i];
@@ -344,8 +316,12 @@ int register_lte_tty_driver(void)
 		tty_set_operations(tty_driver, &gdm_tty_ops);
 
 		ret = tty_register_driver(tty_driver);
+		if (ret) {
+			put_tty_driver(tty_driver);
+			return ret;
+		}
 
-		g_tty_drv[i] = tty_driver;
+		gdm_driver[i] = tty_driver;
 	}
 
 	return ret;
@@ -357,10 +333,11 @@ void unregister_lte_tty_driver(void)
 	int i;
 
 	for (i = 0; i < TTY_MAX_COUNT; i++) {
-		tty_driver = g_tty_drv[i];
+		tty_driver = gdm_driver[i];
 		if (tty_driver) {
 			tty_unregister_driver(tty_driver);
 			put_tty_driver(tty_driver);
 		}
 	}
 }
+
diff --git a/drivers/staging/gdm724x/gdm_tty.h b/drivers/staging/gdm724x/gdm_tty.h
index a75be1d..297438b 100644
--- a/drivers/staging/gdm724x/gdm_tty.h
+++ b/drivers/staging/gdm724x/gdm_tty.h
@@ -33,21 +33,33 @@ enum RECV_PACKET_PROCESS {
 	RECV_PACKET_PROCESS_CONTINUE = 1,
 };
 
+struct gdm {
+	struct tty_dev *tty_dev;
+	struct tty_port port;
+	unsigned int index;
+	unsigned int minor;
+};
+
 struct tty_dev {
 	void *priv_dev;
-	int (*send_func)(void *priv_dev, void *data, int len, int tty_index,
-			void (*cb)(void *cb_data), void *cb_data);
-	int (*recv_func)(void *priv_dev, int (*cb)(void *data, int len,
-			 int tty_index, int minor, int complete));
-	int (*send_control)(void *priv_dev, int request, int value, void *data,
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
 			    int len);
-	u8 minor[2];
-};
-
-struct tty_str {
-	struct tty_dev *tty_dev;
-	int tty_drv_index;
-	struct tty_port port;
+	struct gdm *gdm[2];
 };
 
 int register_lte_tty_driver(void);
-- 
1.7.10.4

