Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaEDPlY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:41:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbaEDPlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 029/158] ACPICA: Restore code that repairs NULL package elements in return values.
Date: Sun,  4 May 2014 11:38:58 -0400
Message-Id: <20140504154033.987693333@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/nsrepair.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/drivers/acpi/acpica/nsrepair.c
+++ b/drivers/acpi/acpica/nsrepair.c
@@ -207,13 +207,30 @@ acpi_ns_simple_repair(struct acpi_evalua
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


