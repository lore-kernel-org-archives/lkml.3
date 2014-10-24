Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbaJXD1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 23:27:17 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:53130 "EHLO
	homiemail-a61.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbaJXD1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 23:27:15 -0400
Message-ID: <1414121220.817.0.camel@linux-t7sj.site>
Subject: [PATCH] futex: Mention key referencing differences between shared
 and private futexes
From: Davidlohr Bueso <dave@stgolabs.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Matteo Franchin <Matteo.Franchin@arm.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 23 Oct 2014 20:27:00 -0700
In-Reply-To: <1413563929-2664-1-git-send-email-catalin.marinas@arm.com>
References: <1413563929-2664-1-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@stgolabs.net>

Update our documentation as of fix 76835b0ebf8 (futex: Ensure
get_futex_key_refs() always implies a barrier). Explicitly
state that we don't do key referencing for private futexes.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/futex.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index f3a3a07..bbf071f 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -143,9 +143,8 @@
  *
  * Where (A) orders the waiters increment and the futex value read through
  * atomic operations (see hb_waiters_inc) and where (B) orders the write
- * to futex and the waiters read -- this is done by the barriers in
- * get_futex_key_refs(), through either ihold or atomic_inc, depending on the
- * futex type.
+ * to futex and the waiters read -- this is done by the barriers for both
+ * shared and private futexes in get_futex_key_refs().
  *
  * This yields the following case (where X:=waiters, Y:=futex):
  *
@@ -344,13 +343,20 @@ static void get_futex_key_refs(union futex_key *key)
 		futex_get_mm(key); /* implies MB (B) */
 		break;
 	default:
+		/*
+		 * Private futexes do not hold reference on an inode or
+		 * mm, therefore the only purpose of calling get_futex_key_refs
+		 * is because we need the barrier for the lockless waiter check.
+		 */
 		smp_mb(); /* explicit MB (B) */
 	}
 }
 
 /*
  * Drop a reference to the resource addressed by a key.
- * The hash bucket spinlock must not be held.
+ * The hash bucket spinlock must not be held. This is
+ * a no-op for private futexes, see comment in the get
+ * counterpart.
  */
 static void drop_futex_key_refs(union futex_key *key)
 {
-- 
1.8.4.5



