Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaGLOoV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 10:44:21 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:38865 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaGLOoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 10:44:15 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH v2 1/8] init.h: Add __init_str / __exit_str macros
Date: Sat, 12 Jul 2014 16:43:25 +0200
Message-Id: <1405176212-12175-2-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405176212-12175-1-git-send-email-minipli@googlemail.com>
References: <1405176212-12175-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add macros to be able to mark string literals used in __init / __exit
functions.

Signed-off-by: Mathias Krause <minipli@googlemail.com>

---
v2: - use a better code example
---
 include/linux/init.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/init.h b/include/linux/init.h
index 2df8e8dd10..2c1cf10bb7 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -35,6 +35,20 @@
  * Don't forget to initialize data not at file scope, i.e. within a function,
  * as gcc otherwise puts the data into the bss section and not into the init
  * section.
+ *
+ * For strings used in __init / __exit functions the __init_str() /
+ * __exit_str() macros will take care of marking the strings accordingly so
+ * they can be freed, too. Otherwise the strings would resist in memory, even
+ * though they are no longer referenced.
+ *
+ * Use them like this:
+ *
+ * static int __init my_setup(char *arg)
+ * {
+ *    if (!strcmp(arg, __init_str("disable")))
+ *       enabled = false;
+ * }
+ * __setup("mydev=", my_setup);
  */
 
 /* These are for everybody (although not all archs will actually
@@ -45,6 +59,12 @@
 #define __exitdata	__section(.exit.data)
 #define __exit_call	__used __section(.exitcall.exit)
 
+/* Those can be used to mark strings used in __init / __exit functions. */
+#define __init_str(str)	__mark_str(str, __UNIQUE_ID(_init_str_), __initconst)
+#define __exit_str(str)	__mark_str(str, __UNIQUE_ID(_exit_str_), __exitdata)
+#define __mark_str(str, var, __section) \
+	({ static const char var[] __section __aligned(1) = str; var; })
+
 /*
  * Some architecture have tool chains which do not handle rodata attributes
  * correctly. For those disable special sections for const, so that other
-- 
1.7.10.4

