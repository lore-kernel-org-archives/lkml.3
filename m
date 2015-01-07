Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbbAGC6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:58:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935AbbAGBwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.18 42/84] x86, microcode, AMD: Do not use smp_processor_id() in preemtible context
Date: Tue,  6 Jan 2015 17:49:45 -0800
Message-Id: <20150107014030.387143410@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@suse.de>

commit 2ef84b3bb97f03332f0c1edb4466b1750dcf97b5 upstream.

Hand down the cpu number instead, otherwise lockdep screams when doing

echo 1 > /sys/devices/system/cpu/microcode/reload.

BUG: using smp_processor_id() in preemptible [00000000] code: amd64-microcode/2470
caller is debug_smp_processor_id+0x12/0x20
CPU: 1 PID: 2470 Comm: amd64-microcode Not tainted 3.18.0-rc6+ #26
...

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1417428741-4501-1-git-send-email-bp@alien8.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/microcode_amd.h      |    2 +-
 arch/x86/kernel/cpu/microcode/amd.c       |    8 ++++----
 arch/x86/kernel/cpu/microcode/amd_early.c |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/microcode_amd.h
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -59,7 +59,7 @@ static inline u16 find_equiv_id(struct e
 
 extern int __apply_microcode_amd(struct microcode_amd *mc_amd);
 extern int apply_microcode_amd(int cpu);
-extern enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size);
+extern enum ucode_state load_microcode_amd(int cpu, u8 family, const u8 *data, size_t size);
 
 #define PATCH_MAX_SIZE PAGE_SIZE
 extern u8 amd_ucode_patch[PATCH_MAX_SIZE];
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -376,7 +376,7 @@ static enum ucode_state __load_microcode
 	return UCODE_OK;
 }
 
-enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size)
+enum ucode_state load_microcode_amd(int cpu, u8 family, const u8 *data, size_t size)
 {
 	enum ucode_state ret;
 
@@ -390,8 +390,8 @@ enum ucode_state load_microcode_amd(u8 f
 
 #if defined(CONFIG_MICROCODE_AMD_EARLY) && defined(CONFIG_X86_32)
 	/* save BSP's matching patch for early load */
-	if (cpu_data(smp_processor_id()).cpu_index == boot_cpu_data.cpu_index) {
-		struct ucode_patch *p = find_patch(smp_processor_id());
+	if (cpu_data(cpu).cpu_index == boot_cpu_data.cpu_index) {
+		struct ucode_patch *p = find_patch(cpu);
 		if (p) {
 			memset(amd_ucode_patch, 0, PATCH_MAX_SIZE);
 			memcpy(amd_ucode_patch, p->data, min_t(u32, ksize(p->data),
@@ -444,7 +444,7 @@ static enum ucode_state request_microcod
 		goto fw_release;
 	}
 
-	ret = load_microcode_amd(c->x86, fw->data, fw->size);
+	ret = load_microcode_amd(cpu, c->x86, fw->data, fw->size);
 
  fw_release:
 	release_firmware(fw);
--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -389,7 +389,7 @@ int __init save_microcode_in_initrd_amd(
 	eax   = cpuid_eax(0x00000001);
 	eax   = ((eax >> 8) & 0xf) + ((eax >> 20) & 0xff);
 
-	ret = load_microcode_amd(eax, container, container_size);
+	ret = load_microcode_amd(smp_processor_id(), eax, container, container_size);
 	if (ret != UCODE_OK)
 		retval = -EINVAL;
 


