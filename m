Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbbANTTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:19:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39787 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbANTTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:19:30 -0500
Date: Wed, 14 Jan 2015 11:18:54 -0800
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-e42f678a0237f84f0004fbaf0fad0b844751eadd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, peterz@infradead.org,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, dbueso@suse.de, mingo@kernel.org,
        dave@stgolabs.net
Reply-To: paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        peterz@infradead.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, mingo@kernel.org, dbueso@suse.de,
        tglx@linutronix.de
In-Reply-To: <1420573509-24774-3-git-send-email-dave@stgolabs.net>
References: <1420573509-24774-3-git-send-email-dave@stgolabs.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/mutex:
  Move MCS related comments to proper location
Git-Commit-ID: e42f678a0237f84f0004fbaf0fad0b844751eadd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e42f678a0237f84f0004fbaf0fad0b844751eadd
Gitweb:     http://git.kernel.org/tip/e42f678a0237f84f0004fbaf0fad0b844751eadd
Author:     Davidlohr Bueso <dave@stgolabs.net>
AuthorDate: Tue, 6 Jan 2015 11:45:05 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 14 Jan 2015 15:07:22 +0100

locking/mutex: Move MCS related comments to proper location

It serves much better if the comments are right before the osq_lock() call.
Also delete a useless comment.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1420573509-24774-3-git-send-email-dave@stgolabs.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
 
