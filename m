Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab3ENOtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:49:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361Ab3ENOto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:49:44 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, chuck.anderson@oracle.com
Subject: [PATCH 2/2] cpu: make sure that cpu/online file created before KOBJ_ADD is emitted
Date: Tue, 14 May 2013 16:46:07 +0200
Message-Id: <1368542767-2126-3-git-send-email-imammedo@redhat.com>
In-Reply-To: <1368542767-2126-1-git-send-email-imammedo@redhat.com>
References: <1368542767-2126-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It fixes race between udev and hotplugged CPU registration by defining
"online" attribute statically, so that device_add() would create it
before notifying udev about new CPU.

Original issue report is at https://lkml.org/lkml/2012/4/30/198
"
> On Mon, Apr 30, 2012 at 11:36:23AM -0400, Konrad Rzeszutek Wilk wrote:
> > Hey Greg,
> >
> > Hoping you can help with some guidance on how to fix this.
> >
> > The issue is with CPU hotplug is that when a CPU goes up
> > it calls 'arch_register_cpu' which eventually calls
> > register_cpu. That function does these two things:
> >
> > 251         error = device_register(&cpu->dev);
> > 252         if (!error && cpu->hotpluggable)
> > 253                 register_cpu_control(cpu);
> >
> > and the device_register creates a nice little SysFS directory:
> >
> > /sys/devices/system/cpu/cpu2/ which at line 251 has the 'add' attribute
> > but no 'online' attribute. udev then tries to echo 1 to the 'online'
> > and it we get:
> > udevd-work[2421]: error opening ATTR{/sys/devices/system/cpu/cpu2/online} for writing: No such file or directory
> >
> > Line 253 creates said 'online' and at that time udev [or the system admin]
> > can write 1 to 'online' and the CPU goes up.
> >
> > So .. any thoughts? Is there some way to inhibit from uevent being sent
> > until line 253 has run?
"

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/base/cpu.c |   34 +++++++++++++++++++++-------------
 1 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 8f9e264..c377673 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -85,18 +85,21 @@ static ssize_t __ref store_online(struct device *dev,
 }
 static DEVICE_ATTR(online, 0644, show_online, store_online);
 
-static void __cpuinit register_cpu_control(struct cpu *cpu)
-{
-	device_create_file(&cpu->dev, &dev_attr_online);
-}
+static struct attribute *hotplug_cpu_attrs[] = {
+	&dev_attr_online.attr,
+	NULL
+};
+
+static struct attribute_group hotplug_cpu_attr_group = {
+	.attrs = hotplug_cpu_attrs,
+};
+
 void unregister_cpu(struct cpu *cpu)
 {
 	int logical_cpu = cpu->dev.id;
 
 	unregister_cpu_under_node(logical_cpu, cpu_to_node(logical_cpu));
 
-	device_remove_file(&cpu->dev, &dev_attr_online);
-
 	device_unregister(&cpu->dev);
 	per_cpu(cpu_sys_devices, logical_cpu) = NULL;
 	return;
@@ -122,11 +125,6 @@ static ssize_t cpu_release_store(struct device *dev,
 static DEVICE_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
 static DEVICE_ATTR(release, S_IWUSR, NULL, cpu_release_store);
 #endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
-
-#else /* ... !CONFIG_HOTPLUG_CPU */
-static inline void register_cpu_control(struct cpu *cpu)
-{
-}
 #endif /* CONFIG_HOTPLUG_CPU */
 
 #ifdef CONFIG_KEXEC
@@ -183,6 +181,16 @@ static const struct attribute_group *common_cpu_attr_groups[] = {
 	NULL
 };
 
+static const struct attribute_group *hotplugable_cpu_attr_groups[] = {
+#ifdef CONFIG_KEXEC
+	&crash_note_cpu_attr_group,
+#endif
+#ifdef CONFIG_HOTPLUG_CPU
+	&hotplug_cpu_attr_group,
+#endif
+	NULL
+};
+
 /*
  * Print cpu online, possible, present, and system maps
  */
@@ -298,9 +306,9 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
 	cpu->dev.bus->uevent = arch_cpu_uevent;
 #endif
 	cpu->dev.groups = common_cpu_attr_groups;
+	if (cpu->hotpluggable)
+		cpu->dev.groups = hotplugable_cpu_attr_groups;
 	error = device_register(&cpu->dev);
-	if (!error && cpu->hotpluggable)
-		register_cpu_control(cpu);
 	if (!error)
 		per_cpu(cpu_sys_devices, num) = &cpu->dev;
 	if (!error)
-- 
1.7.1

