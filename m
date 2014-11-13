Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934180AbaKMT2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:28:24 -0500
Received: from mail-yk0-f178.google.com ([209.85.160.178]:48375 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933528AbaKMTZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:25:22 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 08/16] rcupdate: Replace smp_read_barrier_depends() with lockless_dereference()
Date: Thu, 13 Nov 2014 14:24:14 -0500
Message-Id: <1415906662-4576-9-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). The following PATCH makes the change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/linux/rcupdate.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ed4f593..386ba28 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -582,11 +582,11 @@ static inline void rcu_preempt_sleep_check(void)
 })
 #define __rcu_dereference_check(p, c, space) \
 ({ \
-	typeof(*p) *_________p1 = (typeof(*p) *__force)ACCESS_ONCE(p); \
+	/* Dependency order vs. p above. */ \
+	typeof(*p) *________p1 = (typeof(*p) *__force)lockless_dereference(p); \
 	rcu_lockdep_assert(c, "suspicious rcu_dereference_check() usage"); \
 	rcu_dereference_sparse(p, space); \
-	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
-	((typeof(*p) __force __kernel *)(_________p1)); \
+	((typeof(*p) __force __kernel *)(________p1)); \
 })
 #define __rcu_dereference_protected(p, c, space) \
 ({ \
@@ -603,10 +603,10 @@ static inline void rcu_preempt_sleep_check(void)
 })
 #define __rcu_dereference_index_check(p, c) \
 ({ \
-	typeof(p) _________p1 = ACCESS_ONCE(p); \
+	/* Dependency order vs. p above. */ \
+	typeof(p) _________p1 = lockless_dereference(p); \
 	rcu_lockdep_assert(c, \
 			   "suspicious rcu_dereference_index_check() usage"); \
-	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
 	(_________p1); \
 })
 
-- 
1.9.1

