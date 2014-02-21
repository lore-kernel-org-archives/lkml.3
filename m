Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaBUEaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 23:30:20 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43295 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbaBUEaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 23:30:17 -0500
From: behanw@converseincode.com
To: rob@landley.net, paul.gortmaker@windriver.com, rdunlap@infradead.org,
        geert@linux-m68k.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] module: LLVMLinux: Fix section mismatch issues on alias usage
Date: Thu, 20 Feb 2014 20:28:29 -0800
Message-Id: <1392956909-22715-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

Attribute aliases don't inherit the link section name when compiled with clang.
As a result, the linking section needs to be explicitly specified when building
a module. This behavior is undefined in the standard which is why it differs from
compiler to compiler.

Author:  PaX Team <pageexec@freemail.hu>
ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
URL:     http://llvm.linuxfoundation.org
Merge:   Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 include/linux/init.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index e168880..384ec5e 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -297,13 +297,14 @@ void __init parse_early_options(char *cmdline);
 #define module_init(initfn)					\
 	static inline initcall_t __inittest(void)		\
 	{ return initfn; }					\
-	int init_module(void) __attribute__((alias(#initfn)));
+	int init_module(void) __section(.init) __attribute__((alias(#initfn)));
 
 /* This is only required if you want to be unloadable. */
 #define module_exit(exitfn)					\
 	static inline exitcall_t __exittest(void)		\
 	{ return exitfn; }					\
-	void cleanup_module(void) __attribute__((alias(#exitfn)));
+	void cleanup_module(void) __section(.exit)              \
+		__attribute__((alias(#exitfn)));
 
 #define __setup_param(str, unique_id, fn)	/* nothing */
 #define __setup(str, func) 			/* nothing */
-- 
1.8.3.2

