Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161353Ab3DGCgN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 22:36:13 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:65154 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161269Ab3DGCgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 22:36:10 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 1/3] compat: redefine core_initcall() and late_initcall()
Date: Sat,  6 Apr 2013 19:35:36 -0700
Message-Id: <1365302138-19736-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365302138-19736-1-git-send-email-mcgrof@do-not-panic.com>
References: <1365302138-19736-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

It is questionable if we'd want to backport calls declared
through late_initcall() or core_initcall() on the kernel
but if this ends up being desired the current of copying
kernel code requires either patching or redefining these
symbols to make them build.

To avoid having to maintain patches for these components
and having to delcare these routines on header files through
compat manually use these init macros to help us define
symbols we *can* use on the compat module init.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 backport/include/linux/compat-2.6.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/backport/include/linux/compat-2.6.h b/backport/include/linux/compat-2.6.h
index 57a1c13..109afd4 100644
--- a/backport/include/linux/compat-2.6.h
+++ b/backport/include/linux/compat-2.6.h
@@ -18,6 +18,21 @@
 #include <linux/init.h>
 #include <linux/uidgid.h>
 
+#define backport_init_sym(fn) extern void backport_##fn(void);
+#define backport_init_call(fn) backport_##fn()
+
+#define backport_initcall(fn)			\
+	void backport_##fn(void)		\
+	{					\
+		fn();				\
+	}
+
+#undef core_initcall
+#undef late_initcall
+
+#define core_initcall	backport_initcall
+#define late_initcall	backport_initcall
+
 /*
  * The define overwriting module_init is based on the original module_init
  * which looks like this:
-- 
1.7.10.4

