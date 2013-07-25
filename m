Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3GYJJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:09:28 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46656 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab3GYJIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:08:55 -0400
X-AuditID: 85900ec0-d2ec7b900000151e-82-51f0eb245cdb
X-Mailbox-Line: From nobody Thu Jul 25 17:37:30 2013
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [RESEND RFC PATCH 1/5] printk: make printk a macro
To: linux-kernel@vger.kernel.org
Cc: yrl.pp-manager.tt@hitachi.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, kay@vrfy.org, davem@davemloft.net,
        itoukzo@nttdata.co.jp, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Date: Thu, 25 Jul 2013 17:37:30 +0900
Message-ID: <20130725083730.20349.94796.stgit@localhost.localdomain>
In-Reply-To: <20130725083730.20349.50797.stgit@localhost.localdomain>
References: <20130725083730.20349.50797.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To allow building up metadata transparently for each printk(), make
printk() a macro while keeping printk()'s API.  Then, printk() calls
_printk() which implements the original printk() function.

printk() is used from assembly sources, but they don't include printk.h
and don't use this new printk() macro.  This is addressed by assigning
the printk symbol to _printk in the linker script.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---

 include/asm-generic/vmlinux.lds.h |    1 +
 include/linux/printk.h            |    4 +++-
 kernel/printk.c                   |   12 ++++++++----
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 69732d2..0162017 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -393,6 +393,7 @@
 		*(.text.hot)						\
 		*(.text)						\
 		*(.ref.text)						\
+		VMLINUX_SYMBOL(printk) = VMLINUX_SYMBOL(_printk);	\
 	MEM_KEEP(init.text)						\
 	MEM_KEEP(exit.text)						\
 		*(.text.unlikely)
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 22c7052..c7a8c6b 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -121,7 +121,9 @@ asmlinkage int printk_emit(int facility, int level,
 			   const char *fmt, ...);
 
 asmlinkage __printf(1, 2) __cold
-int printk(const char *fmt, ...);
+int _printk(const char *fmt, ...);
+
+#define printk(fmt, args...) _printk(fmt, ## args)
 
 /*
  * Special printk facility for scheduler use only, _DO_NOT_USE_ !
diff --git a/kernel/printk.c b/kernel/printk.c
index 69b0890..4cf26ea 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1658,10 +1658,14 @@ asmlinkage int printk_emit(int facility, int level,
 EXPORT_SYMBOL(printk_emit);
 
 /**
- * printk - print a kernel message
+ * _printk - print a kernel message
  * @fmt: format string
  *
- * This is printk(). It can be called from any context. We want it to work.
+ * Now, printk() is a macro defined in include/linux/printk.h, and this
+ * function is its body.  It can be called from any context, but please
+ * use printk() macro.  Directly calling _printk() is not recommended.
+ * In assembly sources, you can call printk as in the past because the
+ * linker program links the printk symbol in assembly sources to _printk.
  *
  * We try to grab the console_lock. If we succeed, it's easy - we log the
  * output and call the console drivers.  If we fail to get the semaphore, we
@@ -1678,7 +1682,7 @@ EXPORT_SYMBOL(printk_emit);
  *
  * See the vsnprintf() documentation for format string extensions over C99.
  */
-asmlinkage int printk(const char *fmt, ...)
+asmlinkage int _printk(const char *fmt, ...)
 {
 	va_list args;
 	int r;
@@ -1697,7 +1701,7 @@ asmlinkage int printk(const char *fmt, ...)
 
 	return r;
 }
-EXPORT_SYMBOL(printk);
+EXPORT_SYMBOL(_printk);
 
 #else /* CONFIG_PRINTK */
 


