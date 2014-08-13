Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaHMK5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:57:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53361 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaHMK5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:57:35 -0400
Date: Wed, 13 Aug 2014 03:56:40 -0700
From: tip-bot for Bart Van Assche <tipbot@zytor.com>
Message-ID: <tip-4999201a59ef555f9105d2bb2459ed895627f7aa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        davem@davemloft.net, paulmck@linux.vnet.ibm.com, bvanassche@acm.org,
        akpm@linux-foundation.org, oleg@redhat.com, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        davem@davemloft.net, paulmck@linux.vnet.ibm.com, bvanassche@acm.org,
        akpm@linux-foundation.org, tglx@linutronix.de, oleg@redhat.com,
        rientjes@google.com
In-Reply-To: <53E4A7F8.1040700@acm.org>
References: <53E4A7F8.1040700@acm.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/spinlocks:
  Always evaluate the second argument of spin_lock_nested()
Git-Commit-ID: 4999201a59ef555f9105d2bb2459ed895627f7aa
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

Commit-ID:  4999201a59ef555f9105d2bb2459ed895627f7aa
Gitweb:     http://git.kernel.org/tip/4999201a59ef555f9105d2bb2459ed895627f7aa
Author:     Bart Van Assche <bvanassche@acm.org>
AuthorDate: Fri, 8 Aug 2014 12:35:36 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 10:32:38 +0200

locking/spinlocks: Always evaluate the second argument of spin_lock_nested()

Evaluating a macro argument only if certain configuration options
have been selected is confusing and error-prone. Hence always
evaluate the second argument of spin_lock_nested().

An intentional side effect of this patch is that it avoids that
the following warning is reported for netif_addr_lock_nested()
when building with CONFIG_DEBUG_LOCK_ALLOC=n and with W=1:

  include/linux/netdevice.h: In function 'netif_addr_lock_nested':
  include/linux/netdevice.h:2865:6: warning: variable 'subclass' set but not used [-Wunused-but-set-variable]
    int subclass = SINGLE_DEPTH_NESTING;
        ^

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/53E4A7F8.1040700@acm.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/spinlock.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 3f2867f..262ba4e 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -197,7 +197,13 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
 		 _raw_spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
 	 } while (0)
 #else
-# define raw_spin_lock_nested(lock, subclass)		_raw_spin_lock(lock)
+/*
+ * Always evaluate the 'subclass' argument to avoid that the compiler
+ * warns about set-but-not-used variables when building with
+ * CONFIG_DEBUG_LOCK_ALLOC=n and with W=1.
+ */
+# define raw_spin_lock_nested(lock, subclass)		\
+	_raw_spin_lock(((void)(subclass), (lock)))
 # define raw_spin_lock_nest_lock(lock, nest_lock)	_raw_spin_lock(lock)
 #endif
 
