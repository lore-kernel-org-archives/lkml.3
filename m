Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbaIOU4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:56:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbaIOT1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.16 099/158] ACPI / EC: Add support to disallow QR_EC to be issued when SCI_EVT isnt set
Date: Mon, 15 Sep 2014 12:25:38 -0700
Message-Id: <20140915192545.857120129@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/ec.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -197,6 +197,8 @@ static bool advance_transaction(struct a
 				t->rdata[t->ri++] = acpi_ec_read_data(ec);
 				if (t->rlen == t->ri) {
 					t->flags |= ACPI_EC_COMMAND_COMPLETE;
+					if (t->command == ACPI_EC_COMMAND_QUERY)
+						pr_debug("hardware QR_EC completion\n");
 					wakeup = true;
 				}
 			} else
@@ -208,7 +210,20 @@ static bool advance_transaction(struct a
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


