Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab3EWBQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 21:16:53 -0400
Received: from [216.32.181.183] ([216.32.181.183]:10784 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756643Ab3EWBQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 21:16:51 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MN88U3-01-HUD-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>
CC: Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Borislav Petkov <bp@alien8.de>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 1/2] x86/microcode: vendor abstract out save_microcode_in_initrd()
Date: Wed, 22 May 2013 20:15:33 -0500
Message-ID: <1369271734-3231-2-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369271734-3231-1-git-send-email-jacob.shin@amd.com>
References: <1369271734-3231-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently save_microcode_in_initrd() is declared in vendor neutural
microcode.h file, but defined in vendor specific
microcode_intel_early.c file. Vendor abstract it out to
microcode_core_early.c with a wrapper function.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/include/asm/microcode_intel.h  |    2 ++
 arch/x86/kernel/microcode_core_early.c  |   10 ++++++++++
 arch/x86/kernel/microcode_intel_early.c |    2 +-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index 5356f92..cf729eb 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -67,10 +67,12 @@ update_match_revision(struct microcode_header_intel *mc_header, int rev);
 extern void __init load_ucode_intel_bsp(void);
 extern void __cpuinit load_ucode_intel_ap(void);
 extern void show_ucode_info_early(void);
+extern int __init save_microcode_in_initrd_intel(void);
 #else
 static inline __init void load_ucode_intel_bsp(void) {}
 static inline __cpuinit void load_ucode_intel_ap(void) {}
 static inline void show_ucode_info_early(void) {}
+static inline int __init save_microcode_in_initrd_intel(void) {}
 #endif
 
 #if defined(CONFIG_MICROCODE_INTEL_EARLY) && defined(CONFIG_HOTPLUG_CPU)
diff --git a/arch/x86/kernel/microcode_core_early.c b/arch/x86/kernel/microcode_core_early.c
index 833d51d..0d19ac5 100644
--- a/arch/x86/kernel/microcode_core_early.c
+++ b/arch/x86/kernel/microcode_core_early.c
@@ -98,3 +98,13 @@ void __cpuinit load_ucode_ap(void)
 	if (vendor == X86_VENDOR_INTEL && x86 >= 6)
 		load_ucode_intel_ap();
 }
+
+int __init save_microcode_in_initrd(void)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	if (c->x86_vendor == X86_VENDOR_INTEL && c->x86 >= 6)
+		return save_microcode_in_initrd_intel();
+
+	return 0;
+}
diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index 2e9e128..88f0edc 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -699,7 +699,7 @@ static int __cpuinit apply_microcode_early(struct mc_saved_data *mc_saved_data,
  * This function converts microcode patch offsets previously stored in
  * mc_saved_in_initrd to pointers and stores the pointers in mc_saved_data.
  */
-int __init save_microcode_in_initrd(void)
+int __init save_microcode_in_initrd_intel(void)
 {
 	unsigned int count = mc_saved_data.mc_saved_count;
 	struct microcode_intel *mc_saved[MAX_UCODE_COUNT];
-- 
1.7.9.5


