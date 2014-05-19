Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbaESS7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:59:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38915 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaESS7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:59:40 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 2/2] x86, microcode: Add a disable chicken bit
Date: Mon, 19 May 2014 20:59:17 +0200
Message-Id: <1400525957-11525-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400525957-11525-1-git-send-email-bp@alien8.de>
References: <1400525957-11525-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Add a cmdline param which disables the microcode loader. This is useful
mostly in debugging situations where we want to turn off microcode
loading, both early from the initrd and late, as a means to be able to
rule out its influence on the machine.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/microcode.h           |  1 +
 arch/x86/kernel/cpu/microcode/core.c       |  6 +++++
 arch/x86/kernel/cpu/microcode/core_early.c | 37 ++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index b59827e76529..64dc362506b7 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -25,6 +25,7 @@ struct cpu_signature {
 struct device;
 
 enum ucode_state { UCODE_ERROR, UCODE_OK, UCODE_NFOUND };
+extern bool dis_ucode_ldr;
 
 struct microcode_ops {
 	enum ucode_state (*request_microcode_user) (int cpu,
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 15c987698b0f..dd9d6190b08d 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -97,6 +97,9 @@ MODULE_LICENSE("GPL");
 
 static struct microcode_ops	*microcode_ops;
 
+bool dis_ucode_ldr;
+module_param(dis_ucode_ldr, bool, 0);
+
 /*
  * Synchronization.
  *
@@ -546,6 +549,9 @@ static int __init microcode_init(void)
 	struct cpuinfo_x86 *c = &cpu_data(0);
 	int error;
 
+	if (dis_ucode_ldr)
+		return 0;
+
 	if (c->x86_vendor == X86_VENDOR_INTEL)
 		microcode_ops = init_intel_microcode();
 	else if (c->x86_vendor == X86_VENDOR_AMD)
diff --git a/arch/x86/kernel/cpu/microcode/core_early.c b/arch/x86/kernel/cpu/microcode/core_early.c
index be7f8514f577..5f28a64e71ea 100644
--- a/arch/x86/kernel/cpu/microcode/core_early.c
+++ b/arch/x86/kernel/cpu/microcode/core_early.c
@@ -17,9 +17,11 @@
  *	2 of the License, or (at your option) any later version.
  */
 #include <linux/module.h>
+#include <asm/microcode.h>
 #include <asm/microcode_intel.h>
 #include <asm/microcode_amd.h>
 #include <asm/processor.h>
+#include <asm/cmdline.h>
 
 #define QCHAR(a, b, c, d) ((a) + ((b) << 8) + ((c) << 16) + ((d) << 24))
 #define CPUID_INTEL1 QCHAR('G', 'e', 'n', 'u')
@@ -72,10 +74,33 @@ static int x86_family(void)
 	return x86;
 }
 
+static bool __init check_loader_disabled_bsp(void)
+{
+#ifdef CONFIG_X86_32
+	const char *cmdline = (const char *)__pa_nodebug(boot_command_line);
+	const char *opt	    = "dis_ucode_ldr";
+	const char *option  = (const char *)__pa_nodebug(opt);
+	bool *res = (bool *)__pa_nodebug(&dis_ucode_ldr);
+
+#else /* CONFIG_X86_64 */
+	const char *cmdline = boot_command_line;
+	const char *option  = "dis_ucode_ldr";
+	bool *res = &dis_ucode_ldr;
+#endif
+
+	if (cmdline_find_option_bool(cmdline, option))
+		*res = true;
+
+	return *res;
+}
+
 void __init load_ucode_bsp(void)
 {
 	int vendor, x86;
 
+	if (check_loader_disabled_bsp())
+		return;
+
 	if (!have_cpuid_p())
 		return;
 
@@ -96,10 +121,22 @@ void __init load_ucode_bsp(void)
 	}
 }
 
+static bool check_loader_disabled_ap(void)
+{
+#ifdef CONFIG_X86_32
+	return __pa_nodebug(dis_ucode_ldr);
+#else
+	return dis_ucode_ldr;
+#endif
+}
+
 void load_ucode_ap(void)
 {
 	int vendor, x86;
 
+	if (check_loader_disabled_ap())
+		return;
+
 	if (!have_cpuid_p())
 		return;
 
-- 
1.9.0

