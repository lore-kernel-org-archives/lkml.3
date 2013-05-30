Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590Ab3E3TLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:11:31 -0400
Received: from [216.32.180.185] ([216.32.180.185]:31781 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759422Ab3E3TLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:11:02 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
X-WSS-ID: 0MNML83-02-AB4-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>
CC: Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Borislav Petkov <bp@alien8.de>, Joe Perches <joe@perches.com>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V3 3/4] x86/microcode/amd: refactor functions to prepare for early loading
Date: Thu, 30 May 2013 14:09:18 -0500
Message-ID: <1369940959-2077-4-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369940959-2077-1-git-send-email-jacob.shin@amd.com>
References: <1369940959-2077-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation work for early loading, refactor some common functions
that will be shared, and move some struct defines to a common header file.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/include/asm/microcode_amd.h |   64 ++++++++++++++++++++
 arch/x86/kernel/microcode_amd.c      |  111 +++++++++++++---------------------
 2 files changed, 106 insertions(+), 69 deletions(-)
 create mode 100644 arch/x86/include/asm/microcode_amd.h

diff --git a/arch/x86/include/asm/microcode_amd.h b/arch/x86/include/asm/microcode_amd.h
new file mode 100644
index 0000000..a57d9b7
--- /dev/null
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -0,0 +1,64 @@
+#ifndef _ASM_X86_MICROCODE_AMD_H
+#define _ASM_X86_MICROCODE_AMD_H
+
+#include <asm/microcode.h>
+
+#define UCODE_MAGIC			0x00414d44
+#define UCODE_EQUIV_CPU_TABLE_TYPE	0x00000000
+#define UCODE_UCODE_TYPE		0x00000001
+
+#define SECTION_HDR_SIZE		8
+#define CONTAINER_HDR_SZ		12
+
+struct equiv_cpu_entry {
+	u32	installed_cpu;
+	u32	fixed_errata_mask;
+	u32	fixed_errata_compare;
+	u16	equiv_cpu;
+	u16	res;
+} __attribute__((packed));
+
+struct microcode_header_amd {
+	u32	data_code;
+	u32	patch_id;
+	u16	mc_patch_data_id;
+	u8	mc_patch_data_len;
+	u8	init_flag;
+	u32	mc_patch_data_checksum;
+	u32	nb_dev_id;
+	u32	sb_dev_id;
+	u16	processor_rev_id;
+	u8	nb_rev_id;
+	u8	sb_rev_id;
+	u8	bios_api_rev;
+	u8	reserved1[3];
+	u32	match_reg[8];
+} __attribute__((packed));
+
+struct microcode_amd {
+	struct microcode_header_amd	hdr;
+	unsigned int			mpb[0];
+};
+
+static inline u16 find_equiv_id(struct equiv_cpu_entry *equiv_cpu_table,
+				unsigned int sig)
+{
+	int i = 0;
+
+	if (!equiv_cpu_table)
+		return 0;
+
+	while (equiv_cpu_table[i].installed_cpu != 0) {
+		if (sig == equiv_cpu_table[i].installed_cpu)
+			return equiv_cpu_table[i].equiv_cpu;
+
+		i++;
+	}
+	return 0;
+}
+
+extern int __apply_microcode_amd(struct microcode_amd *mc_amd);
+extern int apply_microcode_amd(int cpu);
+extern enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size);
+
+#endif /* _ASM_X86_MICROCODE_AMD_H */
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index efdec7c..8f11f8f 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -31,48 +31,12 @@
 #include <asm/microcode.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
+#include <asm/microcode_amd.h>
 
 MODULE_DESCRIPTION("AMD Microcode Update Driver");
 MODULE_AUTHOR("Peter Oruba");
 MODULE_LICENSE("GPL v2");
 
-#define UCODE_MAGIC                0x00414d44
-#define UCODE_EQUIV_CPU_TABLE_TYPE 0x00000000
-#define UCODE_UCODE_TYPE           0x00000001
-
-struct equiv_cpu_entry {
-	u32	installed_cpu;
-	u32	fixed_errata_mask;
-	u32	fixed_errata_compare;
-	u16	equiv_cpu;
-	u16	res;
-} __attribute__((packed));
-
-struct microcode_header_amd {
-	u32	data_code;
-	u32	patch_id;
-	u16	mc_patch_data_id;
-	u8	mc_patch_data_len;
-	u8	init_flag;
-	u32	mc_patch_data_checksum;
-	u32	nb_dev_id;
-	u32	sb_dev_id;
-	u16	processor_rev_id;
-	u8	nb_rev_id;
-	u8	sb_rev_id;
-	u8	bios_api_rev;
-	u8	reserved1[3];
-	u32	match_reg[8];
-} __attribute__((packed));
-
-struct microcode_amd {
-	struct microcode_header_amd	hdr;
-	unsigned int			mpb[0];
-};
-
-#define SECTION_HDR_SIZE	8
-#define CONTAINER_HDR_SZ	12
-
 static struct equiv_cpu_entry *equiv_cpu_table;
 
 struct ucode_patch {
@@ -84,21 +48,10 @@ struct ucode_patch {
 
 static LIST_HEAD(pcache);
 
-static u16 find_equiv_id(unsigned int cpu)
+static u16 __find_equiv_id(unsigned int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	int i = 0;
-
-	if (!equiv_cpu_table)
-		return 0;
-
-	while (equiv_cpu_table[i].installed_cpu != 0) {
-		if (uci->cpu_sig.sig == equiv_cpu_table[i].installed_cpu)
-			return equiv_cpu_table[i].equiv_cpu;
-
-		i++;
-	}
-	return 0;
+	return find_equiv_id(equiv_cpu_table, uci->cpu_sig.sig);
 }
 
 static u32 find_cpu_family_by_equiv_cpu(u16 equiv_cpu)
@@ -163,7 +116,7 @@ static struct ucode_patch *find_patch(unsigned int cpu)
 {
 	u16 equiv_id;
 
-	equiv_id = find_equiv_id(cpu);
+	equiv_id = __find_equiv_id(cpu);
 	if (!equiv_id)
 		return NULL;
 
@@ -215,7 +168,21 @@ static unsigned int verify_patch_size(int cpu, u32 patch_size,
 	return patch_size;
 }
 
-static int apply_microcode_amd(int cpu)
+int __apply_microcode_amd(struct microcode_amd *mc_amd)
+{
+	u32 rev, dummy;
+
+	wrmsrl(MSR_AMD64_PATCH_LOADER, (u64)(long)&mc_amd->hdr.data_code);
+
+	/* verify patch application was successful */
+	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
+	if (rev != mc_amd->hdr.patch_id)
+		return -1;
+
+	return 0;
+}
+
+int apply_microcode_amd(int cpu)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct microcode_amd *mc_amd;
@@ -242,19 +209,15 @@ static int apply_microcode_amd(int cpu)
 		return 0;
 	}
 
-	wrmsrl(MSR_AMD64_PATCH_LOADER, (u64)(long)&mc_amd->hdr.data_code);
-
-	/* verify patch application was successful */
-	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
-	if (rev != mc_amd->hdr.patch_id) {
+	if (__apply_microcode_amd(mc_amd))
 		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
-		       cpu, mc_amd->hdr.patch_id);
-		return -1;
-	}
+			cpu, mc_amd->hdr.patch_id);
+	else
+		pr_info("CPU%d: new patch_level=0x%08x\n", cpu,
+			mc_amd->hdr.patch_id);
 
-	pr_info("CPU%d: new patch_level=0x%08x\n", cpu, rev);
-	uci->cpu_sig.rev = rev;
-	c->microcode = rev;
+	uci->cpu_sig.rev = mc_amd->hdr.patch_id;
+	c->microcode = mc_amd->hdr.patch_id;
 
 	return 0;
 }
@@ -364,7 +327,7 @@ static int verify_and_add_patch(unsigned int cpu, u8 *fw, unsigned int leftover)
 	return crnt_size;
 }
 
-static enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size)
+static enum ucode_state __load_microcode_amd(int cpu, const u8 *data, size_t size)
 {
 	enum ucode_state ret = UCODE_ERROR;
 	unsigned int leftover;
@@ -398,6 +361,21 @@ static enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size)
 	return UCODE_OK;
 }
 
+enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size)
+{
+	enum ucode_state ret;
+
+	/* free old equiv table */
+	free_equiv_cpu_table();
+
+	ret = __load_microcode_amd(cpu, data, size);
+
+	if (ret != UCODE_OK)
+		cleanup();
+
+	return ret;
+}
+
 /*
  * AMD microcode firmware naming convention, up to family 15h they are in
  * the legacy file:
@@ -440,12 +418,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 		goto fw_release;
 	}
 
-	/* free old equiv table */
-	free_equiv_cpu_table();
-
 	ret = load_microcode_amd(cpu, fw->data, fw->size);
-	if (ret != UCODE_OK)
-		cleanup();
 
  fw_release:
 	release_firmware(fw);
-- 
1.7.9.5


