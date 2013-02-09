Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab3BIBKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:10:52 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:49489 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947580Ab3BIBIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:08:45 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 09/16] ACPI / idle: remove usage of the statedata
Date: Fri,  8 Feb 2013 20:08:13 -0500
Message-Id: <ac3ebafa81af76d65e4fb45c6388f08e90ddcc6d.1360371180.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360372100-28482-1-git-send-email-lenb@kernel.org>
References: <1360372100-28482-1-git-send-email-lenb@kernel.org>
In-Reply-To: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
References: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

Len Brown sent a patch to remove this field in the intel_idle driver.
The other user of this field is the davinci cpuidle driver and a
patch has been sent to remove the usage of it.

This patch removes the last user of this field.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_idle.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 6837065..8b433cb 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -66,6 +66,8 @@ module_param(latency_factor, uint, 0644);
 
 static DEFINE_PER_CPU(struct cpuidle_device *, acpi_cpuidle_device);
 
+static struct acpi_processor_cx *acpi_cstate[CPUIDLE_STATE_MAX];
+
 static int disabled_by_idle_boot_param(void)
 {
 	return boot_option_idle_override == IDLE_POLL ||
@@ -721,8 +723,7 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 		struct cpuidle_driver *drv, int index)
 {
 	struct acpi_processor *pr;
-	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
-	struct acpi_processor_cx *cx = cpuidle_get_statedata(state_usage);
+	struct acpi_processor_cx *cx = acpi_cstate[index];
 
 	pr = __this_cpu_read(processors);
 
@@ -745,8 +746,7 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
  */
 static int acpi_idle_play_dead(struct cpuidle_device *dev, int index)
 {
-	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
-	struct acpi_processor_cx *cx = cpuidle_get_statedata(state_usage);
+	struct acpi_processor_cx *cx = acpi_cstate[index];
 
 	ACPI_FLUSH_CPU_CACHE();
 
@@ -776,8 +776,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 		struct cpuidle_driver *drv, int index)
 {
 	struct acpi_processor *pr;
-	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
-	struct acpi_processor_cx *cx = cpuidle_get_statedata(state_usage);
+	struct acpi_processor_cx *cx = acpi_cstate[index];
 
 	pr = __this_cpu_read(processors);
 
@@ -835,8 +834,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 		struct cpuidle_driver *drv, int index)
 {
 	struct acpi_processor *pr;
-	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
-	struct acpi_processor_cx *cx = cpuidle_get_statedata(state_usage);
+	struct acpi_processor_cx *cx = acpi_cstate[index];
 
 	pr = __this_cpu_read(processors);
 
@@ -935,7 +933,6 @@ static int acpi_processor_setup_cpuidle_cx(struct acpi_processor *pr,
 {
 	int i, count = CPUIDLE_DRIVER_STATE_START;
 	struct acpi_processor_cx *cx;
-	struct cpuidle_state_usage *state_usage;
 
 	if (!pr->flags.power_setup_done)
 		return -EINVAL;
@@ -954,7 +951,6 @@ static int acpi_processor_setup_cpuidle_cx(struct acpi_processor *pr,
 
 	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER && i <= max_cstate; i++) {
 		cx = &pr->power.states[i];
-		state_usage = &dev->states_usage[count];
 
 		if (!cx->valid)
 			continue;
@@ -965,8 +961,7 @@ static int acpi_processor_setup_cpuidle_cx(struct acpi_processor *pr,
 		    !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED))
 			continue;
 #endif
-
-		cpuidle_set_statedata(state_usage, cx);
+		acpi_cstate[count] = cx;
 
 		count++;
 		if (count == CPUIDLE_STATE_MAX)
-- 
1.8.1.3.535.ga923c31

