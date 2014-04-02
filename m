Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030646AbaDBWKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:10:47 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:51294 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932763AbaDBWKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:10:46 -0400
From: Rabin Vincent <rabin@rab.in>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>
Subject: [PATCH] arm: ftrace: work with CONFIG_DEBUG_SET_MODULE_RONX
Date: Thu,  3 Apr 2014 00:10:19 +0200
Message-Id: <1396476619-15386-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make ftrace work with CONFIG_DEBUG_SET_MODULE_RONX by making module text
writable around the place where ftrace does its work, like it is done on
x86 in the patch which introduced CONFIG_DEBUG_SET_MODULE_RONX,
84e1c6bb38eb ("x86: Add RO/NX protection for loadable kernel modules").

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/kernel/ftrace.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 34e5664..70ce654 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -14,6 +14,7 @@
 
 #include <linux/ftrace.h>
 #include <linux/uaccess.h>
+#include <linux/module.h>
 
 #include <asm/cacheflush.h>
 #include <asm/opcodes.h>
@@ -63,6 +64,18 @@ static unsigned long adjust_address(struct dyn_ftrace *rec, unsigned long addr)
 }
 #endif
 
+int ftrace_arch_code_modify_prepare(void)
+{
+	set_all_modules_text_rw();
+	return 0;
+}
+
+int ftrace_arch_code_modify_post_process(void)
+{
+	set_all_modules_text_ro();
+	return 0;
+}
+
 static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
 {
 	return arm_gen_branch_link(pc, addr);
-- 
1.9.1

