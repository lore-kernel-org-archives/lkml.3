Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3IXWWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 18:22:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:47542 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab3IXWWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 18:22:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,974,1371106800"; 
   d="scan'208";a="383032910"
Subject: [PATCH v5 1/6] rwsem: check the lock before cpmxchg in
 down_write_trylock
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
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
In-Reply-To: <cover.1380057198.git.tim.c.chen@linux.intel.com>
References: <cover.1380057198.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Sep 2013 15:22:26 -0700
Message-ID: <1380061346.3467.50.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cmpxchg will cause the cacheline bouning when do the value checking,
that cause scalability issue in a large machine (like a 80 core box).

So a lock pre-read can relief this contention.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/asm-generic/rwsem.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/rwsem.h b/include/asm-generic/rwsem.h
index bb1e2cd..5ba80e7 100644
--- a/include/asm-generic/rwsem.h
+++ b/include/asm-generic/rwsem.h
@@ -70,11 +70,11 @@ static inline void __down_write(struct rw_semaphore *sem)
 
 static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
-	long tmp;
+	if (unlikely(sem->count != RWSEM_UNLOCKED_VALUE))
+		return 0;
 
-	tmp = cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
-		      RWSEM_ACTIVE_WRITE_BIAS);
-	return tmp == RWSEM_UNLOCKED_VALUE;
+	return cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
+		      RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_UNLOCKED_VALUE;
 }
 
 /*
-- 
1.7.4.4



