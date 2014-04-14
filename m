Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaDNHY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:24:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42403 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbaDNHYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:24:22 -0400
Date: Mon, 14 Apr 2014 00:22:17 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-a227960fe0cafcc229a8d6bb8b454a3a0b33719d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu, mlsemon35@gmail.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        jason.low2@hp.com, davej@redhat.com, tglx@linutronix.de,
        kirill@shutemov.name
Reply-To: mingo@kernel.org, hpa@zytor.com, mlsemon35@gmail.com,
        Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        peterz@infradead.org, davej@redhat.com, jason.low2@hp.com,
        tglx@linutronix.de, kirill@shutemov.name
In-Reply-To: <20140410141559.GE13658@twins.programming.kicks-ass.net>
References: <20140410141559.GE13658@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] locking/mutex: Fix debug_mutexes
Git-Commit-ID: a227960fe0cafcc229a8d6bb8b454a3a0b33719d
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

Commit-ID:  a227960fe0cafcc229a8d6bb8b454a3a0b33719d
Gitweb:     http://git.kernel.org/tip/a227960fe0cafcc229a8d6bb8b454a3a0b33719d
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 10 Apr 2014 16:15:59 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 11 Apr 2014 10:40:35 +0200

locking/mutex: Fix debug_mutexes

debug_mutex_unlock() would bail when !debug_locks and forgets to
actually unlock.

Reported-by: "Michael L. Semon" <mlsemon35@gmail.com>
Reported-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Fixes: 6f008e72cd11 ("locking/mutex: Fix debug checks")
Tested-by: Dave Jones <davej@redhat.com>
Cc: Jason Low <jason.low2@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140410141559.GE13658@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex-debug.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
index e1191c9..5cf6731 100644
--- a/kernel/locking/mutex-debug.c
+++ b/kernel/locking/mutex-debug.c
@@ -71,18 +71,17 @@ void mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
 
 void debug_mutex_unlock(struct mutex *lock)
 {
-	if (unlikely(!debug_locks))
-		return;
+	if (likely(debug_locks)) {
+		DEBUG_LOCKS_WARN_ON(lock->magic != lock);
 
-	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
+		if (!lock->owner)
+			DEBUG_LOCKS_WARN_ON(!lock->owner);
+		else
+			DEBUG_LOCKS_WARN_ON(lock->owner != current);
 
-	if (!lock->owner)
-		DEBUG_LOCKS_WARN_ON(!lock->owner);
-	else
-		DEBUG_LOCKS_WARN_ON(lock->owner != current);
-
-	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
-	mutex_clear_owner(lock);
+		DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
+		mutex_clear_owner(lock);
+	}
 
 	/*
 	 * __mutex_slowpath_needs_to_unlock() is explicitly 0 for debug
