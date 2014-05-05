Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaEEQPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 12:15:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:22806 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbaEEQPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 12:15:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,989,1389772800"; 
   d="scan'208";a="506164720"
Subject: Re: [tip:locking/core] rwsem: Add comments to explain the meaning
 of the rwsem's count field
From: Tim Chen <tim.c.chen@linux.intel.com>
To: mingo@kernel.org
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        peter@hurleysoftware.com, jason.low2@hp.com, riel@redhat.com,
        alex.shi@linaro.org, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de, walken@google.com,
        davidlohr@hp.com, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <tip-3cf2f34e1a3d4d5ff209d087925cf950e52f4805@git.kernel.org>
References: <1399060437.2970.146.camel@schen9-DESK>
	 <tip-3cf2f34e1a3d4d5ff209d087925cf950e52f4805@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 May 2014 09:03:28 -0700
Message-ID: <1399305808.2970.186.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-05 at 01:46 -0700, tip-bot for Tim Chen wrote:
> Commit-ID:  3cf2f34e1a3d4d5ff209d087925cf950e52f4805
> Gitweb:     http://git.kernel.org/tip/3cf2f34e1a3d4d5ff209d087925cf950e52f4805
> Author:     Tim Chen <tim.c.chen@linux.intel.com>
> AuthorDate: Fri, 2 May 2014 12:53:57 -0700
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Sun, 4 May 2014 20:34:26 +0200
> 

Ingo,

Can you pick up this version of the patch instead.  I've updated the
comments to reflect all cases for which the rwsem's count is less than
WAITING_BIAS, as Peter has pointed out.

Thanks.

Tim

---
>From edb145882b09e007b878eedd9d6683259c6ec506 Mon Sep 17 00:00:00 2001
Message-Id: <edb145882b09e007b878eedd9d6683259c6ec506.1399279707.git.tim.c.chen@linux.intel.com>
From: Tim Chen <tim.c.chen@linux.intel.com>
Date: Thu, 1 May 2014 03:13:09 -0700
Subject: [PATCH v3] rwsem: Comments to explain the meaning of the rwsem's count
 field
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Davidlohr Bueso <davidlohr@hp.com>, Alex Shi <alex.shi@linaro.org>, Andi Kleen <andi@firstfloor.org>, Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>, Peter Hurley <peter@hurleysoftware.com>, Thomas Gleixner <tglx@linutronix.de>, Paul E.McKenney <paulmck@linux.vnet.ibm.com>, Jason Low <jason.low2@hp.com>, linux-kernel@vger.kernel.org

It takes me quite a while to understand how rwsem's count field mainifest
itself in different scenarios.  I'm adding comments to provide a quick
reference on the the rwsem's count field for each scenario where readers
and writers are contending for the lock.  Hopefully it will be useful
for future maintenance of the code and for people to get up to speed on
how the logic in the code works.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
Changes from v2 (https://lkml.org/lkml/2014/5/2/514)
 - Account for all scenearios where count < WAITING_BIAS 

Changes from v1 (https://lkml.org/lkml/2014/5/1/327)
 - Account for the scenarios where readers/writers are attempting lock.
 - Grammatical corrections.
 - Corrected value for the second case of 0xffff0001 count.

 kernel/locking/rwsem-xadd.c | 60 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 1d66e08..a794aaa 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -12,6 +12,66 @@
 #include <linux/export.h>
 
 /*
+ * Guide to the rw_semaphore's count field.
+ * (32-bit count illustrated in descending order, similar for 64-bit count)
+ *
+ * 0x0000000X	(1) X readers active or attempting lock, no writer waiting
+ *		    where X = #active_readers + #readers attempting to lock
+ *		    count computed as (X*ACTIVE_BIAS)
+ *
+ * 0x00000000	(1) rwsem is unlocked, and no one is waiting for the lock or
+ *		    attempting to read lock or write lock.
+ *
+ * 0xffff000X	(1) X readers active or attempting lock, with waiters for lock
+ *		    where X = #active readers + #readers attempting lock
+ *		    (X*ACTIVE_BIAS + WAITING_BIAS)
+ *		(2) 1 writer attempting lock, no waiters for lock
+ *		    where X-1 = #active readers + #readers attempting lock
+ *		    ((X-1)*ACTIVE_BIAS + ACTIVE_WRITE_BIAS)
+ *		(3) 1 writer active, no waiters for lock
+ *		    where X-1 = #active readers + #readers attempting lock
+ *		    ((X-1)*ACTIVE_BIAS + ACTIVE_WRITE_BIAS)
+ *
+ * 0xffff0001	(1) 1 reader active or attempting lock, waiters for lock
+ *		    (WAITING_BIAS + ACTIVE_BIAS)
+ *		(2) 1 writer active or attempting lock, no waiters for lock
+ *		    (ACTIVE_WRITE_BIAS)
+ *
+ * 0xffff0000	(1) There are writers or readers queued but none active
+ *		    or in the process of attempting lock.
+ *		    (WAITING_BIAS)
+ *		Note: writer can attempt to steal lock for this count by adding
+ *		ACTIVE_WRITE_BIAS in cmpxchg and checking the old count
+ *
+ * count < WAITING_BIAS
+ *		(1) X writer active, Y writer(s) attempting lock,
+ *		    Z readers attempting lock, no waiters
+ *		    where X = 0 or 1, (X+Y) >= 2, Z >= 0
+ *                  ((X+Y) * ACTIVE_WRITE_BIAS + Z * ACTIVE_BIAS)
+ *		(2) X writer active, Y writer(s) attempting lock,
+ *		    Z readers attempting lock, waiters for lock 
+ *		    where X = 0 or 1, (X+Y) >= 1, Z >= 0
+ *		    ((X+Y) * ACTIVE_WRITE_BIAS + Z * ACTIVE_BIAS + WAITING_BIAS)
+ *
+ * Note: Readers attempt to lock by adding ACTIVE_BIAS in down_read and checking
+ *	 the count becomes more than 0 for successful lock acquisition,
+ *	 i.e. the case where there are only readers locking or nobody has lock.
+ *	 (1st and 2nd case above). In rwsem_down_read failed, after 
+ *	 putting itself on the wait queue, it will check again if there are
+ *	 only readers locking, nobody has lock or it is first in queue (1, 2, and
+ *	 5th case), and call __rwsem_do_wake to wake up waiter at front 
+ *	 of queue to attempt locking again.
+ *
+ *	 Writers attempt to lock by adding ACTIVE_WRITE_BIAS in down_write and
+ *	 checking the count becomes ACTIVE_WRITE_BIAS for successful lock
+ *	 acquisition (i.e. nobody else has lock or attempts lock).  If
+ *	 unsuccessful, in rwsem_down_write_failed, we'll check to see if there
+ *	 are only waiters but none active (5th case), and attempt to
+ *	 steal the lock.
+ *
+ */
+
+/*
  * Initialize an rwsem:
  */
 void __init_rwsem(struct rw_semaphore *sem, const char *name,
-- 
1.7.11.7



