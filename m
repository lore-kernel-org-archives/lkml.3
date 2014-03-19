Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965178AbaCSXbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:31:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42777 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965074AbaCSXbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:31:32 -0400
Date: Wed, 19 Mar 2014 16:31:20 -0700
From: tip-bot for Vivek Goyal <tipbot@zytor.com>
Message-ID: <tip-fb4cac573ef6dce8d7543b68306566561c2e5725@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, vgoyal@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, vgoyal@redhat.com, hpa@linux.intel.com
In-Reply-To: <1395170800-11059-5-git-send-email-vgoyal@redhat.com>
References: <1395170800-11059-5-git-send-email-vgoyal@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot: Move memcmp()
  into string.h and string.c
Git-Commit-ID: fb4cac573ef6dce8d7543b68306566561c2e5725
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

Commit-ID:  fb4cac573ef6dce8d7543b68306566561c2e5725
Gitweb:     http://git.kernel.org/tip/fb4cac573ef6dce8d7543b68306566561c2e5725
Author:     Vivek Goyal <vgoyal@redhat.com>
AuthorDate: Tue, 18 Mar 2014 15:26:39 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 19 Mar 2014 15:44:04 -0700

x86, boot: Move memcmp() into string.h and string.c

Try to treat memcmp() in same way as memcpy() and memset(). Provide a
declaration in boot/string.h and by default user gets a memcmp() which
maps to builtin function.

Move optimized definition of memcmp() in boot/string.c. Now a user can
do #undef memcmp and link against string.c to use optimzied memcmp().

It also simplifies boot/compressed/string.c where we had to redefine
memcmp(). That extra definition is gone now.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Link: http://lkml.kernel.org/r/1395170800-11059-5-git-send-email-vgoyal@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/boot.h              |  8 --------
 arch/x86/boot/compressed/string.c | 11 -----------
 arch/x86/boot/string.c            | 14 ++++++++++++++
 arch/x86/boot/string.h            |  2 ++
 4 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index bed9665..bd49ec6 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -177,14 +177,6 @@ static inline void wrgs32(u32 v, addr_t addr)
 }
 
 /* Note: these only return true/false, not a signed return value! */
-static inline int memcmp(const void *s1, const void *s2, size_t len)
-{
-	u8 diff;
-	asm("repe; cmpsb; setnz %0"
-	    : "=qm" (diff), "+D" (s1), "+S" (s2), "+c" (len));
-	return diff;
-}
-
 static inline int memcmp_fs(const void *s1, addr_t s2, size_t len)
 {
 	u8 diff;
diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
index 3b5a82f..920b55e 100644
--- a/arch/x86/boot/compressed/string.c
+++ b/arch/x86/boot/compressed/string.c
@@ -1,15 +1,4 @@
 #include "misc.h"
-
-/* Avoid intereference from any defines in string_32.h */
-#undef memcmp
-int memcmp(const void *s1, const void *s2, size_t len)
-{
-	u8 diff;
-	asm("repe; cmpsb; setnz %0"
-	    : "=qm" (diff), "+D" (s1), "+S" (s2), "+c" (len));
-	return diff;
-}
-
 #include "../string.c"
 
 /* misc.h might pull in string_32.h which has a macro for memcpy. undef that */
diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index 574dedf..5339040 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -14,6 +14,20 @@
 
 #include "boot.h"
 
+/*
+ * This file gets included in compressed/string.c which might pull in
+ * string_32.h and which in turn maps memcmp to __builtin_memcmp(). Undo
+ * that first.
+ */
+#undef memcmp
+int memcmp(const void *s1, const void *s2, size_t len)
+{
+	u8 diff;
+	asm("repe; cmpsb; setnz %0"
+	    : "=qm" (diff), "+D" (s1), "+S" (s2), "+c" (len));
+	return diff;
+}
+
 int strcmp(const char *str1, const char *str2)
 {
 	const unsigned char *s1 = (const unsigned char *)str1;
diff --git a/arch/x86/boot/string.h b/arch/x86/boot/string.h
index 10939d8..725e820 100644
--- a/arch/x86/boot/string.h
+++ b/arch/x86/boot/string.h
@@ -8,6 +8,7 @@
 
 void *memcpy(void *dst, const void *src, size_t len);
 void *memset(void *dst, int c, size_t len);
+int memcmp(const void *s1, const void *s2, size_t len);
 
 /*
  * Access builtin version by default. If one needs to use optimized version,
@@ -15,5 +16,6 @@ void *memset(void *dst, int c, size_t len);
  */
 #define memcpy(d,s,l) __builtin_memcpy(d,s,l)
 #define memset(d,c,l) __builtin_memset(d,c,l)
+#define memcmp	__builtin_memcmp
 
 #endif /* BOOT_STRING_H */
