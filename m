Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaB0Pth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:49:37 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:22166 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752589AbaB0Pt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:49:27 -0500
Message-Id: <20140227154923.563572071@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 27 Feb 2014 10:46:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        <stable@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFA][PATCH 5/5] tracepoint: Warn and notify if tracepoints are not loaded due to
 module taint
References: <20140227154616.703252665@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0005-tracepoint-Warn-and-notify-if-tracepoints-are-not-lo.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Request for Ack ]

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If a module is loaded that is tainted with anything but OOT or CRAP, then
it will not create the tracepoint infrastructure for the module. The user needs
to be warned when this happens instead of exiting silently.

Fixes: 97e1c18e8d17 "tracing: Kernel Tracepoints"
Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/tracepoint.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 63630ae..a65af20 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -649,8 +649,12 @@ static int tracepoint_module_coming(struct module *mod)
 	 * module headers (for forced load), to make sure we don't cause a crash.
 	 * Staging and out-of-tree GPL modules are fine.
 	 */
-	if (trace_module_has_bad_taint(mod))
+	if (trace_module_has_bad_taint(mod)) {
+		pr_err("Module '%s' is tainted, disabling tracepoints\n",
+		       mod->name);
 		return 0;
+	}
+
 	mutex_lock(&tracepoints_mutex);
 	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);
 	if (!tp_mod) {
-- 
1.8.5.3


