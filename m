Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbbAWOya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:54:30 -0500
Received: from msr13.hinet.net ([168.95.4.113]:52366 "EHLO msr13.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbbAWOy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:54:27 -0500
X-Greylist: delayed 8328 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jan 2015 09:54:26 EST
From: Duson Lin <dusonlin@emc.com.tw>
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com
Cc: phoenix@emc.com.tw, Duson Lin <dusonlin@emc.com.tw>
Subject: =?UTF-8?q?=5BPATCH=5D=20Input=3A=20elan=5Fi2c=20-=20Compare=20signature=20metadata=20before=20update=20fw?=
Date: Fri, 23 Jan 2015 20:35:30 +0800
Message-Id: <1422016530-24071-1-git-send-email-dusonlin@emc.com.tw>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMosTGxXK/M0FMV8zhUIjBosUSFpd3zWGzuPnpG6vF4UUvGC0WNt5k
	tHjRPpnFgdXj8yY5j52z7rJ7HP/YwBzAHMWamZeUX5HAmvH7ZSNrwU3VimkbJrI1MHbLdzFy
	cggJREpsO3KRBcRmE1CVmPC0lxXEFhGIkji57DIbiM0sYCFxfvlaJhBbWKBE4vm9h2D1LED1
	s25NZgexeQWcJTrerWYEsSUEFCW6n01gg4gLSpyc+QSongNojrrE+nlCECPlJZq3zmaewMg9
	C0nVLISqWUiqFjAyr2IUyS2u0C3OLTbUNdHLyMxLLdED4k2MwJBZEc/Ot4Px7EnDQ4xMHJyH
	GAU4GJV4eD+s2hsixJpYVlyZCxLnPsQoycGkJMobZXkoRIgvKT+lMiOxOCO+qDQntfgQowQH
	j5II7z47oBxvcUFibnFmOkxKhoNDSYI3CiQlWJSanlqRlplTkloEkT7FqCglztsJkhQA6cso
	zYPLwWLtEqOslDDvMyOgGp6C1KLczBJU+VeM4kAXC/PeB5nCk5lXArf8FdBdTEB3uWw/AHJX
	SSJCCgBDIWxMGAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To match different firmware file format, we replace original firmware file size
checking with the signature metadata comparison when update firmware, If failed,
the update will be aborted.

Signed-off-by: Duson Lin <dusonlin@emc.com.tw>
---
 drivers/input/mouse/elan_i2c.h       |    6 +++---
 drivers/input/mouse/elan_i2c_core.c  |   23 +++++++++++++----------
 drivers/input/mouse/elan_i2c_i2c.c   |    1 -
 drivers/input/mouse/elan_i2c_smbus.c |    1 -
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/input/mouse/elan_i2c.h b/drivers/input/mouse/elan_i2c.h
index 2e83862..e100c1b 100644
--- a/drivers/input/mouse/elan_i2c.h
+++ b/drivers/input/mouse/elan_i2c.h
@@ -4,7 +4,6 @@
  * Copyright (c) 2013 ELAN Microelectronics Corp.
  *
  * Author: 林政維 (Duson Lin) <dusonlin@emc.com.tw>
- * Version: 1.5.5
  *
  * Based on cyapa driver:
  * copyright (c) 2011-2012 Cypress Semiconductor, Inc.
@@ -33,8 +32,9 @@
 #define ETP_FW_IAP_PAGE_ERR	(1 << 5)
 #define ETP_FW_IAP_INTF_ERR	(1 << 4)
 #define ETP_FW_PAGE_SIZE	64
-#define ETP_FW_PAGE_COUNT	768
-#define ETP_FW_SIZE		(ETP_FW_PAGE_SIZE * ETP_FW_PAGE_COUNT)
+#define ETP_FW_VAILDPAGE_COUNT	768
+#define ETP_FW_SIGNATURE_SIZE	6
+#define ETP_FW_SIGNATURE_ADDRESS	0xBFFA
 
 struct i2c_client;
 struct completion;
diff --git a/drivers/input/mouse/elan_i2c_core.c b/drivers/input/mouse/elan_i2c_core.c
index 0cb2be4..16f9584 100644
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 ELAN Microelectronics Corp.
  *
  * Author: 林政維 (Duson Lin) <dusonlin@emc.com.tw>
- * Version: 1.5.5
+ * Version: 1.5.6
  *
  * Based on cyapa driver:
  * copyright (c) 2011-2012 Cypress Semiconductor, Inc.
@@ -40,7 +40,7 @@
 #include "elan_i2c.h"
 
 #define DRIVER_NAME		"elan_i2c"
-#define ELAN_DRIVER_VERSION	"1.5.5"
+#define ELAN_DRIVER_VERSION	"1.5.6"
 #define ETP_PRESSURE_OFFSET	25
 #define ETP_MAX_PRESSURE	255
 #define ETP_FWIDTH_REDUCE	90
@@ -312,7 +312,7 @@ static int __elan_update_firmware(struct elan_tp_data *data,
 	iap_start_addr = get_unaligned_le16(&fw->data[ETP_IAP_START_ADDR * 2]);
 
 	boot_page_count = (iap_start_addr * 2) / ETP_FW_PAGE_SIZE;
-	for (i = boot_page_count; i < ETP_FW_PAGE_COUNT; i++) {
+	for (i = boot_page_count; i < ETP_FW_VAILDPAGE_COUNT; i++) {
 		u16 checksum = 0;
 		const u8 *page = &fw->data[i * ETP_FW_PAGE_SIZE];
 
@@ -434,10 +434,11 @@ static ssize_t elan_sysfs_update_fw(struct device *dev,
 				    struct device_attribute *attr,
 				    const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct elan_tp_data *data = i2c_get_clientdata(client);
+	struct elan_tp_data *data = dev_get_drvdata(dev);
 	const struct firmware *fw;
 	int error;
+	const u8 *fw_signature;
+	static const u8 signature[] = {0xAA, 0x55, 0xCC, 0x33, 0xFF, 0xFF};
 
 	error = request_firmware(&fw, ETP_FW_NAME, dev);
 	if (error) {
@@ -446,10 +447,12 @@ static ssize_t elan_sysfs_update_fw(struct device *dev,
 		return error;
 	}
 
-	/* Firmware must be exactly PAGE_NUM * PAGE_SIZE bytes */
-	if (fw->size != ETP_FW_SIZE) {
-		dev_err(dev, "invalid firmware size = %zu, expected %d.\n",
-			fw->size, ETP_FW_SIZE);
+	/* Firmware file must match signature data */
+	fw_signature = &fw->data[ETP_FW_SIGNATURE_ADDRESS];
+	if (memcmp(fw_signature, signature, sizeof(signature)) != 0) {
+		dev_err(dev, "signature mismatch (expected %*ph, got %*ph)\n",
+			     (int)sizeof(signature), signature,
+			     (int)sizeof(signature), fw_signature);
 		error = -EBADF;
 		goto out_release_fw;
 	}
@@ -464,7 +467,7 @@ static ssize_t elan_sysfs_update_fw(struct device *dev,
 
 out_release_fw:
 	release_firmware(fw);
-	return error ?: count;
+	return error?: count;
 }
 
 static ssize_t calibrate_store(struct device *dev,
diff --git a/drivers/input/mouse/elan_i2c_i2c.c b/drivers/input/mouse/elan_i2c_i2c.c
index 97d4937..029941f 100644
--- a/drivers/input/mouse/elan_i2c_i2c.c
+++ b/drivers/input/mouse/elan_i2c_i2c.c
@@ -4,7 +4,6 @@
  * Copyright (c) 2013 ELAN Microelectronics Corp.
  *
  * Author: 林政維 (Duson Lin) <dusonlin@emc.com.tw>
- * Version: 1.5.5
  *
  * Based on cyapa driver:
  * copyright (c) 2011-2012 Cypress Semiconductor, Inc.
diff --git a/drivers/input/mouse/elan_i2c_smbus.c b/drivers/input/mouse/elan_i2c_smbus.c
index 359bf85..5cd4a05 100644
--- a/drivers/input/mouse/elan_i2c_smbus.c
+++ b/drivers/input/mouse/elan_i2c_smbus.c
@@ -4,7 +4,6 @@
  * Copyright (c) 2013 ELAN Microelectronics Corp.
  *
  * Author: 林政維 (Duson Lin) <dusonlin@emc.com.tw>
- * Version: 1.5.5
  *
  * Based on cyapa driver:
  * copyright (c) 2011-2012 Cypress Semiconductor, Inc.
-- 
1.7.10.4

