Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab3LVPbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 10:31:25 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53207 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764Ab3LVPbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 10:31:23 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Andrew Jones <drjones@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v7 7/7] jump_label: use defined macros instead of hard-coding for better readability
Date: Sun, 22 Dec 2013 23:25:43 +0800
Message-Id: <1387725944-810-8-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387725944-810-1-git-send-email-liuj97@gmail.com>
References: <1387725944-810-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use macro JUMP_LABEL_TRUE_BRANCH instead of hard-coding for better
readability.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 include/linux/jump_label.h | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 3999977..5c1dfb2 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -81,18 +81,21 @@ struct module;
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
@@ -122,10 +125,12 @@ extern void static_key_slow_inc(struct static_key *key);
 extern void static_key_slow_dec(struct static_key *key);
 extern void jump_label_apply_nops(struct module *mod);
 
-#define STATIC_KEY_INIT_TRUE ((struct static_key) \
-	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1 })
-#define STATIC_KEY_INIT_FALSE ((struct static_key) \
-	{ .enabled = ATOMIC_INIT(0), .entries = (void *)0 })
+#define STATIC_KEY_INIT_TRUE ((struct static_key)		\
+	{ .enabled = ATOMIC_INIT(1),				\
+	  .entries = (void *)JUMP_LABEL_TYPE_TRUE_BRANCH })
+#define STATIC_KEY_INIT_FALSE ((struct static_key)		\
+	{ .enabled = ATOMIC_INIT(0),				\
+	  .entries = (void *)JUMP_LABEL_TYPE_FALSE_BRANCH })
 
 #else  /* !HAVE_JUMP_LABEL */
 
-- 
1.8.1.2

