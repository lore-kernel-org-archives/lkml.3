Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966628Ab3DQTXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:23:52 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:29538 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936356Ab3DQTXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:23:45 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v4 optional 4/4] mutex: back out architecture specific check for negative mutex count
Date: Wed, 17 Apr 2013 15:23:14 -0400
Message-Id: <1366226594-5506-5-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366226594-5506-1-git-send-email-Waiman.Long@hp.com>
References: <1366226594-5506-1-git-send-email-Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If it is confirmed that all the supported architectures can allow a
negative mutex count without incorrect behavior, we can then back
out the architecture specific change and allow the mutex count to
go to any negative number. That should further reduce contention for
non-x86 architecture.

If this is not the case, this patch should be dropped.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/include/asm/mutex.h |   10 ----------
 kernel/mutex.c               |    9 ++-------
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
-- 
1.7.1

