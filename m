Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaANIqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:46:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:63516 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbaANIqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:46:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,657,1384329600"; 
   d="scan'208";a="464783191"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org
Cc: wsa@the-dreams.de, broonie@linaro.org, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, jarkko.nikula@linux.intel.com,
        mika.westerberg@linux.intel.com, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 1/4] ACPI: fix create_modalias() return value handling
Date: Tue, 14 Jan 2014 16:46:35 +0800
Message-Id: <1389689198-2641-2-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, create_modalias() handles the output truncated case in
an improper way (return -EINVAL).
Plus, acpi_device_uevent() and acpi_device_modalias_show() do
improper check for the create_modalias() return value as well.

This patch fixes create_modalias() to
return -EINVAL if there is an output error,
return -ENOMEM if the output is truncated,
and also fixes both acpi_device_uevent() and acpi_device_modalias_show()
to do proper return value check.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/scan.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index fd39459..c925321 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -85,6 +85,9 @@ int acpi_scan_add_handler_with_hotplug(struct acpi_scan_handler *handler,
  * Creates hid/cid(s) string needed for modalias and uevent
  * e.g. on a device with hid:IBM0001 and cid:ACPI0001 you get:
  * char *modalias: "acpi:IBM0001:ACPI0001"
+ * Return: 0: no _HID and no _CID
+ *         -EINVAL: output error
+ *         -ENOMEM: output is truncated
 */
 static int create_modalias(struct acpi_device *acpi_dev, char *modalias,
 			   int size)
@@ -101,8 +104,10 @@ static int create_modalias(struct acpi_device *acpi_dev, char *modalias,
 
 	list_for_each_entry(id, &acpi_dev->pnp.ids, list) {
 		count = snprintf(&modalias[len], size, "%s:", id->id);
-		if (count < 0 || count >= size)
-			return -EINVAL;
+		if (count < 0)
+			return EINVAL;
+		if (count >= size)
+			return -ENOMEM;
 		len += count;
 		size -= count;
 	}
@@ -116,10 +121,9 @@ acpi_device_modalias_show(struct device *dev, struct device_attribute *attr, cha
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 	int len;
 
-	/* Device has no HID and no CID or string is >1024 */
 	len = create_modalias(acpi_dev, buf, 1024);
 	if (len <= 0)
-		return 0;
+		return len;
 	buf[len++] = '\n';
 	return len;
 }
@@ -782,8 +786,8 @@ static int acpi_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 		return -ENOMEM;
 	len = create_modalias(acpi_dev, &env->buf[env->buflen - 1],
 			      sizeof(env->buf) - env->buflen);
-	if (len >= (sizeof(env->buf) - env->buflen))
-		return -ENOMEM;
+	if (len <= 0)
+		return len;
 	env->buflen += len;
 	return 0;
 }
-- 
1.7.9.5

