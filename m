Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaDALSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:18:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42575 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaDALSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 099/144] ACPI / sleep: Add extra checks for HW Reduced ACPI mode sleep states
Date: Tue,  1 Apr 2014 12:15:03 +0100
Message-Id: <1396350948-29910-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit a4e90bed511220ff601d064c9e5d583e91308f65 upstream.

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

Among other things, this prevents the kernel from attempting to
use ACPI for powering off HW Reduced ACPI systems without the sleep
control and sleep status registers, because ACPI power off doesn't
have a chance to work on them.  That allows alternative power off
mechanisms that may actually work to be used on those systems.  The
affected machines include Dell Venue 8 Pro, Asus T100TA, Haswell
Desktop SDP and Ivy Bridge EP Demo depot.

References: https://bugzilla.kernel.org/show_bug.cgi?id=70931
Reported-by: Adam Williamson <awilliam@redhat.com>
Tested-by: Aubrey Li <aubrey.li@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/sleep.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 187ab61..025effa 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -78,6 +78,17 @@ static int acpi_sleep_prepare(u32 acpi_state)
 	return 0;
 }
 
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
 #ifdef CONFIG_ACPI_SLEEP
 static u32 acpi_target_sleep_state = ACPI_STATE_S0;
 
@@ -602,15 +613,9 @@ static void acpi_sleep_suspend_setup(void)
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
@@ -741,11 +746,7 @@ static const struct platform_hibernation_ops acpi_hibernation_ops_old = {
 
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
@@ -794,8 +795,6 @@ static void acpi_power_off(void)
 
 int __init acpi_sleep_init(void)
 {
-	acpi_status status;
-	u8 type_a, type_b;
 	char supported[ACPI_S_STATE_COUNT * 3 + 1];
 	char *pos = supported;
 	int i;
@@ -810,8 +809,7 @@ int __init acpi_sleep_init(void)
 	acpi_sleep_suspend_setup();
 	acpi_sleep_hibernate_setup();
 
-	status = acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
-	if (ACPI_SUCCESS(status)) {
+	if (acpi_sleep_state_supported(ACPI_STATE_S5)) {
 		sleep_states[ACPI_STATE_S5] = 1;
 		pm_power_off_prepare = acpi_power_off_prepare;
 		pm_power_off = acpi_power_off;
-- 
1.9.1

