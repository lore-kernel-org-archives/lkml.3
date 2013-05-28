Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab3E1D4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52525 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758833Ab3E1DyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Robert Jennings" <rcj@linux.vnet.ibm.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.409253031@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [34/94] powerpc: Bring all threads online prior to
 migration/hibernation
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Jennings <rcj@linux.vnet.ibm.com>

commit 120496ac2d2d60aee68d3123a68169502a85f4b5 upstream.

This patch brings online all threads which are present but not online
prior to migration/hibernation.  After migration/hibernation those
threads are taken back offline.

During migration/hibernation all online CPUs must call H_JOIN, this is
required by the hypervisor.  Without this patch, threads that are offline
(H_CEDE'd) will not be woken to make the H_JOIN call and the OS will be
deadlocked (all threads either JOIN'd or CEDE'd).

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/include/asm/rtas.h          |    2 +
 arch/powerpc/kernel/rtas.c               |  113 ++++++++++++++++++++++++++++++
 arch/powerpc/platforms/pseries/suspend.c |   22 ++++++
 3 files changed, 137 insertions(+)

--- a/arch/powerpc/include/asm/rtas.h
+++ b/arch/powerpc/include/asm/rtas.h
@@ -230,6 +230,8 @@ extern void rtas_progress(char *s, unsig
 extern void rtas_initialize(void);
 extern int rtas_suspend_cpu(struct rtas_suspend_me_data *data);
 extern int rtas_suspend_last_cpu(struct rtas_suspend_me_data *data);
+extern int rtas_online_cpus_mask(cpumask_var_t cpus);
+extern int rtas_offline_cpus_mask(cpumask_var_t cpus);
 extern int rtas_ibm_suspend_me(struct rtas_args *);
 
 struct rtc_time;
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/capability.h>
 #include <linux/delay.h>
+#include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/completion.h>
 #include <linux/cpumask.h>
@@ -809,6 +810,95 @@ static void rtas_percpu_suspend_me(void
 	__rtas_suspend_cpu((struct rtas_suspend_me_data *)info, 1);
 }
 
+enum rtas_cpu_state {
+	DOWN,
+	UP,
+};
+
+#ifndef CONFIG_SMP
+static int rtas_cpu_state_change_mask(enum rtas_cpu_state state,
+				cpumask_var_t cpus)
+{
+	if (!cpumask_empty(cpus)) {
+		cpumask_clear(cpus);
+		return -EINVAL;
+	} else
+		return 0;
+}
+#else
+/* On return cpumask will be altered to indicate CPUs changed.
+ * CPUs with states changed will be set in the mask,
+ * CPUs with status unchanged will be unset in the mask. */
+static int rtas_cpu_state_change_mask(enum rtas_cpu_state state,
+				cpumask_var_t cpus)
+{
+	int cpu;
+	int cpuret = 0;
+	int ret = 0;
+
+	if (cpumask_empty(cpus))
+		return 0;
+
+	for_each_cpu(cpu, cpus) {
+		switch (state) {
+		case DOWN:
+			cpuret = cpu_down(cpu);
+			break;
+		case UP:
+			cpuret = cpu_up(cpu);
+			break;
+		}
+		if (cpuret) {
+			pr_debug("%s: cpu_%s for cpu#%d returned %d.\n",
+					__func__,
+					((state == UP) ? "up" : "down"),
+					cpu, cpuret);
+			if (!ret)
+				ret = cpuret;
+			if (state == UP) {
+				/* clear bits for unchanged cpus, return */
+				cpumask_shift_right(cpus, cpus, cpu);
+				cpumask_shift_left(cpus, cpus, cpu);
+				break;
+			} else {
+				/* clear bit for unchanged cpu, continue */
+				cpumask_clear_cpu(cpu, cpus);
+			}
+		}
+	}
+
+	return ret;
+}
+#endif
+
+int rtas_online_cpus_mask(cpumask_var_t cpus)
+{
+	int ret;
+
+	ret = rtas_cpu_state_change_mask(UP, cpus);
+
+	if (ret) {
+		cpumask_var_t tmp_mask;
+
+		if (!alloc_cpumask_var(&tmp_mask, GFP_TEMPORARY))
+			return ret;
+
+		/* Use tmp_mask to preserve cpus mask from first failure */
+		cpumask_copy(tmp_mask, cpus);
+		rtas_offline_cpus_mask(tmp_mask);
+		free_cpumask_var(tmp_mask);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(rtas_online_cpus_mask);
+
+int rtas_offline_cpus_mask(cpumask_var_t cpus)
+{
+	return rtas_cpu_state_change_mask(DOWN, cpus);
+}
+EXPORT_SYMBOL(rtas_offline_cpus_mask);
+
 int rtas_ibm_suspend_me(struct rtas_args *args)
 {
 	long state;
@@ -816,6 +906,8 @@ int rtas_ibm_suspend_me(struct rtas_args
 	unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
 	struct rtas_suspend_me_data data;
 	DECLARE_COMPLETION_ONSTACK(done);
+	cpumask_var_t offline_mask;
+	int cpuret;
 
 	if (!rtas_service_present("ibm,suspend-me"))
 		return -ENOSYS;
@@ -839,11 +931,24 @@ int rtas_ibm_suspend_me(struct rtas_args
 		return 0;
 	}
 
+	if (!alloc_cpumask_var(&offline_mask, GFP_TEMPORARY))
+		return -ENOMEM;
+
 	atomic_set(&data.working, 0);
 	atomic_set(&data.done, 0);
 	atomic_set(&data.error, 0);
 	data.token = rtas_token("ibm,suspend-me");
 	data.complete = &done;
+
+	/* All present CPUs must be online */
+	cpumask_andnot(offline_mask, cpu_present_mask, cpu_online_mask);
+	cpuret = rtas_online_cpus_mask(offline_mask);
+	if (cpuret) {
+		pr_err("%s: Could not bring present CPUs online.\n", __func__);
+		atomic_set(&data.error, cpuret);
+		goto out;
+	}
+
 	stop_topology_update();
 
 	/* Call function on all CPUs.  One of us will make the
@@ -859,6 +964,14 @@ int rtas_ibm_suspend_me(struct rtas_args
 
 	start_topology_update();
 
+	/* Take down CPUs not online prior to suspend */
+	cpuret = rtas_offline_cpus_mask(offline_mask);
+	if (cpuret)
+		pr_warn("%s: Could not restore CPUs to offline state.\n",
+				__func__);
+
+out:
+	free_cpumask_var(offline_mask);
 	return atomic_read(&data.error);
 }
 #else /* CONFIG_PPC_PSERIES */
--- a/arch/powerpc/platforms/pseries/suspend.c
+++ b/arch/powerpc/platforms/pseries/suspend.c
@@ -16,6 +16,7 @@
   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
   */
 
+#include <linux/cpu.h>
 #include <linux/delay.h>
 #include <linux/suspend.h>
 #include <linux/stat.h>
@@ -126,11 +127,15 @@ static ssize_t store_hibernate(struct sy
 			       struct sysdev_class_attribute *attr,
 			       const char *buf, size_t count)
 {
+	cpumask_var_t offline_mask;
 	int rc;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (!alloc_cpumask_var(&offline_mask, GFP_TEMPORARY))
+		return -ENOMEM;
+
 	stream_id = simple_strtoul(buf, NULL, 16);
 
 	do {
@@ -140,15 +145,32 @@ static ssize_t store_hibernate(struct sy
 	} while (rc == -EAGAIN);
 
 	if (!rc) {
+		/* All present CPUs must be online */
+		cpumask_andnot(offline_mask, cpu_present_mask,
+				cpu_online_mask);
+		rc = rtas_online_cpus_mask(offline_mask);
+		if (rc) {
+			pr_err("%s: Could not bring present CPUs online.\n",
+					__func__);
+			goto out;
+		}
+
 		stop_topology_update();
 		rc = pm_suspend(PM_SUSPEND_MEM);
 		start_topology_update();
+
+		/* Take down CPUs not online prior to suspend */
+		if (!rtas_offline_cpus_mask(offline_mask))
+			pr_warn("%s: Could not restore CPUs to offline "
+					"state.\n", __func__);
 	}
 
 	stream_id = 0;
 
 	if (!rc)
 		rc = count;
+out:
+	free_cpumask_var(offline_mask);
 	return rc;
 }
 

