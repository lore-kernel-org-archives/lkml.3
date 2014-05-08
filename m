Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaEHLsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 07:48:09 -0400
Received: from mail.efficios.com ([78.47.125.74]:45346 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbaEHLsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 07:48:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sasha Levin <sasha.levin@oracle.com>, Oleg Nesterov <oleg@redhat.com>,
        Dave Jones <davej@redhat.com>
Subject: [PATCH] Fix: tracepoint: use after rcu free
Date: Thu,  8 May 2014 07:47:49 -0400
Message-Id: <1399549669-25465-1-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit de7b2973903c6cc50b31ee5682a69b2219b9919d
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date:   Tue Apr 8 17:26:21 2014 -0400

    tracepoint: Use struct pointer instead of name hash for reg/unreg tracepoints

introduces a use after free by calling release_probes on the old struct
tracepoint array before the newly allocated array is published with
rcu_assign_pointer. There is a race window where tracepoints (RCU
readers) can perform a "use-after-grace-period-after-free", which shows
up as a GPF in stress-tests.

Link: https://lkml.org/lkml/2014/5/6/738
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Sasha Levin <sasha.levin@oracle.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Dave Jones <davej@redhat.com>
---
 kernel/tracepoint.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index ac5b23c..6620e58 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -188,7 +188,6 @@ static int tracepoint_add_func(struct tracepoint *tp,
 		WARN_ON_ONCE(1);
 		return PTR_ERR(old);
 	}
-	release_probes(old);
 
 	/*
 	 * rcu_assign_pointer has a smp_wmb() which makes sure that the new
@@ -200,6 +199,7 @@ static int tracepoint_add_func(struct tracepoint *tp,
 	rcu_assign_pointer(tp->funcs, tp_funcs);
 	if (!static_key_enabled(&tp->key))
 		static_key_slow_inc(&tp->key);
+	release_probes(old);
 	return 0;
 }
 
@@ -221,7 +221,6 @@ static int tracepoint_remove_func(struct tracepoint *tp,
 		WARN_ON_ONCE(1);
 		return PTR_ERR(old);
 	}
-	release_probes(old);
 
 	if (!tp_funcs) {
 		/* Removed last function */
@@ -232,6 +231,7 @@ static int tracepoint_remove_func(struct tracepoint *tp,
 			static_key_slow_dec(&tp->key);
 	}
 	rcu_assign_pointer(tp->funcs, tp_funcs);
+	release_probes(old);
 	return 0;
 }
 
-- 
1.7.10.4

