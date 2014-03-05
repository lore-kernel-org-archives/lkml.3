Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbaCEOie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:38:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41806 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaCEOia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:38:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 54/62] ACPI / processor: Rework processor throttling with work_on_cpu()
Date: Wed,  5 Mar 2014 14:36:58 +0000
Message-Id: <1394030226-26652-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit f3ca4164529b875374c410193bbbac0ee960895f upstream.

acpi_processor_set_throttling() uses set_cpus_allowed_ptr() to make
sure that the (struct acpi_processor)->acpi_processor_set_throttling()
callback will run on the right CPU.  However, the function may be
called from a worker thread already bound to a different CPU in which
case that won't work.

Make acpi_processor_set_throttling() use work_on_cpu() as appropriate
instead of abusing set_cpus_allowed_ptr().

Reported-and-tested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
[rjw: Changelog]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/processor_throttling.c | 69 +++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 37 deletions(-)

diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index 1d02b7b..c653cc2 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -59,6 +59,12 @@ struct throttling_tstate {
 	int target_state;		/* target T-state */
 };
 
+struct acpi_processor_throttling_arg {
+	struct acpi_processor *pr;
+	int target_state;
+	bool force;
+};
+
 #define THROTTLING_PRECHANGE       (1)
 #define THROTTLING_POSTCHANGE      (2)
 
@@ -1062,16 +1068,24 @@ static int acpi_processor_set_throttling_ptc(struct acpi_processor *pr,
 	return 0;
 }
 
+static long acpi_processor_throttling_fn(void *data)
+{
+	struct acpi_processor_throttling_arg *arg = data;
+	struct acpi_processor *pr = arg->pr;
+
+	return pr->throttling.acpi_processor_set_throttling(pr,
+			arg->target_state, arg->force);
+}
+
 int acpi_processor_set_throttling(struct acpi_processor *pr,
 						int state, bool force)
 {
-	cpumask_var_t saved_mask;
 	int ret = 0;
 	unsigned int i;
 	struct acpi_processor *match_pr;
 	struct acpi_processor_throttling *p_throttling;
+	struct acpi_processor_throttling_arg arg;
 	struct throttling_tstate t_state;
-	cpumask_var_t online_throttling_cpus;
 
 	if (!pr)
 		return -EINVAL;
@@ -1082,14 +1096,6 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
 	if ((state < 0) || (state > (pr->throttling.state_count - 1)))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&saved_mask, GFP_KERNEL))
-		return -ENOMEM;
-
-	if (!alloc_cpumask_var(&online_throttling_cpus, GFP_KERNEL)) {
-		free_cpumask_var(saved_mask);
-		return -ENOMEM;
-	}
-
 	if (cpu_is_offline(pr->id)) {
 		/*
 		 * the cpu pointed by pr->id is offline. Unnecessary to change
@@ -1098,17 +1104,15 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
 		return -ENODEV;
 	}
 
-	cpumask_copy(saved_mask, &current->cpus_allowed);
 	t_state.target_state = state;
 	p_throttling = &(pr->throttling);
-	cpumask_and(online_throttling_cpus, cpu_online_mask,
-		    p_throttling->shared_cpu_map);
+
 	/*
 	 * The throttling notifier will be called for every
 	 * affected cpu in order to get one proper T-state.
 	 * The notifier event is THROTTLING_PRECHANGE.
 	 */
-	for_each_cpu(i, online_throttling_cpus) {
+	for_each_cpu_and(i, cpu_online_mask, p_throttling->shared_cpu_map) {
 		t_state.cpu = i;
 		acpi_processor_throttling_notifier(THROTTLING_PRECHANGE,
 							&t_state);
@@ -1120,21 +1124,18 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-		/* FIXME: use work_on_cpu() */
-		if (set_cpus_allowed_ptr(current, cpumask_of(pr->id))) {
-			/* Can't migrate to the pr->id CPU. Exit */
-			ret = -ENODEV;
-			goto exit;
-		}
-		ret = p_throttling->acpi_processor_set_throttling(pr,
-						t_state.target_state, force);
+		arg.pr = pr;
+		arg.target_state = state;
+		arg.force = force;
+		ret = work_on_cpu(pr->id, acpi_processor_throttling_fn, &arg);
 	} else {
 		/*
 		 * When the T-state coordination is SW_ALL or HW_ALL,
 		 * it is necessary to set T-state for every affected
 		 * cpus.
 		 */
-		for_each_cpu(i, online_throttling_cpus) {
+		for_each_cpu_and(i, cpu_online_mask,
+		    p_throttling->shared_cpu_map) {
 			match_pr = per_cpu(processors, i);
 			/*
 			 * If the pointer is invalid, we will report the
@@ -1155,13 +1156,12 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
 					"on CPU %d\n", i));
 				continue;
 			}
-			t_state.cpu = i;
-			/* FIXME: use work_on_cpu() */
-			if (set_cpus_allowed_ptr(current, cpumask_of(i)))
-				continue;
-			ret = match_pr->throttling.
-				acpi_processor_set_throttling(
-				match_pr, t_state.target_state, force);
+
+			arg.pr = match_pr;
+			arg.target_state = state;
+			arg.force = force;
+			ret = work_on_cpu(pr->id, acpi_processor_throttling_fn,
+				&arg);
 		}
 	}
 	/*
@@ -1170,17 +1170,12 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
 	 * affected cpu to update the T-states.
 	 * The notifier event is THROTTLING_POSTCHANGE
 	 */
-	for_each_cpu(i, online_throttling_cpus) {
+	for_each_cpu_and(i, cpu_online_mask, p_throttling->shared_cpu_map) {
 		t_state.cpu = i;
 		acpi_processor_throttling_notifier(THROTTLING_POSTCHANGE,
 							&t_state);
 	}
-	/* restore the previous state */
-	/* FIXME: use work_on_cpu() */
-	set_cpus_allowed_ptr(current, saved_mask);
-exit:
-	free_cpumask_var(online_throttling_cpus);
-	free_cpumask_var(saved_mask);
+
 	return ret;
 }
 
-- 
1.9.0

