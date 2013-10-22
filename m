Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab3JVSBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 14:01:09 -0400
Received: from mout.gmx.net ([212.227.15.18]:60037 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab3JVSBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 14:01:05 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: james.l.morris@oracle.com, tpmdd-devel@lists.sourceforge.net,
        adlai@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 08/15] tpm: Remove tpm_show_caps_1_2
Date: Tue, 22 Oct 2013 20:00:33 +0200
Message-Id: <1382464840-7639-8-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1382464840-7639-6-git-send-email-peterhuewe@gmx.de>
References: <1382464840-7639-6-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:KRYxT1J0Y6ZnJ0EAfdnQHnuvwTP4xLkq9E+7fvz5MfFjclQZzDt
 bqFSIc92u0XexgX2VPhW91prAS6BJTh6rY9rhjglw1NG4S3B0mu06bfRw7rKdw3B3c4iagc
 AOywhYuqhv8tqM6vJQG0zHiOF4wueZih+oIhxO/4px4w3uNmXuqLh6twtyPry/jQHWekgGu
 Xgm0+O0pY0Dylb7QRU7KA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

The version of the TPM should not depend on the bus it is connected
through. 1.1, 1.2 and soon 2.0 TPMS will be all be able to use the
same bus interfaces.

Make tpm_show_caps try the 1.2 capability first. If that fails then
fall back to the 1.1 capability. This effectively auto-detects what
interface the TPM supports at run-time.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Joel Schopp <jschopp@linux.vnet.ibm.com>
Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm.c              |   56 ++++++++++++++--------------------
 drivers/char/tpm/tpm.h              |    2 -
 drivers/char/tpm/tpm_i2c_infineon.c |    2 +-
 drivers/char/tpm/tpm_i2c_stm_st33.c |    2 +-
 drivers/char/tpm/tpm_ibmvtpm.c      |    2 +-
 drivers/char/tpm/tpm_tis.c          |    2 +-
 6 files changed, 27 insertions(+), 39 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index c3ab508..72f0c68 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1020,43 +1020,33 @@ ssize_t tpm_show_caps(struct device *dev, struct device_attribute *attr,
 	str += sprintf(str, "Manufacturer: 0x%x\n",
 		       be32_to_cpu(cap.manufacturer_id));
 
-	rc = tpm_getcap(dev, CAP_VERSION_1_1, &cap,
-		        "attempting to determine the 1.1 version");
-	if (rc)
-		return 0;
-	str += sprintf(str,
-		       "TCG version: %d.%d\nFirmware version: %d.%d\n",
-		       cap.tpm_version.Major, cap.tpm_version.Minor,
-		       cap.tpm_version.revMajor, cap.tpm_version.revMinor);
-	return str - buf;
-}
-EXPORT_SYMBOL_GPL(tpm_show_caps);
-
-ssize_t tpm_show_caps_1_2(struct device * dev,
-			  struct device_attribute * attr, char *buf)
-{
-	cap_t cap;
-	ssize_t rc;
-	char *str = buf;
-
-	rc = tpm_getcap(dev, TPM_CAP_PROP_MANUFACTURER, &cap,
-			"attempting to determine the manufacturer");
-	if (rc)
-		return 0;
-	str += sprintf(str, "Manufacturer: 0x%x\n",
-		       be32_to_cpu(cap.manufacturer_id));
+	/* Try to get a TPM version 1.2 TPM_CAP_VERSION_INFO */
 	rc = tpm_getcap(dev, CAP_VERSION_1_2, &cap,
 			 "attempting to determine the 1.2 version");
-	if (rc)
-		return 0;
-	str += sprintf(str,
-		       "TCG version: %d.%d\nFirmware version: %d.%d\n",
-		       cap.tpm_version_1_2.Major, cap.tpm_version_1_2.Minor,
-		       cap.tpm_version_1_2.revMajor,
-		       cap.tpm_version_1_2.revMinor);
+	if (!rc) {
+		str += sprintf(str,
+			       "TCG version: %d.%d\nFirmware version: %d.%d\n",
+			       cap.tpm_version_1_2.Major,
+			       cap.tpm_version_1_2.Minor,
+			       cap.tpm_version_1_2.revMajor,
+			       cap.tpm_version_1_2.revMinor);
+	} else {
+		/* Otherwise just use TPM_STRUCT_VER */
+		rc = tpm_getcap(dev, CAP_VERSION_1_1, &cap,
+				"attempting to determine the 1.1 version");
+		if (rc)
+			return 0;
+		str += sprintf(str,
+			       "TCG version: %d.%d\nFirmware version: %d.%d\n",
+			       cap.tpm_version.Major,
+			       cap.tpm_version.Minor,
+			       cap.tpm_version.revMajor,
+			       cap.tpm_version.revMinor);
+	}
+
 	return str - buf;
 }
-EXPORT_SYMBOL_GPL(tpm_show_caps_1_2);
+EXPORT_SYMBOL_GPL(tpm_show_caps);
 
 ssize_t tpm_show_durations(struct device *dev, struct device_attribute *attr,
 			  char *buf)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 0df18b5..f328478 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -59,8 +59,6 @@ extern ssize_t tpm_show_pcrs(struct device *, struct device_attribute *attr,
 				char *);
 extern ssize_t tpm_show_caps(struct device *, struct device_attribute *attr,
 				char *);
-extern ssize_t tpm_show_caps_1_2(struct device *, struct device_attribute *attr,
-				char *);
 extern ssize_t tpm_store_cancel(struct device *, struct device_attribute *attr,
 				const char *, size_t);
 extern ssize_t tpm_show_enabled(struct device *, struct device_attribute *attr,
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index e33d8e5..fefd2aa 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -581,7 +581,7 @@ static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
 static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
 static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
 static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
+static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
 static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
 static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
 static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index b2390b6..a0d6ceb5 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -584,7 +584,7 @@ static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
 static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
 static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
 static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
+static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
 static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
 
 static struct attribute *stm_tpm_attrs[] = {
diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 838f043..2783a42 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -419,7 +419,7 @@ static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
 static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
 static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated,
 		   NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
+static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
 static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
 static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
 static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 5796d01..1b74459 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -448,7 +448,7 @@ static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
 static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
 static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated,
 		   NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
+static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
 static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
 static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
 static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
-- 
1.7.5.4

