Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaB0Ptc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:49:32 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:22937 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753389AbaB0Pt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:49:28 -0500
Message-Id: <20140227154923.412972313@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 27 Feb 2014 10:46:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        <stable@vger.kernel.org>
Subject: [RFA][PATCH 4/5] tracepoint: Do not waste memory on mods with no tracepoints
References: <20140227154616.703252665@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0004-tracepoint-Do-not-waste-memory-on-mods-with-no-trace.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Note, this is marked stable as the next patch requires it ]

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

No reason to allocate tp_module structures for modules that have no
tracepoints. This just wastes memory.

Fixes: b75ef8b44b1c "Tracepoint: Dissociate from module mutex"
Cc: stable@vger.kernel.org # 3.2+
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/tracepoint.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 031cc56..63630ae 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -641,6 +641,9 @@ static int tracepoint_module_coming(struct module *mod)
 	struct tp_module *tp_mod, *iter;
 	int ret = 0;
 
+	if (!mod->num_tracepoints)
+		return 0;
+
 	/*
 	 * We skip modules that taint the kernel, especially those with different
 	 * module headers (for forced load), to make sure we don't cause a crash.
@@ -684,6 +687,9 @@ static int tracepoint_module_going(struct module *mod)
 {
 	struct tp_module *pos;
 
+	if (!mod->num_tracepoints)
+		return 0;
+
 	mutex_lock(&tracepoints_mutex);
 	tracepoint_update_probe_range(mod->tracepoints_ptrs,
 		mod->tracepoints_ptrs + mod->num_tracepoints);
-- 
1.8.5.3


