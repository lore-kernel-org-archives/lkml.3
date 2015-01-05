Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbbAEVLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:11:43 -0500
Received: from mail-by2on0142.outbound.protection.outlook.com ([207.46.100.142]:52304
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754077AbbAEVLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:11:39 -0500
X-WSS-ID: 0NHQ2V8-07-OPZ-02
X-M-MSG: 
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
To: <rjw@rjwysocki.net>, <lenb@kernel.org>, <hdegoede@redhat.com>,
        <tj@kernel.org>, <arnd@arndb.de>, <mjg59@srcf.ucam.org>,
        <grant.likely@linaro.org>
CC: <hanjun.guo@linaro.org>, <al.stone@linaro.org>,
        <graeme.gregory@linaro.org>, <leo.duran@amd.com>,
        <linux-ide@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-acpi@lists.linaro.org>,
        "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>
Subject: [V2 PATCH 1/2] ACPI / scan: Add support for ACPI _CLS device matching
Date: Mon, 5 Jan 2015 15:11:14 -0600
Message-ID: <1420492275-6878-2-git-send-email-Suravee.Suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420492275-6878-1-git-send-email-Suravee.Suthikulpanit@amd.com>
References: <1420492275-6878-1-git-send-email-Suravee.Suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(2950100001)(87936001)(86362001)(50466002)(99396003)(36756003)(106466001)(19580405001)(4396001)(19580395003)(46102003)(53416004)(105586002)(21056001)(84676001)(50226001)(48376002)(107046002)(2201001)(229853001)(101416001)(50986999)(120916001)(47776003)(62966003)(89996001)(92566001)(97736003)(77156002)(77096005)(64706001)(68736005)(20776003)(76176999)(31966008);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:CO1PR02MB208;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB208;
X-Forefront-PRVS: 0447DB1C71
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2015 21:11:34.5775
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB208
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
 drivers/acpi/scan.c             | 79 +++++++++++++++++++++++++++++++++++++++--
 include/acpi/acnames.h          |  1 +
 include/linux/acpi.h            | 10 ++++++
 include/linux/device.h          |  1 +
 include/linux/mod_devicetable.h |  6 ++++
 5 files changed, 94 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 16914cc..7b25221 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -987,13 +987,86 @@ static bool acpi_of_driver_match_device(struct device *dev,
 bool acpi_driver_match_device(struct device *dev,
 			      const struct device_driver *drv)
 {
-	if (!drv->acpi_match_table)
-		return acpi_of_driver_match_device(dev, drv);
+	bool ret = false;
 
-	return !!acpi_match_device(drv->acpi_match_table, dev);
+	if (drv->acpi_match_table)
+		ret = !!acpi_match_device(drv->acpi_match_table, dev);
+
+	/* Next, try to match with special "PRP0001" _HID */
+	if (!ret && drv->of_match_table)
+		ret = acpi_of_driver_match_device(dev, drv);
+
+	/* Next, try to match with PCI-defined class-code */
+	if (!ret && drv->acpi_match_cls)
+		ret = acpi_match_device_cls(drv->acpi_match_cls, dev);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(acpi_driver_match_device);
 
+/**
+ * acpi_match_device_cls - Match a struct device against a ACPI _CLS method
+ * @dev_cls: A pointer to struct acpi_device_cls object to match against.
+ * @dev: The ACPI device structure to match.
+ *
+ * Check if @dev has a valid ACPI and _CLS handle. If there is a
+ * struct acpi_device_cls object for that handle, use that object to match
+ * against the given struct acpi_device_cls object.
+ *
+ * Return true on success or false on failure.
+ */
+bool acpi_match_device_cls(const struct acpi_device_cls *dev_cls,
+			  const struct device *dev)
+{
+	bool ret = false;
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
+		ret = true;
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
index 87f365e..2f2b8ce 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -432,6 +432,10 @@ const struct acpi_device_id *acpi_match_device(const struct acpi_device_id *ids,
 
 extern bool acpi_driver_match_device(struct device *dev,
 				     const struct device_driver *drv);
+
+bool acpi_match_device_cls(const struct acpi_device_cls *dev_cls,
+			   const struct device *dev);
+
 int acpi_device_uevent_modalias(struct device *, struct kobj_uevent_env *);
 int acpi_device_modalias(struct device *, char *, int);
 void acpi_walk_dep_device_list(acpi_handle handle);
@@ -527,6 +531,12 @@ static inline const struct acpi_device_id *acpi_match_device(
 	return NULL;
 }
 
+static inline bool acpi_match_device_cls(const struct acpi_device_cls *dev_cls,
+					 const struct device *dev)
+{
+	return false;
+}
+
 static inline bool acpi_driver_match_device(struct device *dev,
 					    const struct device_driver *drv)
 {
diff --git a/include/linux/device.h b/include/linux/device.h
index fb50673..8e259c5c 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -237,6 +237,7 @@ struct device_driver {
 
 	const struct of_device_id	*of_match_table;
 	const struct acpi_device_id	*acpi_match_table;
+	const struct acpi_device_cls	*acpi_match_cls;
 
 	int (*probe) (struct device *dev);
 	int (*remove) (struct device *dev);
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 745def8..00e94ec 100644
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

