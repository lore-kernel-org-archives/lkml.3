Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaFGB1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:27:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36175 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dennis Jansen" <dennis.jansen@web.de>,
        "Juan Manuel Cabo" <juanmanuel.cabo@gmail.com>,
        "Kieran Clancy" <clancy.kieran@gmail.com>,
        "Nicolas Porcel" <nicolasporcel06@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Giannis Koutsou" <giannis.koutsou@gmail.com>,
        "Maurizio D'Addona" <mauritiusdadd@gmail.com>,
        "Stefan Biereigel" <stefan@biereigel.de>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.686682608@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 03/92] ACPI / EC: Process rather than discard events
 in acpi_ec_clear
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kieran Clancy <clancy.kieran@gmail.com>

commit 3eba563e280101209bad27d40bfc83ddf1489234 upstream.

Address a regression caused by commit ad332c8a4533:
(ACPI / EC: Clear stale EC events on Samsung systems)

After the earlier patch, there was found to be a race condition on some
earlier Samsung systems (N150/N210/N220). The function acpi_ec_clear was
sometimes discarding a new EC event before its GPE was triggered by the
system. In the case of these systems, this meant that the "lid open"
event was not registered on resume if that was the cause of the wake,
leading to problems when attempting to close the lid to suspend again.

After testing on a number of Samsung systems, both those affected by the
previous EC bug and those affected by the race condition, it seemed that
the best course of action was to process rather than discard the events.
On Samsung systems which accumulate stale EC events, there does not seem
to be any adverse side-effects of running the associated _Q methods.

This patch adds an argument to the static function acpi_ec_sync_query so
that it may be used within the acpi_ec_clear loop in place of
acpi_ec_query_unlocked which was used previously.

With thanks to Stefan Biereigel for reporting the issue, and for all the
people who helped test the new patch on affected systems.

Fixes: ad332c8a4533 (ACPI / EC: Clear stale EC events on Samsung systems)
References: https://lkml.kernel.org/r/532FE3B2.9060808@biereigel-wb.de
References: https://bugzilla.kernel.org/show_bug.cgi?id=44161#c173
Reported-by: Stefan Biereigel <stefan@biereigel.de>
Signed-off-by: Kieran Clancy <clancy.kieran@gmail.com>
Tested-by: Stefan Biereigel <stefan@biereigel.de>
Tested-by: Dennis Jansen <dennis.jansen@web.de>
Tested-by: Nicolas Porcel <nicolasporcel06@gmail.com>
Tested-by: Maurizio D'Addona <mauritiusdadd@gmail.com>
Tested-by: Juan Manuel Cabo <juanmanuel.cabo@gmail.com>
Tested-by: Giannis Koutsou <giannis.koutsou@gmail.com>
Tested-by: Kieran Clancy <clancy.kieran@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/ec.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -206,13 +206,13 @@ unlock:
 	spin_unlock_irqrestore(&ec->curr_lock, flags);
 }
 
-static int acpi_ec_sync_query(struct acpi_ec *ec);
+static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data);
 
 static int ec_check_sci_sync(struct acpi_ec *ec, u8 state)
 {
 	if (state & ACPI_EC_FLAG_SCI) {
 		if (!test_and_set_bit(EC_FLAGS_QUERY_PENDING, &ec->flags))
-			return acpi_ec_sync_query(ec);
+			return acpi_ec_sync_query(ec, NULL);
 	}
 	return 0;
 }
@@ -452,10 +452,8 @@ int ec_transaction(u8 command,
 
 EXPORT_SYMBOL(ec_transaction);
 
-static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 *data);
-
 /*
- * Clears stale _Q events that might have accumulated in the EC.
+ * Process _Q events that might have accumulated in the EC.
  * Run with locked ec mutex.
  */
 static void acpi_ec_clear(struct acpi_ec *ec)
@@ -464,7 +462,7 @@ static void acpi_ec_clear(struct acpi_ec
 	u8 value = 0;
 
 	for (i = 0; i < ACPI_EC_CLEAR_MAX; i++) {
-		status = acpi_ec_query_unlocked(ec, &value);
+		status = acpi_ec_sync_query(ec, &value);
 		if (status || !value)
 			break;
 	}
@@ -591,13 +589,18 @@ static void acpi_ec_run(void *cxt)
 	kfree(handler);
 }
 
-static int acpi_ec_sync_query(struct acpi_ec *ec)
+static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data)
 {
 	u8 value = 0;
 	int status;
 	struct acpi_ec_query_handler *handler, *copy;
-	if ((status = acpi_ec_query_unlocked(ec, &value)))
+
+	status = acpi_ec_query_unlocked(ec, &value);
+	if (data)
+		*data = value;
+	if (status)
 		return status;
+
 	list_for_each_entry(handler, &ec->list, node) {
 		if (value == handler->query_bit) {
 			/* have custom handler for this bit */
@@ -620,7 +623,7 @@ static void acpi_ec_gpe_query(void *ec_c
 	if (!ec)
 		return;
 	mutex_lock(&ec->lock);
-	acpi_ec_sync_query(ec);
+	acpi_ec_sync_query(ec, NULL);
 	mutex_unlock(&ec->lock);
 }
 

