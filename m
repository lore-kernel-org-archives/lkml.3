Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3FZQ2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:28:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:35218 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab3FZQ2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:28:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,945,1363158000"; 
   d="scan'208";a="359985234"
Subject: [PATCH v3 4/5] rwsem/wake: check lock before do atomic update
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <cover.1372261602.git.tim.c.chen@linux.intel.com>
References: <cover.1372261602.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jun 2013 09:28:01 -0700
Message-ID: <1372264081.22432.124.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atomic update lock and roll back will cause cache bouncing in large
machine. A lock status pre-read can relieve this problem

Suggested-by: Davidlohr bueso <davidlohr.bueso@hp.com>
Suggested-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 lib/rwsem.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index a8055cf..1d6e6e8 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -64,7 +64,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 	struct rwsem_waiter *waiter;
 	struct task_struct *tsk;
 	struct list_head *next;
-	long oldcount, woken, loop, adjustment;
+	long woken, loop, adjustment;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
 	if (waiter->type == RWSEM_WAITING_FOR_WRITE) {
@@ -86,6 +86,12 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 	if (wake_type != RWSEM_WAKE_READ_OWNED) {
 		adjustment = RWSEM_ACTIVE_READ_BIAS;
 		while (1) {
+			long oldcount;
+
+			/* A writer stole the lock. */
+			if (unlikely(sem->count < RWSEM_WAITING_BIAS))
+				return sem;
+
 			oldcount = rwsem_atomic_update(adjustment, sem)
 								- adjustment;
 			if (likely(oldcount >= RWSEM_WAITING_BIAS))
-- 
1.7.4.4



