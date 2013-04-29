Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab3D2MVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:21:37 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48963 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181Ab3D2MVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:21:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Subject: [PATCH 2/3 RFC] Driver core: Use generic offline/online for CPU offline/online
Date: Mon, 29 Apr 2013 14:28:02 +0200
Message-ID: <5608485.T3GFgtNYov@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
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
 drivers/base/cpu.c |   62 ++++++++++++-----------------------------------------
 1 file changed, 15 insertions(+), 47 deletions(-)

Index: linux-pm/drivers/base/cpu.c
===================================================================
--- linux-pm.orig/drivers/base/cpu.c
+++ linux-pm/drivers/base/cpu.c
@@ -16,66 +16,25 @@
 
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
-
-	return sprintf(buf, "%u\n", !!cpu_online(cpu->dev.id));
+	return cpu_up(dev->id);
 }
 
-static ssize_t __ref store_online(struct device *dev,
-				  struct device_attribute *attr,
-				  const char *buf, size_t count)
+static int cpu_subsys_offline(struct device *dev)
 {
-	struct cpu *cpu = container_of(dev, struct cpu, dev);
-	ssize_t ret;
-
-	cpu_hotplug_driver_lock();
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
-	cpu_hotplug_driver_unlock();
-
-	if (ret >= 0)
-		ret = count;
-	return ret;
+	return cpu_down(dev->id);
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
@@ -108,6 +67,16 @@ static inline void register_cpu_control(
 }
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
 
@@ -245,12 +214,11 @@ int __cpuinit register_cpu(struct cpu *c
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

