Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbaEHVHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:07:53 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:51070 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755323AbaEHVHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:07:52 -0400
Message-Id: <20140508210750.480917700@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 08 May 2014 17:07:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sasha Levin <sasha.levin@oracle.com>, Oleg Nesterov <oleg@redhat.com>,
        Dave Jones <davej@redhat.com>
Subject: [PATCH 2/2] tracepoint: Fix use of tracepoint funcs after rcu free
References: <20140508210703.464573159@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracepoint-Fix-use-of-tracepoint-funcs-after-rcu-fre.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Commit de7b2973903c "tracepoint: Use struct pointer instead of name hash
for reg/unreg tracepoints" introduces a use after free by calling
release_probes on the old struct tracepoint array before the newly
allocated array is published with rcu_assign_pointer. There is a race
window where tracepoints (RCU readers) can perform a
"use-after-grace-period-after-free", which shows up as a GPF in
stress-tests.

Link: http://lkml.kernel.org/r/53698021.5020108@oracle.com
Link: http://lkml.kernel.org/p/1399549669-25465-1-git-send-email-mathieu.desnoyers@efficios.com

Reported-by: Sasha Levin <sasha.levin@oracle.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Dave Jones <davej@redhat.com>
Fixes: de7b2973903c "tracepoint: Use struct pointer instead of name hash for reg/unreg tracepoints"
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/tracepoint.c | 4 ++--
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
1.8.5.3


