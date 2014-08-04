Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaHDQzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:55:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56624 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151AbaHDQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Lv Zheng" <lv.zheng@intel.com>,
        "Steffen Weber" <steffen.weber@gmail.com>,
        "Arthur Chen" <axchen@nvidia.com>, "Barton Xu" <tank.xuhan@gmail.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.877006260@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 35/94] ACPI / EC: Remove duplicated ec_wait_ibf0() waiter
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Lv Zheng <lv.zheng@intel.com>

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/ec.c | 27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -288,23 +288,6 @@ static int acpi_ec_transaction_unlocked(
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
@@ -325,12 +308,6 @@ static int acpi_ec_transaction(struct ac
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
@@ -354,7 +331,6 @@ static int acpi_ec_transaction(struct ac
 		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
 	}
 	pr_debug(PREFIX "transaction end\n");
-end:
 	if (ec->global_lock)
 		acpi_release_global_lock(glk);
 unlock:
@@ -670,8 +646,7 @@ static u32 acpi_ec_gpe_handler(acpi_hand
 	spin_lock_irqsave(&ec->curr_lock, flags);
 	advance_transaction(ec);
 	spin_unlock_irqrestore(&ec->curr_lock, flags);
-	if (ec_transaction_completed(ec) &&
-	    (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF) == 0) {
+	if (ec_transaction_completed(ec)) {
 		wake_up(&ec->wait);
 		ec_check_sci(ec, acpi_ec_read_status(ec));
 	}

