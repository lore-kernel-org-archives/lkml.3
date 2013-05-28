Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab3E1VYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:24:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab3E1VYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:24:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 38/78] ACPI / EC: Restart transaction even when the IBF flag set
Date: Tue, 28 May 2013 14:19:47 -0700
Message-Id: <1369776027-17859-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 28fe5c825f8e15744d04c7c1b8df197950923ecd upstream.

The EC driver works abnormally with IBF flag always set.
IBF means "The host has written a byte of data to the command
or data port, but the embedded controller has not yet read it".
If IBF is set in the EC status and not cleared, this will cause
all subsequent EC requests to fail with a timeout error.

Change the EC driver so that it doesn't refuse to restart a
transaction if IBF is set in the status.  Also increase the
number of transaction restarts to 5, as it turns out that 2
is not sufficient in some cases.

This bug happens on several different machines (Asus V1S,
Dell Latitude E6530, Samsung R719, Acer Aspire 5930G,
Sony Vaio SR19VN and others).

[rjw: Changelog]
References: https://bugzilla.kernel.org/show_bug.cgi?id=14733
References: https://bugzilla.kernel.org/show_bug.cgi?id=15560
References: https://bugzilla.kernel.org/show_bug.cgi?id=15946
References: https://bugzilla.kernel.org/show_bug.cgi?id=42945
References: https://bugzilla.kernel.org/show_bug.cgi?id=48221
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/ec.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 354007d..a563e11 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -223,7 +223,7 @@ static int ec_check_sci_sync(struct acpi_ec *ec, u8 state)
 static int ec_poll(struct acpi_ec *ec)
 {
 	unsigned long flags;
-	int repeat = 2; /* number of command restarts */
+	int repeat = 5; /* number of command restarts */
 	while (repeat--) {
 		unsigned long delay = jiffies +
 			msecs_to_jiffies(ec_delay);
@@ -241,8 +241,6 @@ static int ec_poll(struct acpi_ec *ec)
 			}
 			advance_transaction(ec, acpi_ec_read_status(ec));
 		} while (time_before(jiffies, delay));
-		if (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF)
-			break;
 		pr_debug(PREFIX "controller reset, restart transaction\n");
 		spin_lock_irqsave(&ec->lock, flags);
 		start_transaction(ec);
-- 
1.8.1.2

