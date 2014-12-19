Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaLSUNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 15:13:42 -0500
Received: from mail-bl2on0116.outbound.protection.outlook.com ([65.55.169.116]:9920
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751165AbaLSUNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 15:13:38 -0500
X-Greylist: delayed 2391 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Dec 2014 15:13:37 EST
X-WSS-ID: 0NGUIUB-08-L9C-02
X-M-MSG: 
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
To: <rjw@rjwysocki.net>, <lenb@kernel.org>, <hdegoede@redhat.com>,
        <tj@kernel.org>, <arnd@arndb.de>, <mjg59@srcf.ucam.org>
CC: <hanjun.guo@linaro.org>, <al.stone@linaro.org>,
        <graeme.gregory@linaro.org>, <leo.duran@amd.com>,
        <linux-ide@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-acpi@lists.linaro.org>,
        "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 1/2] ACPI / scan: Add support for ACPI _CLS device matching
Date: Fri, 19 Dec 2014 14:13:07 -0600
Message-ID: <1419019988-4398-2-git-send-email-Suravee.Suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1419019988-4398-1-git-send-email-Suravee.Suthikulpanit@amd.com>
References: <1419019988-4398-1-git-send-email-Suravee.Suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(101416001)(68736005)(53416004)(97736003)(99396003)(50466002)(4396001)(2950100001)(77096005)(19580405001)(46102003)(19580395003)(105586002)(48376002)(107046002)(2201001)(31966008)(62966003)(50226001)(92566001)(50986999)(229853001)(120916001)(64706001)(86362001)(21056001)(20776003)(76176999)(36756003)(89996001)(87936001)(77156002)(84676001)(106466001)(309714004);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB205;
X-Forefront-PRVS: 0430FA5CB7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device drivers typically use ACPI _HIDs/_CIDs listed in struct device_driver
acpi_match_table to match devices. However, for generic drivers, we do
not want to list _HID for all supported devices, and some device classes
do not have _CID (e.g. SATA, USB). Instead, we can leverage ACPI _CLS,
which specifies PCI-defined class code (i.e. base-class, subclass and
programming interface).

This patch adds support for matching ACPI devices using the _CLS method.

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 drivers/acpi/scan.c             | 63 +++++++++++++++++++++++++++++++++++++++++
 include/acpi/acnames.h          |  1 +
 include/linux/acpi.h            | 12 +++++++-
 include/linux/device.h          |  1 +
 include/linux/mod_devicetable.h |  6 ++++
 5 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index d670158..6bf6f90 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -864,6 +864,69 @@ int acpi_match_device_ids(struct acpi_device *device,
 }
 EXPORT_SYMBOL(acpi_match_device_ids);
 
+/**
+ * acpi_match_device_cls - Match a struct device against a ACPI _CLS method
+ * @dev_cls: A pointer to struct acpi_device_cls object to match against.
+ * @dev: The ACPI device structure to match.
+ *
+ * Check if @dev has a valid ACPI and _CLS handle. If there is a
+ * struct acpi_device_cls object for that handle, use that object to match
+ * against the given struct acpi_device_cls object.
+ *
+ * Return 0 on success or error code on failure.
+ */
+int acpi_match_device_cls(const struct acpi_device_cls *dev_cls,
+			  const struct device *dev)
+{
+	int ret = -EINVAL;
+	acpi_status status;
+	union acpi_object *pkg;
+	struct acpi_device_cls cls;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	struct acpi_buffer format = { sizeof("NNN"), "NNN" };
+	struct acpi_buffer state = { 0, NULL };
+	struct acpi_device *adev = ACPI_COMPANION(dev);
+	acpi_handle handle = ACPI_HANDLE(dev);
+
+	if (!handle || !adev || !adev->status.present || !dev_cls)
+		return ret;
+
+	status = acpi_evaluate_object(handle, METHOD_NAME__CLS, NULL, &buffer);
+	if (ACPI_FAILURE(status))
+		return ret;
+
+	/**
+	 * Note:
+	 * ACPIv5.1 defines the package to contain 3 integers for
+	 * Base-Class code, Sub-Class code, and Programming Interface code.
+	 */
+	pkg = buffer.pointer;
+	if (!pkg ||
+	    (pkg->type != ACPI_TYPE_PACKAGE) ||
+	    (pkg->package.count != 3)) {
+		dev_err(&adev->dev, "Invalid _CLS data\n");
+		goto out;
+	}
+
+	state.length = sizeof(struct acpi_device_cls);
+	state.pointer = &cls;
+
+	status = acpi_extract_package(pkg, &format, &state);
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status, "Invalid data"));
+		goto out;
+	}
+
+	if ((dev_cls->base_class == cls.base_class) &&
+	    (dev_cls->sub_class == cls.sub_class) &&
+	    (dev_cls->prog_interface == cls.prog_interface))
+		ret = 0;
+out:
+	kfree(buffer.pointer);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(acpi_match_device_cls);
+
 static void acpi_free_power_resources_lists(struct acpi_device *device)
 {
 	int i;
diff --git a/include/acpi/acnames.h b/include/acpi/acnames.h
index 7461327..22332a6 100644
--- a/include/acpi/acnames.h
+++ b/include/acpi/acnames.h
@@ -51,6 +51,7 @@
 #define METHOD_NAME__BBN        "_BBN"
 #define METHOD_NAME__CBA        "_CBA"
 #define METHOD_NAME__CID        "_CID"
+#define METHOD_NAME__CLS        "_CLS"
 #define METHOD_NAME__CRS        "_CRS"
 #define METHOD_NAME__DDN        "_DDN"
 #define METHOD_NAME__HID        "_HID"
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 5a92d49..d377623 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -428,10 +428,14 @@ extern int acpi_nvs_for_each_region(int (*func)(__u64, __u64, void *),
 const struct acpi_device_id *acpi_match_device(const struct acpi_device_id *ids,
 					       const struct device *dev);
 
+int acpi_match_device_cls(const struct acpi_device_cls *dev_cls,
+			  const struct device *dev);
+
 static inline bool acpi_driver_match_device(struct device *dev,
 					    const struct device_driver *drv)
 {
-	return !!acpi_match_device(drv->acpi_match_table, dev);
+	return (!!acpi_match_device(drv->acpi_match_table, dev) ||
+		 !acpi_match_device_cls(drv->acpi_cls, dev));
 }
 
 int acpi_device_uevent_modalias(struct device *, struct kobj_uevent_env *);
@@ -511,6 +515,12 @@ static inline const struct acpi_device_id *acpi_match_device(
 	return NULL;
 }
 
+static inline int acpi_match_device_cls(const struct acpi_device_cls *dev_cls,
+				 const struct device *dev)
+{
+	return -EINVAL;
+}
+
 static inline bool acpi_driver_match_device(struct device *dev,
 					    const struct device_driver *drv)
 {
diff --git a/include/linux/device.h b/include/linux/device.h
index ce1f2160..a469adc 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -237,6 +237,7 @@ struct device_driver {
 
 	const struct of_device_id	*of_match_table;
 	const struct acpi_device_id	*acpi_match_table;
+	const struct acpi_device_cls	*acpi_cls;
 
 	int (*probe) (struct device *dev);
 	int (*remove) (struct device *dev);
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 44eeef0..f2ef3c6 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -186,6 +186,12 @@ struct css_device_id {
 
 #define ACPI_ID_LEN	9
 
+struct acpi_device_cls {
+	kernel_ulong_t base_class;
+	kernel_ulong_t sub_class;
+	kernel_ulong_t prog_interface;
+};
+
 struct acpi_device_id {
 	__u8 id[ACPI_ID_LEN];
 	kernel_ulong_t driver_data;
-- 
1.9.3

