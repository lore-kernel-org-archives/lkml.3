Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbaCKMm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:42:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35811 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbaCKMmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:42:23 -0400
Date: Tue, 11 Mar 2014 05:41:51 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-zah5eyn9gu7qlgwh9r6n2anc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking/mutexes: Add extra reschedule point
Git-Commit-ID: 34c6bc2c919a55e5ad4e698510a2f35ee13ab900
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

Commit-ID:  34c6bc2c919a55e5ad4e698510a2f35ee13ab900
Gitweb:     http://git.kernel.org/tip/34c6bc2c919a55e5ad4e698510a2f35ee13ab900
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 3 Feb 2014 16:21:09 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 12:14:59 +0100

locking/mutexes: Add extra reschedule point

Add in an extra reschedule in an attempt to avoid getting reschedule
the moment we've acquired the lock.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-zah5eyn9gu7qlgwh9r6n2anc@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 2670b84..02c61a9 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -468,6 +468,13 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	}
 	osq_unlock(&lock->osq);
 slowpath:
+	/*
+	 * If we fell out of the spin path because of need_resched(),
+	 * reschedule now, before we try-lock the mutex. This avoids getting
+	 * scheduled out right after we obtained the mutex.
+	 */
+	if (need_resched())
+		schedule_preempt_disabled();
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
 
