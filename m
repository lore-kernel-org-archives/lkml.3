Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab3A3Bhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:37:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43816 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3A3Bhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:37:42 -0500
Date: Tue, 29 Jan 2013 17:37:31 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-3db07e70f0b4742f8daeda5c4aa8fbe7aeb3799e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359058816-7615-19-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-19-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, boot:
  Pass cmd_line_ptr with unsigned long instead
Git-Commit-ID: 3db07e70f0b4742f8daeda5c4aa8fbe7aeb3799e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:37:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3db07e70f0b4742f8daeda5c4aa8fbe7aeb3799e
Gitweb:     http://git.kernel.org/tip/3db07e70f0b4742f8daeda5c4aa8fbe7aeb3799e
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:19:59 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:26:09 -0800

x86, boot: Pass cmd_line_ptr with unsigned long instead

boot/compressed/misc.c is used for bzImage in 64bit and 32bit, and
cmd_line_ptr could point to buffer that is above 4g, cmd_line_ptr
should be 64bit otherwise high 32bit will be capped out.

So need to change data type to unsigned long, that will be 64bit get
correct address of command line buffer.

And it is still ok with 32bit bzImage, because unsigned long on 32bit kernel
is still 32bit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-19-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/boot.h    | 8 ++++----
 arch/x86/boot/cmdline.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 7fadf80..5b75319 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -285,11 +285,11 @@ struct biosregs {
 void intcall(u8 int_no, const struct biosregs *ireg, struct biosregs *oreg);
 
 /* cmdline.c */
-int __cmdline_find_option(u32 cmdline_ptr, const char *option, char *buffer, int bufsize);
-int __cmdline_find_option_bool(u32 cmdline_ptr, const char *option);
+int __cmdline_find_option(unsigned long cmdline_ptr, const char *option, char *buffer, int bufsize);
+int __cmdline_find_option_bool(unsigned long cmdline_ptr, const char *option);
 static inline int cmdline_find_option(const char *option, char *buffer, int bufsize)
 {
-	u32 cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
+	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
 
 	if (cmd_line_ptr >= 0x100000)
 		return -1;      /* inaccessible */
@@ -299,7 +299,7 @@ static inline int cmdline_find_option(const char *option, char *buffer, int bufs
 
 static inline int cmdline_find_option_bool(const char *option)
 {
-	u32 cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
+	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
 
 	if (cmd_line_ptr >= 0x100000)
 		return -1;      /* inaccessible */
diff --git a/arch/x86/boot/cmdline.c b/arch/x86/boot/cmdline.c
index 768f00f..625d21b 100644
--- a/arch/x86/boot/cmdline.c
+++ b/arch/x86/boot/cmdline.c
@@ -27,7 +27,7 @@ static inline int myisspace(u8 c)
  * Returns the length of the argument (regardless of if it was
  * truncated to fit in the buffer), or -1 on not found.
  */
-int __cmdline_find_option(u32 cmdline_ptr, const char *option, char *buffer, int bufsize)
+int __cmdline_find_option(unsigned long cmdline_ptr, const char *option, char *buffer, int bufsize)
 {
 	addr_t cptr;
 	char c;
@@ -99,7 +99,7 @@ int __cmdline_find_option(u32 cmdline_ptr, const char *option, char *buffer, int
  * Returns the position of that option (starts counting with 1)
  * or 0 on not found
  */
-int __cmdline_find_option_bool(u32 cmdline_ptr, const char *option)
+int __cmdline_find_option_bool(unsigned long cmdline_ptr, const char *option)
 {
 	addr_t cptr;
 	char c;
