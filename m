Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab3K0CKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:10:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab3K0A42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:56:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.4 05/39] ACPICA: Interpreter: Fix Store() when implicit conversion is not possible.
Date: Tue, 26 Nov 2013 16:56:29 -0800
Message-Id: <20131127005619.423254158@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005619.011763867@linuxfoundation.org>
References: <20131127005619.011763867@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/exstore.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

--- a/drivers/acpi/acpica/exstore.c
+++ b/drivers/acpi/acpica/exstore.c
@@ -487,14 +487,33 @@ acpi_ex_store_object_to_node(union acpi_
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
 
-		/* No conversions for all other types.  Just attach the source object */
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
 


