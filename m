Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab3A2Js7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:48:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52457 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab3A2Jsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:48:55 -0500
Date: Tue, 29 Jan 2013 01:48:43 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-5dcd14ecd41ea2b3ae3295a9b30d98769d52165f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359058816-7615-26-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-26-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot:
  Sanitize boot_params if not zeroed on creation
Git-Commit-ID: 5dcd14ecd41ea2b3ae3295a9b30d98769d52165f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 01:48:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5dcd14ecd41ea2b3ae3295a9b30d98769d52165f
Gitweb:     http://git.kernel.org/tip/5dcd14ecd41ea2b3ae3295a9b30d98769d52165f
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 29 Jan 2013 01:05:24 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 01:22:17 -0800

x86, boot: Sanitize boot_params if not zeroed on creation

Use the new sentinel field to detect bootloaders which fail to follow
protocol and don't initialize fields in struct boot_params that they
do not explicitly initialize to zero.

Based on an original patch and research by Yinghai Lu.
Changed by hpa to be invoked both in the decompression path and in the
kernel proper; the latter for the case where a bootloader takes over
decompression.

Originally-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-26-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/misc.c        |  2 ++
 arch/x86/boot/compressed/misc.h        |  1 +
 arch/x86/include/asm/bootparam_utils.h | 38 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/head32.c               |  3 +++
 arch/x86/kernel/head64.c               |  2 ++
 5 files changed, 46 insertions(+)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 88f7ff6..7cb56c6 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -325,6 +325,8 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 {
 	real_mode = rmode;
 
+	sanitize_boot_params(real_mode);
+
 	if (real_mode->screen_info.orig_video_mode == 7) {
 		vidmem = (char *) 0xb0000;
 		vidport = 0x3b4;
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 0e6dc0e..674019d 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -18,6 +18,7 @@
 #include <asm/page.h>
 #include <asm/boot.h>
 #include <asm/bootparam.h>
+#include <asm/bootparam_utils.h>
 
 #define BOOT_BOOT_H
 #include "../ctype.h"
diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
new file mode 100644
index 0000000..5b5e9cb
--- /dev/null
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -0,0 +1,38 @@
+#ifndef _ASM_X86_BOOTPARAM_UTILS_H
+#define _ASM_X86_BOOTPARAM_UTILS_H
+
+#include <asm/bootparam.h>
+
+/*
+ * This file is included from multiple environments.  Do not
+ * add completing #includes to make it standalone.
+ */
+
+/*
+ * Deal with bootloaders which fail to initialize unknown fields in
+ * boot_params to zero.  The list fields in this list are taken from
+ * analysis of kexec-tools; if other broken bootloaders initialize a
+ * different set of fields we will need to figure out how to disambiguate.
+ *
+ */
+static void sanitize_boot_params(struct boot_params *boot_params)
+{
+	if (boot_params->sentinel) {
+		/*fields in boot_params are not valid, clear them */
+		memset(&boot_params->olpc_ofw_header, 0,
+		       (char *)&boot_params->alt_mem_k -
+			(char *)&boot_params->olpc_ofw_header);
+		memset(&boot_params->kbd_status, 0,
+		       (char *)&boot_params->hdr -
+		       (char *)&boot_params->kbd_status);
+		memset(&boot_params->_pad7[0], 0,
+		       (char *)&boot_params->edd_mbr_sig_buffer[0] -
+			(char *)&boot_params->_pad7[0]);
+		memset(&boot_params->_pad8[0], 0,
+		       (char *)&boot_params->eddbuf[0] -
+			(char *)&boot_params->_pad8[0]);
+		memset(&boot_params->_pad9[0], 0, sizeof(boot_params->_pad9));
+	}
+}
+
+#endif /* _ASM_X86_BOOTPARAM_UTILS_H */
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index c18f59d..6773c91 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -18,6 +18,7 @@
 #include <asm/io_apic.h>
 #include <asm/bios_ebda.h>
 #include <asm/tlbflush.h>
+#include <asm/bootparam_utils.h>
 
 static void __init i386_default_early_setup(void)
 {
@@ -30,6 +31,8 @@ static void __init i386_default_early_setup(void)
 
 void __init i386_start_kernel(void)
 {
+	sanitize_boot_params(&boot_params);
+
 	memblock_reserve(__pa_symbol(&_text),
 			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
 
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 037df57..849fc9e 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -25,6 +25,7 @@
 #include <asm/kdebug.h>
 #include <asm/e820.h>
 #include <asm/bios_ebda.h>
+#include <asm/bootparam_utils.h>
 
 static void __init zap_identity_mappings(void)
 {
@@ -46,6 +47,7 @@ static void __init copy_bootdata(char *real_mode_data)
 	char * command_line;
 
 	memcpy(&boot_params, real_mode_data, sizeof boot_params);
+	sanitize_boot_params(&boot_params);
 	if (boot_params.hdr.cmd_line_ptr) {
 		command_line = __va(boot_params.hdr.cmd_line_ptr);
 		memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
