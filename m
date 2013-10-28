Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab3J1MGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:06:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545Ab3J1MGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:06:36 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, tigran@aivazian.fsnet.co.uk,
        x86@kernel.org, hmh@hmh.eng.br, andi@firstfloor.org
Subject: [PATCH] x86, microcode, Fix long microcode load time when firmware file is missing [v2]
Date: Mon, 28 Oct 2013 08:06:08 -0400
Message-Id: <1382961968-20067-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no firmware is found on the system that matches the processor, the
microcode module can take hours to load.  For example on recent kernels
when loading the microcode module on an Intel system:

[  239.532116] microcode: CPU0 sig=0x306e4, pf=0x1, revision=0x413
[  299.693447] microcode: CPU1 sig=0x306e4, pf=0x1, revision=0x413
[  359.821972] microcode: CPU2 sig=0x306e4, pf=0x1, revision=0x413
[  419.960263] microcode: CPU3 sig=0x306e4, pf=0x1, revision=0x413
[  480.090024] microcode: CPU4 sig=0x306e4, pf=0x1, revision=0x413
...
[ 2825.151364] microcode: CPU43 sig=0x306e4, pf=0x1, revision=0x413
[ 2885.280863] microcode: CPU44 sig=0x306e4, pf=0x1, revision=0x413
[ 2945.410719] microcode: CPU45 sig=0x306e4, pf=0x1, revision=0x413
[ 3005.540541] microcode: CPU46 sig=0x306e4, pf=0x1, revision=0x413
[ 3065.670405] microcode: CPU47 sig=0x306e4, pf=0x1, revision=0x413
...
etc.

Similarly there is a 60 second "hang" when loading the AMD module, which
isn't as bad as the Intel situation.  This is because the AMD microcode
loader only attempts to look for the firmware on the boot_cpu and, if
found, loads the microcode on each cpu.  This patch does the same for the
Intel microcode, and it obviously peeds up the module load if there is no
microcode update available.

After making this change, the old microcode loading code and the new
loading code can be cleaned up and unified in the core code.

This patch was tested on several systems (both AMD and Intel) with the
microcode in place and without, as well as on several different OSes.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: tigran@aivazian.fsnet.co.uk
Cc: x86@kernel.org
Cc: hmh@hmh.eng.br
Cc: andi@firstfloor.org

v2: Update for Andi's and Henrique's comments.

---
 arch/x86/kernel/microcode_core.c  | 142 +++++++++++++++++---------------------
 arch/x86/kernel/microcode_intel.c |  33 +++++++--
 2 files changed, 91 insertions(+), 84 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 15c9876..608b1bd 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -180,30 +180,57 @@ static int apply_microcode_on_target(int cpu)
 	return ret;
 }
 
-#ifdef CONFIG_MICROCODE_OLD_INTERFACE
-static int do_microcode_update(const void __user *buf, size_t size)
+/* fake device for request_firmware */
+static struct platform_device	*microcode_pdev;
+
+static int do_microcode_update(bool user, const void __user *buf, size_t size)
 {
-	int error = 0;
-	int cpu;
+	enum ucode_state ustate;
+	int boot_cpu = boot_cpu_data.cpu_index;
+	int cpu, ret;
+
+	get_online_cpus();
+	mutex_lock(&microcode_mutex);
+
+	if (user)
+		ustate = microcode_ops->request_microcode_user(boot_cpu,
+							       buf, size);
+	else
+		ustate = microcode_ops->request_microcode_fw(boot_cpu,
+							   &microcode_pdev->dev,
+							     true);
+	if (ustate == UCODE_ERROR) {
+		pr_warn("Error firmware request failed\n");
+		ret = -EINVAL;
+		goto out;
+	}
 
 	for_each_online_cpu(cpu) {
-		struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-		enum ucode_state ustate;
-
-		if (!uci->valid)
-			continue;
-
-		ustate = microcode_ops->request_microcode_user(cpu, buf, size);
-		if (ustate == UCODE_ERROR) {
-			error = -1;
-			break;
-		} else if (ustate == UCODE_OK)
-			apply_microcode_on_target(cpu);
+		ret = collect_cpu_info(cpu);
+		if (ret) {
+			pr_warn("Error collecting info on CPU %d\n", cpu);
+			ret = -ENODEV;
+			goto out;
+		}
+
+		ret = apply_microcode_on_target(cpu);
+		if (ret) {
+			pr_warn("Error reloading microcode on CPU %d\n", cpu);
+			ret = -EINVAL;
+			goto out;
+		}
 	}
 
-	return error;
+	perf_check_microcode();
+out:
+	mutex_unlock(&microcode_mutex);
+	put_online_cpus();
+
+	return ret;
 }
 
+#ifdef CONFIG_MICROCODE_OLD_INTERFACE
+
 static int microcode_open(struct inode *inode, struct file *file)
 {
 	return capable(CAP_SYS_RAWIO) ? nonseekable_open(inode, file) : -EPERM;
@@ -219,18 +246,10 @@ static ssize_t microcode_write(struct file *file, const char __user *buf,
 		return ret;
 	}
 
-	get_online_cpus();
-	mutex_lock(&microcode_mutex);
-
-	if (do_microcode_update(buf, len) == 0)
+	ret = do_microcode_update(true, buf, len);
+	if (!ret)
 		ret = (ssize_t)len;
 
-	if (ret > 0)
-		perf_check_microcode();
-
-	mutex_unlock(&microcode_mutex);
-	put_online_cpus();
-
 	return ret;
 }
 
@@ -273,34 +292,12 @@ MODULE_ALIAS("devname:cpu/microcode");
 #define microcode_dev_exit()	do { } while (0)
 #endif
 
-/* fake device for request_firmware */
-static struct platform_device	*microcode_pdev;
-
-static int reload_for_cpu(int cpu)
-{
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	enum ucode_state ustate;
-	int err = 0;
-
-	if (!uci->valid)
-		return err;
-
-	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev, true);
-	if (ustate == UCODE_OK)
-		apply_microcode_on_target(cpu);
-	else
-		if (ustate == UCODE_ERROR)
-			err = -EINVAL;
-	return err;
-}
-
 static ssize_t reload_store(struct device *dev,
 			    struct device_attribute *attr,
 			    const char *buf, size_t size)
 {
 	unsigned long val;
-	int cpu;
-	ssize_t ret = 0, tmp_ret;
+	ssize_t ret;
 
 	ret = kstrtoul(buf, 0, &val);
 	if (ret)
@@ -309,22 +306,7 @@ static ssize_t reload_store(struct device *dev,
 	if (val != 1)
 		return size;
 
-	get_online_cpus();
-	mutex_lock(&microcode_mutex);
-	for_each_online_cpu(cpu) {
-		tmp_ret = reload_for_cpu(cpu);
-		if (tmp_ret != 0)
-			pr_warn("Error reloading microcode on CPU %d\n", cpu);
-
-		/* save retval of the first encountered reload error */
-		if (!ret)
-			ret = tmp_ret;
-	}
-	if (!ret)
-		perf_check_microcode();
-	mutex_unlock(&microcode_mutex);
-	put_online_cpus();
-
+	ret = do_microcode_update(false, NULL, 0);
 	if (!ret)
 		ret = size;
 
@@ -380,26 +362,32 @@ static enum ucode_state microcode_resume_cpu(int cpu)
 static enum ucode_state microcode_init_cpu(int cpu, bool refresh_fw)
 {
 	enum ucode_state ustate;
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-
-	if (uci && uci->valid)
-		return UCODE_OK;
-
-	if (collect_cpu_info(cpu))
-		return UCODE_ERROR;
+	int ret;
 
 	/* --dimm. Trigger a delayed update? */
 	if (system_state != SYSTEM_RUNNING)
 		return UCODE_NFOUND;
 
+	ret = collect_cpu_info(cpu);
+	if (ret) {
+		pr_warn("Error collecting info on CPU %d\n", cpu);
+		return UCODE_ERROR;
+	}
+
 	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev,
 						     refresh_fw);
-
-	if (ustate == UCODE_OK) {
-		pr_debug("CPU%d updated upon init\n", cpu);
-		apply_microcode_on_target(cpu);
+	if (ustate == UCODE_NFOUND) {
+		pr_info("Processor microcode update not found\n");
+		return ustate;
 	}
 
+	if (ustate != UCODE_OK)
+		pr_warn("Error microcode request failed on CPU %d\n", cpu);
+
+	ret = apply_microcode_on_target(cpu);
+	if (ret)
+		pr_warn("Error applying microcode on CPU %d\n", cpu);
+
 	return ustate;
 }
 
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 5fb2ceb..f39b677 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -87,9 +87,12 @@ MODULE_DESCRIPTION("Microcode Update Driver");
 MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
 MODULE_LICENSE("GPL");
 
+static void *master_mc; /* global copy of the microcode */
+
 static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
 	unsigned int val[2];
 
 	memset(csig, 0, sizeof(*csig));
@@ -102,9 +105,10 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 		csig->pf = 1 << ((val[1] >> 18) & 7);
 	}
 
+	if (master_mc)
+		uci->mc = master_mc;
+
 	csig->rev = c->microcode;
-	pr_info("CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
-		cpu_num, csig->sig, csig->pf, csig->rev);
 
 	return 0;
 }
@@ -124,6 +128,9 @@ static int get_matching_mc(struct microcode_intel *mc_intel, int cpu)
 	cpf = cpu_sig.pf;
 	crev = cpu_sig.rev;
 
+	pr_info("CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
+		cpu, csig, cpf, crev);
+
 	return get_matching_microcode(csig, cpf, mc_intel, crev);
 }
 
@@ -136,12 +143,12 @@ int apply_microcode(int cpu)
 	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
 
 	uci = ucode_cpu_info + cpu;
-	mc_intel = uci->mc;
+	mc_intel = master_mc;
 
 	/* We should bind the task to the CPU */
 	BUG_ON(cpu_num != cpu);
 
-	if (mc_intel == NULL)
+	if ((mc_intel == NULL) || (!uci->valid))
 		return 0;
 
 	/*
@@ -246,7 +253,8 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 	}
 
 	vfree(uci->mc);
-	uci->mc = (struct microcode_intel *)new_mc;
+	master_mc = (struct microcode_intel *)new_mc;
+	uci->mc = master_mc;
 
 	/*
 	 * If early loading microcode is supported, save this mc into
@@ -275,11 +283,14 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device,
 	const struct firmware *firmware;
 	enum ucode_state ret;
 
+	if (!refresh_fw || (c->cpu_index != boot_cpu_data.cpu_index))
+		return UCODE_OK;
+
 	sprintf(name, "intel-ucode/%02x-%02x-%02x",
 		c->x86, c->x86_model, c->x86_mask);
 
 	if (request_firmware(&firmware, name, device)) {
-		pr_debug("data file %s load failed\n", name);
+		pr_warn("data file %s load failed\n", name);
 		return UCODE_NFOUND;
 	}
 
@@ -299,15 +310,23 @@ static int get_ucode_user(void *to, const void *from, size_t n)
 static enum ucode_state
 request_microcode_user(int cpu, const void __user *buf, size_t size)
 {
-	return generic_load_microcode(cpu, (void *)buf, size, &get_ucode_user);
+	int boot_cpu = boot_cpu_data.cpu_index;
+
+	return generic_load_microcode(boot_cpu, (void *)buf, size,
+				      &get_ucode_user);
 }
 
 static void microcode_fini_cpu(int cpu)
 {
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
+	if (c->cpu_index != boot_cpu_data.cpu_index)
+		return;
+
 	vfree(uci->mc);
 	uci->mc = NULL;
+	master_mc = NULL;
 }
 
 static struct microcode_ops microcode_intel_ops = {
-- 
1.8.3.1

