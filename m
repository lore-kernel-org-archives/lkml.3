Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaEESXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:23:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:43857 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbaEESXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:23:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,990,1389772800"; 
   d="scan'208";a="535005385"
Subject: Re: [tip:locking/core] rwsem: Add comments to explain the meaning
 of the rwsem's count field
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        peter@hurleysoftware.com, jason.low2@hp.com, riel@redhat.com,
        alex.shi@linaro.org, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de, walken@google.com,
        davidlohr@hp.com, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20140505172611.GA7154@gmail.com>
References: <1399060437.2970.146.camel@schen9-DESK>
	 <tip-3cf2f34e1a3d4d5ff209d087925cf950e52f4805@git.kernel.org>
	 <1399305808.2970.186.camel@schen9-DESK>  <20140505172611.GA7154@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 May 2014 11:21:25 -0700
Message-ID: <1399314085.2970.205.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-05 at 19:26 +0200, Ingo Molnar wrote:
> * Tim Chen <tim.c.chen@linux.intel.com> wrote:
> 
> > On Mon, 2014-05-05 at 01:46 -0700, tip-bot for Tim Chen wrote:
> > > Commit-ID:  3cf2f34e1a3d4d5ff209d087925cf950e52f4805
> > > Gitweb:     http://git.kernel.org/tip/3cf2f34e1a3d4d5ff209d087925cf950e52f4805
> > > Author:     Tim Chen <tim.c.chen@linux.intel.com>
> > > AuthorDate: Fri, 2 May 2014 12:53:57 -0700
> > > Committer:  Ingo Molnar <mingo@kernel.org>
> > > CommitDate: Sun, 4 May 2014 20:34:26 +0200
> > > 
> > 
> > Ingo,
> > 
> > Can you pick up this version of the patch instead.  I've updated the 
> > comments to reflect all cases for which the rwsem's count is less 
> > than WAITING_BIAS, as Peter has pointed out.
> 
> Please send a delta patch against the one I applied - and also the 
> state diagram suggestion with Peter, once it's clear what form it 
> should take. I've yet to see a state diagram that was inferior to 
> equivalent textual description - is this case an exception to that?
> 

Ingo,

The delta patch is included below.  Thinking a bit more,
the state diagram approach is not necessarily less verbose
because the state is a tuple (count, wait queue state).
After enumerating the states, we may wind up with very similar
to what I have.

Thanks.

Tim

---
>From 490e647f5144a27e09cb987a5216de100de6c253 Mon Sep 17 00:00:00 2001
Message-Id: <490e647f5144a27e09cb987a5216de100de6c253.1399287355.git.tim.c.chen@linux.intel.com>
From: Tim Chen <tim.c.chen@linux.intel.com>
Date: Mon, 5 May 2014 03:53:08 -0700
Subject: [PATCH] rwsem: Update comments on rwsem count for count <
 WAITING_BIAS
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Davidlohr Bueso <davidlohr@hp.com>, Alex Shi <alex.shi@linaro.org>, Andi Kleen <andi@firstfloor.org>, Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>, Peter Hurley <peter@hurleysoftware.com>, Thomas Gleixner <tglx@linutronix.de>, Paul E.McKenney <paulmck@linux.vnet.ibm.com>, Jason Low <jason.low2@hp.com>, linux-kernel@vger.kernel.org

Update the comments for rwsem count for the case
where count < WAITING_BIAS.  Also some clean up of comments
and added explanation on how the rwsem_down_read_failed
path uses the count field.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 kernel/locking/rwsem-xadd.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index b4219ff..a794aaa 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -12,24 +12,24 @@
 #include <linux/export.h>
 
 /*
- * Guide to the rw_semaphore's count field for common values.
- * (32-bit case illustrated, similar for 64-bit)
+ * Guide to the rw_semaphore's count field.
+ * (32-bit count illustrated in descending order, similar for 64-bit count)
  *
  * 0x0000000X	(1) X readers active or attempting lock, no writer waiting
- *		    X = #active_readers + #readers attempting to lock
- *		    (X*ACTIVE_BIAS)
+ *		    where X = #active_readers + #readers attempting to lock
+ *		    count computed as (X*ACTIVE_BIAS)
  *
- * 0x00000000	rwsem is unlocked, and no one is waiting for the lock or
- *		attempting to read lock or write lock.
+ * 0x00000000	(1) rwsem is unlocked, and no one is waiting for the lock or
+ *		    attempting to read lock or write lock.
  *
  * 0xffff000X	(1) X readers active or attempting lock, with waiters for lock
- *		    X = #active readers + # readers attempting lock
+ *		    where X = #active readers + #readers attempting lock
  *		    (X*ACTIVE_BIAS + WAITING_BIAS)
  *		(2) 1 writer attempting lock, no waiters for lock
- *		    X-1 = #active readers + #readers attempting lock
+ *		    where X-1 = #active readers + #readers attempting lock
  *		    ((X-1)*ACTIVE_BIAS + ACTIVE_WRITE_BIAS)
  *		(3) 1 writer active, no waiters for lock
- *		    X-1 = #active readers + #readers attempting lock
+ *		    where X-1 = #active readers + #readers attempting lock
  *		    ((X-1)*ACTIVE_BIAS + ACTIVE_WRITE_BIAS)
  *
  * 0xffff0001	(1) 1 reader active or attempting lock, waiters for lock
@@ -43,19 +43,30 @@
  *		Note: writer can attempt to steal lock for this count by adding
  *		ACTIVE_WRITE_BIAS in cmpxchg and checking the old count
  *
- * 0xfffe0001	(1) 1 writer active, or attempting lock. Waiters on queue.
- *		    (ACTIVE_WRITE_BIAS + WAITING_BIAS)
+ * count < WAITING_BIAS
+ *		(1) X writer active, Y writer(s) attempting lock,
+ *		    Z readers attempting lock, no waiters
+ *		    where X = 0 or 1, (X+Y) >= 2, Z >= 0
+ *                  ((X+Y) * ACTIVE_WRITE_BIAS + Z * ACTIVE_BIAS)
+ *		(2) X writer active, Y writer(s) attempting lock,
+ *		    Z readers attempting lock, waiters for lock 
+ *		    where X = 0 or 1, (X+Y) >= 1, Z >= 0
+ *		    ((X+Y) * ACTIVE_WRITE_BIAS + Z * ACTIVE_BIAS + WAITING_BIAS)
  *
  * Note: Readers attempt to lock by adding ACTIVE_BIAS in down_read and checking
  *	 the count becomes more than 0 for successful lock acquisition,
- *	 i.e. the case where there are only readers or nobody has lock.
- *	 (1st and 2nd case above).
+ *	 i.e. the case where there are only readers locking or nobody has lock.
+ *	 (1st and 2nd case above). In rwsem_down_read failed, after 
+ *	 putting itself on the wait queue, it will check again if there are
+ *	 only readers locking, nobody has lock or it is first in queue (1, 2, and
+ *	 5th case), and call __rwsem_do_wake to wake up waiter at front 
+ *	 of queue to attempt locking again.
  *
  *	 Writers attempt to lock by adding ACTIVE_WRITE_BIAS in down_write and
  *	 checking the count becomes ACTIVE_WRITE_BIAS for successful lock
  *	 acquisition (i.e. nobody else has lock or attempts lock).  If
  *	 unsuccessful, in rwsem_down_write_failed, we'll check to see if there
- *	 are only waiters but none active (5th case above), and attempt to
+ *	 are only waiters but none active (5th case), and attempt to
  *	 steal the lock.
  *
  */
-- 
1.7.11.7




