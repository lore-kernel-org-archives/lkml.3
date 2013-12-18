Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3LRG5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:57:35 -0500
Received: from mga14.intel.com ([143.182.124.37]:58557 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab3LRG5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:57:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="328666696"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Peter Huewe <peterhuewe@gmx.de>,
        Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jiri Kosina <jkosina@suse.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>
Subject: [RFC Patch v1 02/13] ACPI, extlog: replace open-coded _DSM specific code with helper functions
Date: Wed, 18 Dec 2013 14:58:10 +0800
Message-Id: <1387349901-3391-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
References: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helper functions to simplify _DSM related code in acpi_extlog driver.
Also mark initialization data and functions with __init and __initdata
to reduce memory footprint.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/acpi_extlog.c |   61 +++++++++-----------------------------------
 1 file changed, 12 insertions(+), 49 deletions(-)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index a6869e1..928c4db 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -20,11 +20,9 @@
 #define EXT_ELOG_ENTRY_MASK	GENMASK_ULL(51, 0) /* elog entry address mask */
 
 #define EXTLOG_DSM_REV		0x0
-#define	EXTLOG_FN_QUERY		0x0
 #define	EXTLOG_FN_ADDR		0x1
 
 #define FLAG_OS_OPTIN		BIT(0)
-#define EXTLOG_QUERY_L1_EXIST	BIT(1)
 #define ELOG_ENTRY_VALID	(1ULL<<63)
 #define ELOG_ENTRY_LEN		0x1000
 
@@ -43,7 +41,7 @@ struct extlog_l1_head {
 	u8  rev1[12];
 };
 
-static u8 extlog_dsm_uuid[] = "663E35AF-CC10-41A4-88EA-5470AF055295";
+static u8 extlog_dsm_uuid[] __initdata = "663E35AF-CC10-41A4-88EA-5470AF055295";
 
 /* L1 table related physical address */
 static u64 elog_base;
@@ -153,62 +151,27 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 	return NOTIFY_DONE;
 }
 
-static int extlog_get_dsm(acpi_handle handle, int rev, int func, u64 *ret)
+static bool __init extlog_get_l1addr(void)
 {
-	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
-	struct acpi_object_list input;
-	union acpi_object params[4], *obj;
 	u8 uuid[16];
-	int i;
+	acpi_handle handle;
+	union acpi_object *obj;
 
 	acpi_str_to_uuid(extlog_dsm_uuid, uuid);
-	input.count = 4;
-	input.pointer = params;
-	params[0].type = ACPI_TYPE_BUFFER;
-	params[0].buffer.length = 16;
-	params[0].buffer.pointer = uuid;
-	params[1].type = ACPI_TYPE_INTEGER;
-	params[1].integer.value = rev;
-	params[2].type = ACPI_TYPE_INTEGER;
-	params[2].integer.value = func;
-	params[3].type = ACPI_TYPE_PACKAGE;
-	params[3].package.count = 0;
-	params[3].package.elements = NULL;
-
-	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_DSM", &input, &buf)))
-		return -1;
-
-	*ret = 0;
-	obj = (union acpi_object *)buf.pointer;
-	if (obj->type == ACPI_TYPE_INTEGER) {
-		*ret = obj->integer.value;
-	} else if (obj->type == ACPI_TYPE_BUFFER) {
-		if (obj->buffer.length <= 8) {
-			for (i = 0; i < obj->buffer.length; i++)
-				*ret |= (obj->buffer.pointer[i] << (i * 8));
-		}
-	}
-	kfree(buf.pointer);
-
-	return 0;
-}
-
-static bool extlog_get_l1addr(void)
-{
-	acpi_handle handle;
-	u64 ret;
 
 	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle)))
 		return false;
-
-	if (extlog_get_dsm(handle, EXTLOG_DSM_REV, EXTLOG_FN_QUERY, &ret) ||
-	    !(ret & EXTLOG_QUERY_L1_EXIST))
+	if (!acpi_check_dsm(handle, uuid, EXTLOG_DSM_REV, 1 << EXTLOG_FN_ADDR))
 		return false;
-
-	if (extlog_get_dsm(handle, EXTLOG_DSM_REV, EXTLOG_FN_ADDR, &ret))
+	obj = acpi_evaluate_dsm_typed(handle, uuid, EXTLOG_DSM_REV,
+				      EXTLOG_FN_ADDR, NULL, ACPI_TYPE_INTEGER);
+	if (!obj) {
 		return false;
+	} else {
+		l1_dirbase = obj->integer.value;
+		ACPI_FREE(obj);
+	}
 
-	l1_dirbase = ret;
 	/* Spec says L1 directory must be 4K aligned, bail out if it isn't */
 	if (l1_dirbase & ((1 << 12) - 1)) {
 		pr_warn(FW_BUG "L1 Directory is invalid at physical %llx\n",
-- 
1.7.10.4

