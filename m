Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab3AYUyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:54:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab3AYUyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:54:13 -0500
Date: Fri, 25 Jan 2013 15:30:09 -0500
From: Rik van Riel <riel@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, "Paul E. McKenney" <paulmck@us.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 7/6] kernel: document fast queue spinlocks
Message-ID: <20130125153009.209f24ba@annuminas.surriel.com>
In-Reply-To: <1358896415-28569-5-git-send-email-walken@google.com>
References: <1358896415-28569-1-git-send-email-walken@google.com>
	<1358896415-28569-5-git-send-email-walken@google.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the fast queue spinlocks in a way that I can understand.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
This may still not be clear to others. Please let me know if you
would like me to change/enhance the documentation, so you can
understand it too.

 kernel/queue_spinlock.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/kernel/queue_spinlock.c b/kernel/queue_spinlock.c
index b571508..dc740fe 100644
--- a/kernel/queue_spinlock.c
+++ b/kernel/queue_spinlock.c
@@ -9,6 +9,23 @@
 #include <asm/processor.h>	/* for cpu_relax() */
 #include <asm/queue_spinlock.h>
 
+/*
+ * Fast queue spinlocks use a pool of tokens, which contain the actual locks,
+ * and are continuously moved around. Every spinlock is associated with one
+ * token, and every CPU is associated with two tokens. 
+ *
+ * When taking a lock, one of the CPU's tokens is associated with the lock,
+ * and the lock's token is associated with the CPU.
+ *
+ * The token that gets associated with the spinlock at lock time will indicate
+ * the lock is busy. The token that was previously associated with the spinlock,
+ * and is now associated with the CPU taking the lock, will indicate whether
+ * the previous lock holder has already unlocked the lock.
+ *
+ * To unlock a fast ticket spinlock, the CPU will unlock the token that it
+ * associated with the spinlock.
+ */
+
 DEFINE_PER_CPU(struct q_spinlock_token *, q_spinlock_token[2]);
 
 static inline struct q_spinlock_token *
@@ -25,8 +42,11 @@ ____q_spin_lock(struct q_spinlock *lock,
 
 	token = __this_cpu_read(*percpu_token);
 	token->wait = true;
+	/* Associate our (marked busy) token with the spinlock. */
 	prev = xchg(&lock->token, token);
+	/* The spinlock's old token is ours now. */
 	__this_cpu_write(*percpu_token, prev);
+	/* Wait for the spinlock's old token to be unlocked. */
 	while (ACCESS_ONCE(prev->wait))
 		cpu_relax();
 	q_spin_lock_mb();	/* guarantee acquire load semantics */

