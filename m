Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbaCRT1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:27:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757861AbaCRT0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Cc: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 5/5] x86/boot: Move memset() definition in compressed/string.c
Date: Tue, 18 Mar 2014 15:26:40 -0400
Message-Id: <1395170800-11059-6-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1395170800-11059-1-git-send-email-vgoyal@redhat.com>
References: <1395170800-11059-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently compressed/misc.c needs to link against memset(). I think one of
the reasons of this need is inclusion of various header files which define
static inline functions and use memset() inside these. For example,
include/linux/bitmap.h

I think trying to include "../string.h" and using builtin version of memset
does not work because by the time "#define memset" shows up, it is too
late. Some other header file has already used memset() and expects to
find a definition during link phase.

Currently we have a C definitoin of memset() in misc.c. Move it to
compressed/string.c so that others can use it if need be.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/boot/compressed/misc.c   | 20 +++++++-------------
 arch/x86/boot/compressed/string.c | 10 ++++++++++
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 3100092..1768461 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -98,8 +98,14 @@
  */
 #define STATIC		static
 
-#undef memset
 #undef memcpy
+
+/*
+ * Use a normal definition of memset() from string.c. There are already
+ * included header files which expect a definition of memset() and by
+ * the time we define memset macro, it is too late.
+ */
+#undef memset
 #define memzero(s, n)	memset((s), 0, (n))
 
 
@@ -110,8 +116,6 @@ static void error(char *m);
  */
 struct boot_params *real_mode;		/* Pointer to real-mode data */
 
-void *memset(void *s, int c, size_t n);
-
 memptr free_mem_ptr;
 memptr free_mem_end_ptr;
 
@@ -216,16 +220,6 @@ void __putstr(const char *s)
 	outb(0xff & (pos >> 1), vidport+1);
 }
 
-void *memset(void *s, int c, size_t n)
-{
-	int i;
-	char *ss = s;
-
-	for (i = 0; i < n; i++)
-		ss[i] = c;
-	return s;
-}
-
 static void error(char *x)
 {
 	error_putstr("\n\n");
diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
index 920b55e..f3c57e3 100644
--- a/arch/x86/boot/compressed/string.c
+++ b/arch/x86/boot/compressed/string.c
@@ -33,3 +33,13 @@ void *memcpy(void *dest, const void *src, size_t n)
 	return dest;
 }
 #endif
+
+void *memset(void *s, int c, size_t n)
+{
+	int i;
+	char *ss = s;
+
+	for (i = 0; i < n; i++)
+		ss[i] = c;
+	return s;
+}
-- 
1.8.5.3

