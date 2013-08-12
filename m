Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3HLT4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 15:56:44 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:27326 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3HLT4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 15:56:41 -0400
Message-ID: <201308121956.r7CJueHs010309@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 12 Aug 2013 14:39:22 -0400
Subject: [PATCH] tile: support reporting Tilera hypervisor statistics
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer hypervisors have an API for reporting per-cpu statistics
information.  This change allows seeing that information via
/sys/devices/system/cpu/cpuN/hv_stats file for each core.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/hv/hypervisor.h | 16 +++++++--
 arch/tile/kernel/sysfs.c          | 76 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/arch/tile/include/hv/hypervisor.h b/arch/tile/include/hv/hypervisor.h
index 71abe38..e944974 100644
--- a/arch/tile/include/hv/hypervisor.h
+++ b/arch/tile/include/hv/hypervisor.h
@@ -559,14 +559,24 @@ typedef enum {
   HV_CONFSTR_CPUMOD_REV      = 18,
 
   /** Human-readable CPU module description. */
-  HV_CONFSTR_CPUMOD_DESC     = 19
+  HV_CONFSTR_CPUMOD_DESC     = 19,
+
+  /** Per-tile hypervisor statistics.  When this identifier is specified,
+   *  the hv_confstr call takes two extra arguments.  The first is the
+   *  HV_XY_TO_LOTAR of the target tile's coordinates.  The second is
+   *  a flag word.  The only current flag is the lowest bit, which means
+   *  "zero out the stats instead of retrieving them"; in this case the
+   *  buffer and buffer length are ignored. */
+  HV_CONFSTR_HV_STATS        = 20
 
 } HV_ConfstrQuery;
 
 /** Query a configuration string from the hypervisor.
  *
  * @param query Identifier for the specific string to be retrieved
- *        (HV_CONFSTR_xxx).
+ *        (HV_CONFSTR_xxx).  Some strings may require or permit extra
+ *        arguments to be appended which select specific objects to be
+ *        described; see the string descriptions above.
  * @param buf Buffer in which to place the string.
  * @param len Length of the buffer.
  * @return If query is valid, then the length of the corresponding string,
@@ -574,7 +584,7 @@ typedef enum {
  *        was truncated.  If query is invalid, HV_EINVAL.  If the specified
  *        buffer is not writable by the client, HV_EFAULT.
  */
-int hv_confstr(HV_ConfstrQuery query, HV_VirtAddr buf, int len);
+int hv_confstr(HV_ConfstrQuery query, HV_VirtAddr buf, int len, ...);
 
 /** Tile coordinate */
 typedef struct
diff --git a/arch/tile/kernel/sysfs.c b/arch/tile/kernel/sysfs.c
index 024b978..575bda8 100644
--- a/arch/tile/kernel/sysfs.c
+++ b/arch/tile/kernel/sysfs.c
@@ -161,6 +161,67 @@ hvconfig_bin_read(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
+static ssize_t hv_stats_show(struct device *dev,
+			     struct device_attribute *attr,
+			     char *page)
+{
+	int cpu = dev->id;
+	long lotar = HV_XY_TO_LOTAR(cpu_x(cpu), cpu_y(cpu));
+
+	ssize_t n = hv_confstr(HV_CONFSTR_HV_STATS,
+			       (unsigned long)page, PAGE_SIZE - 1,
+			       lotar, 0);
+	n = n < 0 ? 0 : min(n, (ssize_t)PAGE_SIZE - 1);
+	page[n] = '\0';
+	return n;
+}
+
+static ssize_t hv_stats_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *page,
+			      size_t count)
+{
+	int cpu = dev->id;
+	long lotar = HV_XY_TO_LOTAR(cpu_x(cpu), cpu_y(cpu));
+
+	ssize_t n = hv_confstr(HV_CONFSTR_HV_STATS, 0, 0, lotar, 1);
+	return n < 0 ? n : count;
+}
+
+static DEVICE_ATTR(hv_stats, 0644, hv_stats_show, hv_stats_store);
+
+static int hv_stats_device_add(struct device *dev, struct subsys_interface *sif)
+{
+	int err, cpu = dev->id;
+
+	if (!cpu_online(cpu))
+		return 0;
+
+	err = sysfs_create_file(&dev->kobj, &dev_attr_hv_stats.attr);
+
+	return err;
+}
+
+static int hv_stats_device_remove(struct device *dev,
+				  struct subsys_interface *sif)
+{
+	int cpu = dev->id;
+
+	if (!cpu_online(cpu))
+		return 0;
+
+	sysfs_remove_file(&dev->kobj, &dev_attr_hv_stats.attr);
+	return 0;
+}
+
+
+static struct subsys_interface hv_stats_interface = {
+	.name			= "hv_stats",
+	.subsys			= &cpu_subsys,
+	.add_dev		= hv_stats_device_add,
+	.remove_dev		= hv_stats_device_remove,
+};
+
 static int __init create_sysfs_entries(void)
 {
 	int err = 0;
@@ -192,6 +253,21 @@ static int __init create_sysfs_entries(void)
 		err = sysfs_create_bin_file(hypervisor_kobj, &hvconfig_bin);
 	}
 
+	if (!err) {
+		/*
+		 * Don't bother adding the hv_stats files on each CPU if
+		 * our hypervisor doesn't supply statistics.
+		 */
+		int cpu = raw_smp_processor_id();
+		long lotar = HV_XY_TO_LOTAR(cpu_x(cpu), cpu_y(cpu));
+		char dummy;
+		ssize_t n = hv_confstr(HV_CONFSTR_HV_STATS,
+				       (unsigned long) &dummy, 1,
+				       lotar, 0);
+		if (n >= 0)
+			err = subsys_interface_register(&hv_stats_interface);
+	}
+
 	return err;
 }
 subsys_initcall(create_sysfs_entries);
-- 
1.8.3.1

