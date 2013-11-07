Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab3KHAEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:04:41 -0500
Received: from dmz-mailsec-scanner-4.mit.edu ([18.9.25.15]:45274 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754005Ab3KHAEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:04:30 -0500
X-AuditID: 1209190f-b7f7b8e0000053dd-5e-527c29617e17
Date: Thu, 7 Nov 2013 18:59:26 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 09/11] random: forget lock in lockless accounting
Message-ID: <20131107235926.GL16018@ringworld.MIT.EDU>
References: <cover.1383868558.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1383868558.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsUixG6nrpuoWRNksPoaq8XuOYtZLC7vmsPm
	wORxZsERdo/Pm+QCmKK4bFJSczLLUov07RK4Mp59+M9ccJar4sXshywNjHc4uhg5OSQETCQO
	vt/FAmGLSVy4t56ti5GLQ0hgNpNE05Gn7CAJIYENjBITpmtCJH4ySly9ep0ZJMEioCLx5/pJ
	JhCbTUBB4sf8dWBxEQFliVUzN4HFmQXsJX5PnQw2SFjAUeLI2odgcV4BM4nGM6ehFhhI/Jz+
	lgUiLihxcuYTFoheLYkb/14C1XMA2dISy/+BHc0pYCjR3nyFFcQWBTphysltbBMYBWch6Z6F
	pHsWQvcCRuZVjLIpuVW6uYmZOcWpybrFyYl5ealFuiZ6uZkleqkppZsYQaHLKcm/g/HbQaVD
	jAIcjEo8vAUXqoOEWBPLiitzDzFKcjApifJOVK8JEuJLyk+pzEgszogvKs1JLT7EKMHBrCTC
	+0wRKMebklhZlVqUD5OS5mBREue9yWEfJCSQnliSmp2aWpBaBJOV4eBQkuDV0gBqFCxKTU+t
	SMvMKUFIM3FwggznARoeAVLDW1yQmFucmQ6RP8WoKCXOawSSEABJZJTmwfXCUssrRnGgV4R5
	VUCqeIBpCa77FdBgJqDBIb8qQQaXJCKkpBoY65eYRee5G7jEzjVa5RO9r/1NqfdFw8vXPstJ
	3yxrP/hk8idLnwM38k90fglv/uUmNyNQPVefTYevmrV58a7Hv030z5xzO7l4wz/+8pWZvr78
	Kna/BD8Uea31nXLgzEkD3TmfV82utLfmzLRSUZsloi8TXbN0wn7+M28b4qy5mH1OHH+5svWR
	EktxRqKhFnNRcSIAQNoeHAgDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only mutable data accessed here is ->entropy_count, but since
902c098a3 ("random: use lockless techniques in the interrupt path")
that member isn't protected by the lock anyway.  Since 10b3a32d2
("random: fix accounting race condition") we use cmpxchg to protect
our accesses to ->entropy_count here.  Drop the use of the lock.

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9e4645e..1bf6bf8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -843,9 +843,6 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 	unsigned long flags;
 	int wakeup_write = 0;
 
-	/* Hold lock while accounting */
-	spin_lock_irqsave(&r->lock, flags);
-
 	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
 	DEBUG_ENT("trying to extract %zu bits from %s\n",
 		  nbytes * 8, r->name);
@@ -871,8 +868,6 @@ retry:
 	DEBUG_ENT("debiting %zu entropy credits from %s%s\n",
 		  nbytes * 8, r->name, r->limit ? "" : " (unlimited)");
 
-	spin_unlock_irqrestore(&r->lock, flags);
-
 	if (wakeup_write) {
 		wake_up_interruptible(&random_write_wait);
 		kill_fasync(&fasync, SIGIO, POLL_OUT);
-- 
1.8.3.2

