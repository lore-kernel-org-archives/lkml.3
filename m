Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaFDTIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:08:40 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:20318 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaFDTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:08:38 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        tim.c.chen@linux.intel.com, peter@hurleysoftware.com, riel@redhat.com,
        hpa@zytor.com, walken@google.com, davidlohr@hp.com, Waiman.Long@hp.com,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com,
        jason.low2@hp.com
Subject: [RFC PATCH 2/3] locking/mutex: Correct documentation on mutex optimistic spinning
Date: Wed,  4 Jun 2014 12:08:30 -0700
Message-Id: <1401908911-8947-3-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401908911-8947-1-git-send-email-jason.low2@hp.com>
References: <1401908911-8947-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mutex optimistic spinning documentation states that we spin for
acquisition when we find that there are no pending waiters. However,
in actuality, whether or not there are waiters for the mutex doesn't
determine if we will spin for it.

This patch removes that statement and also adds a comment which
mentions that we spin for the mutex while we don't need to reschedule.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/mutex.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 0925968..fc55f72 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -389,12 +389,10 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
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

