Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab3BVHhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 02:37:39 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:52715 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752070Ab3BVHhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:37:38 -0500
Message-ID: <1361518656.1896.4.camel@joe-AO722>
Subject: [PATCH] acpi: sleep: Avoid interleaved message on errors
From: Joe Perches <joe@perches.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 21 Feb 2013 23:37:36 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got this dmesg log on an Acer Aspire 725.

[    0.256351] ACPI: (supports S0ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    0.256373] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    0.256391]  S3 S4 S5)

Avoid this interleaving error messages.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/acpi/sleep.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 6d3a06a..2421303 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -599,7 +599,6 @@ static void acpi_sleep_suspend_setup(void)
 		status = acpi_get_sleep_type_data(i, &type_a, &type_b);
 		if (ACPI_SUCCESS(status)) {
 			sleep_states[i] = 1;
-			pr_cont(" S%d", i);
 		}
 	}
 
@@ -742,7 +741,6 @@ static void acpi_sleep_hibernate_setup(void)
 	hibernation_set_ops(old_suspend_ordering ?
 			&acpi_hibernation_ops_old : &acpi_hibernation_ops);
 	sleep_states[ACPI_STATE_S4] = 1;
-	pr_cont(KERN_CONT " S4");
 	if (nosigcheck)
 		return;
 
@@ -788,6 +786,9 @@ int __init acpi_sleep_init(void)
 {
 	acpi_status status;
 	u8 type_a, type_b;
+	char supported[ACPI_S_STATE_COUNT * 3 + 1];
+	char *pos = supported;
+	int i;
 
 	if (acpi_disabled)
 		return 0;
@@ -795,7 +796,6 @@ int __init acpi_sleep_init(void)
 	acpi_sleep_dmi_check();
 
 	sleep_states[ACPI_STATE_S0] = 1;
-	pr_info(PREFIX "(supports S0");
 
 	acpi_sleep_suspend_setup();
 	acpi_sleep_hibernate_setup();
@@ -803,11 +803,17 @@ int __init acpi_sleep_init(void)
 	status = acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
 	if (ACPI_SUCCESS(status)) {
 		sleep_states[ACPI_STATE_S5] = 1;
-		pr_cont(" S5");
 		pm_power_off_prepare = acpi_power_off_prepare;
 		pm_power_off = acpi_power_off;
 	}
-	pr_cont(")\n");
+
+	supported[0] = 0;
+	for (i = 0; i < ACPI_S_STATE_COUNT; i++) {
+		if (sleep_states[i])
+			pos += sprintf(pos, " S%d", i);
+	}
+	pr_info(PREFIX "(supports%s)\n", supported);
+
 	/*
 	 * Register the tts_notifier to reboot notifier list so that the _TTS
 	 * object can also be evaluated when the system enters S5.


