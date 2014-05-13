Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814AbaEMKk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:40:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60764 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760034AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lv Zheng <lv.zheng@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 027/182] ACPICA: Restore code that repairs NULL package elements in return values.
Date: Tue, 13 May 2014 11:26:19 +0200
Message-Id: <6c64550f4fd6baf7abb9480ab549e63de1d00950.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/acpi/acpica/nsrepair.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpica/nsrepair.c b/drivers/acpi/acpica/nsrepair.c
index f8e71ea60319..b2d247356c7d 100644
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
1.9.3

