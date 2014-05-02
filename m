Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaEBQJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:09:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43976 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbaEBPnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:43:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lv Zheng <lv.zheng@intel.com>, Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 023/151] ACPICA: Restore code that repairs NULL package elements in return values.
Date: Fri,  2 May 2014 08:36:51 -0700
Message-Id: <1399045139-4531-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lv Zheng <lv.zheng@intel.com>

commit 61db45ca21630f5ab7f678d54c5d969c21647854 upstream.

The original code was lost accidently, it was not generated along with the
following commit of mechanism improvements and thus not get merged:

  Commit: d5a36100f62fa6db5541344e08b361b34e9114c5
  Subject: ACPICA: Add mechanism for early object repairs on a per-name basis

  Adds the framework to allow object repairs very early in the
  return object analysis. Enables repairs like string->unicode,
  etc.

This patch restores the implementation of the NULL element repair code for
ACPI_RTYPE_NONE.  In the original design, ACPI_RTYPE_NONE is defined to
collect simple NULL object repairs.
Lv Zheng.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=67901
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/acpica/nsrepair.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpica/nsrepair.c b/drivers/acpi/acpica/nsrepair.c
index a05afff..b6f6863 100644
--- a/drivers/acpi/acpica/nsrepair.c
+++ b/drivers/acpi/acpica/nsrepair.c
@@ -207,13 +207,30 @@ acpi_ns_simple_repair(struct acpi_evaluate_info *info,
 	 * this predefined name. Either one return value is expected, or none,
 	 * for both methods and other objects.
 	 *
-	 * Exit now if there is no return object. Warning if one was expected.
+	 * Try to fix if there was no return object. Warning if failed to fix.
 	 */
 	if (!return_object) {
 		if (expected_btypes && (!(expected_btypes & ACPI_RTYPE_NONE))) {
-			ACPI_WARN_PREDEFINED((AE_INFO, info->full_pathname,
-					      ACPI_WARN_ALWAYS,
-					      "Missing expected return value"));
+			if (package_index != ACPI_NOT_PACKAGE_ELEMENT) {
+				ACPI_WARN_PREDEFINED((AE_INFO,
+						      info->full_pathname,
+						      ACPI_WARN_ALWAYS,
+						      "Found unexpected NULL package element"));
+
+				status =
+				    acpi_ns_repair_null_element(info,
+								expected_btypes,
+								package_index,
+								return_object_ptr);
+				if (ACPI_SUCCESS(status)) {
+					return (AE_OK);	/* Repair was successful */
+				}
+			} else {
+				ACPI_WARN_PREDEFINED((AE_INFO,
+						      info->full_pathname,
+						      ACPI_WARN_ALWAYS,
+						      "Missing expected return value"));
+			}
 
 			return (AE_AML_NO_RETURN_VALUE);
 		}
-- 
1.9.1

