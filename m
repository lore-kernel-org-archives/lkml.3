Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965788AbaFQVqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:46:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53794 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965720AbaFQVqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:46:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 054/212] net: avoid dependency of net_get_random_once on nop patching
Date: Tue, 17 Jun 2014 14:42:28 -0700
Message-Id: <1403041506-13646-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 3d4405226d27b3a215e4d03cfa51f536244e5de7 ]

net_get_random_once depends on the static keys infrastructure to patch up
the branch to the slow path during boot. This was realized by abusing the
static keys api and defining a new initializer to not enable the call
site while still indicating that the branch point should get patched
up. This was needed to have the fast path considered likely by gcc.

The static key initialization during boot up normally walks through all
the registered keys and either patches in ideal nops or enables the jump
site but omitted that step on x86 if ideal nops where already placed at
static_key branch points. Thus net_get_random_once branches not always
became active.

This patch switches net_get_random_once to the ordinary static_key
api and thus places the kernel fast path in the - by gcc considered -
unlikely path.  Microbenchmarks on Intel and AMD x86-64 showed that
the unlikely path actually beats the likely path in terms of cycle cost
and that different nop patterns did not make much difference, thus this
switch should not be noticeable.

Fixes: a48e42920ff38b ("net: introduce new macro net_get_random_once")
Reported-by: Tuomas Räsänen <tuomasjjrasanen@tjjr.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/net.h | 15 ++++-----------
 net/core/utils.c    |  8 ++++----
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 69be3e6..4b425b3 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -251,24 +251,17 @@ do {								\
 bool __net_get_random_once(void *buf, int nbytes, bool *done,
 			   struct static_key *done_key);
 
-#ifdef HAVE_JUMP_LABEL
-#define ___NET_RANDOM_STATIC_KEY_INIT ((struct static_key) \
-		{ .enabled = ATOMIC_INIT(0), .entries = (void *)1 })
-#else /* !HAVE_JUMP_LABEL */
-#define ___NET_RANDOM_STATIC_KEY_INIT STATIC_KEY_INIT_FALSE
-#endif /* HAVE_JUMP_LABEL */
-
 #define net_get_random_once(buf, nbytes)				\
 	({								\
 		bool ___ret = false;					\
 		static bool ___done = false;				\
-		static struct static_key ___done_key =			\
-			___NET_RANDOM_STATIC_KEY_INIT;			\
-		if (!static_key_true(&___done_key))			\
+		static struct static_key ___once_key =			\
+			STATIC_KEY_INIT_TRUE;				\
+		if (static_key_true(&___once_key))			\
 			___ret = __net_get_random_once(buf,		\
 						       nbytes,		\
 						       &___done,	\
-						       &___done_key);	\
+						       &___once_key);	\
 		___ret;							\
 	})
 
diff --git a/net/core/utils.c b/net/core/utils.c
index 2f737bf..eed3433 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -348,8 +348,8 @@ static void __net_random_once_deferred(struct work_struct *w)
 {
 	struct __net_random_once_work *work =
 		container_of(w, struct __net_random_once_work, work);
-	if (!static_key_enabled(work->key))
-		static_key_slow_inc(work->key);
+	BUG_ON(!static_key_enabled(work->key));
+	static_key_slow_dec(work->key);
 	kfree(work);
 }
 
@@ -367,7 +367,7 @@ static void __net_random_once_disable_jump(struct static_key *key)
 }
 
 bool __net_get_random_once(void *buf, int nbytes, bool *done,
-			   struct static_key *done_key)
+			   struct static_key *once_key)
 {
 	static DEFINE_SPINLOCK(lock);
 	unsigned long flags;
@@ -382,7 +382,7 @@ bool __net_get_random_once(void *buf, int nbytes, bool *done,
 	*done = true;
 	spin_unlock_irqrestore(&lock, flags);
 
-	__net_random_once_disable_jump(done_key);
+	__net_random_once_disable_jump(once_key);
 
 	return true;
 }
-- 
1.9.1

