Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaENTDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:03:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:13019 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbaENTDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:03:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1053,1389772800"; 
   d="scan'208";a="540453821"
From: "Luck, Tony" <tony.luck@intel.com>
Subject: [RFC] Unnecessary work and noise from mce code in suspend/resume path
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>, Chen Gong <gong.chen@linux.jf.intel.com>,
        Aiden Park <aiden.park@intel.com>
Date: Wed, 14 May 2014 12:02:32 -0700
Message-Id: <5373bdc83257044f09@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we suspend a laptop we offline all but one processor. But
the mce code registers on a notify chain so it can clean up
some sysfs entries. Part of that code calls device_unregister()
which will fire kobject_uevent() which might wake up some user
code that is watching for such things.

Patch below from Aiden Park works around the issue by avoiding 
the device_unregister()/device_register() by just keeping track
of the original device registrations.

1) Is there a better way to avoid the kobject_uevent()?
2) What user code actually uses all these sysfs files?
   Some test code in mcelog(8) uses:
        /sys/devices/system/machinecheck/machinecheck0/trigger
   Some code in mce-test package adjusts
        /sys/devices/system/machinecheck/machinecheck0/tolerant
   But neither of these make use of all the per-cpu instances
   created/destroyed on every suspend/resume (or logical processor
   offline).  Should we just move these out of per-cpu directories
   and scrap this whole block of code?
3) checkpatch isn't happy about use of NR_CPUS I suspect the
   usage here warrants for_each_possible_cpu()

-Tony Luck
---

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
old mode 100644
new mode 100755
index 68317c80de7f..e49302f24ce5
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -113,6 +113,8 @@ static DEFINE_PER_CPU(struct work_struct, mce_work);
 
 static void (*quirk_no_way_out)(int bank, struct mce *m, struct pt_regs *regs);
 
+static struct device *mce_devices[NR_CPUS];
+
 /*
  * CPU/chipset specific EDAC code can register a notifier call here to print
  * MCE errors in a human-readable form.
@@ -2060,7 +2062,18 @@ static int mce_syscore_suspend(void)
 
 static void mce_syscore_shutdown(void)
 {
+	int i = 0;
+	struct device *dev;
+
 	mce_disable_error_reporting();
+
+	for (i = 0; i < NR_CPUS; i++) {
+		dev = mce_devices[i];
+		if (dev) {
+			device_unregister(dev);
+			mce_devices[i] = NULL;
+		}
+	}
 }
 
 /*
@@ -2272,23 +2285,27 @@ static void mce_device_release(struct device *dev)
 static int mce_device_create(unsigned int cpu)
 {
 	struct device *dev;
-	int err;
+	int err = 0;
 	int i, j;
 
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
-	dev = kzalloc(sizeof *dev, GFP_KERNEL);
-	if (!dev)
-		return -ENOMEM;
-	dev->id  = cpu;
-	dev->bus = &mce_subsys;
-	dev->release = &mce_device_release;
+	dev = mce_devices[cpu];
+	if (!dev) {
+		dev = kzalloc(sizeof *dev, GFP_KERNEL);
+		if (!dev)
+			return -ENOMEM;
+		dev->id  = cpu;
+		dev->bus = &mce_subsys;
+		dev->release = &mce_device_release;
 
-	err = device_register(dev);
-	if (err) {
-		put_device(dev);
-		return err;
+		err = device_register(dev);
+		if (err) {
+			put_device(dev);
+			return err;
+		}
+		mce_devices[cpu] = dev;
 	}
 
 	for (i = 0; mce_device_attrs[i]; i++) {
@@ -2313,6 +2330,7 @@ error:
 		device_remove_file(dev, mce_device_attrs[i]);
 
 	device_unregister(dev);
+	mce_devices[cpu] = NULL;
 
 	return err;
 }
@@ -2331,7 +2349,6 @@ static void mce_device_remove(unsigned int cpu)
 	for (i = 0; i < mca_cfg.banks; i++)
 		device_remove_file(dev, &mce_banks[i].attr);
 
-	device_unregister(dev);
 	cpumask_clear_cpu(cpu, mce_device_initialized);
 	per_cpu(mce_device, cpu) = NULL;
 }
@@ -2450,6 +2467,7 @@ static __init int mcheck_init_device(void)
 
 	cpu_notifier_register_begin();
 	for_each_online_cpu(i) {
+		mce_devices[i] = NULL;
 		err = mce_device_create(i);
 		if (err) {
 			cpu_notifier_register_done();
