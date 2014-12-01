Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaLAKM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:12:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47684 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbaLAKMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:12:24 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, microcode, AMD: Do not use smp_processor_id in preemtible context
Date: Mon,  1 Dec 2014 11:12:21 +0100
Message-Id: <1417428741-4501-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hand down the cpu number instead, otherwise lockdep screams when doing

echo 1 > /sys/devices/system/cpu/microcode/reload.

BUG: using smp_processor_id() in preemptible [00000000] code: amd64-microcode/2470
caller is debug_smp_processor_id+0x12/0x20
CPU: 1 PID: 2470 Comm: amd64-microcode Not tainted 3.18.0-rc6+ #26
...

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/microcode_amd.h      | 2 +-
 arch/x86/kernel/cpu/microcode/amd.c       | 8 ++++----
 arch/x86/kernel/cpu/microcode/amd_early.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/microcode_amd.h b/arch/x86/include/asm/microcode_amd.h
index b7b10b82d3e5..48a48024ebe4 100644
--- a/arch/x86/include/asm/microcode_amd.h
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -59,7 +59,7 @@ static inline u16 find_equiv_id(struct equiv_cpu_entry *equiv_cpu_table,
 
 extern int __apply_microcode_amd(struct microcode_amd *mc_amd);
 extern int apply_microcode_amd(int cpu);
-extern enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size);
+extern enum ucode_state load_microcode_amd(int cpu, u8 family, const u8 *data, size_t size);
 
 #define PATCH_MAX_SIZE PAGE_SIZE
 extern u8 amd_ucode_patch[PATCH_MAX_SIZE];
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 8fffd845e22b..bfbbe6195e2d 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -376,7 +376,7 @@ static enum ucode_state __load_microcode_amd(u8 family, const u8 *data,
 	return UCODE_OK;
 }
 
-enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size)
+enum ucode_state load_microcode_amd(int cpu, u8 family, const u8 *data, size_t size)
 {
 	enum ucode_state ret;
 
@@ -390,8 +390,8 @@ enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size)
 
 #if defined(CONFIG_MICROCODE_AMD_EARLY) && defined(CONFIG_X86_32)
 	/* save BSP's matching patch for early load */
-	if (cpu_data(smp_processor_id()).cpu_index == boot_cpu_data.cpu_index) {
-		struct ucode_patch *p = find_patch(smp_processor_id());
+	if (cpu_data(cpu).cpu_index == boot_cpu_data.cpu_index) {
+		struct ucode_patch *p = find_patch(cpu);
 		if (p) {
 			memset(amd_ucode_patch, 0, PATCH_MAX_SIZE);
 			memcpy(amd_ucode_patch, p->data, min_t(u32, ksize(p->data),
@@ -444,7 +444,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 		goto fw_release;
 	}
 
-	ret = load_microcode_amd(c->x86, fw->data, fw->size);
+	ret = load_microcode_amd(cpu, c->x86, fw->data, fw->size);
 
  fw_release:
 	release_firmware(fw);
diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
index 06674473b0e6..3d988a30a21d 100644
--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -389,7 +389,7 @@ int __init save_microcode_in_initrd_amd(void)
 	eax   = cpuid_eax(0x00000001);
 	eax   = ((eax >> 8) & 0xf) + ((eax >> 20) & 0xff);
 
-	ret = load_microcode_amd(eax, container, container_size);
+	ret = load_microcode_amd(smp_processor_id(), eax, container, container_size);
 	if (ret != UCODE_OK)
 		retval = -EINVAL;
 
-- 
2.0.0

