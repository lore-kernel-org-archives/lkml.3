Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbaDHGXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 02:23:44 -0400
Received: from mout.gmx.net ([212.227.17.20]:61767 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaDHGXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 02:23:42 -0400
Date: Tue, 8 Apr 2014 08:21:06 +0200
From: Michael Brunner <mibru@gmx.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Chris Healy <chealy@imsco-us.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH] mfd: Add sysfs attributes for Kontron PLD firmware revision
Message-ID: <20140408082106.2bb49571@hyperion>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:/NCFhud++zQzoq/fczAsuivUyzf6ZeFzrgE2NFpXMXPKe9t6Ueg
 7LGzrsKNlI2POTIJeJ+bFKQaYf6bu0JgYhW5G0R6Ml+8hDjjLs18CSGZ19j/TP+GQh77sBu
 kQ5YkulbEMJgeWLhrG1DN7yaDXP91D3mKPKjZSljUKh5QRkIbq2y+UMlbXazEfjNWgLYB1W
 YuaRHj4IdngUqMYEyjFfw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds attributes to the Kontron PLD driver to allow
applications to retrieve firmware information.
Additionally the format has been changed to conform with the
representation in other Kontron software.

Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/mfd/kempld-core.c  | 127 +++++++++++++++++++++++++++++++++++++--------
 include/linux/mfd/kempld.h |   4 ++
 2 files changed, 110 insertions(+), 21 deletions(-)

diff --git a/drivers/mfd/kempld-core.c b/drivers/mfd/kempld-core.c
index d3e2327..f8c965b 100644
--- a/drivers/mfd/kempld-core.c
+++ b/drivers/mfd/kempld-core.c
@@ -288,9 +288,38 @@ EXPORT_SYMBOL_GPL(kempld_release_mutex);
  */
 static int kempld_get_info(struct kempld_device_data *pld)
 {
+	int ret;
 	struct kempld_platform_data *pdata = dev_get_platdata(pld->dev);
+	char major, minor;
+
+	ret = pdata->get_info(pld);
+	if (ret)
+		return ret;
+
+	/* The Kontron PLD firmware version string has the following format:
+	 * Pwxy.zzzz
+	 *   P:    Fixed
+	 *   w:    PLD number    - 1 hex digit
+	 *   x:    Major version - 1 alphanumerical digit (0-9A-V)
+	 *   y:    Minor version - 1 alphanumerical digit (0-9A-V)
+	 *   zzzz: Build number  - 4 zero padded hex digits */
 
-	return pdata->get_info(pld);
+	if (pld->info.major < 10)
+		major = pld->info.major + '0';
+	else
+		major = (pld->info.major - 10) + 'A';
+	if (pld->info.minor < 10)
+		minor = pld->info.minor + '0';
+	else
+		minor = (pld->info.minor - 10) + 'A';
+
+	ret = scnprintf(pld->info.version, sizeof(pld->info.version),
+			"P%X%c%c.%04X", pld->info.number, major, minor,
+			pld->info.buildnr);
+	if (ret < 0)
+		return ret;
+
+	return 0;
 }
 
 /*
@@ -307,9 +336,71 @@ static int kempld_register_cells(struct kempld_device_data *pld)
 	return pdata->register_cells(pld);
 }
 
+static const char *kempld_get_type_string(struct kempld_device_data *pld)
+{
+	const char *version_type;
+
+	switch (pld->info.type) {
+	case 0:
+		version_type = "release";
+		break;
+	case 1:
+		version_type = "debug";
+		break;
+	case 2:
+		version_type = "custom";
+		break;
+	default:
+		version_type = "unspecified";
+		break;
+	}
+
+	return version_type;
+}
+
+static ssize_t kempld_version_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kempld_device_data *pld = dev_get_drvdata(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n", pld->info.version);
+}
+
+static ssize_t kempld_specification_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kempld_device_data *pld = dev_get_drvdata(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%d.%d\n", pld->info.spec_major,
+		       pld->info.spec_minor);
+}
+
+static ssize_t kempld_type_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kempld_device_data *pld = dev_get_drvdata(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n", kempld_get_type_string(pld));
+}
+
+static DEVICE_ATTR(pld_version, S_IRUGO, kempld_version_show, NULL);
+static DEVICE_ATTR(pld_specification, S_IRUGO, kempld_specification_show,
+		   NULL);
+static DEVICE_ATTR(pld_type, S_IRUGO, kempld_type_show, NULL);
+
+static struct attribute *pld_attributes[] = {
+	&dev_attr_pld_version.attr,
+	&dev_attr_pld_specification.attr,
+	&dev_attr_pld_type.attr,
+	NULL
+};
+
+static const struct attribute_group pld_attr_group = {
+	.attrs = pld_attributes,
+};
+
 static int kempld_detect_device(struct kempld_device_data *pld)
 {
-	char *version_type;
 	u8 index_reg;
 	int ret;
 
@@ -332,27 +423,19 @@ static int kempld_detect_device(struct kempld_device_data *pld)
 	if (ret)
 		return ret;
 
-	switch (pld->info.type) {
-	case 0:
-		version_type = "release";
-		break;
-	case 1:
-		version_type = "debug";
-		break;
-	case 2:
-		version_type = "custom";
-		break;
-	default:
-		version_type = "unspecified";
-	}
+	dev_info(pld->dev, "Found Kontron PLD - %s (%s), spec %d.%d\n",
+		 pld->info.version, kempld_get_type_string(pld),
+		 pld->info.spec_major, pld->info.spec_minor);
+
+	ret = sysfs_create_group(&pld->dev->kobj, &pld_attr_group);
+	if (ret)
+		return ret;
 
-	dev_info(pld->dev, "Found Kontron PLD %d\n", pld->info.number);
-	dev_info(pld->dev, "%s version %d.%d build %d, specification %d.%d\n",
-		 version_type, pld->info.major, pld->info.minor,
-		 pld->info.buildnr, pld->info.spec_major,
-		 pld->info.spec_minor);
+	ret = kempld_register_cells(pld);
+	if (ret)
+		sysfs_remove_group(&pld->dev->kobj, &pld_attr_group);
 
-	return kempld_register_cells(pld);
+	return ret;
 }
 
 static int kempld_probe(struct platform_device *pdev)
@@ -396,6 +479,8 @@ static int kempld_remove(struct platform_device *pdev)
 	struct kempld_device_data *pld = platform_get_drvdata(pdev);
 	struct kempld_platform_data *pdata = dev_get_platdata(pld->dev);
 
+	sysfs_remove_group(&pld->dev->kobj, &pld_attr_group);
+
 	mfd_remove_devices(&pdev->dev);
 	pdata->release_hardware_mutex(pld);
 
diff --git a/include/linux/mfd/kempld.h b/include/linux/mfd/kempld.h
index b911ef3..26e0b46 100644
--- a/include/linux/mfd/kempld.h
+++ b/include/linux/mfd/kempld.h
@@ -51,6 +51,8 @@
 #define	KEMPLD_TYPE_DEBUG		0x1
 #define	KEMPLD_TYPE_CUSTOM		0x2
 
+#define KEMPLD_VERSION_LEN		10
+
 /**
  * struct kempld_info - PLD device information structure
  * @major:	PLD major revision
@@ -60,6 +62,7 @@
  * @type:	PLD type
  * @spec_major:	PLD FW specification major revision
  * @spec_minor:	PLD FW specification minor revision
+ * @version:	PLD version string
  */
 struct kempld_info {
 	unsigned int major;
@@ -69,6 +72,7 @@ struct kempld_info {
 	unsigned int type;
 	unsigned int spec_major;
 	unsigned int spec_minor;
+	char version[KEMPLD_VERSION_LEN];
 };
 
 /**
-- 
1.8.5.1
