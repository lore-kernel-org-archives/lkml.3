Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3A3Bp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:45:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43947 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3A3Bp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:45:56 -0500
Date: Tue, 29 Jan 2013 17:45:38 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-8cf52eb755e5c5046d2a5d5d3b64d839677ed8ae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, caushik1@gmail.com, matt.fleming@intel.com,
        jmillenbach@gmail.com, tglx@linutronix.de, josh@joshtriplett.org,
        hpa@linux.intel.com, rob@landley.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, caushik1@gmail.com, matt.fleming@intel.com,
        jmillenbach@gmail.com, tglx@linutronix.de, josh@joshtriplett.org,
        hpa@linux.intel.com, rob@landley.net
In-Reply-To: <1359058816-7615-26-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-26-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, boot:
  enable support load bzImage and ramdisk above 4G
Git-Commit-ID: 8cf52eb755e5c5046d2a5d5d3b64d839677ed8ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:45:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8cf52eb755e5c5046d2a5d5d3b64d839677ed8ae
Gitweb:     http://git.kernel.org/tip/8cf52eb755e5c5046d2a5d5d3b64d839677ed8ae
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 28 Jan 2013 20:16:44 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:30:22 -0800

x86, boot: enable support load bzImage and ramdisk above 4G

xloadflags bit 1 indicates that we can load the kernel and all data
structure above 4G; it is set if kernel is relocatable and 64bit.

bootloader will check if xloadflags bit1 is set to decicde if
it could load ramdisk and kernel high above 4G.

bootloader will fill value to ext_ramdisk_image/size for high 32bits
when it load ramdisk above 4G.
kernel use get_ramdisk_image/size to use ext_ramdisk_image/size to get
right positon for ramdisk.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Rob Landley <rob@landley.net>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Gokul Caushik <caushik1@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Joe Millenbach <jmillenbach@gmail.com>
Link: http://lkml.kernel.org/r/1359058816-7615-26-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/cmdline.c |  2 ++
 arch/x86/boot/compressed/misc.c    | 19 +++++++++++++++++++
 arch/x86/boot/header.S             | 10 +++++++++-
 arch/x86/kernel/head64.c           |  2 ++
 arch/x86/kernel/setup.c            |  4 ++++
 5 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
index b4c913c..bffd73b 100644
--- a/arch/x86/boot/compressed/cmdline.c
+++ b/arch/x86/boot/compressed/cmdline.c
@@ -17,6 +17,8 @@ static unsigned long get_cmd_line_ptr(void)
 {
 	unsigned long cmd_line_ptr = real_mode->hdr.cmd_line_ptr;
 
+	cmd_line_ptr |= (u64)real_mode->ext_cmd_line_ptr << 32;
+
 	return cmd_line_ptr;
 }
 int cmdline_find_option(const char *option, char *buffer, int bufsize)
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 7cb56c6..5d8dc86 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -318,6 +318,23 @@ static void parse_elf(void *output)
 	free(phdrs);
 }
 
+static void sanitize_real_mode(struct boot_params *real_mode)
+{
+	if (real_mode->sentinel) {
+		/*fields in boot_params are not valid, clear them */
+		memset(&real_mode->olpc_ofw_header, 0,
+		       (char *)&real_mode->alt_mem_k -
+			(char *)&real_mode->olpc_ofw_header);
+		memset(&real_mode->_pad7[0], 0,
+		       (char *)&real_mode->edd_mbr_sig_buffer[0] -
+			(char *)&real_mode->_pad7[0]);
+		memset(&real_mode->_pad8[0], 0,
+		       (char *)&real_mode->eddbuf[0] -
+			(char *)&real_mode->_pad8[0]);
+		memset(&real_mode->_pad9[0], 0, sizeof(real_mode->_pad9));
+	}
+}
+
 asmlinkage void decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *input_data,
 				  unsigned long input_len,
@@ -327,6 +344,8 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 
 	sanitize_boot_params(real_mode);
 
+	sanitize_real_mode(real_mode);
+
 	if (real_mode->screen_info.orig_video_mode == 7) {
 		vidmem = (char *) 0xb0000;
 		vidport = 0x3b4;
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 944ce59..9ec06a1 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -374,6 +374,14 @@ xloadflags:
 #else
 # define XLF0 0
 #endif
+
+#if defined(CONFIG_RELOCATABLE) && defined(CONFIG_X86_64)
+   /* kernel/boot_param/ramdisk could be loaded above 4g */
+# define XLF1 XLF_CAN_BE_LOADED_ABOVE_4G
+#else
+# define XLF1 0
+#endif
+
 #ifdef CONFIG_EFI_STUB
 # ifdef CONFIG_X86_64
 #  define XLF23 XLF_EFI_HANDOVER_64		/* 64-bit EFI handover ok */
@@ -383,7 +391,7 @@ xloadflags:
 #else
 # define XLF23 0
 #endif
-			.word XLF0 | XLF23
+			.word XLF0 | XLF1 | XLF23
 
 cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
                                                 #added with boot protocol
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 62c8ce4..6873b07 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -116,6 +116,8 @@ static unsigned long get_cmd_line_ptr(void)
 {
 	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
 
+	cmd_line_ptr |= (u64)boot_params.ext_cmd_line_ptr << 32;
+
 	return cmd_line_ptr;
 }
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 83b3861..519f2bc 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -298,12 +298,16 @@ static u64 __init get_ramdisk_image(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 
+	ramdisk_image |= (u64)boot_params.ext_ramdisk_image << 32;
+
 	return ramdisk_image;
 }
 static u64 __init get_ramdisk_size(void)
 {
 	u64 ramdisk_size = boot_params.hdr.ramdisk_size;
 
+	ramdisk_size |= (u64)boot_params.ext_ramdisk_size << 32;
+
 	return ramdisk_size;
 }
 
