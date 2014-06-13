Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaFMC2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 22:28:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42306 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaFMC2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 22:28:21 -0400
Date: Thu, 12 Jun 2014 19:28:10 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-b4b31f6101433e4b8ee73779b69b935af07682f8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <3d9b27e92745b27b6fda1b9a98f70dc9c1246c7a.1402620737.git.luto@amacapital.net>
References: <3d9b27e92745b27b6fda1b9a98f70dc9c1246c7a.1402620737.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86/vdso: Add PUT_LE to store little-endian values
Git-Commit-ID: b4b31f6101433e4b8ee73779b69b935af07682f8
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

Commit-ID:  b4b31f6101433e4b8ee73779b69b935af07682f8
Gitweb:     http://git.kernel.org/tip/b4b31f6101433e4b8ee73779b69b935af07682f8
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Thu, 12 Jun 2014 17:53:11 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 12 Jun 2014 19:01:51 -0700

x86/vdso: Add PUT_LE to store little-endian values

Add PUT_LE() by analogy with GET_LE() to write littleendian values in
addition to reading them.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/3d9b27e92745b27b6fda1b9a98f70dc9c1246c7a.1402620737.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
 
