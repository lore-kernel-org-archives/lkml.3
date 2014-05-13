Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562AbaEMKkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:40:23 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60748 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760020AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 029/182] s390/cio: fix driver callback initialization for ccw consoles
Date: Tue, 13 May 2014 11:26:21 +0200
Message-Id: <7389fa84b9505ca2b429f4f7ae5d1a317abc11c4.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2253e8d79237c69086ded391e6767afe16972527 upstream.

ccw consoles are in use before they can be properly registered with
the driver core. For devices which are in use by a device driver we
rely on the ccw_device's pointer to the driver callbacks to be valid.
For ccw consoles this pointer is NULL until they are registered later
during boot and we dereferenced this pointer. This worked by
chance on 64 bit builds (cdev->drv was NULL but the optional callback
cdev->drv->path_event was also NULL by coincidence) and was unnoticed
until we received reports about boot failures on 31 bit systems.
Fix it by initializing the driver pointer for ccw consoles.

Reported-by: Mike Frysinger <vapier@gentoo.org>
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/s390/include/asm/ccwdev.h |  2 +-
 drivers/s390/char/con3215.c    |  2 +-
 drivers/s390/char/con3270.c    |  6 +-----
 drivers/s390/char/raw3270.c    | 10 +++++++++-
 drivers/s390/char/raw3270.h    |  2 +-
 drivers/s390/cio/device.c      |  3 ++-
 6 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/s390/include/asm/ccwdev.h b/arch/s390/include/asm/ccwdev.h
index f201af8be580..31b5ca8f8c3d 100644
--- a/arch/s390/include/asm/ccwdev.h
+++ b/arch/s390/include/asm/ccwdev.h
@@ -219,7 +219,7 @@ extern void ccw_device_get_id(struct ccw_device *, struct ccw_dev_id *);
 #define to_ccwdev(n) container_of(n, struct ccw_device, dev)
 #define to_ccwdrv(n) container_of(n, struct ccw_driver, driver)
 
-extern struct ccw_device *ccw_device_probe_console(void);
+extern struct ccw_device *ccw_device_probe_console(struct ccw_driver *);
 extern void ccw_device_wait_idle(struct ccw_device *);
 extern int ccw_device_force_console(struct ccw_device *);
 
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index eb5d22795c47..bb86494e2b7b 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -922,7 +922,7 @@ static int __init con3215_init(void)
 		raw3215_freelist = req;
 	}
 
-	cdev = ccw_device_probe_console();
+	cdev = ccw_device_probe_console(&raw3215_ccw_driver);
 	if (IS_ERR(cdev))
 		return -ENODEV;
 
diff --git a/drivers/s390/char/con3270.c b/drivers/s390/char/con3270.c
index 699fd3e363df..bb6b0df50b33 100644
--- a/drivers/s390/char/con3270.c
+++ b/drivers/s390/char/con3270.c
@@ -576,7 +576,6 @@ static struct console con3270 = {
 static int __init
 con3270_init(void)
 {
-	struct ccw_device *cdev;
 	struct raw3270 *rp;
 	void *cbuf;
 	int i;
@@ -591,10 +590,7 @@ con3270_init(void)
 		cpcmd("TERM AUTOCR OFF", NULL, 0, NULL);
 	}
 
-	cdev = ccw_device_probe_console();
-	if (IS_ERR(cdev))
-		return -ENODEV;
-	rp = raw3270_setup_console(cdev);
+	rp = raw3270_setup_console();
 	if (IS_ERR(rp))
 		return PTR_ERR(rp);
 
diff --git a/drivers/s390/char/raw3270.c b/drivers/s390/char/raw3270.c
index 24a08e8f19e1..651d1f5da7c4 100644
--- a/drivers/s390/char/raw3270.c
+++ b/drivers/s390/char/raw3270.c
@@ -776,16 +776,24 @@ raw3270_setup_device(struct ccw_device *cdev, struct raw3270 *rp, char *ascebc)
 }
 
 #ifdef CONFIG_TN3270_CONSOLE
+/* Tentative definition - see below for actual definition. */
+static struct ccw_driver raw3270_ccw_driver;
+
 /*
  * Setup 3270 device configured as console.
  */
-struct raw3270 __init *raw3270_setup_console(struct ccw_device *cdev)
+struct raw3270 __init *raw3270_setup_console(void)
 {
+	struct ccw_device *cdev;
 	unsigned long flags;
 	struct raw3270 *rp;
 	char *ascebc;
 	int rc;
 
+	cdev = ccw_device_probe_console(&raw3270_ccw_driver);
+	if (IS_ERR(cdev))
+		return ERR_CAST(cdev);
+
 	rp = kzalloc(sizeof(struct raw3270), GFP_KERNEL | GFP_DMA);
 	ascebc = kzalloc(256, GFP_KERNEL);
 	rc = raw3270_setup_device(cdev, rp, ascebc);
diff --git a/drivers/s390/char/raw3270.h b/drivers/s390/char/raw3270.h
index 7b73ff8c1bd7..359276a88396 100644
--- a/drivers/s390/char/raw3270.h
+++ b/drivers/s390/char/raw3270.h
@@ -190,7 +190,7 @@ raw3270_put_view(struct raw3270_view *view)
 		wake_up(&raw3270_wait_queue);
 }
 
-struct raw3270 *raw3270_setup_console(struct ccw_device *cdev);
+struct raw3270 *raw3270_setup_console(void);
 void raw3270_wait_cons_dev(struct raw3270 *);
 
 /* Notifier for device addition/removal */
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index e4a7ab2bb629..3a33be681fbe 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1610,7 +1610,7 @@ out_unlock:
 	return rc;
 }
 
-struct ccw_device *ccw_device_probe_console(void)
+struct ccw_device *ccw_device_probe_console(struct ccw_driver *drv)
 {
 	struct io_subchannel_private *io_priv;
 	struct ccw_device *cdev;
@@ -1632,6 +1632,7 @@ struct ccw_device *ccw_device_probe_console(void)
 		kfree(io_priv);
 		return cdev;
 	}
+	cdev->drv = drv;
 	set_io_private(sch, io_priv);
 	ret = ccw_device_console_enable(cdev, sch);
 	if (ret) {
-- 
1.9.3

