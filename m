Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab3KHCQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:16:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34444 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab3KHCQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 03/91] ACPICA: Return error if DerefOf resolves to a null package element.
Date: Thu,  7 Nov 2013 18:14:18 -0800
Message-Id: <1383876946-2396-4-git-send-email-kamal@canonical.com>
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

commit a50abf4842dd7d603a2ad6dcc7f1467fd2a66f03 upstream.

Disallow the dereference of a reference (via index) to an uninitialized
package element. Provides compatibility with other ACPI
implementations. ACPICA BZ 1003.

References: https://bugs.acpica.org/show_bug.cgi?id=431
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/acpica/exoparg1.c | 13 ++++++++++---
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
1.8.1.2

