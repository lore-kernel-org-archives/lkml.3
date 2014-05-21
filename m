Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaEUDqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 23:46:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58930 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaEUDp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 23:45:59 -0400
Date: Tue, 20 May 2014 20:45:47 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-65cef1311d5d212fd3d48a43678536dc878ca288@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1400525957-11525-3-git-send-email-bp@alien8.de>
References: <1400525957-11525-3-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode: Add a disable chicken bit
Git-Commit-ID: 65cef1311d5d212fd3d48a43678536dc878ca288
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

Commit-ID:  65cef1311d5d212fd3d48a43678536dc878ca288
Gitweb:     http://git.kernel.org/tip/65cef1311d5d212fd3d48a43678536dc878ca288
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 19 May 2014 20:59:17 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 20 May 2014 20:21:27 -0700

x86, microcode: Add a disable chicken bit

Add a cmdline param which disables the microcode loader. This is useful
mostly in debugging situations where we want to turn off microcode
loading, both early from the initrd and late, as a means to be able to
rule out its influence on the machine.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1400525957-11525-3-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/microcode.h           |  1 +
 arch/x86/kernel/cpu/microcode/core.c       |  6 +++++
 arch/x86/kernel/cpu/microcode/core_early.c | 37 ++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index b59827e..64dc362 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -25,6 +25,7 @@ struct cpu_signature {
 struct device;
 
 enum ucode_state { UCODE_ERROR, UCODE_OK, UCODE_NFOUND };
+extern bool dis_ucode_ldr;
 
 struct microcode_ops {
 	enum ucode_state (*request_microcode_user) (int cpu,
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 15c9876..dd9d619 100644
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
index be7f851..5f28a64 100644
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
 
