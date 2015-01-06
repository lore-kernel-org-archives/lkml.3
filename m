Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbbAFKUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:20:35 -0500
Received: from ozlabs.org ([103.22.144.67]:54707 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011AbbAFKUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:20:32 -0500
From: Anton Blanchard <anton@samba.org>
To: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au,
        mmarek@suse.cz, akpm@linux-foundation.org, jbaron@akamai.com,
        peterz@infradead.org, liuj97@gmail.com, mingo@kernel.org,
        mgorman@suse.de
Cc: linuxppc-dev@lists.ozlabs.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] jump_label: Allow jump labels to be used in assembly
Date: Tue,  6 Jan 2015 21:20:27 +1100
Message-Id: <1420539628-17875-1-git-send-email-anton@samba.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To use jump labels in assembly we need the HAVE_JUMP_LABEL define,
so we select a fallback version if the toolchain does not support
them.

Modify linux/jump_label.h so it can be included by assembly files.
We also need to add -DCC_HAVE_ASM_GOTO to KBUILD_AFLAGS.

Signed-off-by: Anton Blanchard <anton@samba.org>
---
 Makefile                   |  1 +
 include/linux/jump_label.h | 21 +++++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index ef748e1..7b83c3f 100644
--- a/Makefile
+++ b/Makefile
@@ -774,6 +774,7 @@ KBUILD_ARFLAGS := $(call ar-option,D)
 # check for 'asm goto'
 ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
 	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
+	KBUILD_AFLAGS += -DCC_HAVE_ASM_GOTO
 endif
 
 include $(srctree)/scripts/Makefile.extrawarn
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 98f923b6..f4de473 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -45,6 +45,12 @@
  * same as using STATIC_KEY_INIT_FALSE.
  */
 
+#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+# define HAVE_JUMP_LABEL
+#endif
+
+#ifndef __ASSEMBLY__
+
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/bug.h>
@@ -55,7 +61,7 @@ extern bool static_key_initialized;
 				    "%s used before call to jump_label_init", \
 				    __func__)
 
-#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+#ifdef HAVE_JUMP_LABEL
 
 struct static_key {
 	atomic_t enabled;
@@ -66,13 +72,18 @@ struct static_key {
 #endif
 };
 
-# include <asm/jump_label.h>
-# define HAVE_JUMP_LABEL
 #else
 struct static_key {
 	atomic_t enabled;
 };
-#endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
+#endif	/* HAVE_JUMP_LABEL */
+#endif /* __ASSEMBLY__ */
+
+#ifdef HAVE_JUMP_LABEL
+#include <asm/jump_label.h>
+#endif
+
+#ifndef __ASSEMBLY__
 
 enum jump_label_type {
 	JUMP_LABEL_DISABLE = 0,
@@ -203,3 +214,5 @@ static inline bool static_key_enabled(struct static_key *key)
 }
 
 #endif	/* _LINUX_JUMP_LABEL_H */
+
+#endif /* __ASSEMBLY__ */
-- 
2.1.0

