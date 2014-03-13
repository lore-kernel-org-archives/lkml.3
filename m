Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaCMH25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 03:28:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33565 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbaCMH2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 03:28:53 -0400
Date: Thu, 13 Mar 2014 00:28:18 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-6f008e72cd111a119b5d8de8c5438d892aae99eb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140312122442.GB27965@twins.programming.kicks-ass.net>
References: <20140312122442.GB27965@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking/mutex: Fix debug checks
Git-Commit-ID: 6f008e72cd111a119b5d8de8c5438d892aae99eb
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

Commit-ID:  6f008e72cd111a119b5d8de8c5438d892aae99eb
Gitweb:     http://git.kernel.org/tip/6f008e72cd111a119b5d8de8c5438d892aae99eb
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 12 Mar 2014 13:24:42 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 12 Mar 2014 13:49:47 +0100

locking/mutex: Fix debug checks

OK, so commit:

  1d8fe7dc8078 ("locking/mutexes: Unlock the mutex without the wait_lock")

generates this boot warning when CONFIG_DEBUG_MUTEXES=y:

  WARNING: CPU: 0 PID: 139 at /usr/src/linux-2.6/kernel/locking/mutex-debug.c:82 debug_mutex_unlock+0x155/0x180() DEBUG_LOCKS_WARN_ON(lock->owner != current)

And that makes sense, because as soon as we release the lock a
new owner can come in...

One would think that !__mutex_slowpath_needs_to_unlock()
implementations suffer the same, but for DEBUG we fall back to
mutex-null.h which has an unconditional 1 for that.

The mutex debug code requires the mutex to be unlocked after
doing the debug checks, otherwise it can find inconsistent
state.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: jason.low2@hp.com
Link: http://lkml.kernel.org/r/20140312122442.GB27965@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex-debug.c | 6 ++++++
 kernel/locking/mutex.c       | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
index faf6f5b..e1191c9 100644
--- a/kernel/locking/mutex-debug.c
+++ b/kernel/locking/mutex-debug.c
@@ -83,6 +83,12 @@ void debug_mutex_unlock(struct mutex *lock)
 
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
 	mutex_clear_owner(lock);
+
+	/*
+	 * __mutex_slowpath_needs_to_unlock() is explicitly 0 for debug
+	 * mutexes so that we can do it here after we've verified state.
+	 */
+	atomic_set(&lock->count, 1);
 }
 
 void debug_mutex_init(struct mutex *lock, const char *name,
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 02c61a9..14fe72c 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -34,6 +34,13 @@
 #ifdef CONFIG_DEBUG_MUTEXES
 # include "mutex-debug.h"
 # include <asm-generic/mutex-null.h>
+/*
+ * Must be 0 for the debug case so we do not do the unlock outside of the
+ * wait_lock region. debug_mutex_unlock() will do the actual unlock in this
+ * case.
+ */
+# undef __mutex_slowpath_needs_to_unlock
+# define  __mutex_slowpath_needs_to_unlock()	0
 #else
 # include "mutex.h"
 # include <asm/mutex.h>
