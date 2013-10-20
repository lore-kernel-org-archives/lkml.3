Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab3JTVfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 17:35:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab3JTVfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 17:35:50 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, x86@kernel.org,
        herrmann.der.user@googlemail.com, ming.lei@canonical.com,
        tigran@aivazian.fsnet.co.uk
Subject: [PATCH 2/2] intel_microcode, Fix long microcode load time when firmware file is missing
Date: Sun, 20 Oct 2013 17:35:26 -0400
Message-Id: <1382304926-1641-3-git-send-email-prarit@redhat.com>
In-Reply-To: <1382304926-1641-1-git-send-email-prarit@redhat.com>
References: <1382304926-1641-1-git-send-email-prarit@redhat.com>
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
isn't as bad as the Intel situation, but it is a noticeable delay in the
system boot and can be improved upon.

Using request_firmware_nowait() seems more appropriate here and then we
can avoid these delays, resulting in very quick load times for the
microcode.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: x86@kernel.org
Cc: herrmann.der.user@googlemail.com
Cc: ming.lei@canonical.com
Cc: tigran@aivazian.fsnet.co.uk
---
 arch/x86/include/asm/microcode.h  |    7 ++++
 arch/x86/kernel/microcode_amd.c   |   79 +++++++++++++++++++++++++++----------
 arch/x86/kernel/microcode_core.c  |    7 ++++
 arch/x86/kernel/microcode_intel.c |   67 +++++++++++++++++++++++++------
 4 files changed, 127 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index f98bd66..461a66f 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -11,6 +11,12 @@ struct device;
 
 enum ucode_state { UCODE_ERROR, UCODE_OK, UCODE_NFOUND };
 
+/* data struct for request_firmware_nowait callback */
+struct microcode_request_data {
+	unsigned long cpu;
+	char name[36];
+};
+
 struct microcode_ops {
 	enum ucode_state (*request_microcode_user) (int cpu,
 				const void __user *buf, size_t size);
@@ -34,6 +40,7 @@ struct ucode_cpu_info {
 	struct cpu_signature	cpu_sig;
 	int			valid;
 	void			*mc;
+	struct completion	completion;
 };
 extern struct ucode_cpu_info ucode_cpu_info[];
 
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index af99f71..17a2a09 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/cpu.h>
 
 #include <asm/microcode.h>
 #include <asm/processor.h>
@@ -399,6 +400,40 @@ enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size)
 	return ret;
 }
 
+static void amd_apply_firmware(const struct firmware *fw, void *context)
+{
+	struct microcode_request_data *mrd =
+				       (struct microcode_request_data *)context;
+	int cpu = mrd->cpu;
+	int ret = UCODE_ERROR;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
+	if (!fw) {
+		pr_warn("firmware %s not found\n", mrd->name);
+		goto out;
+	}
+
+	if (!fw->data || !fw->size) {
+		pr_warn("firmware %s invalid\n", mrd->name);
+		goto out;
+	}
+
+	if (*(u32 *)fw->data != UCODE_MAGIC) {
+		pr_err("invalid magic value (0x%08x)\n", *(u32 *)fw->data);
+		goto out;
+	}
+
+	ret = load_microcode_amd(c->x86, fw->data, fw->size);
+	if (ret == UCODE_OK)
+		pr_info("firmware %s is ready for cpu %d\n", mrd->name, cpu);
+out:
+	complete_all(&uci->completion);
+	if (fw)
+		release_firmware(fw);
+	vfree(mrd);
+}
+
 /*
  * AMD microcode firmware naming convention, up to family 15h they are in
  * the legacy file:
@@ -418,36 +453,38 @@ enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size)
 static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 					      bool refresh_fw)
 {
-	char fw_name[36] = "amd-ucode/microcode_amd.bin";
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	enum ucode_state ret = UCODE_NFOUND;
-	const struct firmware *fw;
+	struct device *cpu_device;
+	struct microcode_request_data *mrd;
 
-	/* reload ucode container only on the boot cpu */
-	if (!refresh_fw || c->cpu_index != boot_cpu_data.cpu_index)
+	if (!refresh_fw)
 		return UCODE_OK;
 
-	if (c->x86 >= 0x15)
-		snprintf(fw_name, sizeof(fw_name), "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
+	mrd = vmalloc(sizeof(mrd));
+	if (!mrd)
+		return UCODE_ERROR;
 
-	if (request_firmware(&fw, (const char *)fw_name, device)) {
-		pr_err("failed to load file %s\n", fw_name);
-		goto out;
+	cpu_device = get_cpu_device(cpu);
+	if (!cpu_device) {
+		pr_err("cpu %d, no device found\n", cpu);
+		cpu_device = device;
 	}
 
-	ret = UCODE_ERROR;
-	if (*(u32 *)fw->data != UCODE_MAGIC) {
-		pr_err("invalid magic value (0x%08x)\n", *(u32 *)fw->data);
-		goto fw_release;
+	mrd->cpu = cpu;
+	sprintf(mrd->name, "amd-ucode/microcode_amd.bin");
+	if (c->x86 >= 0x15)
+		snprintf(mrd->name, sizeof(mrd->name),
+			 "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
+
+	if (request_firmware_nowait(THIS_MODULE, FW_ACTION_NOHOTPLUG,
+				    mrd->name, cpu_device, GFP_KERNEL,
+				    (void *)mrd, amd_apply_firmware)) {
+		pr_info("data file %s load failed\n", mrd->name);
+		vfree(mrd);
+		return UCODE_NFOUND;
 	}
 
-	ret = load_microcode_amd(c->x86, fw->data, fw->size);
-
- fw_release:
-	release_firmware(fw);
-
- out:
-	return ret;
+	return UCODE_OK;
 }
 
 static enum ucode_state
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 15c9876..36351dc 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -171,8 +171,13 @@ static void apply_microcode_local(void *arg)
 static int apply_microcode_on_target(int cpu)
 {
 	struct apply_microcode_ctx ctx = { .err = 0 };
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	int ret;
 
+	ret = wait_for_completion_timeout(&uci->completion, HZ);
+	if (!ret)
+		pr_warn("microcode: cpu %d thread wait timed out\n", cpu);
+
 	ret = smp_call_function_single(cpu, apply_microcode_local, &ctx, 1);
 	if (!ret)
 		ret = ctx.err;
@@ -285,6 +290,7 @@ static int reload_for_cpu(int cpu)
 	if (!uci->valid)
 		return err;
 
+	init_completion(&uci->completion);
 	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev, true);
 	if (ustate == UCODE_OK)
 		apply_microcode_on_target(cpu);
@@ -392,6 +398,7 @@ static enum ucode_state microcode_init_cpu(int cpu, bool refresh_fw)
 	if (system_state != SYSTEM_RUNNING)
 		return UCODE_NFOUND;
 
+	init_completion(&uci->completion);
 	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev,
 						     refresh_fw);
 
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 5fb2ceb..c63d7c0 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -78,6 +78,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
+#include <linux/cpu.h>
 
 #include <asm/microcode_intel.h>
 #include <asm/processor.h>
@@ -267,28 +268,70 @@ static int get_ucode_fw(void *to, const void *from, size_t n)
 	return 0;
 }
 
+static void intel_apply_firmware(const struct firmware *fw, void *context)
+{
+	struct microcode_request_data *mrd =
+				       (struct microcode_request_data *)context;
+	int cpu = mrd->cpu;
+	int ret = UCODE_ERROR;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+
+	if (!fw) {
+		pr_warn("firmware %s not found\n", mrd->name);
+		goto out;
+	}
+
+	if (!fw->data || !fw->size) {
+		pr_warn("firmware %s invalid\n", mrd->name);
+		goto out;
+	}
+
+	ret = generic_load_microcode(cpu, (void *)fw->data,
+				     fw->size, &get_ucode_fw);
+	if (ret == UCODE_OK)
+		pr_info("firmware %s is ready for cpu %d\n", mrd->name, cpu);
+
+out:
+	complete_all(&uci->completion);
+	if (fw)
+		release_firmware(fw);
+	vfree(mrd);
+}
+
 static enum ucode_state request_microcode_fw(int cpu, struct device *device,
 					     bool refresh_fw)
 {
-	char name[30];
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	const struct firmware *firmware;
-	enum ucode_state ret;
+	struct device *cpu_device;
+	struct microcode_request_data *mrd;
 
-	sprintf(name, "intel-ucode/%02x-%02x-%02x",
-		c->x86, c->x86_model, c->x86_mask);
+	if (!refresh_fw)
+		return UCODE_OK;
 
-	if (request_firmware(&firmware, name, device)) {
-		pr_debug("data file %s load failed\n", name);
-		return UCODE_NFOUND;
+	mrd = vmalloc(sizeof(*mrd));
+	if (!mrd)
+		return UCODE_ERROR;
+
+	cpu_device = get_cpu_device(cpu);
+	if (!cpu_device) {
+		pr_err("cpu %d, no device found\n", cpu);
+		cpu_device = device;
 	}
+	cpu_device = device;
 
-	ret = generic_load_microcode(cpu, (void *)firmware->data,
-				     firmware->size, &get_ucode_fw);
+	mrd->cpu = cpu;
+	sprintf(mrd->name, "intel-ucode/%02x-%02x-%02x",
+		c->x86, c->x86_model, c->x86_mask);
 
-	release_firmware(firmware);
+	if (request_firmware_nowait(THIS_MODULE, FW_ACTION_NOHOTPLUG,
+				    mrd->name, cpu_device, GFP_KERNEL,
+				    (void *)mrd, intel_apply_firmware)) {
+		pr_info("data file %s load failed\n", mrd->name);
+		vfree(mrd);
+		return UCODE_NFOUND;
+	}
 
-	return ret;
+	return UCODE_OK;
 }
 
 static int get_ucode_user(void *to, const void *from, size_t n)
-- 
1.7.9.3

