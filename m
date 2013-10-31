Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750736Ab3JaBKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 21:10:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:4644 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab3JaBKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 21:10:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,605,1378882800"; 
   d="scan'208";a="420023576"
From: Lv Zheng <lv.zheng@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Lv Zheng <lv.zheng@intel.com>, <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 1/4] ACPICA: Interpreter: Fix Store() when implicit conversion is not possible.
Date: Thu, 31 Oct 2013 09:09:17 +0800
Message-Id: <8db5fd5bf27564209c9ffe357bc6355d66d10341.1383181113.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1383181113.git.lv.zheng@intel.com>
References: <cover.1383181113.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

commit 3f654bad3257427bea7ba1c4d43a23d99a03622b upstream.

For the cases such as a store of a string to an existing package
object, implement the store as a CopyObject().
This is a small departure from the ACPI specification which states
that the control method should be aborted in this case. However,
ASLTS suite depends on this behavior.

 Cc: <stable@vger.kernel.org> # 3.8.x
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpica/exstore.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpica/exstore.c b/drivers/acpi/acpica/exstore.c
index 90431f1..4ff37e8 100644
--- a/drivers/acpi/acpica/exstore.c
+++ b/drivers/acpi/acpica/exstore.c
@@ -487,14 +487,33 @@ acpi_ex_store_object_to_node(union acpi_operand_object *source_desc,
 	default:
 
 		ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
-				  "Storing %s (%p) directly into node (%p) with no implicit conversion\n",
+				  "Storing [%s] (%p) directly into node [%s] (%p)"
+				  " with no implicit conversion\n",
 				  acpi_ut_get_object_type_name(source_desc),
-				  source_desc, node));
+				  source_desc,
+				  acpi_ut_get_object_type_name(target_desc),
+				  node));
 
-		/* No conversions for all other types. Just attach the source object */
+		/*
+		 * No conversions for all other types. Directly store a copy of
+		 * the source object. NOTE: This is a departure from the ACPI
+		 * spec, which states "If conversion is impossible, abort the
+		 * running control method".
+		 *
+		 * This code implements "If conversion is impossible, treat the
+		 * Store operation as a CopyObject".
+		 */
+		status =
+		    acpi_ut_copy_iobject_to_iobject(source_desc, &new_desc,
+						    walk_state);
+		if (ACPI_FAILURE(status)) {
+			return_ACPI_STATUS(status);
+		}
 
-		status = acpi_ns_attach_object(node, source_desc,
-					       source_desc->common.type);
+		status =
+		    acpi_ns_attach_object(node, new_desc,
+					  new_desc->common.type);
+		acpi_ut_remove_reference(new_desc);
 		break;
 	}
 
-- 
1.7.10

