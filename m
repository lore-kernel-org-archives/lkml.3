Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab3LRG5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:57:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:58557 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab3LRG5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:57:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="328666702"
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
Subject: [RFC Patch v1 03/13] PCI, pci-label: release allocated ACPI object on error recovery path
Date: Wed, 18 Dec 2013 14:58:11 +0800
Message-Id: <1387349901-3391-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
References: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function dsm_get_label() leaks the returned ACPI object if
obj->package.count is not 2, so fix the possible memory leak.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/pci/pci-label.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
index d51f45a..f6e01a5 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -233,11 +233,7 @@ dsm_get_label(acpi_handle handle, int func,
 		return -1;
 
 	obj = (union acpi_object *)output->pointer;
-
-	switch (obj->type) {
-	case ACPI_TYPE_PACKAGE:
-		if (obj->package.count != 2)
-			break;
+	if (obj->type == ACPI_TYPE_PACKAGE && obj->package.count == 2) {
 		len = obj->package.elements[0].integer.value;
 		if (buf) {
 			if (attribute == ACPI_ATTR_INDEX_SHOW)
@@ -250,10 +246,10 @@ dsm_get_label(acpi_handle handle, int func,
 		}
 		kfree(output->pointer);
 		return len;
-	break;
-	default:
-		kfree(output->pointer);
 	}
+
+	kfree(output->pointer);
+
 	return -1;
 }
 
-- 
1.7.10.4

