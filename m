Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbaKRPRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:17:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbaKROJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:30 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 002/206] ACPI / EC: Add support to disallow QR_EC to be issued when SCI_EVT isn't set
Date: Tue, 18 Nov 2014 15:05:57 +0100
Message-Id: <6c0b6ba79db1b33efe2e5233fbefcd26d1a5a022.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Cc: 3.16+ <stable@vger.kernel.org> # 3.16+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/acpi/ec.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 7171d52e12ca..edd453a760d0 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -193,6 +193,8 @@ static bool advance_transaction(struct acpi_ec *ec)
 				t->rdata[t->ri++] = acpi_ec_read_data(ec);
 				if (t->rlen == t->ri) {
 					t->flags |= ACPI_EC_COMMAND_COMPLETE;
+					if (t->command == ACPI_EC_COMMAND_QUERY)
+						pr_debug("hardware QR_EC completion\n");
 					wakeup = true;
 				}
 			} else
@@ -204,7 +206,20 @@ static bool advance_transaction(struct acpi_ec *ec)
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
2.1.3

