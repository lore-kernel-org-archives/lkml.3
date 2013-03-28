Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab3C1Goc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:44:32 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63528 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3C1Go3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:44:29 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/14] workqueue: make workqueue->name[] fixed len
Date: Wed, 27 Mar 2013 23:43:32 -0700
Message-Id: <1364453020-2829-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364453020-2829-1-git-send-email-tj@kernel.org>
References: <1364453020-2829-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently workqueue->name[] is of flexible length.  We want to use the
flexible field for something more useful and there isn't much benefit
in allowing arbitrary name length anyway.  Make it fixed len capping
at 24 bytes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 65f200c..23c9099 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -101,6 +101,8 @@ enum {
 	 */
 	RESCUER_NICE_LEVEL	= -20,
 	HIGHPRI_NICE_LEVEL	= -20,
+
+	WQ_NAME_LEN		= 24,
 };
 
 /*
@@ -252,7 +254,7 @@ struct workqueue_struct {
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map	lockdep_map;
 #endif
-	char			name[];		/* I: workqueue name */
+	char			name[WQ_NAME_LEN]; /* I: workqueue name */
 };
 
 static struct kmem_cache *pwq_cache;
@@ -3752,17 +3754,12 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 					       struct lock_class_key *key,
 					       const char *lock_name, ...)
 {
-	va_list args, args1;
+	va_list args;
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;
-	size_t namelen;
-
-	/* determine namelen, allocate wq and format name */
-	va_start(args, lock_name);
-	va_copy(args1, args);
-	namelen = vsnprintf(NULL, 0, fmt, args) + 1;
 
-	wq = kzalloc(sizeof(*wq) + namelen, GFP_KERNEL);
+	/* allocate wq and format name */
+	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
 	if (!wq)
 		return NULL;
 
@@ -3772,9 +3769,9 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 			goto err_free_wq;
 	}
 
-	vsnprintf(wq->name, namelen, fmt, args1);
+	va_start(args, lock_name);
+	vsnprintf(wq->name, sizeof(wq->name), fmt, args);
 	va_end(args);
-	va_end(args1);
 
 	max_active = max_active ?: WQ_DFL_ACTIVE;
 	max_active = wq_clamp_max_active(max_active, flags, wq->name);
-- 
1.8.1.4

