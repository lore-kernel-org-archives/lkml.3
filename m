Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061AbaD2TvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:51:20 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:34924 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965172AbaD2TuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:50:18 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, m.chehab@samsung.com, tj@kernel.org,
        olebowle@gmx.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 3/4] media/em28xx: changes to create token for tuner access
Date: Tue, 29 Apr 2014 13:49:25 -0600
Message-Id: <019bbf54a8ccbd236bbdfd552919d9a11a006db9.1398797955.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1398797954.git.shuah.kh@samsung.com>
References: <cover.1398797954.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1398797954.git.shuah.kh@samsung.com>
References: <cover.1398797954.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes add a new tuner_tkn field to struct em28xx and create
a token devres to allow sharing tuner function across analog
and digital functions. Tuner token is created during probe in
em28xx_usb_probe() and destroyed during disconnect in
em28xx_release_resources().

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   41 +++++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h       |    4 +++
 2 files changed, 45 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 50aa5a5..01c1955 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2428,6 +2428,37 @@ static struct em28xx_hash_table em28xx_i2c_hash[] = {
 };
 /* NOTE: introduce a separate hash table for devices with 16 bit eeproms */
 
+/* interfaces to create and destroy token resources */
+static int em28xx_create_token_resources(struct em28xx *dev)
+{
+	int rc = 0, len;
+	char buf[64];
+
+	/* create token devres for tuner */
+	len = snprintf(buf, sizeof(buf),
+		"tuner:%s-%s-%d",
+		dev_name(&dev->udev->dev),
+		dev->udev->bus->bus_name,
+		dev->tuner_addr);
+
+	dev->tuner_tkn = devm_kzalloc(&dev->udev->dev, len + 1, GFP_KERNEL);
+	if (!dev->tuner_tkn)
+		return -ENOMEM;
+
+	strcpy(dev->tuner_tkn, buf);
+	rc = devm_token_create(&dev->udev->dev, dev->tuner_tkn);
+	if (rc)
+		return rc;
+
+	em28xx_info("Tuner token created\n");
+	return rc;
+}
+
+static void em28xx_destroy_token_resources(struct em28xx *dev)
+{
+	devm_token_destroy(&dev->udev->dev, dev->tuner_tkn);
+}
+
 int em28xx_tuner_callback(void *ptr, int component, int command, int arg)
 {
 	struct em28xx_i2c_bus *i2c_bus = ptr;
@@ -2949,6 +2980,9 @@ static void em28xx_release_resources(struct em28xx *dev)
 		em28xx_i2c_unregister(dev, 1);
 	em28xx_i2c_unregister(dev, 0);
 
+	/* destroy token resources */
+	em28xx_destroy_token_resources(dev);
+
 	usb_put_dev(dev->udev);
 
 	/* Mark device as unused */
@@ -3431,6 +3465,13 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
 	kref_init(&dev->ref);
 
+	/* create token resources before requesting for modules */
+	if (em28xx_create_token_resources(dev)) {
+		em28xx_errdev("Error creating token resources!\n");
+		retval = -ENOMEM;
+		goto err_free;
+	}
+
 	request_modules(dev);
 
 	/* Should be the last thing to do, to avoid newer udev's to
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 2051fc9..e82f868 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -34,6 +34,7 @@
 #include <linux/mutex.h>
 #include <linux/kref.h>
 #include <linux/videodev2.h>
+#include <linux/token_devres.h>
 
 #include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-device.h>
@@ -547,6 +548,9 @@ struct em28xx {
 	int devno;		/* marks the number of this device */
 	enum em28xx_chip_id chip_id;
 
+	/* token resources */
+	char *tuner_tkn; /* tuner token id */
+
 	unsigned int is_em25xx:1;	/* em25xx/em276x/7x/8x family bridge */
 	unsigned char disconnected:1;	/* device has been diconnected */
 	unsigned int has_video:1;
-- 
1.7.10.4

