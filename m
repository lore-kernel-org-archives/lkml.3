Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbaEEMnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:43:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:40971 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932184AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 08/50] printk: pr_debug_ratelimited: check state first to reduce "callbacks suppressed" messages
Date: Mon,  5 May 2014 14:42:50 +0200
Message-Id: <ec44c106c1641a532faaed93a7d26d4b3e90cc25.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 29fc2bc75393864bbc9b90a7a13a0d0e11c6f41e upstream.

pr_debug_ratelimited should be coded similarly to dev_dbg_ratelimited
to reduce the "callbacks suppressed" messages.

Add #include <linux/dynamic_debug.h> to printk.h. Unfortunately, this
new #include must be after the prototype/declaration of function printk.

It may be better to split out these _ratelimited declarations into
a separate file one day.

Any use of these pr_<foo>_ratelimited functions must also have another
specific #include <ratelimited.h>.  Most users have this done indirectly
via #include <linux/kernel.h>

printk.h may not #include <linux/ratelimit.h> as it causes circular
dependencies and compilation failures.

Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Krzysztof Mazur <krzysiek@podlesie.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/printk.h | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index e6131a782481..694925837a16 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -233,6 +233,8 @@ extern asmlinkage void dump_stack(void) __cold;
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
+#include <linux/dynamic_debug.h>
+
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(CONFIG_DYNAMIC_DEBUG)
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
@@ -343,7 +345,19 @@ extern asmlinkage void dump_stack(void) __cold;
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
-#if defined(DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG)
+/* descriptor check is first to prevent flooding with "callbacks suppressed" */
+#define pr_debug_ratelimited(fmt, ...)					\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT) &&	\
+	    __ratelimit(&_rs))						\
+		__dynamic_pr_debug(&descriptor, fmt, ##__VA_ARGS__);	\
+} while (0)
+#elif defined(DEBUG)
 #define pr_debug_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
-- 
1.9.2

