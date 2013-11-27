Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686Ab3K0B6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:58:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364Ab3K0A5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.10 01/80] ACPICA: DeRefOf operator: Update to fully resolve FieldUnit and BufferField refs.
Date: Tue, 26 Nov 2013 16:56:30 -0800
Message-Id: <20131127005641.039794736@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/exoparg1.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

--- a/drivers/acpi/acpica/exoparg1.c
+++ b/drivers/acpi/acpica/exoparg1.c
@@ -991,11 +991,40 @@ acpi_status acpi_ex_opcode_1A_0T_1R(stru
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


