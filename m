Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954AbaE2FJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:09:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726AbaE2Efs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Tuomas=20R=E4s=E4nen?= <tuomasjjrasanen@tjjr.fi>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 126/140] net: avoid dependency of net_get_random_once on nop patching
Date: Wed, 28 May 2014 21:34:25 -0700
Message-Id: <20140529043105.558328168@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/net.h |   15 ++++-----------
 net/core/utils.c    |    8 ++++----
 2 files changed, 8 insertions(+), 15 deletions(-)

--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -248,24 +248,17 @@ do {								\
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
 
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -348,8 +348,8 @@ static void __net_random_once_deferred(s
 {
 	struct __net_random_once_work *work =
 		container_of(w, struct __net_random_once_work, work);
-	if (!static_key_enabled(work->key))
-		static_key_slow_inc(work->key);
+	BUG_ON(!static_key_enabled(work->key));
+	static_key_slow_dec(work->key);
 	kfree(work);
 }
 
@@ -367,7 +367,7 @@ static void __net_random_once_disable_ju
 }
 
 bool __net_get_random_once(void *buf, int nbytes, bool *done,
-			   struct static_key *done_key)
+			   struct static_key *once_key)
 {
 	static DEFINE_SPINLOCK(lock);
 	unsigned long flags;
@@ -382,7 +382,7 @@ bool __net_get_random_once(void *buf, in
 	*done = true;
 	spin_unlock_irqrestore(&lock, flags);
 
-	__net_random_once_disable_jump(done_key);
+	__net_random_once_disable_jump(once_key);
 
 	return true;
 }


