Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab3EBMYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:24:38 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55034 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab3EBMXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:23:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com, Len Brown <lenb@kernel.org>
Subject: [PATCH 2/4] Driver core: Use generic offline/online for CPU offline/online
Date: Thu, 02 May 2013 14:28:19 +0200
Message-ID: <14113724.8SqWXP0sFF@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3166726.elbgrUIZ0L@vostro.rjw.lan>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan> <3166726.elbgrUIZ0L@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Rework the CPU hotplug code in drivers/base/cpu.c to use the
generic offline/online support introduced previously instead of
its own CPU-specific code.

For this purpose, modify cpu_subsys to provide offline and online
callbacks for CONFIG_HOTPLUG_CPU set and remove the code handling
the CPU-specific 'online' sysfs attribute.

This modification is not supposed to change the user-observable
behavior of the kernel (i.e. the 'online' attribute will be present
in exactly the same place in sysfs and should trigger exactly the
same actions as before).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/cpu.c |   66 ++++++++++++++++-------------------------------------
 1 file changed, 20 insertions(+), 46 deletions(-)

Index: linux-pm/drivers/base/cpu.c
===================================================================
--- linux-pm.orig/drivers/base/cpu.c
+++ linux-pm/drivers/base/cpu.c
@@ -16,66 +16,35 @@
 
 #include "base.h"
 
-struct bus_type cpu_subsys = {
-	.name = "cpu",
-	.dev_name = "cpu",
-};
-EXPORT_SYMBOL_GPL(cpu_subsys);
-
 static DEFINE_PER_CPU(struct device *, cpu_sys_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
-static ssize_t show_online(struct device *dev,
-			   struct device_attribute *attr,
-			   char *buf)
+static int cpu_subsys_online(struct device *dev)
 {
-	struct cpu *cpu = container_of(dev, struct cpu, dev);
+	int ret;
 
-	return sprintf(buf, "%u\n", !!cpu_online(cpu->dev.id));
+	cpu_hotplug_driver_lock();
+	ret = cpu_up(dev->id);
+	cpu_hotplug_driver_unlock();
+	return ret;
 }
 
-static ssize_t __ref store_online(struct device *dev,
-				  struct device_attribute *attr,
-				  const char *buf, size_t count)
+static int cpu_subsys_offline(struct device *dev)
 {
-	struct cpu *cpu = container_of(dev, struct cpu, dev);
-	ssize_t ret;
+	int ret;
 
 	cpu_hotplug_driver_lock();
-	switch (buf[0]) {
-	case '0':
-		ret = cpu_down(cpu->dev.id);
-		if (!ret)
-			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
-		break;
-	case '1':
-		ret = cpu_up(cpu->dev.id);
-		if (!ret)
-			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
-		break;
-	default:
-		ret = -EINVAL;
-	}
+	ret = cpu_down(dev->id);
 	cpu_hotplug_driver_unlock();
-
-	if (ret >= 0)
-		ret = count;
 	return ret;
 }
-static DEVICE_ATTR(online, 0644, show_online, store_online);
 
-static void __cpuinit register_cpu_control(struct cpu *cpu)
-{
-	device_create_file(&cpu->dev, &dev_attr_online);
-}
 void unregister_cpu(struct cpu *cpu)
 {
 	int logical_cpu = cpu->dev.id;
 
 	unregister_cpu_under_node(logical_cpu, cpu_to_node(logical_cpu));
 
-	device_remove_file(&cpu->dev, &dev_attr_online);
-
 	device_unregister(&cpu->dev);
 	per_cpu(cpu_sys_devices, logical_cpu) = NULL;
 	return;
@@ -102,12 +71,18 @@ static DEVICE_ATTR(probe, S_IWUSR, NULL,
 static DEVICE_ATTR(release, S_IWUSR, NULL, cpu_release_store);
 #endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
 
-#else /* ... !CONFIG_HOTPLUG_CPU */
-static inline void register_cpu_control(struct cpu *cpu)
-{
-}
 #endif /* CONFIG_HOTPLUG_CPU */
 
+struct bus_type cpu_subsys = {
+	.name = "cpu",
+	.dev_name = "cpu",
+#ifdef CONFIG_HOTPLUG_CPU
+	.online = cpu_subsys_online,
+	.offline = cpu_subsys_offline,
+#endif
+};
+EXPORT_SYMBOL_GPL(cpu_subsys);
+
 #ifdef CONFIG_KEXEC
 #include <linux/kexec.h>
 
@@ -245,12 +220,11 @@ int __cpuinit register_cpu(struct cpu *c
 	cpu->dev.id = num;
 	cpu->dev.bus = &cpu_subsys;
 	cpu->dev.release = cpu_device_release;
+	cpu->dev.offline_disabled = !cpu->hotpluggable;
 #ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
 	cpu->dev.bus->uevent = arch_cpu_uevent;
 #endif
 	error = device_register(&cpu->dev);
-	if (!error && cpu->hotpluggable)
-		register_cpu_control(cpu);
 	if (!error)
 		per_cpu(cpu_sys_devices, num) = &cpu->dev;
 	if (!error)

