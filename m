Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaLAKyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:54:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53749 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaLAKyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:54:49 -0500
Date: Mon, 1 Dec 2014 02:54:34 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-2ef84b3bb97f03332f0c1edb4466b1750dcf97b5@git.kernel.org>
Cc: bp@suse.de, hpa@zytor.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Reply-To: hpa@zytor.com, bp@suse.de, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, mingo@kernel.org
In-Reply-To: <1417428741-4501-1-git-send-email-bp@alien8.de>
References: <1417428741-4501-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, AMD:
  Do not use smp_processor_id() in preemtible context
Git-Commit-ID: 2ef84b3bb97f03332f0c1edb4466b1750dcf97b5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ef84b3bb97f03332f0c1edb4466b1750dcf97b5
Gitweb:     http://git.kernel.org/tip/2ef84b3bb97f03332f0c1edb4466b1750dcf97b5
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 1 Dec 2014 11:12:21 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 1 Dec 2014 11:51:05 +0100

x86, microcode, AMD: Do not use smp_processor_id() in preemtible context

Hand down the cpu number instead, otherwise lockdep screams when doing

echo 1 > /sys/devices/system/cpu/microcode/reload.

BUG: using smp_processor_id() in preemptible [00000000] code: amd64-microcode/2470
caller is debug_smp_processor_id+0x12/0x20
CPU: 1 PID: 2470 Comm: amd64-microcode Not tainted 3.18.0-rc6+ #26
...

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1417428741-4501-1-git-send-email-bp@alien8.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/microcode_amd.h      | 2 +-
 arch/x86/kernel/cpu/microcode/amd.c       | 8 ++++----
 arch/x86/kernel/cpu/microcode/amd_early.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/microcode_amd.h b/arch/x86/include/asm/microcode_amd.h
index b7b10b8..48a4802 100644
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
index 8fffd84..bfbbe61 100644
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
index 0667447..3d988a3 100644
--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -389,7 +389,7 @@ int __init save_microcode_in_initrd_amd(void)
 	eax   = cpuid_eax(0x00000001);
 	eax   = ((eax >> 8) & 0xf) + ((eax >> 20) & 0xff);
 
-	ret = load_microcode_amd(eax, container, container_size);
+	ret = load_microcode_amd(smp_processor_id(), eax, container, container_size);
 	if (ret != UCODE_OK)
 		retval = -EINVAL;
 
