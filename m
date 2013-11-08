Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab3KHCRC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:17:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34488 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab3KHCQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 02/91] ACPICA: DeRefOf operator: Update to fully resolve FieldUnit and BufferField refs.
Date: Thu,  7 Nov 2013 18:14:17 -0800
Message-Id: <1383876946-2396-3-git-send-email-kamal@canonical.com>
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

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/acpica/exoparg1.c | 35 ++++++++++++++++++++++++++++++++---
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
1.8.1.2

