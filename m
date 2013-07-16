Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477Ab3GPRFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:05:22 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:64052 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab3GPRFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:05:19 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: [PATCH 2/7] alpha: Eliminate compiler warning from memset macro
Date: Tue, 16 Jul 2013 10:04:35 -0700
Message-Id: <1373994280-12047-3-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373994280-12047-1-git-send-email-rth@twiddle.net>
References: <1373994280-12047-1-git-send-email-rth@twiddle.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling with GCC 4.8 yields several instances of

crypto/vmac.c: In function ‘vmac_final’:
crypto/vmac.c:616:9: warning: value computed is not used [-Wunused-value]
  memset(&mac, 0, sizeof(vmac_t));
         ^
arch/alpha/include/asm/string.h:31:25: note: in definition of macro ‘memset’
     ? __builtin_memset((s),0,(n))          \
                         ^
Converting the macro to an inline function eliminates this problem.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/include/asm/string.h | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/include/asm/string.h b/arch/alpha/include/asm/string.h
index b02b8a2..8b478ae 100644
--- a/arch/alpha/include/asm/string.h
+++ b/arch/alpha/include/asm/string.h
@@ -25,12 +25,18 @@ extern void * __constant_c_memset(void *, unsigned long, size_t);
 extern void * __memset(void *, int, size_t);
 extern void * memset(void *, int, size_t);
 
-#define memset(s, c, n)							    \
-(__builtin_constant_p(c)						    \
- ? (__builtin_constant_p(n) && (c) == 0					    \
-    ? __builtin_memset((s),0,(n)) 					    \
-    : __constant_c_memset((s),0x0101010101010101UL*(unsigned char)(c),(n))) \
- : __memset((s),(c),(n)))
+extern inline void *memset(void *s, int c, size_t n)
+{
+	if (__builtin_constant_p(c)) {
+		if (__builtin_constant_p(n)) {
+			return __builtin_memset(s, c, n);
+		} else {
+			unsigned long c8 = (c & 0xff) * 0x0101010101010101UL;
+			return __constant_c_memset(s, c8, n);
+		}
+	}
+	return __memset(s, c, n);
+}
 
 #define __HAVE_ARCH_STRCPY
 extern char * strcpy(char *,const char *);
-- 
1.8.1.4

