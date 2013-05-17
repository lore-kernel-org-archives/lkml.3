Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab3EQVup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:50:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579Ab3EQVum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:50:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 29/33] ACPI / EC: Restart transaction even when the IBF flag set
Date: Fri, 17 May 2013 14:50:13 -0700
Message-Id: <20130517214920.025232500@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517214916.821259930@linuxfoundation.org>
References: <20130517214916.821259930@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


