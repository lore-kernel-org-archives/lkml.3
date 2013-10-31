Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab3JaBLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 21:11:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:3598 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab3JaBLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 21:11:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,605,1378882800"; 
   d="scan'208";a="420023916"
From: Lv Zheng <lv.zheng@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Lv Zheng <lv.zheng@intel.com>, <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 3/4] ACPICA: Return error if DerefOf resolves to a null package element.
Date: Thu, 31 Oct 2013 09:10:02 +0800
Message-Id: <976668d117fd927c5b8fda914ee920c2708ad8b5.1383181113.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1383181113.git.lv.zheng@intel.com>
References: <cover.1383181113.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

commit a50abf4842dd7d603a2ad6dcc7f1467fd2a66f03 upstream.

Disallow the dereference of a reference (via index) to an uninitialized
package element. Provides compatibility with other ACPI
implementations. ACPICA BZ 1003.

 Cc: <stable@vger.kernel.org> # 3.8.x: 3f654ba: ACPICA: Interpreter: Fix
 Cc: <stable@vger.kernel.org> # 3.8.x: 63660e0: ACPICA: DeRefOf operator:
 Cc: <stable@vger.kernel.org> # 3.8.x
References: https://bugs.acpica.org/show_bug.cgi?id=431
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpica/exoparg1.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/exoparg1.c b/drivers/acpi/acpica/exoparg1.c
index 1fa1ad6..c9f1a21 100644
--- a/drivers/acpi/acpica/exoparg1.c
+++ b/drivers/acpi/acpica/exoparg1.c
@@ -969,10 +969,17 @@ acpi_status acpi_ex_opcode_1A_0T_1R(struct acpi_walk_state *walk_state)
 					 */
 					return_desc =
 					    *(operand[0]->reference.where);
-					if (return_desc) {
-						acpi_ut_add_reference
-						    (return_desc);
+					if (!return_desc) {
+						/*
+						 * Element is NULL, do not allow the dereference.
+						 * This provides compatibility with other ACPI
+						 * implementations.
+						 */
+						return_ACPI_STATUS
+						    (AE_AML_UNINITIALIZED_ELEMENT);
 					}
+
+					acpi_ut_add_reference(return_desc);
 					break;
 
 				default:
-- 
1.7.10

