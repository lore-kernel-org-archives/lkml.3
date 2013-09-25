Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab3IYVKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:10:33 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:40759 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3IYVKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:10:31 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl
Cc: mingo@redhat.com, hpa@linux.intel.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org,
        linux-acpi@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        nfont@linux.vnet.ibm.com, fenghua.yu@intel.com, bp@suse.de,
        srivatsa.bhat@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH RESEND 4/4] hotplug, powerpc, x86: Remove cpu_hotplug_driver_lock()
Date: Wed, 25 Sep 2013 15:08:27 -0600
Message-Id: <1380143307-25462-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_hotplug_driver_lock() serializes CPU online/offline operations
when ARCH_CPU_PROBE_RELEASE is set.  This lock interface is no longer
necessary with the following reason:

 - lock_device_hotplug() now protects CPU online/offline operations,
   including the probe & release interfaces enabled by
   ARCH_CPU_PROBE_RELEASE.  The use of cpu_hotplug_driver_lock() is
   redundant.
 - cpu_hotplug_driver_lock() is only valid when ARCH_CPU_PROBE_RELEASE
   is defined, which is misleading and is only enabled on powerpc.

This patch removes the cpu_hotplug_driver_lock() interface.  As
a result, ARCH_CPU_PROBE_RELEASE only enables / disables the cpu
probe & release interface as intended.  There is no functional change
in this patch.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
---
Performed build test only on powerpc.
Resend: Rebased to linux-next of the PM tree (3.12-rc2).
---
 arch/powerpc/kernel/smp.c              |   12 ---------
 arch/powerpc/platforms/pseries/dlpar.c |   43 ++++++++++++--------------------
 arch/x86/kernel/topology.c             |    2 -
 drivers/base/cpu.c                     |   15 ++---------
 include/linux/cpu.h                    |   13 ----------
 5 files changed, 19 insertions(+), 66 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 8e59abc..930cd8a 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -844,18 +844,6 @@ void __cpu_die(unsigned int cpu)
 		smp_ops->cpu_die(cpu);
 }
 
-static DEFINE_MUTEX(powerpc_cpu_hotplug_driver_mutex);
-
-void cpu_hotplug_driver_lock()
-{
-	mutex_lock(&powerpc_cpu_hotplug_driver_mutex);
-}
-
-void cpu_hotplug_driver_unlock()
-{
-	mutex_unlock(&powerpc_cpu_hotplug_driver_mutex);
-}
-
 void cpu_die(void)
 {
 	if (ppc_md.cpu_die)
diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index 7cfdaae..a8fe5aa 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -404,46 +404,38 @@ static ssize_t dlpar_cpu_probe(const char *buf, size_t count)
 	unsigned long drc_index;
 	int rc;
 
-	cpu_hotplug_driver_lock();
 	rc = strict_strtoul(buf, 0, &drc_index);
-	if (rc) {
-		rc = -EINVAL;
-		goto out;
-	}
+	if (rc)
+		return -EINVAL;
 
 	parent = of_find_node_by_path("/cpus");
-	if (!parent) {
-		rc = -ENODEV;
-		goto out;
-	}
+	if (!parent)
+		return -ENODEV;
 
 	dn = dlpar_configure_connector(drc_index, parent);
-	if (!dn) {
-		rc = -EINVAL;
-		goto out;
-	}
+	if (!dn)
+		return -EINVAL;
 
 	of_node_put(parent);
 
 	rc = dlpar_acquire_drc(drc_index);
 	if (rc) {
 		dlpar_free_cc_nodes(dn);
-		rc = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	rc = dlpar_attach_node(dn);
 	if (rc) {
 		dlpar_release_drc(drc_index);
 		dlpar_free_cc_nodes(dn);
-		goto out;
+		return rc;
 	}
 
 	rc = dlpar_online_cpu(dn);
-out:
-	cpu_hotplug_driver_unlock();
+	if (rc)
+		return rc;
 
-	return rc ? rc : count;
+	return count;
 }
 
 static int dlpar_offline_cpu(struct device_node *dn)
@@ -516,30 +508,27 @@ static ssize_t dlpar_cpu_release(const char *buf, size_t count)
 		return -EINVAL;
 	}
 
-	cpu_hotplug_driver_lock();
 	rc = dlpar_offline_cpu(dn);
 	if (rc) {
 		of_node_put(dn);
-		rc = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	rc = dlpar_release_drc(*drc_index);
 	if (rc) {
 		of_node_put(dn);
-		goto out;
+		return rc;
 	}
 
 	rc = dlpar_detach_node(dn);
 	if (rc) {
 		dlpar_acquire_drc(*drc_index);
-		goto out;
+		return rc;
 	}
 
 	of_node_put(dn);
-out:
-	cpu_hotplug_driver_unlock();
-	return rc ? rc : count;
+
+	return count;
 }
 
 static int __init pseries_dlpar_init(void)
diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index a3f35eb..649b010 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -66,7 +66,6 @@ int __ref _debug_hotplug_cpu(int cpu, int action)
 		return -EINVAL;
 
 	lock_device_hotplug();
-	cpu_hotplug_driver_lock();
 
 	switch (action) {
 	case 0:
@@ -91,7 +90,6 @@ int __ref _debug_hotplug_cpu(int cpu, int action)
 		ret = -EINVAL;
 	}
 
-	cpu_hotplug_driver_unlock();
 	unlock_device_hotplug();
 
 	return ret;
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 51f5d7f..f48370d 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -44,13 +44,11 @@ static int __ref cpu_subsys_online(struct device *dev)
 	struct cpu *cpu = container_of(dev, struct cpu, dev);
 	int cpuid = dev->id;
 	int from_nid, to_nid;
-	int ret = -ENODEV;
-
-	cpu_hotplug_driver_lock();
+	int ret;
 
 	from_nid = cpu_to_node(cpuid);
 	if (from_nid == NUMA_NO_NODE)
-		goto out;
+		return -ENODEV;
 
 	ret = cpu_up(cpuid);
 	/*
@@ -61,19 +59,12 @@ static int __ref cpu_subsys_online(struct device *dev)
 	if (from_nid != to_nid)
 		change_cpu_under_node(cpu, from_nid, to_nid);
 
- out:
-	cpu_hotplug_driver_unlock();
 	return ret;
 }
 
 static int cpu_subsys_offline(struct device *dev)
 {
-	int ret;
-
-	cpu_hotplug_driver_lock();
-	ret = cpu_down(dev->id);
-	cpu_hotplug_driver_unlock();
-	return ret;
+	return cpu_down(dev->id);
 }
 
 void unregister_cpu(struct cpu *cpu)
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 801ff9e..3434ef7 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -185,19 +185,6 @@ extern void cpu_hotplug_enable(void);
 void clear_tasks_mm_cpumask(int cpu);
 int cpu_down(unsigned int cpu);
 
-#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
-extern void cpu_hotplug_driver_lock(void);
-extern void cpu_hotplug_driver_unlock(void);
-#else
-static inline void cpu_hotplug_driver_lock(void)
-{
-}
-
-static inline void cpu_hotplug_driver_unlock(void)
-{
-}
-#endif
-
 #else		/* CONFIG_HOTPLUG_CPU */
 
 static inline void cpu_hotplug_begin(void) {}
