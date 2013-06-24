Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3FXTf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:35:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:47396 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3FXTbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 31/32] drivers: delete __cpuinit usage from all remaining drivers files
Date: Mon, 24 Jun 2013 15:30:36 -0400
Message-ID: <1372102237-8757-32-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit type of throwaway sections might have made sense
some time ago when RAM was more constrained, but now the savings
do not offset the cost and complications.  For example, the fix in
commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
is a good example of the nasty type of bugs that can be created
with improper use of the various __init prefixes.

After a discussion on LKML[1] it was decided that cpuinit should go
the way of devinit and be phased out.  Once all the users are gone,
we can then finally remove the macros themselves from linux/init.h.

This removes all the remaining one-off uses of the __cpuinit macros
from all C files in the drivers/* directory.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 drivers/base/cpu.c                |  2 +-
 drivers/base/topology.c           | 10 +++++-----
 drivers/oprofile/timer_int.c      |  4 ++--
 drivers/xen/xen-acpi-cpuhotplug.c |  2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index b9f0eec..89640eb 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -271,7 +271,7 @@ static void cpu_device_release(struct device *dev)
  *
  * Initialize and register the CPU device.
  */
-int __cpuinit register_cpu(struct cpu *cpu, int num)
+int register_cpu(struct cpu *cpu, int num)
 {
 	int error;
 
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index ae989c5..2f5919e 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -143,22 +143,22 @@ static struct attribute_group topology_attr_group = {
 };
 
 /* Add/Remove cpu_topology interface for CPU device */
-static int __cpuinit topology_add_dev(unsigned int cpu)
+static int topology_add_dev(unsigned int cpu)
 {
 	struct device *dev = get_cpu_device(cpu);
 
 	return sysfs_create_group(&dev->kobj, &topology_attr_group);
 }
 
-static void __cpuinit topology_remove_dev(unsigned int cpu)
+static void topology_remove_dev(unsigned int cpu)
 {
 	struct device *dev = get_cpu_device(cpu);
 
 	sysfs_remove_group(&dev->kobj, &topology_attr_group);
 }
 
-static int __cpuinit topology_cpu_callback(struct notifier_block *nfb,
-					   unsigned long action, void *hcpu)
+static int topology_cpu_callback(struct notifier_block *nfb,
+				 unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	int rc = 0;
@@ -178,7 +178,7 @@ static int __cpuinit topology_cpu_callback(struct notifier_block *nfb,
 	return notifier_from_errno(rc);
 }
 
-static int __cpuinit topology_sysfs_init(void)
+static int topology_sysfs_init(void)
 {
 	int cpu;
 	int rc;
diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
index 93404f7..61be1d9 100644
--- a/drivers/oprofile/timer_int.c
+++ b/drivers/oprofile/timer_int.c
@@ -74,8 +74,8 @@ static void oprofile_hrtimer_stop(void)
 	put_online_cpus();
 }
 
-static int __cpuinit oprofile_cpu_notify(struct notifier_block *self,
-					 unsigned long action, void *hcpu)
+static int oprofile_cpu_notify(struct notifier_block *self,
+			       unsigned long action, void *hcpu)
 {
 	long cpu = (long) hcpu;
 
diff --git a/drivers/xen/xen-acpi-cpuhotplug.c b/drivers/xen/xen-acpi-cpuhotplug.c
index 18c742b..b7d5d95 100644
--- a/drivers/xen/xen-acpi-cpuhotplug.c
+++ b/drivers/xen/xen-acpi-cpuhotplug.c
@@ -89,7 +89,7 @@ static int xen_acpi_processor_enable(struct acpi_device *device)
 	return 0;
 }
 
-static int __cpuinit xen_acpi_processor_add(struct acpi_device *device)
+static int xen_acpi_processor_add(struct acpi_device *device)
 {
 	int ret;
 	struct acpi_processor *pr;
-- 
1.8.1.2

