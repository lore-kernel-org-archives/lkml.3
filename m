Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbaIQARD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 20:17:03 -0400
Received: from g6t1525.atlanta.hp.com ([15.193.200.68]:41745 "EHLO
	g6t1525.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaIQARB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 20:17:01 -0400
Message-ID: <1410913017.2447.22.camel@j-VirtualBox>
Subject: [PATCH v3] locking/rwsem: Avoid double checking before try
 acquiring write lock
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <dbueso@suse.de>
Cc: linux-kernel@vger.kernel.org, Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>, Jason Low <jason.low2@hp.com>
Date: Tue, 16 Sep 2014 17:16:57 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9b0fc9c09f1b checks for if there are known active lockers
in order to avoid write trylocking using expensive cmpxchg() when
it likely wouldn't get the lock.

However, a subsequent patch was added such that we directly
check for sem->count == RWSEM_WAITING_BIAS right before trying
that cmpxchg(). Thus, commit 9b0fc9c09f1b now just adds overhead.
This patch modifies it so that we only do a check for if
count == RWSEM_WAITING_BIAS.

Also, add a comment on why we do an "extra check" of count
before the cmpxchg().

Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/rwsem-xadd.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 12166ec..7628c3f 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -250,16 +250,18 @@ EXPORT_SYMBOL(rwsem_down_read_failed);
 
 static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
 {
-	if (!(count & RWSEM_ACTIVE_MASK)) {
-		/* try acquiring the write lock */
-		if (sem->count == RWSEM_WAITING_BIAS &&
-		    cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
-			    RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
-			if (!list_is_singular(&sem->wait_list))
-				rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
-			return true;
-		}
+	/*
+	 * Try acquiring the write lock. Check count first in order
+	 * to reduce unnecessary expensive cmpxchg() operations.
+	 */
+	if (count == RWSEM_WAITING_BIAS &&
+	    cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
+		    RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
+		if (!list_is_singular(&sem->wait_list))
+			rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
+		return true;
 	}
+
 	return false;
 }
 
-- 
1.7.1



