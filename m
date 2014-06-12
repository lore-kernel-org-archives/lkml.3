Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaFLVU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:20:58 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:33455 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaFLVUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:20:17 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, davidlohr@hp.com, Waiman.Long@hp.com,
        scott.norton@hp.com, aswin@hp.com, jason.low2@hp.com
Subject: [PATCH v3 1/3] mutex: Correct documentation on mutex optimistic spinning
Date: Thu, 12 Jun 2014 14:20:12 -0700
Message-Id: <1402608014-11473-2-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402608014-11473-1-git-send-email-jason.low2@hp.com>
References: <1402608014-11473-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mutex optimistic spinning documentation states that we spin for
acquisition when we find that there are no pending waiters. However,
in actuality, whether or not there are waiters for the mutex doesn't
determine if we will spin for it.

This patch removes that statement and also adds a comment which
mentions that we spin for the mutex while we don't need to reschedule.

Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/mutex.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index bc73d33..dd26bf6 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -388,12 +388,10 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	/*
 	 * Optimistic spinning.
 	 *
-	 * We try to spin for acquisition when we find that there are no
-	 * pending waiters and the lock owner is currently running on a
-	 * (different) CPU.
-	 *
-	 * The rationale is that if the lock owner is running, it is likely to
-	 * release the lock soon.
+	 * We try to spin for acquisition when we find that the lock owner
+	 * is currently running on a (different) CPU and while we don't
+	 * need to reschedule. The rationale is that if the lock owner is
+	 * running, it is likely to release the lock soon.
 	 *
 	 * Since this needs the lock owner, and this mutex implementation
 	 * doesn't track the owner atomically in the lock field, we need to
-- 
1.7.1

