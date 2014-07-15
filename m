Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761170AbaGPACE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:02:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933312AbaGOXNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Barton Xu <tank.xuhan@gmail.com>,
        Steffen Weber <steffen.weber@gmail.com>,
        Arthur Chen <axchen@nvidia.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 23/66] ACPI / EC: Remove duplicated ec_wait_ibf0() waiter
Date: Tue, 15 Jul 2014 16:17:17 -0700
Message-Id: <20140715231703.061926159@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231702.156040999@linuxfoundation.org>
References: <20140715231702.156040999@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/ec.c |   27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -281,23 +281,6 @@ static int acpi_ec_transaction_unlocked(
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
@@ -318,12 +301,6 @@ static int acpi_ec_transaction(struct ac
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
@@ -347,7 +324,6 @@ static int acpi_ec_transaction(struct ac
 		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
 	}
 	pr_debug("transaction end\n");
-end:
 	if (ec->global_lock)
 		acpi_release_global_lock(glk);
 unlock:
@@ -653,8 +629,7 @@ static u32 acpi_ec_gpe_handler(acpi_hand
 	spin_lock_irqsave(&ec->lock, flags);
 	advance_transaction(ec);
 	spin_unlock_irqrestore(&ec->lock, flags);
-	if (ec_transaction_completed(ec) &&
-	    (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF) == 0) {
+	if (ec_transaction_completed(ec)) {
 		wake_up(&ec->wait);
 		ec_check_sci(ec, acpi_ec_read_status(ec));
 	}


