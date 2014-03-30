Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbaC3Xua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:50:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754748AbaC3Xnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:45 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Kieran Clancy" <clancy.kieran@gmail.com>,
        "San Zamoyski" <san@plusnet.pl>,
        "Juan Manuel Cabo" <juanmanuel.cabo@gmail.com>,
        "Maurizio D'Addona" <mauritiusdadd@gmail.com>,
        "Dennis Jansen" <dennis.jansen@web.de>,
        "Lan Tianyu" <tianyu.lan@intel.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.930645225@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 162/200] ACPI / EC: Clear stale EC events on Samsung
 systems
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kieran Clancy <clancy.kieran@gmail.com>

commit ad332c8a45330d170bb38b95209de449b31cd1b4 upstream.

A number of Samsung notebooks (530Uxx/535Uxx/540Uxx/550Pxx/900Xxx/etc)
continue to log events during sleep (lid open/close, AC plug/unplug,
battery level change), which accumulate in the EC until a buffer fills.
After the buffer is full (tests suggest it holds 8 events), GPEs stop
being triggered for new events. This state persists on wake or even on
power cycle, and prevents new events from being registered until the EC
is manually polled.

This is the root cause of a number of bugs, including AC not being
detected properly, lid close not triggering suspend, and low ambient
light not triggering the keyboard backlight. The bug also seemed to be
responsible for performance issues on at least one user's machine.

Juan Manuel Cabo found the cause of bug and the workaround of polling
the EC manually on wake.

The loop which clears the stale events is based on an earlier patch by
Lan Tianyu (see referenced attachment).

This patch:
 - Adds a function acpi_ec_clear() which polls the EC for stale _Q
   events at most ACPI_EC_CLEAR_MAX (currently 100) times. A warning is
   logged if this limit is reached.
 - Adds a flag EC_FLAGS_CLEAR_ON_RESUME which is set to 1 if the DMI
   system vendor is Samsung. This check could be replaced by several
   more specific DMI vendor/product pairs, but it's likely that the bug
   affects more Samsung products than just the five series mentioned
   above. Further, it should not be harmful to run acpi_ec_clear() on
   systems without the bug; it will return immediately after finding no
   data waiting.
 - Runs acpi_ec_clear() on initialisation (boot), from acpi_ec_add()
 - Runs acpi_ec_clear() on wake, from acpi_ec_unblock_transactions()

References: https://bugzilla.kernel.org/show_bug.cgi?id=44161
References: https://bugzilla.kernel.org/show_bug.cgi?id=45461
References: https://bugzilla.kernel.org/show_bug.cgi?id=57271
References: https://bugzilla.kernel.org/attachment.cgi?id=126801
Suggested-by: Juan Manuel Cabo <juanmanuel.cabo@gmail.com>
Signed-off-by: Kieran Clancy <clancy.kieran@gmail.com>
Reviewed-by: Lan Tianyu <tianyu.lan@intel.com>
Reviewed-by: Dennis Jansen <dennis.jansen@web.de>
Tested-by: Kieran Clancy <clancy.kieran@gmail.com>
Tested-by: Juan Manuel Cabo <juanmanuel.cabo@gmail.com>
Tested-by: Dennis Jansen <dennis.jansen@web.de>
Tested-by: Maurizio D'Addona <mauritiusdadd@gmail.com>
Tested-by: San Zamoyski <san@plusnet.pl>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[bwh: Backported to 3.2:
 - Adjust context
 - s/ec->mutex/ec->lock/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/ec.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -70,6 +70,8 @@ enum ec_command {
 #define ACPI_EC_DELAY		500	/* Wait 500ms max. during EC ops */
 #define ACPI_EC_UDELAY_GLK	1000	/* Wait 1ms max. to get global lock */
 #define ACPI_EC_MSI_UDELAY	550	/* Wait 550us for MSI EC */
+#define ACPI_EC_CLEAR_MAX	100	/* Maximum number of events to query
+					 * when trying to clear the EC */
 
 enum {
 	EC_FLAGS_QUERY_PENDING,		/* Query is pending */
@@ -123,6 +125,7 @@ EXPORT_SYMBOL(first_ec);
 static int EC_FLAGS_MSI; /* Out-of-spec MSI controller */
 static int EC_FLAGS_VALIDATE_ECDT; /* ASUStec ECDTs need to be validated */
 static int EC_FLAGS_SKIP_DSDT_SCAN; /* Not all BIOS survive early DSDT scan */
+static int EC_FLAGS_CLEAR_ON_RESUME; /* Needs acpi_ec_clear() on boot/resume */
 
 /* --------------------------------------------------------------------------
                              Transaction Management
@@ -449,6 +452,29 @@ int ec_transaction(u8 command,
 
 EXPORT_SYMBOL(ec_transaction);
 
+static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 *data);
+
+/*
+ * Clears stale _Q events that might have accumulated in the EC.
+ * Run with locked ec mutex.
+ */
+static void acpi_ec_clear(struct acpi_ec *ec)
+{
+	int i, status;
+	u8 value = 0;
+
+	for (i = 0; i < ACPI_EC_CLEAR_MAX; i++) {
+		status = acpi_ec_query_unlocked(ec, &value);
+		if (status || !value)
+			break;
+	}
+
+	if (unlikely(i == ACPI_EC_CLEAR_MAX))
+		pr_warn("Warning: Maximum of %d stale EC events cleared\n", i);
+	else
+		pr_info("%d stale EC events cleared\n", i);
+}
+
 void acpi_ec_block_transactions(void)
 {
 	struct acpi_ec *ec = first_ec;
@@ -472,6 +498,10 @@ void acpi_ec_unblock_transactions(void)
 	mutex_lock(&ec->lock);
 	/* Allow transactions to be carried out again */
 	clear_bit(EC_FLAGS_BLOCKED, &ec->flags);
+
+	if (EC_FLAGS_CLEAR_ON_RESUME)
+		acpi_ec_clear(ec);
+
 	mutex_unlock(&ec->lock);
 }
 
@@ -828,6 +858,13 @@ static int acpi_ec_add(struct acpi_devic
 
 	/* EC is fully operational, allow queries */
 	clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
+
+	/* Clear stale _Q events if hardware might require that */
+	if (EC_FLAGS_CLEAR_ON_RESUME) {
+		mutex_lock(&ec->lock);
+		acpi_ec_clear(ec);
+		mutex_unlock(&ec->lock);
+	}
 	return ret;
 }
 
@@ -929,6 +966,30 @@ static int ec_enlarge_storm_threshold(co
 	return 0;
 }
 
+/*
+ * On some hardware it is necessary to clear events accumulated by the EC during
+ * sleep. These ECs stop reporting GPEs until they are manually polled, if too
+ * many events are accumulated. (e.g. Samsung Series 5/9 notebooks)
+ *
+ * https://bugzilla.kernel.org/show_bug.cgi?id=44161
+ *
+ * Ideally, the EC should also be instructed NOT to accumulate events during
+ * sleep (which Windows seems to do somehow), but the interface to control this
+ * behaviour is not known at this time.
+ *
+ * Models known to be affected are Samsung 530Uxx/535Uxx/540Uxx/550Pxx/900Xxx,
+ * however it is very likely that other Samsung models are affected.
+ *
+ * On systems which don't accumulate _Q events during sleep, this extra check
+ * should be harmless.
+ */
+static int ec_clear_on_resume(const struct dmi_system_id *id)
+{
+	pr_debug("Detected system needing EC poll on resume.\n");
+	EC_FLAGS_CLEAR_ON_RESUME = 1;
+	return 0;
+}
+
 static struct dmi_system_id __initdata ec_dmi_table[] = {
 	{
 	ec_skip_dsdt_scan, "Compal JFL92", {
@@ -968,6 +1029,9 @@ static struct dmi_system_id __initdata e
 	ec_validate_ecdt, "ASUS hardware", {
 	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTek Computer Inc."),
 	DMI_MATCH(DMI_PRODUCT_NAME, "L4R"),}, NULL},
+	{
+	ec_clear_on_resume, "Samsung hardware", {
+	DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD.")}, NULL},
 	{},
 };
 

