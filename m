Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaKFXE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:04:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58859 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaKFWmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:42:25 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 161/162] ACPI / EC: Add support to disallow QR_EC to be issued when SCI_EVT isn't set
Date: Thu,  6 Nov 2014 14:37:05 -0800
Message-Id: <1415313426-9622-162-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lv Zheng <lv.zheng@intel.com>

commit 3afcf2ece453e1a8c2c6de19cdf06da3772a1b08 upstream.

There is a platform refusing to respond QR_EC when SCI_EVT isn't set
(Acer Aspire V5-573G).

Currently, we rely on the behaviour that the EC firmware can respond
something (for example, 0x00 to indicate "no outstanding events") to
QR_EC even when SCI_EVT is not set, but the reporter has complained
about AC/battery pluging/unpluging and video brightness change delay
on that platform.

This is because the work item that has issued QR_EC has to wait until
timeout in this case, and the _Qxx method evaluation work item queued
after QR_EC one is delayed.

It sounds reasonable to fix this issue by:
 1. Implementing SCI_EVT sanity check before issuing QR_EC in the EC
    driver's main state machine.
 2. Moving QR_EC issuing out of the work queue used by _Qxx evaluation
    to a seperate IRQ handling thread.

This patch fixes this issue using solution 1.

By disallowing QR_EC to be issued when SCI_EVT isn't set, we are able to
handle such platform in the EC driver's main state machine. This patch
enhances the state machine in this way to survive with such malfunctioning
EC firmware.

Note that this patch can also fix CLEAR_ON_RESUME quirk which also relies
on the assumption that the platforms are able to respond even when SCI_EVT
isn't set.

Fixes: c0d653412fc8 ACPI / EC: Fix race condition in ec_transaction_completed()
Link: https://bugzilla.kernel.org/show_bug.cgi?id=82611
Reported-and-tested-by: Alexander Mezin <mezin.alexander@gmail.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/ec.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 3b20294..aa232a3 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -191,6 +191,8 @@ static bool advance_transaction(struct acpi_ec *ec)
 				t->rdata[t->ri++] = acpi_ec_read_data(ec);
 				if (t->rlen == t->ri) {
 					t->flags |= ACPI_EC_COMMAND_COMPLETE;
+					if (t->command == ACPI_EC_COMMAND_QUERY)
+						pr_debug("hardware QR_EC completion\n");
 					wakeup = true;
 				}
 			} else
@@ -202,7 +204,20 @@ static bool advance_transaction(struct acpi_ec *ec)
 		}
 		return wakeup;
 	} else {
-		if ((status & ACPI_EC_FLAG_IBF) == 0) {
+		/*
+		 * There is firmware refusing to respond QR_EC when SCI_EVT
+		 * is not set, for which case, we complete the QR_EC
+		 * without issuing it to the firmware.
+		 * https://bugzilla.kernel.org/show_bug.cgi?id=86211
+		 */
+		if (!(status & ACPI_EC_FLAG_SCI) &&
+		    (t->command == ACPI_EC_COMMAND_QUERY)) {
+			t->flags |= ACPI_EC_COMMAND_POLL;
+			t->rdata[t->ri++] = 0x00;
+			t->flags |= ACPI_EC_COMMAND_COMPLETE;
+			pr_debug("software QR_EC completion\n");
+			wakeup = true;
+		} else if ((status & ACPI_EC_FLAG_IBF) == 0) {
 			acpi_ec_write_cmd(ec, t->command);
 			t->flags |= ACPI_EC_COMMAND_POLL;
 		} else
-- 
1.9.1

