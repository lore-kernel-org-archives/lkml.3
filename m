Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030581Ab3HIISI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 04:18:08 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:44201 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967685Ab3HIISC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 04:18:02 -0400
From: Won Kang <wkang77@gmail.com>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, joe@perches.co, sachin.kamat@linaro.org,
        Won Kang <wonkang@gctsemi.com>
Subject: [PATCH] staging: gdm7240: a TTY rewrite according to the latest TTY APIs
Date: Fri,  9 Aug 2013 17:19:17 +0900
Message-Id: <1376036357-7216-1-git-send-email-wonkang@gctsemi.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the old style reference countings and termios.
Renamed variables to meaninful ones.

Signed-off-by: Won Kang <wonkang@gctsemi.com>
---
 drivers/staging/gdm724x/gdm_tty.c |  294 ++++++++++++++++++-------------------
 drivers/staging/gdm724x/gdm_tty.h |    5 +-
 2 files changed, 142 insertions(+), 157 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_tty.c b/drivers/staging/gdm724x/gdm_tty.c
index 912022b..5bcf882 100644
--- a/drivers/staging/gdm724x/gdm_tty.c
+++ b/drivers/staging/gdm724x/gdm_tty.c
@@ -45,141 +45,138 @@
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
 		return -ENODEV;
-	}
 
-	set_bit(TTY_NO_WRITE_SPLIT, &tty->flags);
+	mutex_lock(&gdm_table_lock);
+	gdm = gdm_table[i][j];
+	mutex_unlock(&gdm_table_lock);
+	if (gdm == NULL)
+		return -ENODEV;
 
-	tty->driver_data = tty_str;
-	tty_port_tty_set(&tty_str->port, tty);
-	tty_str->port.count++;
-	set_bit(ASYNCB_INITIALIZED, &tty_str->port.flags);
-	ret = tty_port_block_til_ready(&tty_str->port, tty, filp);
+	tty_port_get(&gdm->port);
 
-	mutex_unlock(&open_mutex);
+	ret = tty_standard_install(driver, tty);
+	if (ret) {
+		tty_port_put(&gdm->port);
+		return ret;
+	}
 
-	return ret;
+	tty->driver_data = gdm;
+
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
+	struct gdm *gdm = tty->driver_data;
+	return tty_port_open(&gdm->port, tty, filp);
+}
 
-		if (tty_str->port.count == 0)
-			tty_port_tty_set(&tty_str->port, NULL);
-			tty_str->port.tty = NULL;
-	}
+static void gdm_tty_cleanup(struct tty_struct *tty)
+{
+	struct gdm *gdm = tty->driver_data;
+	tty_port_put(&gdm->port);
+}
 
-	if (!tty_str->tty_dev) {
-		for (i = 0; i < TTY_MAX_COUNT; i++) {
-			if (!strcmp(tty->driver->driver_name, DRIVER_STRING[i]))
-				break;
-		}
+static void gdm_tty_hangup(struct tty_struct *tty)
+{
+	struct gdm *gdm = tty->driver_data;
+	tty_port_hangup(&gdm->port);
+}
 
-		if (i < TTY_MAX_COUNT) {
-			tty_unregister_device(g_tty_drv[i], tty->index);
-			tty_port_tty_set(&tty_str->port, NULL);
-			kfree(tty_str);
-			g_tty_str[i][tty->index] = NULL;
-		}
-	}
+static void gdm_tty_close(struct tty_struct *tty, struct file *filp)
+{
+	struct gdm *gdm = tty->driver_data;
+	tty_port_close(&gdm->port, tty, filp);
 }
 
 static int gdm_tty_recv_complete(void *data, int len, int index, int minor, int complete)
 {
-	struct tty_str *tty_str = g_tty_str[index][minor];
-	struct tty_port *tty_port;
+	struct gdm *gdm;
 
-	if (!GDM_TTY_READY(tty_str)) {
+	mutex_lock(&gdm_table_lock);
+	gdm = gdm_table[index][minor];
+	mutex_unlock(&gdm_table_lock);
+
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
@@ -187,12 +184,12 @@ static int gdm_tty_write(struct tty_struct *tty, const unsigned char *buf, int l
 
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
@@ -205,131 +202,113 @@ static int gdm_tty_write(struct tty_struct *tty, const unsigned char *buf, int l
 
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
+	struct gdm *gdm;
+	int i;
+	int j;
 
-	if (!GDM_TTY_READY(tty_str))
-		return -ENODEV;
+	for (i = 0; i < TTY_MAX_COUNT; i++) {
 
-	return 1;
-}
+		gdm = kmalloc(sizeof(struct gdm), GFP_KERNEL);
+		if (!gdm)
+			return -ENOMEM;
 
-int register_lte_tty_device(struct tty_dev *tty_dev, struct device *dev)
-{
-	struct tty_str *tty_str;
-	int i, j;
+		mutex_lock(&gdm_table_lock);
 
-	for (i = 0; i < TTY_MAX_COUNT; i++) {
 		for (j = 0; j < GDM_TTY_MINOR; j++) {
-			if (!g_tty_str[i][j])
+			if (!gdm_table[i][j])
 				break;
 		}
 
 		if (j == GDM_TTY_MINOR) {
-			tty_dev->minor[i] = j;
-			return -1;
+			tty_dev->minor[i] = GDM_TTY_MINOR;
+			mutex_unlock(&gdm_table_lock);
+			return -EINVAL;
 		}
 
-		tty_str = kmalloc(sizeof(struct tty_str), GFP_KERNEL);
-		if (!tty_str)
-			return -ENOMEM;
+		gdm_table[i][j] = gdm;
 
-		g_tty_str[i][j] = tty_str;
+		mutex_unlock(&gdm_table_lock);
 
-		tty_str->tty_dev = tty_dev;
-		tty_str->tty_drv_index = i;
 		tty_dev->minor[i] = j;
-		tty_port_init(&tty_str->port);
-		tty_str->port.ops = &gdm_tty_port_ops;
 
-		if (strcmp(DEVICE_STRING[i], "GCT-ATC") != 0)
-			dev = NULL;
-		tty_register_device(g_tty_drv[i], j, dev);
-	}
+		tty_port_init(&gdm->port);
+		gdm->port.ops = &gdm_port_ops;
+		gdm->index = i;
+		gdm->minor = j;
+		gdm->tty_dev = tty_dev;
 
-	acm_set_comm_feature(tty_str, 1);
+		tty_port_register_device(&gdm->port, gdm_driver[i], j, device);
+	}
 
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
+	int j;
 
 	for (i = 0; i < TTY_MAX_COUNT; i++) {
-		if (tty_dev->minor[i] >= GDM_TTY_MINOR)
-			continue;
 
-		tty_str = g_tty_str[i][tty_dev->minor[i]];
-		if (!tty_str)
+		j = tty_dev->minor[i];
+
+		if (j >= GDM_TTY_MINOR)
 			continue;
 
-		tty_str->tty_dev = NULL;
+		mutex_lock(&gdm_table_lock);
+		gdm = gdm_table[i][j];
+		mutex_unlock(&gdm_table_lock);
 
-		if (!tty_str->port.count) {
-			tty_unregister_device(g_tty_drv[i], tty_dev->minor[i]);
-			tty_port_tty_set(&tty_str->port, NULL);
-			kfree(tty_str);
-			g_tty_str[i][tty_dev->minor[i]] = NULL;
+		if (!gdm)
+			continue;
+
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
+		tty_unregister_device(gdm_driver[i], j);
+		tty_port_put(&gdm->port);
+
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
@@ -344,8 +323,12 @@ int register_lte_tty_driver(void)
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
@@ -357,10 +340,11 @@ void unregister_lte_tty_driver(void)
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
index a75be1d..64db5e6 100644
--- a/drivers/staging/gdm724x/gdm_tty.h
+++ b/drivers/staging/gdm724x/gdm_tty.h
@@ -44,10 +44,11 @@ struct tty_dev {
 	u8 minor[2];
 };
 
-struct tty_str {
+struct gdm {
 	struct tty_dev *tty_dev;
-	int tty_drv_index;
 	struct tty_port port;
+	unsigned int index;
+	unsigned int minor;
 };
 
 int register_lte_tty_driver(void);
-- 
1.7.10.4

