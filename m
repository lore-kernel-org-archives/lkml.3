Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaBZQDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:03:16 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:27855 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751170AbaBZQDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:03:15 -0500
Date: Wed, 26 Feb 2014 11:03:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH] tracepoint: Do not waste memory on mods with no
 tracepoints
Message-ID: <20140226110313.4d92fb83@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No reason to allocate tp_module structures for modules that have no
tracepoints. This just wastes memory.

Fixes: b75ef8b44b1c "Tracepoint: Dissociate from module mutex"
Cc: stable@vger.kernel.org # 3.2+
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/tracepoint.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 29f2654..0d4ef26 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -636,6 +636,9 @@ static int tracepoint_module_coming(struct module *mod)
 	struct tp_module *tp_mod, *iter;
 	int ret = 0;
 
+	if (!mod->num_tracepoints)
+		return 0;
+
 	/*
 	 * We skip modules that taint the kernel, especially those with different
 	 * module headers (for forced load), to make sure we don't cause a crash.
@@ -679,6 +682,9 @@ static int tracepoint_module_going(struct module *mod)
 {
 	struct tp_module *pos;
 
+	if (!mod->num_tracepoints)
+		return 0;
+
 	mutex_lock(&tracepoints_mutex);
 	tracepoint_update_probe_range(mod->tracepoints_ptrs,
 		mod->tracepoints_ptrs + mod->num_tracepoints);
-- 
1.8.1.4

