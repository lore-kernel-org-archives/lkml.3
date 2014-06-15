Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaFOAmG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 20:42:06 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53764 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaFOAmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 20:42:04 -0400
From: Lv Zheng <zetalog@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <zetalog@gmail.com>, Lv Zheng <lv.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 3/7] ACPI/EC: Remove duplicated ec_wait_ibf0() waiter.
Date: Sun, 15 Jun 2014 08:41:48 +0800
Message-Id: <5f8350870bcee8d92704eef1285d03725a576c26.1402792240.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1402792240.git.lv.zheng@intel.com>
References: <cover.1402543079.git.lv.zheng@intel.com> <cover.1402792240.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

After we've added the first command byte write into advance_transaction(),
the IBF=0 waiter is duplicated with the command completion waiter
implemented in the ec_poll() because:
   If IBF=1 blocked the first command byte write invoked in the task
   context ec_poll(), it would be kicked off upon IBF=0 interrupt or timed
   out and retried again in the task context.
This patch removes this seperate and duplicate IBF=0 waiter, by doing so,
we can reduce the overall number of times to access the EC_SC(R) status
register.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=70891
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reported-and-tested-by: Gareth Williams <gareth@garethwilliams.me.uk>
Tested-by: Steffen Weber <steffen.weber@gmail.com>
[zetalog: first affected by:]
Cc: <stable@vger.kernel.org> # 2.6.11: 7c6db4e0: ACPI: EC: do transaction from interrupt context
[zetalog: cleanly applying to:]
Cc: <stable@vger.kernel.org> # 3.14.x: 42b946bb: ACPI / EC: disable GPE before removing GPE handler
---
 drivers/acpi/ec.c |   27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index f09386e..d016ea3 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -281,23 +281,6 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	return ret;
 }
 
-static int ec_check_ibf0(struct acpi_ec *ec)
-{
-	u8 status = acpi_ec_read_status(ec);
-	return (status & ACPI_EC_FLAG_IBF) == 0;
-}
-
-static int ec_wait_ibf0(struct acpi_ec *ec)
-{
-	unsigned long delay = jiffies + msecs_to_jiffies(ec_delay);
-	/* interrupt wait manually if GPE mode is not active */
-	while (time_before(jiffies, delay))
-		if (wait_event_timeout(ec->wait, ec_check_ibf0(ec),
-					msecs_to_jiffies(1)))
-			return 0;
-	return -ETIME;
-}
-
 static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 {
 	int status;
@@ -318,12 +301,6 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 			goto unlock;
 		}
 	}
-	if (ec_wait_ibf0(ec)) {
-		pr_err("input buffer is not empty, "
-				"aborting transaction\n");
-		status = -ETIME;
-		goto end;
-	}
 	pr_debug("transaction start (cmd=0x%02x, addr=0x%02x)\n",
 			t->command, t->wdata ? t->wdata[0] : 0);
 	/* disable GPE during transaction if storm is detected */
@@ -347,7 +324,6 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
 	}
 	pr_debug("transaction end\n");
-end:
 	if (ec->global_lock)
 		acpi_release_global_lock(glk);
 unlock:
@@ -653,8 +629,7 @@ static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
 	spin_lock_irqsave(&ec->lock, flags);
 	advance_transaction(ec);
 	spin_unlock_irqrestore(&ec->lock, flags);
-	if (ec_transaction_completed(ec) &&
-	    (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF) == 0) {
+	if (ec_transaction_completed(ec)) {
 		wake_up(&ec->wait);
 		ec_check_sci(ec, acpi_ec_read_status(ec));
 	}
-- 
1.7.10

