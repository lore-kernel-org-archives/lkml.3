Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab3LRG5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:57:48 -0500
Received: from mga14.intel.com ([143.182.124.37]:58557 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab3LRG5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:57:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="328666754"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Peter Huewe <peterhuewe@gmx.de>,
        Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jiri Kosina <jkosina@suse.cz>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>
Subject: [RFC Patch v1 05/13] PCI, pci-label: treat PCI label with index 0 as valid label
Date: Wed, 18 Dec 2013 14:58:13 +0800
Message-Id: <1387349901-3391-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
References: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current pci-label driver detects ACPI label by checking label index
returned by ACPI _DSM method, and treat it as valid if label index
is positive. According to ACPI Firmware specification 3.1, zero is
also an valid label index. So change code to detect availability of
ACPI slot label by checking availaiblity of ACPI _DSM function for
PCI label.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/pci/pci-label.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
index f12dcd1..0260b14 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -187,7 +187,6 @@ static const char device_label_dsm_uuid[] = {
 };
 
 enum acpi_attr_enum {
-	ACPI_ATTR_NONE = 0,
 	ACPI_ATTR_LABEL_SHOW,
 	ACPI_ATTR_INDEX_SHOW,
 };
@@ -222,20 +221,16 @@ dsm_get_label(struct device *dev, char *buf, enum acpi_attr_enum attr)
 	if (obj->type == ACPI_TYPE_PACKAGE && obj->package.count == 2 &&
 	    tmp[0].type == ACPI_TYPE_INTEGER &&
 	    tmp[1].type == ACPI_TYPE_STRING) {
-		len = tmp[0].integer.value;
-		if (buf) {
-			/*
-			 * This second string element is optional even when
-			 * this _DSM is implemented; when not implemented,
-			 * this entry must return a null string.
-			 */
-			if (attr == ACPI_ATTR_INDEX_SHOW)
-				scnprintf(buf, PAGE_SIZE, "%llu\n",
-				tmp->integer.value);
-			else if (attr == ACPI_ATTR_LABEL_SHOW)
-				dsm_label_utf16s_to_utf8s(tmp + 1, buf);
-			len = strlen(buf) > 0 ? strlen(buf) : -1;
-		}
+		/*
+		 * The second string element is optional even when
+		 * this _DSM is implemented; when not implemented,
+		 * this entry must return a null string.
+		 */
+		if (attr == ACPI_ATTR_INDEX_SHOW)
+			scnprintf(buf, PAGE_SIZE, "%llu\n", tmp->integer.value);
+		else if (attr == ACPI_ATTR_LABEL_SHOW)
+			dsm_label_utf16s_to_utf8s(tmp + 1, buf);
+		len = strlen(buf) > 0 ? strlen(buf) : -1;
 	}
 
 	ACPI_FREE(obj);
@@ -246,7 +241,14 @@ dsm_get_label(struct device *dev, char *buf, enum acpi_attr_enum attr)
 static bool
 device_has_dsm(struct device *dev)
 {
-	return dsm_get_label(dev, NULL, ACPI_ATTR_NONE) > 0;
+	acpi_handle handle;
+
+	handle = ACPI_HANDLE(dev);
+	if (!handle)
+		return false;
+
+	return !!acpi_check_dsm(handle, device_label_dsm_uuid, 0x2,
+				1 << DEVICE_LABEL_DSM);
 }
 
 static umode_t
-- 
1.7.10.4

