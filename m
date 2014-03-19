Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965049AbaCSXbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:31:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42766 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964864AbaCSXbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:31:22 -0400
Date: Wed, 19 Mar 2014 16:31:09 -0700
From: tip-bot for Vivek Goyal <tipbot@zytor.com>
Message-ID: <tip-820e8feca06ff744f60e5036c3178dde40b91afc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, vgoyal@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, vgoyal@redhat.com, hpa@linux.intel.com
In-Reply-To: <1395170800-11059-4-git-send-email-vgoyal@redhat.com>
References: <1395170800-11059-4-git-send-email-vgoyal@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot: Move optimized memcpy() 32/
 64 bit versions to compressed/string.c
Git-Commit-ID: 820e8feca06ff744f60e5036c3178dde40b91afc
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

Commit-ID:  820e8feca06ff744f60e5036c3178dde40b91afc
Gitweb:     http://git.kernel.org/tip/820e8feca06ff744f60e5036c3178dde40b91afc
Author:     Vivek Goyal <vgoyal@redhat.com>
AuthorDate: Tue, 18 Mar 2014 15:26:38 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 19 Mar 2014 15:43:59 -0700

x86, boot: Move optimized memcpy() 32/64 bit versions to compressed/string.c

Move optimized versions of memcpy to compressed/string.c This will allow
any other code to use these functions too if need be in future. Again
trying to put definition in a common place instead of hiding it in misc.c

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Link: http://lkml.kernel.org/r/1395170800-11059-4-git-send-email-vgoyal@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/misc.c   | 31 +------------------------------
 arch/x86/boot/compressed/string.c | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 196eaf3..3100092 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -10,6 +10,7 @@
  */
 
 #include "misc.h"
+#include "../string.h"
 
 /* WARNING!!
  * This code is compiled with -fPIC and it is relocated dynamically
@@ -110,7 +111,6 @@ static void error(char *m);
 struct boot_params *real_mode;		/* Pointer to real-mode data */
 
 void *memset(void *s, int c, size_t n);
-void *memcpy(void *dest, const void *src, size_t n);
 
 memptr free_mem_ptr;
 memptr free_mem_end_ptr;
@@ -225,35 +225,6 @@ void *memset(void *s, int c, size_t n)
 		ss[i] = c;
 	return s;
 }
-#ifdef CONFIG_X86_32
-void *memcpy(void *dest, const void *src, size_t n)
-{
-	int d0, d1, d2;
-	asm volatile(
-		"rep ; movsl\n\t"
-		"movl %4,%%ecx\n\t"
-		"rep ; movsb\n\t"
-		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
-		: "0" (n >> 2), "g" (n & 3), "1" (dest), "2" (src)
-		: "memory");
-
-	return dest;
-}
-#else
-void *memcpy(void *dest, const void *src, size_t n)
-{
-	long d0, d1, d2;
-	asm volatile(
-		"rep ; movsq\n\t"
-		"movq %4,%%rcx\n\t"
-		"rep ; movsb\n\t"
-		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
-		: "0" (n >> 3), "g" (n & 7), "1" (dest), "2" (src)
-		: "memory");
-
-	return dest;
-}
-#endif
 
 static void error(char *x)
 {
diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
index 212004e..3b5a82f 100644
--- a/arch/x86/boot/compressed/string.c
+++ b/arch/x86/boot/compressed/string.c
@@ -11,3 +11,36 @@ int memcmp(const void *s1, const void *s2, size_t len)
 }
 
 #include "../string.c"
+
+/* misc.h might pull in string_32.h which has a macro for memcpy. undef that */
+#undef memcpy
+
+#ifdef CONFIG_X86_32
+void *memcpy(void *dest, const void *src, size_t n)
+{
+	int d0, d1, d2;
+	asm volatile(
+		"rep ; movsl\n\t"
+		"movl %4,%%ecx\n\t"
+		"rep ; movsb\n\t"
+		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
+		: "0" (n >> 2), "g" (n & 3), "1" (dest), "2" (src)
+		: "memory");
+
+	return dest;
+}
+#else
+void *memcpy(void *dest, const void *src, size_t n)
+{
+	long d0, d1, d2;
+	asm volatile(
+		"rep ; movsq\n\t"
+		"movq %4,%%rcx\n\t"
+		"rep ; movsb\n\t"
+		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
+		: "0" (n >> 3), "g" (n & 7), "1" (dest), "2" (src)
+		: "memory");
+
+	return dest;
+}
+#endif
