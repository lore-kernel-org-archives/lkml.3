Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3DQE3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 00:29:06 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:29179 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab3DQE2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 00:28:42 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v3 4/5] mutex: Remove new typedefs introduced in patch 2
Date: Wed, 17 Apr 2013 00:28:10 -0400
Message-Id: <1366172891-7729-5-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366172891-7729-1-git-send-email-Waiman.Long@hp.com>
References: <1366172891-7729-1-git-send-email-Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In response to the review comment from Davidlohr, this patch will
remove the new typedefs introduced by patch 2. It also removes an
unnecessary barrier() call.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/mutex.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 5600bdf..140f113 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -113,18 +113,16 @@ EXPORT_SYMBOL(mutex_lock);
  * We don't inline mspin_lock() so that perf can correctly account for the
  * time spent in this lock function.
  */
-typedef struct mspin_node {
-	struct mspin_node *next;
-	int		   locked;	/* 1 if lock acquired */
-} mspin_node_t;
-
-typedef mspin_node_t	*mspin_lock_t;
-
-#define	MLOCK(mutex)	((mspin_lock_t *)&((mutex)->spin_mlock))
-
-static noinline void mspin_lock(mspin_lock_t *lock,  mspin_node_t *node)
+struct mspin_node {
+	struct mspin_node *next ;
+	int		  locked;	/* 1 if lock acquired */
+};
+#define	MLOCK(mutex)	((struct mspin_node **)&((mutex)->spin_mlock))
+
+static noinline
+void mspin_lock(struct mspin_node **lock, struct mspin_node *node)
 {
-	mspin_node_t *prev;
+	struct mspin_node *prev;
 
 	/* Init node */
 	node->locked = 0;
@@ -143,9 +141,9 @@ static noinline void mspin_lock(mspin_lock_t *lock,  mspin_node_t *node)
 		arch_mutex_cpu_relax();
 }
 
-static void mspin_unlock(mspin_lock_t *lock,  mspin_node_t *node)
+static void mspin_unlock(struct mspin_node **lock, struct mspin_node *node)
 {
-	mspin_node_t *next = ACCESS_ONCE(node->next);
+	struct mspin_node *next = ACCESS_ONCE(node->next);
 
 	if (likely(!next)) {
 		/*
@@ -157,7 +155,6 @@ static void mspin_unlock(mspin_lock_t *lock,  mspin_node_t *node)
 		while (!(next = ACCESS_ONCE(node->next)))
 			arch_mutex_cpu_relax();
 	}
-	barrier();
 	ACCESS_ONCE(next->locked) = 1;
 	smp_wmb();
 }
@@ -237,7 +234,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 	for (;;) {
 		struct task_struct *owner;
-		mspin_node_t	    node;
+		struct mspin_node  node;
 
 		/*
 		 * If there's an owner, wait for it to either
-- 
1.7.1

