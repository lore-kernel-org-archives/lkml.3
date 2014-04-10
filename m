Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935073AbaDJJS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:18:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38596 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057AbaDJJSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:18:51 -0400
Date: Thu, 10 Apr 2014 11:18:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Michael L. Semon" <mlsemon35@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: 3.14.0+/x86: lockdep and mutexes not getting along
Message-ID: <20140410091824.GL10526@twins.programming.kicks-ass.net>
References: <alpine.LNX.2.11.1404060059020.8208@bpserver.ds>
 <20140409121940.GA12890@node.dhcp.inet.fi>
 <1397108579.2586.15.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397108579.2586.15.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 10:42:59PM -0700, Jason Low wrote:
> As a starting point, would either of you like to test the following
> patch to see if it fixes the issue? This patch essentially generates the
> same code as in older kernels in the debug case. This applies on top of
> kernels with both commits 6f008e72cd11 and 1d8fe7dc8078.


So I managed to reproduce, and the below makes it go away. I just don't
understand why though. will stare more.

---
--- a/kernel/locking/mutex-debug.c
+++ b/kernel/locking/mutex-debug.c
@@ -83,12 +83,6 @@ void debug_mutex_unlock(struct mutex *lo
 
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
 	mutex_clear_owner(lock);
-
-	/*
-	 * __mutex_slowpath_needs_to_unlock() is explicitly 0 for debug
-	 * mutexes so that we can do it here after we've verified state.
-	 */
-	atomic_set(&lock->count, 1);
 }
 
 void debug_mutex_init(struct mutex *lock, const char *name,
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -34,13 +34,6 @@
 #ifdef CONFIG_DEBUG_MUTEXES
 # include "mutex-debug.h"
 # include <asm-generic/mutex-null.h>
-/*
- * Must be 0 for the debug case so we do not do the unlock outside of the
- * wait_lock region. debug_mutex_unlock() will do the actual unlock in this
- * case.
- */
-# undef __mutex_slowpath_needs_to_unlock
-# define  __mutex_slowpath_needs_to_unlock()	0
 #else
 # include "mutex.h"
 # include <asm/mutex.h>
@@ -688,6 +681,17 @@ __mutex_unlock_common_slowpath(atomic_t
 	unsigned long flags;
 
 	/*
+	 * In the debug cases, obtain the wait_lock first
+	 * before calling the following debugging functions.
+	 */
+#ifdef CONFIG_DEBUG_MUTEXES
+	spin_lock_mutex(&lock->wait_lock, flags);
+	mutex_release(&lock->dep_map, nested, _RET_IP_);
+	debug_mutex_unlock(lock);
+#endif
+
+
+	/*
 	 * some architectures leave the lock unlocked in the fastpath failure
 	 * case, others need to leave it locked. In the later case we have to
 	 * unlock it here
@@ -695,9 +699,11 @@ __mutex_unlock_common_slowpath(atomic_t
 	if (__mutex_slowpath_needs_to_unlock())
 		atomic_set(&lock->count, 1);
 
+#ifndef CONFIG_DEBUG_MUTEXES
 	spin_lock_mutex(&lock->wait_lock, flags);
 	mutex_release(&lock->dep_map, nested, _RET_IP_);
 	debug_mutex_unlock(lock);
+#endif
 
 	if (!list_empty(&lock->wait_list)) {
 		/* get the first entry from the wait-list: */
