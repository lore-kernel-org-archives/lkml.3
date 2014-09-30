Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaI3Nsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:48:50 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51042 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751535AbaI3Nsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:48:31 -0400
From: Sudeep Holla <sudeep.holla@arm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v5 01/11] cpumask: factor out show_cpumap into separate helper function
Date: Tue, 30 Sep 2014 14:48:22 +0100
Message-Id: <1412084912-2767-2-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412084912-2767-1-git-send-email-sudeep.holla@arm.com>
References: <1412084912-2767-1-git-send-email-sudeep.holla@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many sysfs *_show function use cpu{list,mask}_scnprintf to copy cpumap
to the buffer aligned to PAGE_SIZE, append '\n' and '\0' to return null
terminated buffer with newline.

This patch creates a new helper function cpumap_print_to_pagebuf in
cpumask.h using newly added bitmap_print_to_pagebuf and consolidates
most of those sysfs functions using the new helper function.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Suggested-by: Stephen Boyd <sboyd@codeaurora.org>
Tested-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: x86@kernel.org
Cc: linux-acpi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 arch/x86/kernel/cpu/perf_event_amd_iommu.c    |  5 +---
 arch/x86/kernel/cpu/perf_event_amd_uncore.c   |  6 +----
 arch/x86/kernel/cpu/perf_event_intel_rapl.c   |  6 +----
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  6 +----
 drivers/acpi/acpi_pad.c                       |  8 +++---
 drivers/base/cpu.c                            |  5 +---
 drivers/base/node.c                           | 14 +++-------
 drivers/base/topology.c                       | 22 ++-------------
 drivers/pci/pci-sysfs.c                       | 39 +++++++--------------------
 include/linux/bitmap.h                        |  3 +++
 include/linux/cpumask.h                       | 17 ++++++++++++
 lib/bitmap.c                                  | 29 ++++++++++++++++++++
 12 files changed, 73 insertions(+), 87 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_iommu.c b/arch/x86/kernel/cpu/perf_event_amd_iommu.c
index 639d1289b1ba..97242a9242bd 100644
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
+	return cpumap_print_to_pagebuf(true, buf, &iommu_cpumask);
 }
 static DEVICE_ATTR(cpumask, S_IRUGO, _iommu_cpumask_show, NULL);
 
diff --git a/arch/x86/kernel/cpu/perf_event_amd_uncore.c b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
index 30790d798e6b..cc6cedb8f25d 100644
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
+	return cpumap_print_to_pagebuf(true, buf, active_mask);
 }
 static DEVICE_ATTR(cpumask, S_IRUGO, amd_uncore_attr_show_cpumask, NULL);
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 619f7699487a..3256cb87834e 100644
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
+	return cpumap_print_to_pagebuf(true, buf, &rapl_cpu_mask);
 }
 
 static DEVICE_ATTR(cpumask, S_IRUGO, rapl_get_attr_cpumask, NULL);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 0939f86f543d..3c8ddf0b89ad 100644
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
+	return cpumap_print_to_pagebuf(true, buf, &uncore_cpu_mask);
 }
 
 static DEVICE_ATTR(cpumask, S_IRUGO, uncore_get_attr_cpumask, NULL);
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index f148a0580e04..c7b105c0e1d3 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -350,12 +350,10 @@ static ssize_t acpi_pad_idlecpus_store(struct device *dev,
 static ssize_t acpi_pad_idlecpus_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
-	int n = 0;
-	n = cpumask_scnprintf(buf, PAGE_SIZE-2, to_cpumask(pad_busy_cpus_bits));
-	buf[n++] = '\n';
-	buf[n] = '\0';
-	return n;
+	return cpumap_print_to_pagebuf(false, buf,
+				       to_cpumask(pad_busy_cpus_bits));
 }
+
 static DEVICE_ATTR(idlecpus, S_IRUGO|S_IWUSR,
 	acpi_pad_idlecpus_show,
 	acpi_pad_idlecpus_store);
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 006b1bc5297d..4d8a56406fbb 100644
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
+	return cpumap_print_to_pagebuf(true, buf, *ca->map);
 }
 
 #define _CPU_ATTR(name, map) \
diff --git a/drivers/base/node.c b/drivers/base/node.c
index c6d3ae05f1ca..e68c134551ea 100644
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
+	return cpumap_print_to_pagebuf(list, buf, mask);
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
index be7c1fb7c0c9..f7c353843ddf 100644
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
+	return cpumap_print_to_pagebuf(false, buf, topology_##name(dev->id));\
 }
 
 #define define_siblings_show_list(name)					\
@@ -72,7 +54,7 @@ static ssize_t show_##name##_list(struct device *dev,			\
 				  struct device_attribute *attr,	\
 				  char *buf)				\
 {									\
-	return show_cpumap(1, topology_##name(dev->id), buf);		\
+	return cpumap_print_to_pagebuf(true, buf, topology_##name(dev->id));\
 }
 
 #define define_siblings_show_func(name)		\
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9ff0a901ecf7..b8c0ffb36ae7 100644
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
+	return cpumap_print_to_pagebuf(list, buf, mask);
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
+	return cpumap_print_to_pagebuf(false, buf, cpumask);
 }
 static DEVICE_ATTR_RO(cpuaffinity);
 
 static ssize_t cpulistaffinity_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
-	return pci_bus_show_cpuaffinity(dev, 1, attr, buf);
+	const struct cpumask *cpumask = cpumask_of_pcibus(to_pci_bus(dev));
+
+	return cpumap_print_to_pagebuf(true, buf, cpumask);
 }
 static DEVICE_ATTR_RO(cpulistaffinity);
 
diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index e1c8d080c427..9d5c3224a1e2 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -60,6 +60,7 @@
  * bitmap_find_free_region(bitmap, bits, order)	Find and allocate bit region
  * bitmap_release_region(bitmap, pos, order)	Free specified bit region
  * bitmap_allocate_region(bitmap, pos, order)	Allocate specified bit region
+ * bitmap_print_to_pagebuf(list, buf, mask, nbits) Print bitmap src as list/hex
  */
 
 /*
@@ -145,6 +146,8 @@ extern void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int o
 extern int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order);
 extern void bitmap_copy_le(void *dst, const unsigned long *src, int nbits);
 extern int bitmap_ord_to_pos(const unsigned long *bitmap, int n, int bits);
+extern int bitmap_print_to_pagebuf(bool list, char *buf,
+				   const unsigned long *maskp, int nmaskbits);
 
 #define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) % BITS_PER_LONG))
 #define BITMAP_LAST_WORD_MASK(nbits)					\
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 2997af6d2ccd..d8a6f8a1d308 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -792,6 +792,23 @@ static inline const struct cpumask *get_cpu_mask(unsigned int cpu)
 }
 #endif /* NR_CPUS > BITS_PER_LONG */
 
+/**
+ * cpumap_print_to_pagebuf  - copies the cpumask into the buffer either
+ *	as comma-separated list of cpus or hex values of cpumask
+ * @list: indicates whether the cpumap must be list
+ * @mask: the cpumask to copy
+ * @buf: the buffer to copy into
+ *
+ * Returns the length of the (null-terminated) @buf string, zero if
+ * nothing is copied.
+ */
+static inline ssize_t
+cpumap_print_to_pagebuf(bool list, char *buf, const struct cpumask *mask)
+{
+	return bitmap_print_to_pagebuf(list, buf, cpumask_bits(mask),
+				      nr_cpumask_bits);
+}
+
 /*
  *
  * From here down, all obsolete.  Use cpumask_ variants!
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 1e031f2c9aba..0a9f39388c63 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -12,6 +12,8 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/bug.h>
+
+#include <asm/page.h>
 #include <asm/uaccess.h>
 
 /*
@@ -580,6 +582,33 @@ int bitmap_scnlistprintf(char *buf, unsigned int buflen,
 EXPORT_SYMBOL(bitmap_scnlistprintf);
 
 /**
+ * bitmap_print_to_pagebuf - convert bitmap to list or hex format ASCII string
+ * @list: indicates whether the bitmap must be list
+ * @buf: page aligned buffer into which string is placed
+ * @maskp: pointer to bitmap to convert
+ * @nmaskbits: size of bitmap, in bits
+ *
+ * Output format is a comma-separated list of decimal numbers and
+ * ranges if list is specified or hex digits grouped into comma-separated
+ * sets of 8 digits/set. Returns the number of characters written to buf.
+ */
+int bitmap_print_to_pagebuf(bool list, char *buf, const unsigned long *maskp,
+			    int nmaskbits)
+{
+	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf - 2;
+	int n = 0;
+
+	if (len > 1) {
+		n = list ? bitmap_scnlistprintf(buf, len, maskp, nmaskbits) :
+			   bitmap_scnprintf(buf, len, maskp, nmaskbits);
+		buf[n++] = '\n';
+		buf[n] = '\0';
+	}
+	return n;
+}
+EXPORT_SYMBOL(bitmap_print_to_pagebuf);
+
+/**
  * __bitmap_parselist - convert list format ASCII string to bitmap
  * @buf: read nul-terminated user string from this buffer
  * @buflen: buffer size in bytes.  If string is smaller than this
-- 
1.9.1

