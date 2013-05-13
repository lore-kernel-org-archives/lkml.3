Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3EMWJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 18:09:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab3EMWJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 18:09:07 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, konrad.wilk@oracle.com,
        chuck.anderson@oracle.com, imammedo@redhat.com
Subject: [PATCH 2/2] cpu: make sure that cpu/online file created before KOBJ_ADD is emitted
Date: Tue, 14 May 2013 00:05:32 +0200
Message-Id: <1368482732-25554-3-git-send-email-imammedo@redhat.com>
In-Reply-To: <20130513133128.GJ6811@phenom.dumpdata.com>
References: <20130513133128.GJ6811@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes race between udev and hotplugged CPU registration, described at
https://lkml.org/lkml/2012/4/30/198
by defining "online" attribute statically so that device_add() would
create it before notifying udev about new CPU.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 drivers/base/cpu.c |   34 +++++++++++++++++++++-------------
 1 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 02e4d73..6578030 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -64,18 +64,21 @@ static ssize_t __ref store_online(struct device *dev,
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
@@ -101,11 +104,6 @@ static ssize_t cpu_release_store(struct device *dev,
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
@@ -150,6 +148,16 @@ static const struct attribute_group *common_cpu_attr_groups[] = {
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
@@ -265,9 +273,9 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
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

