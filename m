Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab3E1D4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52616 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758879Ab3E1DyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:19 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Lan Tianyu" <tianyu.lan@intel.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.224784937@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [27/94] ACPI / EC: Restart transaction even when the IBF flag set
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/ec.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -217,7 +217,7 @@ static int ec_check_sci_sync(struct acpi
 static int ec_poll(struct acpi_ec *ec)
 {
 	unsigned long flags;
-	int repeat = 2; /* number of command restarts */
+	int repeat = 5; /* number of command restarts */
 	while (repeat--) {
 		unsigned long delay = jiffies +
 			msecs_to_jiffies(ec_delay);
@@ -235,8 +235,6 @@ static int ec_poll(struct acpi_ec *ec)
 			}
 			advance_transaction(ec, acpi_ec_read_status(ec));
 		} while (time_before(jiffies, delay));
-		if (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF)
-			break;
 		pr_debug(PREFIX "controller reset, restart transaction\n");
 		spin_lock_irqsave(&ec->curr_lock, flags);
 		start_transaction(ec);

