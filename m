Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbbAGRVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:21:39 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:41168 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbbAGRVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:21:38 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/10] compiler: Allow 1- and 2-byte smp_load_acquire() and smp_store_release()
Date: Wed,  7 Jan 2015 09:20:51 -0800
Message-Id: <1420651257-553-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420651257-553-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107172030.GA31571@linux.vnet.ibm.com>
 <1420651257-553-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0021-0000-0000-0000079378BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

CPUs without single-byte and double-byte loads and stores place some
"interesting" requirements on concurrent code.  For example (adapted
from Peter Hurley's test code), suppose we have the following structure:

	struct foo {
		spinlock_t lock1;
		spinlock_t lock2;
		char a; /* Protected by lock1. */
		char b; /* Protected by lock2. */
	};
	struct foo *foop;

Of course, it is common (and good) practice to place data protected
by different locks in separate cache lines.  However, if the locks are
rarely acquired (for example, only in rare error cases), and there are
a great many instances of the data structure, then memory footprint can
trump false-sharing concerns, so that it can be better to place them in
the same cache cache line as above.

But if the CPU does not support single-byte loads and stores, a store
to foop->a will do a non-atomic read-modify-write operation on foop->b,
which will come as a nasty surprise to someone holding foop->lock2.  So we
now require CPUs to support single-byte and double-byte loads and stores.
Therefore, this commit adjusts the definition of __native_word() to allow
these sizes to be used by smp_load_acquire() and smp_store_release().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/compiler.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index a1c81f80978e..49811cdddaa5 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -385,7 +385,7 @@ static __always_inline void __assign_once_size(volatile void *p, void *res, int
 
 /* Is this type a native word size -- useful for atomic operations */
 #ifndef __native_word
-# define __native_word(t) (sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
+# define __native_word(t) (sizeof(t) == sizeof(char) || sizeof(t) == sizeof(short) || sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
 #endif
 
 /* Compile time object size, -1 for unknown */
-- 
1.8.1.5

