Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbbAFTqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:46:09 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:35480 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbbAFTpz (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 6 Jan 2015 14:45:55 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 2/6] locking/mutex: Move mcs related comments to proper location
Date: Tue,  6 Jan 2015 11:45:05 -0800
Message-Id: <1420573509-24774-3-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1420573509-24774-1-git-send-email-dave@stgolabs.net>
References: <1420573509-24774-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It serves much better if right before the osq_lock() call.
Also delete a useless comment.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/mutex.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index b042ea5..6db3d0d 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -193,17 +193,6 @@ ww_mutex_set_context_fastpath(struct ww_mutex *lock,
 
 
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-/*
- * In order to avoid a stampede of mutex spinners from acquiring the mutex
- * more or less simultaneously, the spinners need to acquire a MCS lock
- * first before spinning on the owner field.
- *
- */
-
-/*
- * Mutex spinning code migrated from kernel/sched/core.c
- */
-
 static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
 {
 	if (lock->owner != owner)
@@ -307,6 +296,11 @@ static bool mutex_optimistic_spin(struct mutex *lock,
 	if (!mutex_can_spin_on_owner(lock))
 		goto done;
 
+	/*
+	 * In order to avoid a stampede of mutex spinners trying to
+	 * acquire the mutex all at once, the spinners need to take a
+	 * MCS (queued) lock first before spinning on the owner field.
+	 */
 	if (!osq_lock(&lock->osq))
 		goto done;
 
-- 
2.1.2

