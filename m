Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaCKA10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:27:26 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64929 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753084AbaCKA1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:27:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>,
        "Li, Aubrey" <aubrey.li@linux.intel.com>
Subject: [PATCH] ACPI / sleep: Add extra checks for HW Reduced ACPI mode sleep states
Date: Tue, 11 Mar 2014 01:42:42 +0100
Message-ID: <3761293.HvgvPUpS1F@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

If the HW Reduced ACPI mode bit is set in the FADT, ACPICA uses
the optional sleep control and sleep status registers for making
the system enter sleep states (including S5), so it is not possible
to use system sleep states or power it off using ACPI if the HW
Reduced ACPI mode bit is set and those registers are not available.

For this reason, add a new function, acpi_sleep_state_supported(),
checking if the HW Reduced ACPI mode bit is set and whether or not
system sleep states are usable in that case in addition to checking
the return value of acpi_get_sleep_type_data() and make the ACPI
sleep setup routines use that function to check the availability of
system sleep states.

Among other things, this prevents the kernel from attempting to use
ACPI for powering off HW Reduced ACPI systems in which the sleep
control and sleep status registers are not present.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/sleep.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

Index: linux-pm/drivers/acpi/sleep.c
===================================================================
--- linux-pm.orig/drivers/acpi/sleep.c
+++ linux-pm/drivers/acpi/sleep.c
@@ -600,19 +600,24 @@ static const struct platform_suspend_ops
 	.recover = acpi_pm_finish,
 };
 
+static bool acpi_sleep_state_supported(u8 sleep_state)
+{
+	acpi_status status;
+	u8 type_a, type_b;
+
+	status = acpi_get_sleep_type_data(sleep_state, &type_a, &type_b);
+	return ACPI_SUCCESS(status) && (!acpi_gbl_reduced_hardware
+		|| (acpi_gbl_FADT.sleep_control.address
+			&& acpi_gbl_FADT.sleep_status.address));
+}
+
 static void acpi_sleep_suspend_setup(void)
 {
 	int i;
 
-	for (i = ACPI_STATE_S1; i < ACPI_STATE_S4; i++) {
-		acpi_status status;
-		u8 type_a, type_b;
-
-		status = acpi_get_sleep_type_data(i, &type_a, &type_b);
-		if (ACPI_SUCCESS(status)) {
+	for (i = ACPI_STATE_S1; i < ACPI_STATE_S4; i++)
+		if (acpi_sleep_state_supported(i))
 			sleep_states[i] = 1;
-		}
-	}
 
 	suspend_set_ops(old_suspend_ordering ?
 		&acpi_suspend_ops_old : &acpi_suspend_ops);
@@ -740,11 +745,7 @@ static const struct platform_hibernation
 
 static void acpi_sleep_hibernate_setup(void)
 {
-	acpi_status status;
-	u8 type_a, type_b;
-
-	status = acpi_get_sleep_type_data(ACPI_STATE_S4, &type_a, &type_b);
-	if (ACPI_FAILURE(status))
+	if (!acpi_sleep_state_supported(ACPI_STATE_S4))
 		return;
 
 	hibernation_set_ops(old_suspend_ordering ?
@@ -793,8 +794,6 @@ static void acpi_power_off(void)
 
 int __init acpi_sleep_init(void)
 {
-	acpi_status status;
-	u8 type_a, type_b;
 	char supported[ACPI_S_STATE_COUNT * 3 + 1];
 	char *pos = supported;
 	int i;
@@ -806,8 +805,7 @@ int __init acpi_sleep_init(void)
 	acpi_sleep_suspend_setup();
 	acpi_sleep_hibernate_setup();
 
-	status = acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
-	if (ACPI_SUCCESS(status)) {
+	if (acpi_sleep_state_supported(ACPI_STATE_S5)) {
 		sleep_states[ACPI_STATE_S5] = 1;
 		pm_power_off_prepare = acpi_power_off_prepare;
 		pm_power_off = acpi_power_off;

