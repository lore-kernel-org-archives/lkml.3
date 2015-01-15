Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbbAOVCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:02:41 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:15752 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047AbbAOVCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:02:38 -0500
To: akpm@linux-foundation.org, famz@redhat.com
Cc: normalperson@yhbt.net, nzimmer@sgi.com, viro@zeniv.linux.org.uk,
        davidel@xmailserver.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-Id: <97b4d4d11870c63c71c8456750a3fa9706c147e0.1421337657.git.jbaron@akamai.com>
In-Reply-To: <cover.1421337657.git.jbaron@akamai.com>
References: <cover.1421337657.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [RFC PATCH 3/5] epoll: add ep_call_nested_nolock()
Date: Thu, 15 Jan 2015 21:02:37 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an ep_call_nested_nolock() variant which functions the same as
the current ep_call_nested(), except it does not acquire any locks. This
call wil be used by subsequent patches which have provide their own
'external' locking.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 fs/eventpoll.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 2864d67..d0a021a 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -373,11 +373,17 @@ static inline int ep_events_available(struct eventpoll *ep)
 	return !list_empty(&ep->rdllist) || ep->ovflist != EP_UNACTIVE_PTR;
 }
 
+#define ep_call_nested(ncalls, max_nests, nproc, priv, cookie, ctx) \
+	_ep_call_nested(ncalls, max_nests, nproc, priv, cookie, ctx, 1)
+
+#define ep_call_nested_nolock(ncalls, max_nests, nproc, priv, cookie, ctx) \
+	_ep_call_nested(ncalls, max_nests, nproc, priv, cookie, ctx, 0)
+
 /**
- * ep_call_nested - Perform a bound (possibly) nested call, by checking
- *                  that the recursion limit is not exceeded, and that
- *                  the same nested call (by the meaning of same cookie) is
- *                  no re-entered.
+ * _ep_call_nested - Perform a bound (possibly) nested call, by checking
+ *                   that the recursion limit is not exceeded, and that
+ *                   the same nested call (by the meaning of same cookie) is
+ *                   no re-entered.
  *
  * @ncalls: Pointer to the nested_calls structure to be used for this call.
  * @max_nests: Maximum number of allowed nesting calls.
@@ -385,21 +391,23 @@ static inline int ep_events_available(struct eventpoll *ep)
  * @priv: Opaque data to be passed to the @nproc callback.
  * @cookie: Cookie to be used to identify this nested call.
  * @ctx: This instance context.
+ * @lock: protected by the lock or not
  *
  * Returns: Returns the code returned by the @nproc callback, or -1 if
  *          the maximum recursion limit has been exceeded.
  */
-static int ep_call_nested(struct nested_calls *ncalls, int max_nests,
+static int _ep_call_nested(struct nested_calls *ncalls, int max_nests,
 			  int (*nproc)(void *, void *, int), void *priv,
-			  void *cookie, void *ctx)
+			  void *cookie, void *ctx, bool lock)
 {
 	int error, call_nests = 0;
-	unsigned long flags;
+	unsigned long flags = 0;
 	struct list_head *lsthead = &ncalls->tasks_call_list;
 	struct nested_call_node *tncur;
 	struct nested_call_node tnode;
 
-	spin_lock_irqsave(&ncalls->lock, flags);
+	if (lock)
+		spin_lock_irqsave(&ncalls->lock, flags);
 
 	/*
 	 * Try to see if the current task is already inside this wakeup call.
@@ -423,16 +431,19 @@ static int ep_call_nested(struct nested_calls *ncalls, int max_nests,
 	tnode.cookie = cookie;
 	list_add(&tnode.llink, lsthead);
 
-	spin_unlock_irqrestore(&ncalls->lock, flags);
+	if (lock)
+		spin_unlock_irqrestore(&ncalls->lock, flags);
 
 	/* Call the nested function */
 	error = (*nproc)(priv, cookie, call_nests);
 
 	/* Remove the current task from the list */
-	spin_lock_irqsave(&ncalls->lock, flags);
+	if (lock)
+		spin_lock_irqsave(&ncalls->lock, flags);
 	list_del(&tnode.llink);
 out_unlock:
-	spin_unlock_irqrestore(&ncalls->lock, flags);
+	if (lock)
+		spin_unlock_irqrestore(&ncalls->lock, flags);
 
 	return error;
 }
-- 
1.8.2.rc2

