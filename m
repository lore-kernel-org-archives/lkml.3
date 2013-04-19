Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab3DSJBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:01:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47841 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab3DSJBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:01:18 -0400
Date: Fri, 19 Apr 2013 02:00:57 -0700
From: tip-bot for Waiman Long <tipbot@zytor.com>
Message-ID: <tip-cc189d2513d1f45cde87a9043fe3be28559c7490@git.kernel.org>
Cc: mingo@kernel.org, williams@redhat.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        Waiman.Long@hp.com, akpm@linux-foundation.org, tglx@linutronix.de,
        scott.norton@hp.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        davidlohr.bueso@hp.com, davej@redhat.com, paulmck@linux.vnet.ibm.com,
        dhowells@redhat.com, aswin@hp.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, williams@redhat.com, peterz@infradead.org,
        riel@redhat.com, Waiman.Long@hp.com, akpm@linux-foundation.org,
        tglx@linutronix.de, scott.norton@hp.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, davidlohr.bueso@hp.com, davej@redhat.com,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com, aswin@hp.com
In-Reply-To: <1366226594-5506-5-git-send-email-Waiman.Long@hp.com>
References: <1366226594-5506-5-git-send-email-Waiman.Long@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] mutex:
  Back out architecture specific check for negative mutex count
Git-Commit-ID: cc189d2513d1f45cde87a9043fe3be28559c7490
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Apr 2013 02:01:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc189d2513d1f45cde87a9043fe3be28559c7490
Gitweb:     http://git.kernel.org/tip/cc189d2513d1f45cde87a9043fe3be28559c7490
Author:     Waiman Long <Waiman.Long@hp.com>
AuthorDate: Wed, 17 Apr 2013 15:23:14 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Apr 2013 09:33:36 +0200

mutex: Back out architecture specific check for negative mutex count

Linus suggested that probably all the supported architectures can
allow a negative mutex count without incorrect behavior, so we can
then back out the architecture specific change and allow the
mutex count to go to any negative number. That should further
reduce contention for non-x86 architecture.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Chandramouleeswaran Aswin <aswin@hp.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Norton Scott J <scott.norton@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1366226594-5506-5-git-send-email-Waiman.Long@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/mutex.h | 10 ----------
 kernel/mutex.c               |  9 ++-------
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/mutex.h b/arch/x86/include/asm/mutex.h
index bc2a0b0..7d3a482 100644
--- a/arch/x86/include/asm/mutex.h
+++ b/arch/x86/include/asm/mutex.h
@@ -3,13 +3,3 @@
 #else
 # include <asm/mutex_64.h>
 #endif
-
-#ifndef	__ASM_MUTEX_H
-#define	__ASM_MUTEX_H
-/*
- * For the x86 architecture, it allows any negative number (besides -1) in
- * the mutex count to indicate that some other threads are waiting on the
- * mutex.
- */
-#define __ARCH_ALLOW_ANY_NEGATIVE_MUTEX_COUNT	1
-#endif
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 1dbd421..ad53a66 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -38,15 +38,10 @@
 #endif
 
 /*
- * A mutex count of -1 indicates that waiters are sleeping waiting for the
- * mutex. Some architectures can allow any negative number, not just -1, for
- * this purpose.
+ * A negative mutex count indicates that waiters are sleeping waiting for the
+ * mutex.
  */
-#ifdef __ARCH_ALLOW_ANY_NEGATIVE_MUTEX_COUNT
 #define	MUTEX_SHOW_NO_WAITER(mutex)	(atomic_read(&(mutex)->count) >= 0)
-#else
-#define	MUTEX_SHOW_NO_WAITER(mutex)	(atomic_read(&(mutex)->count) != -1)
-#endif
 
 void
 __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
