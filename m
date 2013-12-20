Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab3LTSsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:48:17 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:19639 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab3LTSsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:48:12 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-98-52b490ea03aa
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, lenb@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 4/9] ACPI / cpuidle: fix max idle state handling with
 hotplug CPU support
Date: Fri, 20 Dec 2013 19:47:26 +0100
Message-id: <1387565251-7051-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
References: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jQd3XE7YEGdzdw2ixccZ6Vot5n2Ut
	zja9YbfY+fAtm8XlXXPYLD73HmG0mHF+H5PF7+//WC3OnL7E6sDpsWlVJ5vHnWt72DzOz1jI
	6LHlajuLR9+WVYwenzfJBbBFcdmkpOZklqUW6dslcGUcPfudsWCvVMWCh5vZGhi7xboYOTkk
	BEwk/i1uYoewxSQu3FvP1sXIxSEkMJ1Rovd2NyuE08Uk0frmARNIFZuAlcTE9lWMILaIgKjE
	5d0TWECKmAUeM0rMbprCDJIQFoiT2HToHBuIzSKgKnFmy3awOK+Au8SZs4sZIdYpSnQ/mwBW
	wyngITH71XKwBUJANSe6fjNPYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM46J5J
	72Bc1WBxiFGAg1GJh1cickuQEGtiWXFl7iFGCQ5mJRHem21AId6UxMqq1KL8+KLSnNTiQ4zS
	HCxK4rwHW60DhQTSE0tSs1NTC1KLYLJMHJxSDYyc3xdskGnU+aUhqPP9cnTkD+vUgJNJE11r
	nibO497AHOJ+TnfNi7q24Mgvziv8ztjF/kg7ev+z53yvoG73SLsNfzLO/PK7LaPNrm7E+aOp
	J4rt2o+O/Qa7N9o4nLNYPvlGEVN7xlMjruwtWyRZ+AzX/ni11EUk3HVnsYbUK+aP7g/uB51/
	s1WJpTgj0VCLuag4EQCYFnRnNgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_processor_hotplug() calls acpi_processor_setup_cpuidle_cx()
without calling acpi_processor_setup_cpuidle_states() first so it
is possible that dev->state_count becomes different from
drv->state_count (in case of SMP system with unsupported C2/C3
states + enabled CPU hotplug and num_online_cpus() becoming > 1).

The driver code assumes that cpuidle core will handle such cases
but currently this is untrue (dev->state_count is used only for
handling cpuidle state sysfs entries and drv->state_count is used
for all other cases) and will not be fixed in the future as
dev->state_count is planned to be removed.

Fix the issue by checking for the max supported idle state in
C2/C3 state's ->enter handler (acpi_idle_enter_simple() for C2/C3
and acpi_idle_enter_bm() for C3 + bm_check flag set) and setting
the C1 state (instead of higher states) when needed.

Also remove no longer needed max idle state checks from
acpi_processor_setup_cpuidle_[states,cx]().

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/acpi/processor_idle.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index a0cc5ef4f..c080c99 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -783,6 +783,13 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	if (unlikely(!pr))
 		return -EINVAL;
 
+#ifdef CONFIG_HOTPLUG_CPU
+	if ((cx->type != ACPI_STATE_C1) && (num_online_cpus() > 1) &&
+	    !pr->flags.has_cst &&
+	    !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED))
+		return acpi_idle_enter_c1(dev, drv, CPUIDLE_DRIVER_STATE_START);
+#endif
+
 	if (cx->entry_method == ACPI_CSTATE_FFH) {
 		if (current_set_polling_and_test())
 			return -EINVAL;
@@ -829,6 +836,13 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	if (unlikely(!pr))
 		return -EINVAL;
 
+#ifdef CONFIG_HOTPLUG_CPU
+	if ((cx->type != ACPI_STATE_C1) && (num_online_cpus() > 1) &&
+	    !pr->flags.has_cst &&
+	    !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED))
+		return acpi_idle_enter_c1(dev, drv, CPUIDLE_DRIVER_STATE_START);
+#endif
+
 	if (!cx->bm_sts_skip && acpi_idle_bm_check()) {
 		if (drv->safe_state_index >= 0) {
 			return drv->states[drv->safe_state_index].enter(dev,
@@ -930,12 +944,6 @@ static int acpi_processor_setup_cpuidle_cx(struct acpi_processor *pr,
 		if (!cx->valid)
 			continue;
 
-#ifdef CONFIG_HOTPLUG_CPU
-		if ((cx->type != ACPI_STATE_C1) && (num_online_cpus() > 1) &&
-		    !pr->flags.has_cst &&
-		    !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED))
-			continue;
-#endif
 		per_cpu(acpi_cstate[count], dev->cpu) = cx;
 
 		count++;
@@ -985,13 +993,6 @@ static int acpi_processor_setup_cpuidle_states(struct acpi_processor *pr)
 		if (!cx->valid)
 			continue;
 
-#ifdef CONFIG_HOTPLUG_CPU
-		if ((cx->type != ACPI_STATE_C1) && (num_online_cpus() > 1) &&
-		    !pr->flags.has_cst &&
-		    !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED))
-			continue;
-#endif
-
 		state = &drv->states[count];
 		snprintf(state->name, CPUIDLE_NAME_LEN, "C%d", i);
 		strncpy(state->desc, cx->desc, CPUIDLE_DESC_LEN);
-- 
1.8.2.3

