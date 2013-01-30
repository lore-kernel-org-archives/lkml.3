Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3A3Bfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:35:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43793 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3A3Bf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:35:29 -0500
Date: Tue, 29 Jan 2013 17:35:11 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-f1da834cd902f5e5df0b11a3948fc43c6071b590@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, alexander.h.duyck@intel.com, caushik1@gmail.com,
        jmillenbach@gmail.com, tglx@linutronix.de, josh@joshtriplett.org,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, alexander.h.duyck@intel.com, caushik1@gmail.com,
        jmillenbach@gmail.com, tglx@linutronix.de, josh@joshtriplett.org,
        hpa@linux.intel.com
In-Reply-To: <1359058816-7615-17-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-17-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, boot: Add get_cmd_line_ptr()
Git-Commit-ID: f1da834cd902f5e5df0b11a3948fc43c6071b590
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:35:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1da834cd902f5e5df0b11a3948fc43c6071b590
Gitweb:     http://git.kernel.org/tip/f1da834cd902f5e5df0b11a3948fc43c6071b590
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:19:57 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:25:45 -0800

x86, boot: Add get_cmd_line_ptr()

Add an accessor function for the command line address.
Later we will add support for holding a 64-bit address via ext_cmd_line_ptr.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-17-git-send-email-yinghai@kernel.org
Cc: Gokul Caushik <caushik1@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Joe Millenbach <jmillenbach@gmail.com>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/cmdline.c | 10 ++++++++--
 arch/x86/kernel/head64.c           | 13 +++++++++++--
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
index 10f6b11..b4c913c 100644
--- a/arch/x86/boot/compressed/cmdline.c
+++ b/arch/x86/boot/compressed/cmdline.c
@@ -13,13 +13,19 @@ static inline char rdfs8(addr_t addr)
 	return *((char *)(fs + addr));
 }
 #include "../cmdline.c"
+static unsigned long get_cmd_line_ptr(void)
+{
+	unsigned long cmd_line_ptr = real_mode->hdr.cmd_line_ptr;
+
+	return cmd_line_ptr;
+}
 int cmdline_find_option(const char *option, char *buffer, int bufsize)
 {
-	return __cmdline_find_option(real_mode->hdr.cmd_line_ptr, option, buffer, bufsize);
+	return __cmdline_find_option(get_cmd_line_ptr(), option, buffer, bufsize);
 }
 int cmdline_find_option_bool(const char *option)
 {
-	return __cmdline_find_option_bool(real_mode->hdr.cmd_line_ptr, option);
+	return __cmdline_find_option_bool(get_cmd_line_ptr(), option);
 }
 
 #endif
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index b88a1fa..62c8ce4 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -112,14 +112,23 @@ static void __init clear_bss(void)
 	       (unsigned long) __bss_stop - (unsigned long) __bss_start);
 }
 
+static unsigned long get_cmd_line_ptr(void)
+{
+	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
+
+	return cmd_line_ptr;
+}
+
 static void __init copy_bootdata(char *real_mode_data)
 {
 	char * command_line;
+	unsigned long cmd_line_ptr;
 
 	memcpy(&boot_params, real_mode_data, sizeof boot_params);
 	sanitize_boot_params(&boot_params);
-	if (boot_params.hdr.cmd_line_ptr) {
-		command_line = __va(boot_params.hdr.cmd_line_ptr);
+	cmd_line_ptr = get_cmd_line_ptr();
+	if (cmd_line_ptr) {
+		command_line = __va(cmd_line_ptr);
 		memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	}
 }
