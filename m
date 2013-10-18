Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab3JRP1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:27:24 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54132 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab3JRP1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:27:22 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>, Andrew Jones <drjones@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v5 7/7] jump_label: use defined macros instead of hard-coding for better readability
Date: Fri, 18 Oct 2013 23:20:01 +0800
Message-Id: <1382109602-27432-8-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382109602-27432-1-git-send-email-liuj97@gmail.com>
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use macro JUMP_LABEL_TRUE_BRANCH instead of hard-coding for better
readability.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 include/linux/jump_label.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index a507907..6e54029 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -74,18 +74,21 @@ struct module;
 #include <linux/atomic.h>
 #ifdef HAVE_JUMP_LABEL
 
-#define JUMP_LABEL_TRUE_BRANCH 1UL
+#define JUMP_LABEL_TYPE_FALSE_BRANCH	0UL
+#define JUMP_LABEL_TYPE_TRUE_BRANCH	1UL
+#define JUMP_LABEL_TYPE_MASK		1UL
 
 static
 inline struct jump_entry *jump_label_get_entries(struct static_key *key)
 {
 	return (struct jump_entry *)((unsigned long)key->entries
-						& ~JUMP_LABEL_TRUE_BRANCH);
+						& ~JUMP_LABEL_TYPE_MASK);
 }
 
 static inline bool jump_label_get_branch_default(struct static_key *key)
 {
-	if ((unsigned long)key->entries & JUMP_LABEL_TRUE_BRANCH)
+	if (((unsigned long)key->entries & JUMP_LABEL_TYPE_MASK) ==
+	    JUMP_LABEL_TYPE_TRUE_BRANCH)
 		return true;
 	return false;
 }
@@ -116,9 +119,11 @@ extern void static_key_slow_dec(struct static_key *key);
 extern void jump_label_apply_nops(struct module *mod);
 
 #define STATIC_KEY_INIT_TRUE ((struct static_key) \
-	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1 })
+	{ .enabled = ATOMIC_INIT(1), \
+	  .entries = (void *)JUMP_LABEL_TYPE_TRUE_BRANCH })
 #define STATIC_KEY_INIT_FALSE ((struct static_key) \
-	{ .enabled = ATOMIC_INIT(0), .entries = (void *)0 })
+	{ .enabled = ATOMIC_INIT(0), \
+	  .entries = (void *)JUMP_LABEL_TYPE_FALSE_BRANCH })
 
 #else  /* !HAVE_JUMP_LABEL */
 
-- 
1.8.1.2

