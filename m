Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaHULDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:03:07 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53550 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753917AbaHULAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:00:18 -0400
From: Sudeep Holla <sudeep.holla@arm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: sudeep.holla@arm.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v3 01/11] cpumask: factor out show_cpumap into separate helper function
Date: Thu, 21 Aug 2014 11:59:44 +0100
Message-Id: <1408618794-28497-2-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408618794-28497-1-git-send-email-sudeep.holla@arm.com>
References: <1406306692-7135-1-git-send-email-sudeep.holla@arm.com>
 <1408618794-28497-1-git-send-email-sudeep.holla@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

Many sysfs *_show use cpu{list,mask}_scnprintf to copy cpumap to the
buffer aligned to PAGE_SIZE, append '\n' and '\0' to return null
terminated buffer with newline.

This patch creates a new helper function cpumap_copy_to_buf in
cpumask.h and consolidates most of them using this new helper.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/perf_event_amd_iommu.c    |  5 +---
 arch/x86/kernel/cpu/perf_event_amd_uncore.c   |  6 +----
 arch/x86/kernel/cpu/perf_event_intel_rapl.c   |  6 +----
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  6 +----
 drivers/acpi/acpi_pad.c                       |  6 +----
 drivers/base/cpu.c                            |  5 +---
 drivers/base/node.c                           | 14 +++-------
 drivers/base/topology.c                       | 22 ++-------------
 drivers/pci/pci-sysfs.c                       | 39 +++++++--------------------
 include/linux/cpumask.h                       | 27 +++++++++++++++++++
 10 files changed, 49 insertions(+), 87 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_iommu.c b/arch/x86/kernel/cpu/perf_event_amd_iommu.c
index 639d1289b1ba..61a670de0ef2 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_iommu.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_iommu.c
@@ -130,10 +130,7 @@ static ssize_t _iommu_cpumask_show(struct device *dev,
 				   struct device_attribute *attr,
 				   char *buf)
 {
-	int n = cpulist_scnprintf(buf, PAGE_SIZE - 2, &iommu_cpumask);
-	buf[n++] = '\n';
-	buf[n] = '\0';
-	return n;
+	return cpumap_copy_to_buf(true, &iommu_cpumask, buf);
 }
 static DEVICE_ATTR(cpumask, S_IRUGO, _iommu_cpumask_show, NULL);
 
diff --git a/arch/x86/kernel/cpu/perf_event_amd_uncore.c b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
index 30790d798e6b..d96a37ed8570 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
@@ -219,7 +219,6 @@ static ssize_t amd_uncore_attr_show_cpumask(struct device *dev,
 					    struct device_attribute *attr,
 					    char *buf)
 {
-	int n;
 	cpumask_t *active_mask;
 	struct pmu *pmu = dev_get_drvdata(dev);
 
@@ -230,10 +229,7 @@ static ssize_t amd_uncore_attr_show_cpumask(struct device *dev,
 	else
 		return 0;
 
-	n = cpulist_scnprintf(buf, PAGE_SIZE - 2, active_mask);
-	buf[n++] = '\n';
-	buf[n] = '\0';
-	return n;
+	return cpumap_copy_to_buf(true, active_mask, buf);
 }
 static DEVICE_ATTR(cpumask, S_IRUGO, amd_uncore_attr_show_cpumask, NULL);
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 619f7699487a..8a673e138e2e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -365,11 +365,7 @@ static void rapl_pmu_event_read(struct perf_event *event)
 static ssize_t rapl_get_attr_cpumask(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	int n = cpulist_scnprintf(buf, PAGE_SIZE - 2, &rapl_cpu_mask);
-
-	buf[n++] = '\n';
-	buf[n] = '\0';
-	return n;
+	return cpumap_copy_to_buf(true, &rapl_cpu_mask, buf);
 }
 
 static DEVICE_ATTR(cpumask, S_IRUGO, rapl_get_attr_cpumask, NULL);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 0939f86f543d..a0b810951743 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -3617,11 +3617,7 @@ static int uncore_pmu_event_init(struct perf_event *event)
 static ssize_t uncore_get_attr_cpumask(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	int n = cpulist_scnprintf(buf, PAGE_SIZE - 2, &uncore_cpu_mask);
-
-	buf[n++] = '\n';
-	buf[n] = '\0';
-	return n;
+	return cpumap_copy_to_buf(true, &uncore_cpu_mask, buf);
 }
 
 static DEVICE_ATTR(cpumask, S_IRUGO, uncore_get_attr_cpumask, NULL);
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index f148a0580e04..0dbe52ed6a0d 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -350,11 +350,7 @@ static ssize_t acpi_pad_idlecpus_store(struct device *dev,
 static ssize_t acpi_pad_idlecpus_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
-	int n = 0;
-	n = cpumask_scnprintf(buf, PAGE_SIZE-2, to_cpumask(pad_busy_cpus_bits));
-	buf[n++] = '\n';
-	buf[n] = '\0';
-	return n;
+	return cpumap_copy_to_buf(false, to_cpumask(pad_busy_cpus_bits), buf);
 }
 static DEVICE_ATTR(idlecpus, S_IRUGO|S_IWUSR,
 	acpi_pad_idlecpus_show,
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 006b1bc5297d..277a9cfa9040 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -207,11 +207,8 @@ static ssize_t show_cpus_attr(struct device *dev,
 			      char *buf)
 {
 	struct cpu_attr *ca = container_of(attr, struct cpu_attr, attr);
-	int n = cpulist_scnprintf(buf, PAGE_SIZE-2, *(ca->map));
 
-	buf[n++] = '\n';
-	buf[n] = '\0';
-	return n;
+	return cpumap_copy_to_buf(true, *ca->map, buf);
 }
 
 #define _CPU_ATTR(name, map) \
diff --git a/drivers/base/node.c b/drivers/base/node.c
index c6d3ae05f1ca..6e58ad566c13 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -25,32 +25,26 @@ static struct bus_type node_subsys = {
 };
 
 
-static ssize_t node_read_cpumap(struct device *dev, int type, char *buf)
+static ssize_t node_read_cpumap(struct device *dev, bool list, char *buf)
 {
 	struct node *node_dev = to_node(dev);
 	const struct cpumask *mask = cpumask_of_node(node_dev->dev.id);
-	int len;
 
 	/* 2008/04/07: buf currently PAGE_SIZE, need 9 chars per 32 bits. */
 	BUILD_BUG_ON((NR_CPUS/32 * 9) > (PAGE_SIZE-1));
 
-	len = type?
-		cpulist_scnprintf(buf, PAGE_SIZE-2, mask) :
-		cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
- 	buf[len++] = '\n';
- 	buf[len] = '\0';
-	return len;
+	return cpumap_copy_to_buf(list, mask, buf);
 }
 
 static inline ssize_t node_read_cpumask(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	return node_read_cpumap(dev, 0, buf);
+	return node_read_cpumap(dev, false, buf);
 }
 static inline ssize_t node_read_cpulist(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	return node_read_cpumap(dev, 1, buf);
+	return node_read_cpumap(dev, true, buf);
 }
 
 static DEVICE_ATTR(cpumap,  S_IRUGO, node_read_cpumask, NULL);
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index be7c1fb7c0c9..39b294bd769b 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -42,29 +42,11 @@ static ssize_t show_##name(struct device *dev,			\
 	return sprintf(buf, "%d\n", topology_##name(dev->id));	\
 }
 
-#if defined(topology_thread_cpumask) || defined(topology_core_cpumask) || \
-    defined(topology_book_cpumask)
-static ssize_t show_cpumap(int type, const struct cpumask *mask, char *buf)
-{
-	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
-	int n = 0;
-
-	if (len > 1) {
-		n = type?
-			cpulist_scnprintf(buf, len-2, mask) :
-			cpumask_scnprintf(buf, len-2, mask);
-		buf[n++] = '\n';
-		buf[n] = '\0';
-	}
-	return n;
-}
-#endif
-
 #define define_siblings_show_map(name)					\
 static ssize_t show_##name(struct device *dev,				\
 			   struct device_attribute *attr, char *buf)	\
 {									\
-	return show_cpumap(0, topology_##name(dev->id), buf);		\
+	return cpumap_copy_to_buf(false, topology_##name(dev->id), buf);\
 }
 
 #define define_siblings_show_list(name)					\
@@ -72,7 +54,7 @@ static ssize_t show_##name##_list(struct device *dev,			\
 				  struct device_attribute *attr,	\
 				  char *buf)				\
 {									\
-	return show_cpumap(1, topology_##name(dev->id), buf);		\
+	return cpumap_copy_to_buf(true, topology_##name(dev->id), buf);	\
 }
 
 #define define_siblings_show_func(name)		\
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9ff0a901ecf7..aa0f1359ef30 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -77,11 +77,10 @@ static ssize_t broken_parity_status_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(broken_parity_status);
 
-static ssize_t pci_dev_show_local_cpu(struct device *dev, int type,
+static ssize_t pci_dev_show_local_cpu(struct device *dev, bool list,
 				      struct device_attribute *attr, char *buf)
 {
 	const struct cpumask *mask;
-	int len;
 
 #ifdef CONFIG_NUMA
 	mask = (dev_to_node(dev) == -1) ? cpu_online_mask :
@@ -89,59 +88,41 @@ static ssize_t pci_dev_show_local_cpu(struct device *dev, int type,
 #else
 	mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
 #endif
-	len = type ?
-		cpumask_scnprintf(buf, PAGE_SIZE-2, mask) :
-		cpulist_scnprintf(buf, PAGE_SIZE-2, mask);
-
-	buf[len++] = '\n';
-	buf[len] = '\0';
-	return len;
+	return cpumap_copy_to_buf(list, mask, buf);
 }
 
 static ssize_t local_cpus_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
-	return pci_dev_show_local_cpu(dev, 1, attr, buf);
+	return pci_dev_show_local_cpu(dev, false, attr, buf);
 }
 static DEVICE_ATTR_RO(local_cpus);
 
 static ssize_t local_cpulist_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
-	return pci_dev_show_local_cpu(dev, 0, attr, buf);
+	return pci_dev_show_local_cpu(dev, true, attr, buf);
 }
 static DEVICE_ATTR_RO(local_cpulist);
 
 /*
  * PCI Bus Class Devices
  */
-static ssize_t pci_bus_show_cpuaffinity(struct device *dev, int type,
-					struct device_attribute *attr,
-					char *buf)
-{
-	int ret;
-	const struct cpumask *cpumask;
-
-	cpumask = cpumask_of_pcibus(to_pci_bus(dev));
-	ret = type ?
-		cpulist_scnprintf(buf, PAGE_SIZE-2, cpumask) :
-		cpumask_scnprintf(buf, PAGE_SIZE-2, cpumask);
-	buf[ret++] = '\n';
-	buf[ret] = '\0';
-	return ret;
-}
-
 static ssize_t cpuaffinity_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	return pci_bus_show_cpuaffinity(dev, 0, attr, buf);
+	const struct cpumask *cpumask = cpumask_of_pcibus(to_pci_bus(dev));
+
+	return cpumap_copy_to_buf(false, cpumask, buf);
 }
 static DEVICE_ATTR_RO(cpuaffinity);
 
 static ssize_t cpulistaffinity_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
-	return pci_bus_show_cpuaffinity(dev, 1, attr, buf);
+	const struct cpumask *cpumask = cpumask_of_pcibus(to_pci_bus(dev));
+
+	return cpumap_copy_to_buf(true, cpumask, buf);
 }
 static DEVICE_ATTR_RO(cpulistaffinity);
 
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 2997af6d2ccd..26d8348292dd 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -11,6 +11,8 @@
 #include <linux/bitmap.h>
 #include <linux/bug.h>
 
+#include <asm/page.h>
+
 typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
 
 /**
@@ -792,6 +794,31 @@ static inline const struct cpumask *get_cpu_mask(unsigned int cpu)
 }
 #endif /* NR_CPUS > BITS_PER_LONG */
 
+/**
+ * cpumap_copy_to_buf  - copies the cpumask into the buffer either
+ *	as comma-separated list of cpus or hex values of cpumask
+ * @list: indicates whether the cpumap must be list
+ * @mask: the cpumask to copy
+ * @buf: the buffer to copy into
+ *
+ * Returns the length of the (null-terminated) @buf string, zero if
+ * nothing is copied.
+ */
+static inline ssize_t
+cpumap_copy_to_buf(bool list, const struct cpumask *mask, char *buf)
+{
+	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf - 2;
+	int n = 0;
+
+	if (len > 1) {
+		n = list ? cpulist_scnprintf(buf, len, mask) :
+			   cpumask_scnprintf(buf, len, mask);
+		buf[n++] = '\n';
+		buf[n] = '\0';
+	}
+	return n;
+}
+
 /*
  *
  * From here down, all obsolete.  Use cpumask_ variants!
-- 
1.8.3.2

