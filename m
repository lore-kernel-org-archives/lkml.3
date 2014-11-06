Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaKFWm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:42:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58851 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaKFWmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:42:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 162/162] ACPI / EC: Fix regression due to conflicting firmware behavior between Samsung and Acer.
Date: Thu,  6 Nov 2014 14:37:06 -0800
Message-Id: <1415313426-9622-163-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lv Zheng <lv.zheng@intel.com>

commit 79149001105f18bd2285ada109f9229ea24a7571 upstream.

It is reported that Samsung laptops that need to poll events are broken by
the following commit:
 Commit 3afcf2ece453e1a8c2c6de19cdf06da3772a1b08
 Subject: ACPI / EC: Add support to disallow QR_EC to be issued when SCI_EVT isn't set

The behaviors of the 2 vendor firmwares are conflict:
 1. Acer: OSPM shouldn't issue QR_EC unless SCI_EVT is set, firmware
         automatically sets SCI_EVT as long as there is event queued up.
 2. Samsung: OSPM should issue QR_EC whatever SCI_EVT is set, firmware
            returns 0 when there is no event queued up.

This patch is a quick fix to distinguish the behaviors to make Acer
behavior only effective for Acer EC firmware so that the breakages on
Samsung EC firmware can be avoided.

Fixes: 3afcf2ece453 (ACPI / EC: Add support to disallow QR_EC to be issued ...)
Link: https://bugzilla.kernel.org/show_bug.cgi?id=44161
Reported-and-tested-by: Ortwin Glück <odi@odi.ch>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
[ rjw : Subject ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/ec.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index aa232a3..8c02f84 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -127,6 +127,7 @@ static int EC_FLAGS_MSI; /* Out-of-spec MSI controller */
 static int EC_FLAGS_VALIDATE_ECDT; /* ASUStec ECDTs need to be validated */
 static int EC_FLAGS_SKIP_DSDT_SCAN; /* Not all BIOS survive early DSDT scan */
 static int EC_FLAGS_CLEAR_ON_RESUME; /* Needs acpi_ec_clear() on boot/resume */
+static int EC_FLAGS_QUERY_HANDSHAKE; /* Needs QR_EC issued when SCI_EVT set */
 
 /* --------------------------------------------------------------------------
                              Transaction Management
@@ -204,13 +205,8 @@ static bool advance_transaction(struct acpi_ec *ec)
 		}
 		return wakeup;
 	} else {
-		/*
-		 * There is firmware refusing to respond QR_EC when SCI_EVT
-		 * is not set, for which case, we complete the QR_EC
-		 * without issuing it to the firmware.
-		 * https://bugzilla.kernel.org/show_bug.cgi?id=86211
-		 */
-		if (!(status & ACPI_EC_FLAG_SCI) &&
+		if (EC_FLAGS_QUERY_HANDSHAKE &&
+		    !(status & ACPI_EC_FLAG_SCI) &&
 		    (t->command == ACPI_EC_COMMAND_QUERY)) {
 			t->flags |= ACPI_EC_COMMAND_POLL;
 			t->rdata[t->ri++] = 0x00;
@@ -996,6 +992,18 @@ static int ec_enlarge_storm_threshold(const struct dmi_system_id *id)
 }
 
 /*
+ * Acer EC firmware refuses to respond QR_EC when SCI_EVT is not set, for
+ * which case, we complete the QR_EC without issuing it to the firmware.
+ * https://bugzilla.kernel.org/show_bug.cgi?id=86211
+ */
+static int ec_flag_query_handshake(const struct dmi_system_id *id)
+{
+	pr_debug("Detected the EC firmware requiring QR_EC issued when SCI_EVT set\n");
+	EC_FLAGS_QUERY_HANDSHAKE = 1;
+	return 0;
+}
+
+/*
  * On some hardware it is necessary to clear events accumulated by the EC during
  * sleep. These ECs stop reporting GPEs until they are manually polled, if too
  * many events are accumulated. (e.g. Samsung Series 5/9 notebooks)
@@ -1065,6 +1073,9 @@ static struct dmi_system_id ec_dmi_table[] __initdata = {
 	{
 	ec_clear_on_resume, "Samsung hardware", {
 	DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD.")}, NULL},
+	{
+	ec_flag_query_handshake, "Acer hardware", {
+	DMI_MATCH(DMI_SYS_VENDOR, "Acer"), }, NULL},
 	{},
 };
 
-- 
1.9.1

