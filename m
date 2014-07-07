Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaGGDK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:10:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:32616 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbaGGDKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:10:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,615,1400050800"; 
   d="scan'208";a="539517594"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [UPDATE PATCH v2 4/6] ACPI/EC: Fix a race condition in ec_transaction_completed().
Date: Mon,  7 Jul 2014 11:10:20 +0800
Message-Id: <26cad9936bba0da0c9e9e669922beb2f8e079c3d.1404700569.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1404700569.git.lv.zheng@intel.com>
References: <cover.1402792240.git.lv.zheng@intel.com> <cover.1404700569.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race condition in ec_transaction_completed().

When ec_transaction_completed() is called in the GPE handler, it could
return true because of (ec->curr == NULL). Then the wake_up() invocation
could complete the next command unexpectedly since there is no lock between
the 2 invocations. This is the root cause of the reported issue in 63931.

With the previous cleanup, we now needn't handle IBF=0 waiter race. It's
now safe for us to return a flag from advance_condition() to indicate the
requirement of wakeup, the flag is returned from a locked context.

The ec_transaction_completed() now is only invoked by the ec_poll() where
the ec->curr is ensured to be !NULL.

After cleaning up, the EVT_SCI=1 check should be moved out of the wakeup
condition so that an EVT_SCI raised with (ec->curr == NULL) can trigger a
QR_SC command.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=70891
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=63931
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=59911
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reported-and-tested-by: Gareth Williams <gareth@garethwilliams.me.uk>
Reported-and-tested-by: Hans de Goede <jwrdegoede@fedoraproject.org>
Reported-by: Barton Xu <tank.xuhan@gmail.com>
Tested-by: Arthur Chen <axchen@nvidia.com>
Tested-by: Steffen Weber <steffen.weber@gmail.com>
[zetalog: first affected by:]
Cc: <stable@vger.kernel.org> # 2.6.11: 7c6db4e0: ACPI: EC: do transaction from interrupt context
[zetalog: cleanly applying to:]
Cc: <stable@vger.kernel.org> # 3.14.x: 42b946bb: ACPI / EC: disable GPE before removing GPE handler
---
 drivers/acpi/ec.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index d016ea3..49d8990 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -158,16 +158,17 @@ static int ec_transaction_completed(struct acpi_ec *ec)
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
@@ -183,21 +184,25 @@ static void advance_transaction(struct acpi_ec *ec)
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
@@ -208,13 +213,14 @@ err:
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
@@ -248,7 +254,7 @@ static int ec_poll(struct acpi_ec *ec)
 					return 0;
 			}
 			spin_lock_irqsave(&ec->lock, flags);
-			advance_transaction(ec);
+			(void)advance_transaction(ec);
 			spin_unlock_irqrestore(&ec->lock, flags);
 		} while (time_before(jiffies, delay));
 		pr_debug("controller reset, restart transaction\n");
@@ -627,12 +633,10 @@ static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
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
1.7.10

