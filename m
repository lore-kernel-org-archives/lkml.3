Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaEYOb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 10:31:27 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35733 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaEYObX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 10:31:23 -0400
Subject: [PATCH RFC] sysfs/cpu: add attributes for count of cpus and last
 cpu index
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ulrich Drepper <drepper@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 25 May 2014 18:31:16 +0400
Message-ID: <20140525143116.15062.17935.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Surprisingly there is no straight way to get number of processors.
Sysfs attributes /sys/devices/system/cpu/online, "present" and "possible"
shows cpus bitmap as comma-separated list of numbers and ranges. This format
is human-freindly but it's hard to parse and unusable for scripts.

This patchs adds new attributes into /sys/devices/system/cpu/
nr_online, nr_present, nr_possible, last_online, last_present, last_possible.

nr_* shows count of cpus as plain decimal number.
last_* shows highest index, it might not equal to NR-1 if bitmap is sparse.
This might be useful for preallocating arrays for ranges of cpu indexes.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>

---

Currently GNU C Library does weird things in the implementation of get_nprocs()
and get_nprocs_conf() (sysconf(_SC_NPROCESSORS_ONLN / _SC_NPROCESSORS_CONF)).

get_nprocs() parses "/sys/devices/system/cpu/online", counts lines started with
"cpu" in "/proc/stat" and even parses "/proc/cpuinfo".
And because all this is expensive it caches result for one second.

get_nprocs_conf() counts subdirs in /sys/devices/system/cpu named "cpu*"
It also parses "/proc/cpuinfo" on alpha and sparc. This function returns
count of present CPUs, probably it should return number of possible CPUs
otherwise userspace isn't able to handle cpu-hotplug.
This should be common situation for virtual-machines like XEN or KVM.

If nothing works well both functions return 1. They cannot report error.

For example hotspot JVM uses sysconf(_SC_NPROCESSORS_CONF) to detect
UP machine where it can drop 'lock' prefix in atomic operations.
If sysfs and proc aren't available it crashes or hangs inside GC =)
[ http://hg.openjdk.java.net/jdk8/jdk8/hotspot/file/87ee5ee27509/src/os/linux/vm/os_linux.cpp#l291 ]

Other user which I've found is userspace-RCU. It uses per-cpu arrays indexed by
getcpu() and uses sysconf(_SC_NPROCESSORS_CONF) - 1 as last possible cpu.
So this doesn't work for sparse bitmap, also I'm not sure about cpu-hotplug.
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |   17 +++++++++
 drivers/base/cpu.c                                 |   37 +++++++++++++++++++-
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index d5a0d33..e05edb7 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -37,6 +37,23 @@ Description:	CPU topology files that describe kernel limits related to
 		See Documentation/cputopology.txt for more information.
 
 
+What:		/sys/devices/system/cpu/nr_online
+		/sys/devices/system/cpu/nr_present
+		/sys/devices/system/cpu/nr_possible
+		/sys/devices/system/cpu/last_online
+		/sys/devices/system/cpu/last_present
+		/sys/devices/system/cpu/last_possible
+Date:		May 2014
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Number and last index of processors in the system
+
+		nr_{online,possible,present}: count of cpus
+
+		last_{online,possible,present}: highest cpu index
+
+		See also /sys/devices/system/cpu/{online,possible,present} above
+
+
 What:		/sys/devices/system/cpu/probe
 		/sys/devices/system/cpu/release
 Date:		November 2009
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 006b1bc..1ca73c7 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -214,14 +214,43 @@ static ssize_t show_cpus_attr(struct device *dev,
 	return n;
 }
 
+static ssize_t show_nr_cpus_attr(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct cpu_attr *ca = container_of(attr, struct cpu_attr, attr);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", cpumask_weight(*ca->map));
+}
+
+static ssize_t show_last_cpus_attr(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct cpu_attr *ca = container_of(attr, struct cpu_attr, attr);
+	unsigned last_cpu = find_last_bit(cpumask_bits(*ca->map), NR_CPUS);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", last_cpu);
+}
+
 #define _CPU_ATTR(name, map) \
 	{ __ATTR(name, 0444, show_cpus_attr, NULL), map }
 
-/* Keep in sync with cpu_subsys_attrs */
+#define _NR_CPU_ATTR(name, map) \
+	{ __ATTR(name, 0444, show_nr_cpus_attr, NULL), map }
+
+#define _LAST_CPU_ATTR(name, map) \
+	{ __ATTR(name, 0444, show_last_cpus_attr, NULL), map }
+
+/* Keep in sync with cpu_root_attrs */
 static struct cpu_attr cpu_attrs[] = {
 	_CPU_ATTR(online, &cpu_online_mask),
 	_CPU_ATTR(possible, &cpu_possible_mask),
 	_CPU_ATTR(present, &cpu_present_mask),
+	_NR_CPU_ATTR(nr_online, &cpu_online_mask),
+	_NR_CPU_ATTR(nr_possible, &cpu_possible_mask),
+	_NR_CPU_ATTR(nr_present, &cpu_present_mask),
+	_LAST_CPU_ATTR(last_online, &cpu_online_mask),
+	_LAST_CPU_ATTR(last_possible, &cpu_possible_mask),
+	_LAST_CPU_ATTR(last_present, &cpu_present_mask),
 };
 
 /*
@@ -378,6 +407,12 @@ static struct attribute *cpu_root_attrs[] = {
 	&cpu_attrs[0].attr.attr,
 	&cpu_attrs[1].attr.attr,
 	&cpu_attrs[2].attr.attr,
+	&cpu_attrs[3].attr.attr,
+	&cpu_attrs[4].attr.attr,
+	&cpu_attrs[5].attr.attr,
+	&cpu_attrs[6].attr.attr,
+	&cpu_attrs[7].attr.attr,
+	&cpu_attrs[8].attr.attr,
 	&dev_attr_kernel_max.attr,
 	&dev_attr_offline.attr,
 #ifdef CONFIG_GENERIC_CPU_AUTOPROBE

