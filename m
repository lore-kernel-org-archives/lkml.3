Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbaKRPRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:17:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900AbaKROJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:30 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 003/206] ACPI / EC: Fix regression due to conflicting firmware behavior between Samsung and Acer.
Date: Tue, 18 Nov 2014 15:05:58 +0100
Message-Id: <92f4ce188b5d85a7c26809b830994caf5625b3e8.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Cc: 3.17+ <stable@vger.kernel.org> # 3.17+
[ rjw : Subject ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/acpi/ec.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index edd453a760d0..85752c668473 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -129,6 +129,7 @@ static int EC_FLAGS_MSI; /* Out-of-spec MSI controller */
 static int EC_FLAGS_VALIDATE_ECDT; /* ASUStec ECDTs need to be validated */
 static int EC_FLAGS_SKIP_DSDT_SCAN; /* Not all BIOS survive early DSDT scan */
 static int EC_FLAGS_CLEAR_ON_RESUME; /* Needs acpi_ec_clear() on boot/resume */
+static int EC_FLAGS_QUERY_HANDSHAKE; /* Needs QR_EC issued when SCI_EVT set */
 
 /* --------------------------------------------------------------------------
                              Transaction Management
@@ -206,13 +207,8 @@ static bool advance_transaction(struct acpi_ec *ec)
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
@@ -997,6 +993,18 @@ static int ec_enlarge_storm_threshold(const struct dmi_system_id *id)
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
@@ -1066,6 +1074,9 @@ static struct dmi_system_id ec_dmi_table[] __initdata = {
 	{
 	ec_clear_on_resume, "Samsung hardware", {
 	DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD.")}, NULL},
+	{
+	ec_flag_query_handshake, "Acer hardware", {
+	DMI_MATCH(DMI_SYS_VENDOR, "Acer"), }, NULL},
 	{},
 };
 
-- 
2.1.3

