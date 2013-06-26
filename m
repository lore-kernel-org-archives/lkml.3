Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3FZW17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:27:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:9165 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab3FZW15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:27:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,947,1363158000"; 
   d="scan'208";a="336051901"
Subject: [PATCH v4 3/5] rwsem: remove try_reader_grant label do_wake
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
In-Reply-To: <cover.1372282738.git.tim.c.chen@linux.intel.com>
References: <cover.1372282738.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jun 2013 15:28:00 -0700
Message-ID: <1372285680.22432.143.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That make code simple and more readable

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 lib/rwsem.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 42f1b1a..a8055cf 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -85,15 +85,17 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 	adjustment = 0;
 	if (wake_type != RWSEM_WAKE_READ_OWNED) {
 		adjustment = RWSEM_ACTIVE_READ_BIAS;
- try_reader_grant:
-		oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
-		if (unlikely(oldcount < RWSEM_WAITING_BIAS)) {
-			/* A writer stole the lock. Undo our reader grant. */
+		while (1) {
+			oldcount = rwsem_atomic_update(adjustment, sem)
+								- adjustment;
+			if (likely(oldcount >= RWSEM_WAITING_BIAS))
+				break;
+
+			 /* A writer stole the lock.  Undo our reader grant. */
 			if (rwsem_atomic_update(-adjustment, sem) &
 						RWSEM_ACTIVE_MASK)
 				return sem;
 			/* Last active locker left. Retry waking readers. */
-			goto try_reader_grant;
 		}
 	}
 
-- 
1.7.4.4



