Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaFMGvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:51:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:35548 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbaFMGvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:51:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,470,1400050800"; 
   d="scan'208";a="445043045"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 1/7] ACPI/EC: Fix an issue that advance_transaction() processes stale hardware status.
Date: Fri, 13 Jun 2014 14:51:13 +0800
Message-Id: <6c0639ae1184a183cd69e93d05b1463a6e2b1528.1402641700.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1402641700.git.lv.zheng@intel.com>
References: <cover.1402641700.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advance_transaction() will be invoked from the IRQ context GPE handler
and the task context ec_poll(). The handling of this function is locked so
that the EC state machine are ensured to be advanced sequentially.

But there is a problem. Before invoking advance_transaction(), EC_SC(R) is
read. Then for advance_transaction(), there could be race condition around
the lock from both contexts. The first one reading the register could fail
this race and when it passes the stale register value to the state machine
advancement code, the hardware condition is totally different from when
the register is read. And the hardware accesses determined from the wrong
hardware status can break the EC state machine. For example:
1. When 2 EC_DATA(W) write compete the IBF=0, the 2nd EC_DATA(W) write may
   be invalid due to IBF=1 after the 1st EC_DATA(W).
2. When 1 EC_DATA(W) and 1 EC_SC(W) writes compete the IBF=0, the EC_SC(W)
   write may be invalid due to IBF=1 after the EC_DATA(W). This is the root
   cause of the reported issue.

This patch fixes this issue by moving the EC_SC(R) access into the lock so
that we can ensure that the state machine is advanced under the right
condition.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=70891
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reported-and-tested-by: Gareth Williams <gareth@garethwilliams.me.uk>
Tested-by: Steffen Weber <steffen.weber@gmail.com>
[zetalog: first affected by:]
Cc: <stable@vger.kernel.org> # 2.6.11: 7c6db4e0: ACPI: EC: do transaction from interrupt context
[zetalog: cleanly applying to:]
Cc: <stable@vger.kernel.org> # 3.14.x: 42b946bb: ACPI / EC: disable GPE before removing GPE handler
---
 drivers/acpi/ec.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index ad11ba4..762b4cc 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -168,12 +168,15 @@ static void start_transaction(struct acpi_ec *ec)
 	acpi_ec_write_cmd(ec, ec->curr->command);
 }
 
-static void advance_transaction(struct acpi_ec *ec, u8 status)
+static void advance_transaction(struct acpi_ec *ec)
 {
 	unsigned long flags;
 	struct transaction *t;
+	u8 status;
 
 	spin_lock_irqsave(&ec->lock, flags);
+	pr_debug("===== %s =====\n", in_interrupt() ? "IRQ" : "TASK");
+	status = acpi_ec_read_status(ec);
 	t = ec->curr;
 	if (!t)
 		goto unlock;
@@ -236,7 +239,7 @@ static int ec_poll(struct acpi_ec *ec)
 						msecs_to_jiffies(1)))
 					return 0;
 			}
-			advance_transaction(ec, acpi_ec_read_status(ec));
+			advance_transaction(ec);
 		} while (time_before(jiffies, delay));
 		pr_debug("controller reset, restart transaction\n");
 		spin_lock_irqsave(&ec->lock, flags);
@@ -635,11 +638,8 @@ static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
 	u32 gpe_number, void *data)
 {
 	struct acpi_ec *ec = data;
-	u8 status = acpi_ec_read_status(ec);
-
-	pr_debug("~~~> interrupt, status:0x%02x\n", status);
 
-	advance_transaction(ec, status);
+	advance_transaction(ec);
 	if (ec_transaction_done(ec) &&
 	    (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF) == 0) {
 		wake_up(&ec->wait);
-- 
1.7.10

