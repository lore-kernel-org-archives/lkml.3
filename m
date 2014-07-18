Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161192AbaGRNQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:16:56 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17894 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935179AbaGRNQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:16:52 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 143/170] ACPI / EC: Remove duplicated ec_wait_ibf0() waiter
Date: Fri, 18 Jul 2014 14:12:28 +0200
Message-Id: <8c7ffca7f2ad7dbb3bb3834d4de11725cce69b85.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9b80f0f73ae1583c22325ede341c74195847618c upstream.

After we've added the first command byte write into advance_transaction(),
the IBF=0 waiter is duplicated with the command completion waiter
implemented in the ec_poll() because:
   If IBF=1 blocked the first command byte write invoked in the task
   context ec_poll(), it would be kicked off upon IBF=0 interrupt or timed
   out and retried again in the task context.

Remove this seperate and duplicate IBF=0 waiter.  By doing so we can
reduce the overall number of times to access the EC_SC(R) status
register.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=70891
Link: https://bugzilla.kernel.org/show_bug.cgi?id=63931
Link: https://bugzilla.kernel.org/show_bug.cgi?id=59911
Reported-and-tested-by: Gareth Williams <gareth@garethwilliams.me.uk>
Reported-and-tested-by: Hans de Goede <jwrdegoede@fedoraproject.org>
Reported-by: Barton Xu <tank.xuhan@gmail.com>
Tested-by: Steffen Weber <steffen.weber@gmail.com>
Tested-by: Arthur Chen <axchen@nvidia.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/acpi/ec.c | 27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 6e091a96d023..7b52a724a0dd 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -288,23 +288,6 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
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
@@ -325,12 +308,6 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 			goto unlock;
 		}
 	}
-	if (ec_wait_ibf0(ec)) {
-		pr_err(PREFIX "input buffer is not empty, "
-				"aborting transaction\n");
-		status = -ETIME;
-		goto end;
-	}
 	pr_debug(PREFIX "transaction start (cmd=0x%02x, addr=0x%02x)\n",
 			t->command, t->wdata ? t->wdata[0] : 0);
 	/* disable GPE during transaction if storm is detected */
@@ -354,7 +331,6 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
 	}
 	pr_debug(PREFIX "transaction end\n");
-end:
 	if (ec->global_lock)
 		acpi_release_global_lock(glk);
 unlock:
@@ -680,8 +656,7 @@ static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
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
2.0.0

