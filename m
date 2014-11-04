Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaKDIsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:48:40 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58470 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbaKDInR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:43:17 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v1 02/11] backports: extend module_init() module_exit() for built-in
Date: Tue,  4 Nov 2014 00:42:53 -0800
Message-Id: <1415090582-14129-3-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

When backports is used we want to identify the provenance
of the code used to generate the backport. We do this by
simply requiring all used drivers to at leats check in
with the backports  module which identifies the backport.

We had this in place for modules but not for built-in, add
the respective set of helpers for it.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 backport/backport-include/linux/module.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/backport/backport-include/linux/module.h b/backport/backport-include/linux/module.h
index 82c96bd..8942c5b 100644
--- a/backport/backport-include/linux/module.h
+++ b/backport/backport-include/linux/module.h
@@ -25,6 +25,30 @@ extern void backport_dependency_symbol(void);
 		       " using backports " BACKPORTS_VERSION);
 #endif
 
+#ifndef MODULE
+/*
+ * Forcing the backports module to load allows us to easily
+ * identify the backport.
+ */
+#undef module_init
+#define module_init(fn)							\
+	static int __init __init_backport_##fn(void)			\
+	{								\
+		backport_dependency_symbol();				\
+		return fn();						\
+	}								\
+	__initcall(__init_backport_##fn);
+
+#undef module_exit
+#define module_exit(fn)							\
+	static void __exit __exit_backport_##fn(void)			\
+	{								\
+		fn();							\
+		rcu_barrier();						\
+	}								\
+	__exitcall(__exit_backport_##fn);
+
+#else
 #undef module_init
 #define module_init(initfn)						\
 	static int __init __init_backport(void)				\
@@ -58,6 +82,7 @@ extern void backport_dependency_symbol(void);
 		rcu_barrier();						\
 	}								\
 	void cleanup_module(void) __attribute__((alias("__exit_compat")));
+#endif
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)
 #undef param_check_bool
-- 
2.1.1

