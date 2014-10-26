Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaJZPYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 11:24:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34880 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaJZPYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 11:24:06 -0400
Date: Sun, 26 Oct 2014 08:22:28 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-993b2ff221999066fcff231590593d0b98f45d32@git.kernel.org>
Cc: dbueso@suse.de, peterz@infradead.org, hpa@zytor.com,
        Matteo.Franchin@arm.com, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, catalin.marinas@arm.com,
        torvalds@linux-foundation.org, dvhart@linux.intel.com,
        paulmck@linux.vnet.ibm.com, davidlohr@hp.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: tglx@linutronix.de, mingo@kernel.org, paulmck@linux.vnet.ibm.com,
        davidlohr@hp.com, dave@stgolabs.net, catalin.marinas@arm.com,
        torvalds@linux-foundation.org, dvhart@linux.intel.com, dbueso@suse.de,
        peterz@infradead.org, hpa@zytor.com, Matteo.Franchin@arm.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1414121220.817.0.camel@linux-t7sj.site>
References: <1414121220.817.0.camel@linux-t7sj.site>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/urgent] futex:
  Mention key referencing differences between shared and private futexes
Git-Commit-ID: 993b2ff221999066fcff231590593d0b98f45d32
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  993b2ff221999066fcff231590593d0b98f45d32
Gitweb:     http://git.kernel.org/tip/993b2ff221999066fcff231590593d0b98f45d32
Author:     Davidlohr Bueso <dave@stgolabs.net>
AuthorDate: Thu, 23 Oct 2014 20:27:00 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 26 Oct 2014 16:16:18 +0100

futex: Mention key referencing differences between shared and private futexes

Update our documentation as of fix 76835b0ebf8 (futex: Ensure
get_futex_key_refs() always implies a barrier). Explicitly
state that we don't do key referencing for private futexes.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Matteo Franchin <Matteo.Franchin@arm.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: http://lkml.kernel.org/r/1414121220.817.0.camel@linux-t7sj.site
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
