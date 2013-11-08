Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3KHCQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:16:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34449 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab3KHCQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 01/91] ACPICA: Interpreter: Fix Store() when implicit conversion is not possible.
Date: Thu,  7 Nov 2013 18:14:16 -0800
Message-Id: <1383876946-2396-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Moore <robert.moore@intel.com>

commit 3f654bad3257427bea7ba1c4d43a23d99a03622b upstream.

For the cases such as a store of a string to an existing package
object, implement the store as a CopyObject().
This is a small departure from the ACPI specification which states
that the control method should be aborted in this case. However,
ASLTS suite depends on this behavior.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/acpica/exstore.c | 29 ++++++++++++++++++++++++-----
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
1.8.1.2

