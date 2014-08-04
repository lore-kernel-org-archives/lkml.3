Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaHDQza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:55:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56623 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbaHDQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Arthur Chen" <axchen@nvidia.com>,
        "Steffen Weber" <steffen.weber@gmail.com>,
        "Lv Zheng" <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Barton Xu" <tank.xuhan@gmail.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.435558478@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 32/94] ACPI / EC: Avoid race condition related to
 advance_transaction()
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

commit 66b42b78bc1e816f92b662e8888c89195e4199e1 upstream.

The advance_transaction() will be invoked from the IRQ context GPE handler
and the task context ec_poll(). The handling of this function is locked so
that the EC state machine are ensured to be advanced sequentially.

But there is a problem. Before invoking advance_transaction(), EC_SC(R) is
read. Then for advance_transaction(), there could be race condition around
the lock from both contexts. The first one reading the register could fail
this race and when it passes the stale register value to the state machine
advancement code, the hardware condition is totally different from when
the register is read. And the hardware accesses determined from the wrong
hardware status can break the EC state machine. And there could be cases
that the functionalities of the platform firmware are seriously affected.
For example:
 1. When 2 EC_DATA(W) writes compete the IBF=0, the 2nd EC_DATA(W) write may
    be invalid due to IBF=1 after the 1st EC_DATA(W) write. Then the
    hardware will either refuse to respond a next EC_SC(W) write of the next
    command or discard the current WR_EC command when it receives a EC_SC(W)
    write of the next command.
 2. When 1 EC_SC(W) write and 1 EC_DATA(W) write compete the IBF=0, the
    EC_DATA(W) write may be invalid due to IBF=1 after the EC_SC(W) write.
    The next EC_DATA(R) could never be responded by the hardware. This is
    the root cause of the reported issue.

Fix this issue by moving the EC_SC(R) access into the lock so that we can
ensure that the state machine is advanced consistently.

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
[bwh: Backported to 3.2:
 - Adjust context
 - Use PREFIX in log message]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/ec.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -175,12 +175,15 @@ static void start_transaction(struct acp
 	acpi_ec_write_cmd(ec, ec->curr->command);
 }
 
-static void advance_transaction(struct acpi_ec *ec, u8 status)
+static void advance_transaction(struct acpi_ec *ec)
 {
 	unsigned long flags;
 	struct transaction *t;
+	u8 status;
 
 	spin_lock_irqsave(&ec->curr_lock, flags);
+	pr_debug(PREFIX "===== %s =====\n", in_interrupt() ? "IRQ" : "TASK");
+	status = acpi_ec_read_status(ec);
 	t = ec->curr;
 	if (!t)
 		goto unlock;
@@ -239,7 +242,7 @@ static int ec_poll(struct acpi_ec *ec)
 						msecs_to_jiffies(1)))
 					return 0;
 			}
-			advance_transaction(ec, acpi_ec_read_status(ec));
+			advance_transaction(ec);
 		} while (time_before(jiffies, delay));
 		pr_debug(PREFIX "controller reset, restart transaction\n");
 		spin_lock_irqsave(&ec->curr_lock, flags);
@@ -648,11 +651,8 @@ static u32 acpi_ec_gpe_handler(acpi_hand
 	u32 gpe_number, void *data)
 {
 	struct acpi_ec *ec = data;
-	u8 status = acpi_ec_read_status(ec);
-
-	pr_debug(PREFIX "~~~> interrupt, status:0x%02x\n", status);
 
-	advance_transaction(ec, status);
+	advance_transaction(ec);
 	if (ec_transaction_done(ec) &&
 	    (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF) == 0) {
 		wake_up(&ec->wait);

