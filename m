Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaFMAx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 20:53:27 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:36899 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbaFMAxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 20:53:21 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: <hpa@zytor.com>, Kui Zhang <kuizhang@gmail.com>
Cc: x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 3/4] x86,vdso: Add PUT_LE to store little-endian values
Date: Thu, 12 Jun 2014 17:53:11 -0700
Message-Id: <3d9b27e92745b27b6fda1b9a98f70dc9c1246c7a.1402620737.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1402620737.git.luto@amacapital.net>
References: <cover.1402620737.git.luto@amacapital.net>
In-Reply-To: <cover.1402620737.git.luto@amacapital.net>
References: <cover.1402620737.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vdso2c.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/vdso/vdso2c.c b/arch/x86/vdso/vdso2c.c
index 450ac6e..7a6bf50 100644
--- a/arch/x86/vdso/vdso2c.c
+++ b/arch/x86/vdso/vdso2c.c
@@ -54,7 +54,7 @@ static void fail(const char *format, ...)
 }
 
 /*
- * Evil macros to do a little-endian read.
+ * Evil macros for little-endian reads and writes
  */
 #define GLE(x, bits, ifnot)						\
 	__builtin_choose_expr(						\
@@ -62,11 +62,24 @@ static void fail(const char *format, ...)
 		(__typeof__(*(x)))get_unaligned_le##bits(x), ifnot)
 
 extern void bad_get_le(void);
-#define LAST_LE(x)							\
+#define LAST_GLE(x)							\
 	__builtin_choose_expr(sizeof(*(x)) == 1, *(x), bad_get_le())
 
 #define GET_LE(x)							\
-	GLE(x, 64, GLE(x, 32, GLE(x, 16, LAST_LE(x))))
+	GLE(x, 64, GLE(x, 32, GLE(x, 16, LAST_GLE(x))))
+
+#define PLE(x, val, bits, ifnot)					\
+	__builtin_choose_expr(						\
+		(sizeof(*(x)) == bits/8),				\
+		put_unaligned_le##bits((val), (x)), ifnot)
+
+extern void bad_put_le(void);
+#define LAST_PLE(x, val)						\
+	__builtin_choose_expr(sizeof(*(x)) == 1, *(x) = (val), bad_put_le())
+
+#define PUT_LE(x, val)					\
+	PLE(x, val, 64, PLE(x, val, 32, PLE(x, val, 16, LAST_PLE(x, val))))
+
 
 #define NSYMS (sizeof(required_syms) / sizeof(required_syms[0]))
 
-- 
1.9.3

