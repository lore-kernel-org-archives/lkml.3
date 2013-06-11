Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3FKSmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:42:53 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46506 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504Ab3FKSmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:42:52 -0400
Date: Tue, 11 Jun 2013 11:41:13 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Gokul Caushik <caushik1@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH] x86, boot: access cmdline when loaded high
Message-ID: <20130611184113.GA2288@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cmdline_find_option routine requires that the kernel cmdline be
located under 0x10000. When running the compressed boot code, if the
cmdline is loaded above this range, it will be ignored. This breaks
recognition of things like "earlyprintk=...". Since the compressed boot
code is already tricking the cmdline routines about locations, take it all
the way and access the cmdline via offset instead of via actual location.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/cmdline.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
index bffd73b..2e39280 100644
--- a/arch/x86/boot/compressed/cmdline.c
+++ b/arch/x86/boot/compressed/cmdline.c
@@ -2,32 +2,29 @@
 
 #ifdef CONFIG_EARLY_PRINTK
 
+/*
+ * We know where the cmdline is, so just retain it, and use a non-zero
+ * offset to trick __cmdline_find_option into running.
+ */
 static unsigned long fs;
 static inline void set_fs(unsigned long seg)
 {
-	fs = seg << 4;  /* shift it back */
+	fs = real_mode->hdr.cmd_line_ptr;
+	fs |= (u64)real_mode->ext_cmd_line_ptr << 32;
 }
 typedef unsigned long addr_t;
 static inline char rdfs8(addr_t addr)
 {
-	return *((char *)(fs + addr));
+	return *((char *)(fs + addr - 0x1));
 }
 #include "../cmdline.c"
-static unsigned long get_cmd_line_ptr(void)
-{
-	unsigned long cmd_line_ptr = real_mode->hdr.cmd_line_ptr;
-
-	cmd_line_ptr |= (u64)real_mode->ext_cmd_line_ptr << 32;
-
-	return cmd_line_ptr;
-}
 int cmdline_find_option(const char *option, char *buffer, int bufsize)
 {
-	return __cmdline_find_option(get_cmd_line_ptr(), option, buffer, bufsize);
+	return __cmdline_find_option(0x1, option, buffer, bufsize);
 }
 int cmdline_find_option_bool(const char *option)
 {
-	return __cmdline_find_option_bool(get_cmd_line_ptr(), option);
+	return __cmdline_find_option_bool(0x1, option);
 }
 
 #endif
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
