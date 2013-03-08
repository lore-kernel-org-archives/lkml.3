Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760Ab3CHEip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 23:38:45 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:37305 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759661Ab3CHEhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:37:21 -0500
From: Michel Lespinasse <walken@google.com>
To: Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/5] kernel: add tasklist_{read,write}_lock{,_any} helper functions
Date: Thu,  7 Mar 2013 20:37:13 -0800
Message-Id: <1362717437-1729-2-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362717437-1729-1-git-send-email-walken@google.com>
References: <1362717437-1729-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tasklist_{read,write}_lock{,_any} functions to acquire/release the
tasklist_lock.

The _any variants may be called from any context, while the others must
be called from process context only.

One of the objectives here is to add explicit annotations for this.
If the call sites for the _any variants could be eliminated somehow,
all remaining tasklist_lock acquisitions would be in process context
so we wouldn't have to use an unfair rwlock_t implementation anymore.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 include/linux/sched.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ac8dbca5ea15..4eb58b796261 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -218,6 +218,7 @@ extern char ___assert_task_state[1 - 2*!!(
 #define TASK_COMM_LEN 16
 
 #include <linux/spinlock.h>
+#include <linux/hardirq.h>
 
 /*
  * This serializes "schedule()" and also protects
@@ -228,6 +229,43 @@ extern char ___assert_task_state[1 - 2*!!(
 extern rwlock_t tasklist_lock;
 extern spinlock_t mmlist_lock;
 
+static inline void tasklist_write_lock(void)
+{
+	WARN_ON_ONCE(in_serving_softirq() || in_irq() || in_nmi());
+	write_lock_irq(&tasklist_lock);
+}
+
+static inline void tasklist_write_unlock(void)
+{
+	write_unlock_irq(&tasklist_lock);
+}
+
+static inline void tasklist_read_lock(void)
+{
+	WARN_ON_ONCE(in_serving_softirq() || in_irq() || in_nmi());
+	read_lock(&tasklist_lock);
+}
+
+static inline void tasklist_read_unlock(void)
+{
+	read_unlock(&tasklist_lock);
+}
+
+static inline void tasklist_read_lock_any(void)
+{
+	read_lock(&tasklist_lock);
+}
+
+static inline int tasklist_read_trylock_any(void)
+{
+	return read_trylock(&tasklist_lock);
+}
+
+static inline void tasklist_read_unlock_any(void)
+{
+	read_unlock(&tasklist_lock);
+}
+
 struct task_struct;
 
 #ifdef CONFIG_PROVE_RCU
-- 
1.8.1.3
