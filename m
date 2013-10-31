Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3JaBKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 21:10:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:31225 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab3JaBK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 21:10:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="427392993"
From: Lv Zheng <lv.zheng@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Lv Zheng <lv.zheng@intel.com>, <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 2/4] ACPICA: DeRefOf operator: Update to fully resolve FieldUnit and BufferField refs.
Date: Thu, 31 Oct 2013 09:09:41 +0800
Message-Id: <64d712f0e498761ffd32272ee2bd1fcb01a8bf65.1383181113.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1383181113.git.lv.zheng@intel.com>
References: <cover.1383181113.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

commit 63660e05ec719613b518547b40a1c501c10f0bc4 upstream.

Previously, references to these objects were resolved only to the actual
FieldUnit or BufferField object. The correct behavior is to resolve these
references to an actual value.
The problem is that DerefOf did not resolve these objects to actual
values.  An "Integer" object is simple, return the value.  But a field in
an operation region will require a read operation.  For a BufferField, the
appropriate data must be extracted from the parent buffer.

NOTE: It appears that this issues is present in Windows7 but not
Windows8.

 Cc: <stable@vger.kernel.org> # 3.8.x: 3f654ba: ACPICA: Interpreter: Fix
 Cc: <stable@vger.kernel.org> # 3.8.x
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpica/exoparg1.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/exoparg1.c b/drivers/acpi/acpica/exoparg1.c
index bbf01e9..1fa1ad6 100644
--- a/drivers/acpi/acpica/exoparg1.c
+++ b/drivers/acpi/acpica/exoparg1.c
@@ -997,11 +997,40 @@ acpi_status acpi_ex_opcode_1A_0T_1R(struct acpi_walk_state *walk_state)
 									 acpi_namespace_node
 									 *)
 									return_desc);
-				}
+					if (!return_desc) {
+						break;
+					}
+
+					/*
+					 * June 2013:
+					 * buffer_fields/field_units require additional resolution
+					 */
+					switch (return_desc->common.type) {
+					case ACPI_TYPE_BUFFER_FIELD:
+					case ACPI_TYPE_LOCAL_REGION_FIELD:
+					case ACPI_TYPE_LOCAL_BANK_FIELD:
+					case ACPI_TYPE_LOCAL_INDEX_FIELD:
+
+						status =
+						    acpi_ex_read_data_from_field
+						    (walk_state, return_desc,
+						     &temp_desc);
+						if (ACPI_FAILURE(status)) {
+							goto cleanup;
+						}
 
-				/* Add another reference to the object! */
+						return_desc = temp_desc;
+						break;
 
-				acpi_ut_add_reference(return_desc);
+					default:
+
+						/* Add another reference to the object */
+
+						acpi_ut_add_reference
+						    (return_desc);
+						break;
+					}
+				}
 				break;
 
 			default:
-- 
1.7.10

