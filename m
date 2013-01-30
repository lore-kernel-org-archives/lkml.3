Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3A3Bgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:36:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43806 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3A3Bgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:36:32 -0500
Date: Tue, 29 Jan 2013 17:36:21 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-16a4baa642cf448742aaf150c4daa093f9dbebbb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359058816-7615-18-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-18-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, boot:
  Move checking of cmd_line_ptr out of common path
Git-Commit-ID: 16a4baa642cf448742aaf150c4daa093f9dbebbb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:36:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16a4baa642cf448742aaf150c4daa093f9dbebbb
Gitweb:     http://git.kernel.org/tip/16a4baa642cf448742aaf150c4daa093f9dbebbb
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:19:58 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:26:01 -0800

x86, boot: Move checking of cmd_line_ptr out of common path

cmdline.c::__cmdline_find_option... are shared between 16-bit setup code
and 32/64 bit decompressor code.

for 32/64 only path via kexec, we should not check if ptr is less 1M.
as those cmdline could be put above 1M, or even 4G.

Move out accessible checking out of __cmdline_find_option()
So decompressor in misc.c can parse cmdline correctly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-18-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/boot.h    | 14 ++++++++++++--
 arch/x86/boot/cmdline.c |  8 ++++----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 18997e5..7fadf80 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -289,12 +289,22 @@ int __cmdline_find_option(u32 cmdline_ptr, const char *option, char *buffer, int
 int __cmdline_find_option_bool(u32 cmdline_ptr, const char *option);
 static inline int cmdline_find_option(const char *option, char *buffer, int bufsize)
 {
-	return __cmdline_find_option(boot_params.hdr.cmd_line_ptr, option, buffer, bufsize);
+	u32 cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
+
+	if (cmd_line_ptr >= 0x100000)
+		return -1;      /* inaccessible */
+
+	return __cmdline_find_option(cmd_line_ptr, option, buffer, bufsize);
 }
 
 static inline int cmdline_find_option_bool(const char *option)
 {
-	return __cmdline_find_option_bool(boot_params.hdr.cmd_line_ptr, option);
+	u32 cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
+
+	if (cmd_line_ptr >= 0x100000)
+		return -1;      /* inaccessible */
+
+	return __cmdline_find_option_bool(cmd_line_ptr, option);
 }
 
 
diff --git a/arch/x86/boot/cmdline.c b/arch/x86/boot/cmdline.c
index 6b3b6f7..768f00f 100644
--- a/arch/x86/boot/cmdline.c
+++ b/arch/x86/boot/cmdline.c
@@ -41,8 +41,8 @@ int __cmdline_find_option(u32 cmdline_ptr, const char *option, char *buffer, int
 		st_bufcpy	/* Copying this to buffer */
 	} state = st_wordstart;
 
-	if (!cmdline_ptr || cmdline_ptr >= 0x100000)
-		return -1;	/* No command line, or inaccessible */
+	if (!cmdline_ptr)
+		return -1;      /* No command line */
 
 	cptr = cmdline_ptr & 0xf;
 	set_fs(cmdline_ptr >> 4);
@@ -111,8 +111,8 @@ int __cmdline_find_option_bool(u32 cmdline_ptr, const char *option)
 		st_wordskip,	/* Miscompare, skip */
 	} state = st_wordstart;
 
-	if (!cmdline_ptr || cmdline_ptr >= 0x100000)
-		return -1;	/* No command line, or inaccessible */
+	if (!cmdline_ptr)
+		return -1;      /* No command line */
 
 	cptr = cmdline_ptr & 0xf;
 	set_fs(cmdline_ptr >> 4);
