Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbaEFPI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:08:58 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:40452 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbaEFPI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:08:57 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: linux-kernel <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Streetman <ddstreet@ieee.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] Documentation: expand/clarify debug documentation
Date: Tue,  6 May 2014 11:08:19 -0400
Message-Id: <1399388899-17476-1-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <CALZtONAVTQuOF3ddZ6jVZqCGgKBicAtT=_w5w4GEueYAsf3jtw@mail.gmail.com>
References: <CALZtONAVTQuOF3ddZ6jVZqCGgKBicAtT=_w5w4GEueYAsf3jtw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pr_debug() and related debug print macros all differ from the
normal pr_XXX() macros, in that the normal ones print unconditionally,
while the debug macros are compiled out unless DEBUG is defined or
CONFIG_DYNAMIC_DEBUG is set.  This isn't obvious, and the only way
to find this out is either to review the actual printk.h code or
to read CodingStyle, and the message there doesn't highlight the
fact.

Change Documentation/CodingStyle to clearly indicate that pr_debug()
and related debug printing macros behave differently than all other
pr_XXX() macros, and attempt to clarify when and where the different
debug printing methods might be used.

Add short comment to printk.h above the pr_XXX() macros indicating
that while these macros print unconditionally, pr_debug() does not.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
---
 Documentation/CodingStyle | 25 ++++++++++++++++++-------
 include/linux/printk.h    |  6 ++++++
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 7fe0546..f9ae2c8 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -660,15 +660,23 @@ There are a number of driver model diagnostic macros in <linux/device.h>
 which you should use to make sure messages are matched to the right device
 and driver, and are tagged with the right level:  dev_err(), dev_warn(),
 dev_info(), and so forth.  For messages that aren't associated with a
-particular device, <linux/printk.h> defines pr_debug() and pr_info().
+particular device, <linux/printk.h> defines pr_notice(), pr_info(),
+pr_warn(), pr_err(), etc.
 
 Coming up with good debugging messages can be quite a challenge; and once
-you have them, they can be a huge help for remote troubleshooting.  Such
-messages should be compiled out when the DEBUG symbol is not defined (that
-is, by default they are not included).  When you use dev_dbg() or pr_debug(),
-that's automatic.  Many subsystems have Kconfig options to turn on -DDEBUG.
-A related convention uses VERBOSE_DEBUG to add dev_vdbg() messages to the
-ones already enabled by DEBUG.
+you have them, they can be a huge help for remote troubleshooting.  However
+debug message printing is handled differently than printing other non-debug
+messages.  While the other pr_XXX() functions print unconditionally,
+pr_debug() does not; it is compiled out by default, unless either DEBUG is
+defined or CONFIG_DYNAMIC_DEBUG is set.  That is true for dev_dbg() also,
+and a related convention uses VERBOSE_DEBUG to add dev_vdbg() messages to
+the ones already enabled by DEBUG.
+
+Many subsystems have Kconfig debug options to turn on -DDEBUG in the
+corresponding Makefile; in other cases specific files #define DEBUG.  And
+when a debug message should be unconditionally printed, such as if it is
+already inside a debug-related #ifdef secton, printk(KERN_DEBUG ...) can be
+used.
 
 
 		Chapter 14: Allocating memory
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 8752f75..88b1f3a 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -210,6 +210,12 @@ extern asmlinkage void dump_stack(void) __cold;
 #define pr_fmt(fmt) fmt
 #endif
 
+/*
+ * These can be used to print at the various log levels.
+ * All of these will print unconditionally, although note that pr_debug()
+ * and other debug macros are compiled out unless either DEBUG is defined
+ * or CONFIG_DYNAMIC_DEBUG is set.
+ */
 #define pr_emerg(fmt, ...) \
 	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_alert(fmt, ...) \
-- 
1.8.3.1

