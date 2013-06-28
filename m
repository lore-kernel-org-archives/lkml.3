Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab3F1Wap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 18:30:45 -0400
Received: from prod-mail-xrelay01.akamai.com ([72.246.2.12]:15041 "EHLO
	prod-mail-xrelay01.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752975Ab3F1Wao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 18:30:44 -0400
To: rostedt@goodmis.org, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org
Message-Id: <d0bf4b2675cde8fed2892975a757bbfe5ecc25ec.1372457176.git.jbaron@akamai.com>
In-Reply-To: <cover.1372457176.git.jbaron@akamai.com>
References: <cover.1372457176.git.jbaron@akamai.com>
Subject: [PATCH 2/3] sched: fix static keys race in sched_feat
Date: Fri, 28 Jun 2013 22:30:43 +0000 (GMT)
From: jbaron@akamai.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Andi Kleen, thue usage of static keys can be racy in
sched_feat_disable vs. sched_feat_enable(). Currently, we first check the
value of keys->enabled, and subsequently update the branch direction. This,
can be racy and can potentially leave the keys in an inconsistent state.

Fix the race by using static_key_slow_set_true()/false(), which does the the
check and set using the jump_label_mutex.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 kernel/sched/core.c  |   12 +++++-------
 kernel/sched/sched.h |   10 +++++-----
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e8b3350..2ebf82e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -165,13 +165,13 @@ static int sched_feat_show(struct seq_file *m, void *v)
 
 #ifdef HAVE_JUMP_LABEL
 
-#define jump_label_key__true  STATIC_KEY_INIT_TRUE
-#define jump_label_key__false STATIC_KEY_INIT_FALSE
+#define jump_label_key__true  STATIC_KEY_BOOLEAN_INIT_TRUE
+#define jump_label_key__false STATIC_KEY_BOOLEAN_INIT_FALSE
 
 #define SCHED_FEAT(name, enabled)	\
 	jump_label_key__##enabled ,
 
-struct static_key sched_feat_keys[__SCHED_FEAT_NR] = {
+struct static_key_boolean sched_feat_keys[__SCHED_FEAT_NR] = {
 #include "features.h"
 };
 
@@ -179,14 +179,12 @@ struct static_key sched_feat_keys[__SCHED_FEAT_NR] = {
 
 static void sched_feat_disable(int i)
 {
-	if (static_key_enabled(&sched_feat_keys[i]))
-		static_key_slow_dec(&sched_feat_keys[i]);
+	static_key_slow_set_false(&sched_feat_keys[i]);
 }
 
 static void sched_feat_enable(int i)
 {
-	if (!static_key_enabled(&sched_feat_keys[i]))
-		static_key_slow_inc(&sched_feat_keys[i]);
+	static_key_slow_set_true(&sched_feat_keys[i]);
 }
 #else
 static void sched_feat_disable(int i) { };
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ce39224..88712dc 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -742,17 +742,17 @@ static __always_inline bool static_branch__false(struct static_key *key)
 	return static_key_false(key); /* Out of line branch. */
 }
 
-#define SCHED_FEAT(name, enabled)					\
-static __always_inline bool static_branch_##name(struct static_key *key) \
-{									\
-	return static_branch__##enabled(key);				\
+#define SCHED_FEAT(name, enabled)						     \
+static __always_inline bool static_branch_##name(struct static_key_boolean *bool_key)\
+{										     \
+	return static_branch__##enabled(&bool_key->key);			     \
 }
 
 #include "features.h"
 
 #undef SCHED_FEAT
 
-extern struct static_key sched_feat_keys[__SCHED_FEAT_NR];
+extern struct static_key_boolean sched_feat_keys[__SCHED_FEAT_NR];
 #define sched_feat(x) (static_branch_##x(&sched_feat_keys[__SCHED_FEAT_##x]))
 #else /* !(SCHED_DEBUG && HAVE_JUMP_LABEL) */
 #define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
-- 
1.7.9.5

