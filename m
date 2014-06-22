Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129AbaFVWrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 18:47:22 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48533 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaFVWrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 18:47:16 -0400
From: Mathias Krause <minipli@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Joe Perches <joe@perches.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
        Mathias Krause <minipli@googlemail.com>
Subject: [RFC PATCH 1/3] init.h: Add __init_str / __exit_str macros
Date: Mon, 23 Jun 2014 00:46:47 +0200
Message-Id: <1403477209-14612-2-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add macros to be able to mark string literals used in __init / __exit
functions.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 include/linux/init.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/init.h b/include/linux/init.h
index 2df8e8dd10..0a425b296e 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -35,6 +35,18 @@
  * Don't forget to initialize data not at file scope, i.e. within a function,
  * as gcc otherwise puts the data into the bss section and not into the init
  * section.
+ *
+ * For messages printed in __init / __exit functions the __init_str() /
+ * __exit_str() macros will take care of marking the strings accordingly so
+ * they can be freed, too. Otherwise the strings would resist in memory, even
+ * though they are no longer referenced.
+ *
+ * Use them like this:
+ *
+ * static void __init initme(void)
+ * {
+ *    printk(__init_str(KERN_INFO "I am fully initialized, now\n"));
+ * }
  */
 
 /* These are for everybody (although not all archs will actually
@@ -45,6 +57,12 @@
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

