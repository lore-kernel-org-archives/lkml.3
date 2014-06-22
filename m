Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaFVWrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 18:47:32 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:47926 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaFVWrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 18:47:17 -0400
From: Mathias Krause <minipli@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Joe Perches <joe@perches.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
        Mathias Krause <minipli@googlemail.com>
Subject: [RFC PATCH 2/3] printk: Provide pi_<level> / pe_<level> macros for __init / __exit code
Date: Mon, 23 Jun 2014 00:46:48 +0200
Message-Id: <1403477209-14612-3-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
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

One remark, though: We cannot provide appropriate p[ie]_debug() macros
for the CONFIG_DYNAMIC_DEBUG case as there is (currently) no way to
remove entries from dyndbg after initialization. But supporting that
scenario would require more work (and code), therefore not necessarily
justifying the memory savings.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 include/linux/printk.h |   52 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 319ff7e53e..b49dd6dbc1 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -226,6 +226,8 @@ extern asmlinkage void dump_stack(void) __cold;
  * All of these will print unconditionally, although note that pr_debug()
  * and other debug macros are compiled out unless either DEBUG is defined
  * or CONFIG_DYNAMIC_DEBUG is set.
+ * The pi_*() and pe_*() variants are provided for usage in __init / __exit
+ * code.
  */
 #define pr_emerg(fmt, ...) \
 	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
@@ -245,13 +247,55 @@ extern asmlinkage void dump_stack(void) __cold;
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
+#define pi_emerg(fmt, ...) \
+	printk(__init_str(KERN_EMERG pr_fmt(fmt)), ##__VA_ARGS__)
+#define pi_alert(fmt, ...) \
+	printk(__init_str(KERN_ALERT pr_fmt(fmt)), ##__VA_ARGS__)
+#define pi_crit(fmt, ...) \
+	printk(__init_str(KERN_CRIT pr_fmt(fmt)), ##__VA_ARGS__)
+#define pi_err(fmt, ...) \
+	printk(__init_str(KERN_ERR pr_fmt(fmt)), ##__VA_ARGS__)
+#define pi_warning(fmt, ...) \
+	printk(__init_str(KERN_WARNING pr_fmt(fmt)), ##__VA_ARGS__)
+#define pi_warn pi_warning
+#define pi_notice(fmt, ...) \
+	printk(__init_str(KERN_NOTICE pr_fmt(fmt)), ##__VA_ARGS__)
+#define pi_info(fmt, ...) \
+	printk(__init_str(KERN_INFO pr_fmt(fmt)), ##__VA_ARGS__)
+#define pi_cont(fmt, ...) \
+	printk(__init_str(KERN_CONT fmt), ##__VA_ARGS__)
+
+#define pe_emerg(fmt, ...) \
+	printk(__exit_str(KERN_EMERG pr_fmt(fmt)), ##__VA_ARGS__)
+#define pe_alert(fmt, ...) \
+	printk(__exit_str(KERN_ALERT pr_fmt(fmt)), ##__VA_ARGS__)
+#define pe_crit(fmt, ...) \
+	printk(__exit_str(KERN_CRIT pr_fmt(fmt)), ##__VA_ARGS__)
+#define pe_err(fmt, ...) \
+	printk(__exit_str(KERN_ERR pr_fmt(fmt)), ##__VA_ARGS__)
+#define pe_warning(fmt, ...) \
+	printk(__exit_str(KERN_WARNING pr_fmt(fmt)), ##__VA_ARGS__)
+#define pe_warn pe_warning
+#define pe_notice(fmt, ...) \
+	printk(__exit_str(KERN_NOTICE pr_fmt(fmt)), ##__VA_ARGS__)
+#define pe_info(fmt, ...) \
+	printk(__exit_str(KERN_INFO pr_fmt(fmt)), ##__VA_ARGS__)
+#define pe_cont(fmt, ...) \
+	printk(__exit_str(KERN_CONT fmt), ##__VA_ARGS__)
+
 /* pr_devel() should produce zero code unless DEBUG is defined */
 #ifdef DEBUG
 #define pr_devel(fmt, ...) \
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pi_devel(fmt, ...) \
+	printk(__init_str(KERN_DEBUG pr_fmt(fmt)), ##__VA_ARGS__)
+#define pe_devel(fmt, ...) \
+	printk(__exit_str(KERN_DEBUG pr_fmt(fmt)), ##__VA_ARGS__)
 #else
 #define pr_devel(fmt, ...) \
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pi_devel pr_devel
+#define pe_devel pr_devel
 #endif
 
 #include <linux/dynamic_debug.h>
@@ -261,12 +305,20 @@ extern asmlinkage void dump_stack(void) __cold;
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
 #define pr_debug(fmt, ...) \
 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
+#define pi_debug pr_debug
+#define pe_debug pr_debug
 #elif defined(DEBUG)
 #define pr_debug(fmt, ...) \
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pi_debug(fmt, ...) \
+	printk(__init_str(KERN_DEBUG pr_fmt(fmt)), ##__VA_ARGS__)
+#define pe_debug(fmt, ...) \
+	printk(__exit_str(KERN_DEBUG pr_fmt(fmt)), ##__VA_ARGS__)
 #else
 #define pr_debug(fmt, ...) \
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pi_debug pr_debug
+#define pe_debug pr_debug
 #endif
 
 /*
-- 
1.7.10.4

