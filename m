Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaFDXVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:21:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaFDXV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Biereigel <stefan@biereigel.de>,
        Kieran Clancy <clancy.kieran@gmail.com>,
        Dennis Jansen <dennis.jansen@web.de>,
        Nicolas Porcel <nicolasporcel06@gmail.com>,
        Maurizio DAddona <mauritiusdadd@gmail.com>,
        Juan Manuel Cabo <juanmanuel.cabo@gmail.com>,
        Giannis Koutsou <giannis.koutsou@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 058/228] ACPI / EC: Process rather than discard events in acpi_ec_clear
Date: Wed,  4 Jun 2014 16:21:27 -0700
Message-Id: <20140604232349.927542764@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/ec.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -206,13 +206,13 @@ unlock:
 	spin_unlock_irqrestore(&ec->lock, flags);
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
@@ -443,10 +443,8 @@ acpi_handle ec_get_handle(void)
 
 EXPORT_SYMBOL(ec_get_handle);
 
-static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 *data);
-
 /*
- * Clears stale _Q events that might have accumulated in the EC.
+ * Process _Q events that might have accumulated in the EC.
  * Run with locked ec mutex.
  */
 static void acpi_ec_clear(struct acpi_ec *ec)
@@ -455,7 +453,7 @@ static void acpi_ec_clear(struct acpi_ec
 	u8 value = 0;
 
 	for (i = 0; i < ACPI_EC_CLEAR_MAX; i++) {
-		status = acpi_ec_query_unlocked(ec, &value);
+		status = acpi_ec_sync_query(ec, &value);
 		if (status || !value)
 			break;
 	}
@@ -582,13 +580,18 @@ static void acpi_ec_run(void *cxt)
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
@@ -612,7 +615,7 @@ static void acpi_ec_gpe_query(void *ec_c
 	if (!ec)
 		return;
 	mutex_lock(&ec->mutex);
-	acpi_ec_sync_query(ec);
+	acpi_ec_sync_query(ec, NULL);
 	mutex_unlock(&ec->mutex);
 }
 


