Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934770AbaGXJtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:49:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55126 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600AbaGXJsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 105/128] ACPI / EC: Fix race condition in ec_transaction_completed()
Date: Thu, 24 Jul 2014 10:45:54 +0100
Message-Id: <1406195177-8656-106-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lv Zheng <lv.zheng@intel.com>

commit c0d653412fc8450370167a3268b78fc772ff9c87 upstream.

There is a race condition in ec_transaction_completed().

When ec_transaction_completed() is called in the GPE handler, it could
return true because of (ec->curr == NULL). Then the wake_up() invocation
could complete the next command unexpectedly since there is no lock between
the 2 invocations. With the previous cleanup, the IBF=0 waiter race need
not be handled any more. It's now safe to return a flag from
advance_condition() to indicate the requirement of wakeup, the flag is
returned from a locked context.

The ec_transaction_completed() is now only invoked by the ec_poll() where
the ec->curr is ensured to be different from NULL.

After cleaning up, the EVT_SCI=1 check should be moved out of the wakeup
condition so that an EVT_SCI raised with (ec->curr == NULL) can trigger a
QR_SC command.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/ec.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 59bf2d016fd1..8bcc70cdb1a0 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -165,16 +165,17 @@ static int ec_transaction_completed(struct acpi_ec *ec)
 	unsigned long flags;
 	int ret = 0;
 	spin_lock_irqsave(&ec->lock, flags);
-	if (!ec->curr || (ec->curr->flags & ACPI_EC_COMMAND_COMPLETE))
+	if (ec->curr && (ec->curr->flags & ACPI_EC_COMMAND_COMPLETE))
 		ret = 1;
 	spin_unlock_irqrestore(&ec->lock, flags);
 	return ret;
 }
 
-static void advance_transaction(struct acpi_ec *ec)
+static bool advance_transaction(struct acpi_ec *ec)
 {
 	struct transaction *t;
 	u8 status;
+	bool wakeup = false;
 
 	pr_debug("===== %s =====\n", in_interrupt() ? "IRQ" : "TASK");
 	status = acpi_ec_read_status(ec);
@@ -190,21 +191,25 @@ static void advance_transaction(struct acpi_ec *ec)
 		} else if (t->rlen > t->ri) {
 			if ((status & ACPI_EC_FLAG_OBF) == 1) {
 				t->rdata[t->ri++] = acpi_ec_read_data(ec);
-				if (t->rlen == t->ri)
+				if (t->rlen == t->ri) {
 					t->flags |= ACPI_EC_COMMAND_COMPLETE;
+					wakeup = true;
+				}
 			} else
 				goto err;
 		} else if (t->wlen == t->wi &&
-			   (status & ACPI_EC_FLAG_IBF) == 0)
+			   (status & ACPI_EC_FLAG_IBF) == 0) {
 			t->flags |= ACPI_EC_COMMAND_COMPLETE;
-		return;
+			wakeup = true;
+		}
+		return wakeup;
 	} else {
 		if ((status & ACPI_EC_FLAG_IBF) == 0) {
 			acpi_ec_write_cmd(ec, t->command);
 			t->flags |= ACPI_EC_COMMAND_POLL;
 		} else
 			goto err;
-		return;
+		return wakeup;
 	}
 err:
 	/*
@@ -215,13 +220,14 @@ err:
 		if (in_interrupt() && t)
 			++t->irq_count;
 	}
+	return wakeup;
 }
 
 static void start_transaction(struct acpi_ec *ec)
 {
 	ec->curr->irq_count = ec->curr->wi = ec->curr->ri = 0;
 	ec->curr->flags = 0;
-	advance_transaction(ec);
+	(void)advance_transaction(ec);
 }
 
 static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data);
@@ -255,7 +261,7 @@ static int ec_poll(struct acpi_ec *ec)
 					return 0;
 			}
 			spin_lock_irqsave(&ec->lock, flags);
-			advance_transaction(ec);
+			(void)advance_transaction(ec);
 			spin_unlock_irqrestore(&ec->lock, flags);
 		} while (time_before(jiffies, delay));
 		pr_debug(PREFIX "controller reset, restart transaction\n");
@@ -654,12 +660,10 @@ static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
 	struct acpi_ec *ec = data;
 
 	spin_lock_irqsave(&ec->lock, flags);
-	advance_transaction(ec);
-	spin_unlock_irqrestore(&ec->lock, flags);
-	if (ec_transaction_completed(ec)) {
+	if (advance_transaction(ec))
 		wake_up(&ec->wait);
-		ec_check_sci(ec, acpi_ec_read_status(ec));
-	}
+	spin_unlock_irqrestore(&ec->lock, flags);
+	ec_check_sci(ec, acpi_ec_read_status(ec));
 	return ACPI_INTERRUPT_HANDLED | ACPI_REENABLE_GPE;
 }
 
-- 
1.9.1

