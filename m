Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab3IIMLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 08:11:22 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39297 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab3IIMLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 08:11:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Peter Wu <lekensteyn@gmail.com>
Subject: [PATCH] ACPI / bind: Prefer device objects with _STA to those without it
Date: Mon, 09 Sep 2013 14:22:19 +0200
Message-ID: <5039378.mVJXDJKcfO@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

As reported at https://bugzilla.kernel.org/show_bug.cgi?id=60829,
there still are cases in which do_find_child() doesn't choose the
ACPI device object it is "expected" to choose if there are more such
objects matching one PCI device present.  This particular problem may
be worked around by making do_find_child() return device obejcts witn
_STA whose result indicates that the device is enabled before device
objects without _STA if there's more than one device object to choose
from.

This change doesn't affect the case in which there's only one
matching ACPI device object per PCI device.

References: https://bugzilla.kernel.org/show_bug.cgi?id=60829
Reported-by: Peter Wu <lekensteyn@gmail.com>
Tested-by: Felix Lisczyk <felix.lisczyk@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c |   35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -79,6 +79,9 @@ static struct acpi_bus_type *acpi_get_bu
 	return ret;
 }
 
+#define FIND_CHILD_MIN_SCORE	1
+#define FIND_CHILD_MAX_SCORE	2
+
 static acpi_status acpi_dev_present(acpi_handle handle, u32 lvl_not_used,
 				  void *not_used, void **ret_p)
 {
@@ -92,14 +95,17 @@ static acpi_status acpi_dev_present(acpi
 	return AE_OK;
 }
 
-static bool acpi_extra_checks_passed(acpi_handle handle, bool is_bridge)
+static int do_find_child_checks(acpi_handle handle, bool is_bridge)
 {
+	bool sta_present = true;
 	unsigned long long sta;
 	acpi_status status;
 
-	status = acpi_bus_get_status_handle(handle, &sta);
-	if (ACPI_FAILURE(status) || !(sta & ACPI_STA_DEVICE_ENABLED))
-		return false;
+	status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+	if (status == AE_NOT_FOUND)
+		sta_present = false;
+	else if (ACPI_FAILURE(status) || !(sta & ACPI_STA_DEVICE_ENABLED))
+		return -ENODEV;
 
 	if (is_bridge) {
 		void *test = NULL;
@@ -107,16 +113,17 @@ static bool acpi_extra_checks_passed(acp
 		/* Check if this object has at least one child device. */
 		acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
 				    acpi_dev_present, NULL, NULL, &test);
-		return !!test;
+		if (!test)
+			return -ENODEV;
 	}
-	return true;
+	return sta_present ? FIND_CHILD_MAX_SCORE : FIND_CHILD_MIN_SCORE;
 }
 
 struct find_child_context {
 	u64 addr;
 	bool is_bridge;
 	acpi_handle ret;
-	bool ret_checked;
+	int ret_score;
 };
 
 static acpi_status do_find_child(acpi_handle handle, u32 lvl_not_used,
@@ -125,6 +132,7 @@ static acpi_status do_find_child(acpi_ha
 	struct find_child_context *context = data;
 	unsigned long long addr;
 	acpi_status status;
+	int score;
 
 	status = acpi_evaluate_integer(handle, METHOD_NAME__ADR, NULL, &addr);
 	if (ACPI_FAILURE(status) || addr != context->addr)
@@ -144,15 +152,20 @@ static acpi_status do_find_child(acpi_ha
 	 * its handle if so.  Second, check the same for the object that we've
 	 * just found.
 	 */
-	if (!context->ret_checked) {
-		if (acpi_extra_checks_passed(context->ret, context->is_bridge))
+	if (!context->ret_score) {
+		score = do_find_child_checks(context->ret, context->is_bridge);
+		if (score == FIND_CHILD_MAX_SCORE)
 			return AE_CTRL_TERMINATE;
 		else
-			context->ret_checked = true;
+			context->ret_score = score;
 	}
-	if (acpi_extra_checks_passed(handle, context->is_bridge)) {
+	score = do_find_child_checks(handle, context->is_bridge);
+	if (score == FIND_CHILD_MAX_SCORE) {
 		context->ret = handle;
 		return AE_CTRL_TERMINATE;
+	} else if (score > context->ret_score) {
+		context->ret = handle;
+		context->ret_score = score;
 	}
 	return AE_OK;
 }

