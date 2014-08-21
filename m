Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbaHUMXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:23:42 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:34982 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaHUMXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:23:37 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCHv3 2/9] printk: Provide pi_<level> / pe_<level> macros for __init / __exit code
Date: Thu, 21 Aug 2014 14:23:05 +0200
Message-Id: <1408623792-7973-3-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
References: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory used for functions marked with __init will be released after
initialization, albeit static data referenced by such code will not, if
not explicitly marked this way, too. This is especially true for format
strings used in messages printed by such code. Those are not marked and
therefore will survive the __init cleanup -- dangling in memory without
ever being referenced again.

Ideally we would like the compiler to automatically recognise such
constructs but it does not and it's not as simple as it might sound, as
strings used in initialization code might latter still be used, e.g. as
a slab cache name. Therefore we need to explicitly mark the strings we
want to release together with the function itself.

For a seamless integration of the necessary __init_str() / __exit_str()
macros to mark the format strings, this patch provides new variants of
the well known pr_<level>() macros as pi_<level>() for __init code and
pe_<level>() for __exit code. Changing existing code should thereby be
as simple as changing a single letter.

For code that cannot be changed to use the pi_<level>() / pe_<level>()
helpers printk_init() and printk_exit() macros are provided, too.

If users get it wrong, e.g. use printk_init() / pi_<level>() in non-init
code or printk_exit() / pe_<level>() in non-exit code, modpost will
detect the error as a section mismatch and report it accordingly.

One remark, though: We cannot provide appropriate p[ie]_debug() macros
for the CONFIG_DYNAMIC_DEBUG case as there is (currently) no way to
remove entries from dyndbg after initialization. But supporting that
scenario would require more work (and code), therefore not necessarily
justifying the memory savings.

Signed-off-by: Mathias Krause <minipli@googlemail.com>

---
v3: change description to mention modpost error catching
v2: introduce printk_init / printk_exit macros (suggested by Joe)
---
 include/linux/init.h   |    7 ++++--
 include/linux/printk.h |   59 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index 2c1cf10bb7..dc5691b2f3 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -39,14 +39,17 @@
  * For strings used in __init / __exit functions the __init_str() /
  * __exit_str() macros will take care of marking the strings accordingly so
  * they can be freed, too. Otherwise the strings would resist in memory, even
- * though they are no longer referenced.
+ * though they are no longer referenced. They're also used to implement the
+ * printk_init() / printk_exit() macros.
  *
  * Use them like this:
  *
  * static int __init my_setup(char *arg)
  * {
- *    if (!strcmp(arg, __init_str("disable")))
+ *    if (!strcmp(arg, __init_str("disable"))) {
+ *       printk_init("Disabled by commandline\n");
  *       enabled = false;
+ *   }
  * }
  * __setup("mydev=", my_setup);
  */
diff --git a/include/linux/printk.h b/include/linux/printk.h
index d78125f73a..3be8e228db 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -229,6 +229,10 @@ extern asmlinkage void dump_stack(void) __cold;
  * All of these will print unconditionally, although note that pr_debug()
  * and other debug macros are compiled out unless either DEBUG is defined
  * or CONFIG_DYNAMIC_DEBUG is set.
+ *
+ * The printk_init() and pi_<level>() macros shall be used in __init code in
+ * favour of printk() / pr_<level>(). The printk_exit() and pe_<level>()
+ * variants shall be used in __exit code.
  */
 #define pr_emerg(fmt, ...) \
 	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
@@ -248,13 +252,60 @@ extern asmlinkage void dump_stack(void) __cold;
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
+#define printk_init(fmt, ...) \
+	printk(__init_str(fmt), ##__VA_ARGS__)
+#define printk_exit(fmt, ...) \
+	printk(__exit_str(fmt), ##__VA_ARGS__)
+
+#define pi_emerg(fmt, ...) \
+	printk_init(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pi_alert(fmt, ...) \
+	printk_init(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pi_crit(fmt, ...) \
+	printk_init(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pi_err(fmt, ...) \
+	printk_init(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pi_warning(fmt, ...) \
+	printk_init(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pi_warn pi_warning
+#define pi_notice(fmt, ...) \
+	printk_init(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pi_info(fmt, ...) \
+	printk_init(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define pi_cont(fmt, ...) \
+	printk_init(KERN_CONT fmt, ##__VA_ARGS__)
+
+#define pe_emerg(fmt, ...) \
+	printk_exit(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pe_alert(fmt, ...) \
+	printk_exit(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pe_crit(fmt, ...) \
+	printk_exit(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pe_err(fmt, ...) \
+	printk_exit(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pe_warning(fmt, ...) \
+	printk_exit(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pe_warn pe_warning
+#define pe_notice(fmt, ...) \
+	printk_exit(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pe_info(fmt, ...) \
+	printk_exit(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define pe_cont(fmt, ...) \
+	printk_exit(KERN_CONT fmt, ##__VA_ARGS__)
+
 /* pr_devel() should produce zero code unless DEBUG is defined */
 #ifdef DEBUG
 #define pr_devel(fmt, ...) \
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pi_devel(fmt, ...) \
+	printk_init(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pe_devel(fmt, ...) \
+	printk_exit(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
 #define pr_devel(fmt, ...) \
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pi_devel pr_devel
+#define pe_devel pr_devel
 #endif
 
 #include <linux/dynamic_debug.h>
@@ -264,12 +315,20 @@ extern asmlinkage void dump_stack(void) __cold;
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
 #define pr_debug(fmt, ...) \
 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
+#define pi_debug pr_debug
+#define pe_debug pr_debug
 #elif defined(DEBUG)
 #define pr_debug(fmt, ...) \
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pi_debug(fmt, ...) \
+	printk_init(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pe_debug(fmt, ...) \
+	printk_exit(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
 #define pr_debug(fmt, ...) \
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pi_debug pr_debug
+#define pe_debug pr_debug
 #endif
 
 /*
-- 
1.7.10.4

