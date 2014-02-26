Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaBZAaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:30:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:16541 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751785AbaBZAaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:30:21 -0500
X-Greylist: delayed 35180 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Feb 2014 19:30:20 EST
Date: Tue, 25 Feb 2014 19:15:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH] tracing: Warn and notify if tracepoints are not loaded
 due to module taint
Message-ID: <20140225191505.32b56105@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Posting this as an RFC, but I plan on pushing it as soon as I finish
testing it ]

If a module is loaded that is tainted with anything but OOT or CRAP, then
it will not create the traceoint infrastructure for the module. There should
be a big warning when this happens instead of exiting silently.

Fixes: 97e1c18e8d17 "tracing: Kernel Tracepoints"
Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/tracepoint.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 29f2654..413bc06 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -641,7 +641,8 @@ static int tracepoint_module_coming(struct module *mod)
 	 * module headers (for forced load), to make sure we don't cause a crash.
 	 * Staging and out-of-tree GPL modules are fine.
 	 */
-	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)))
+	if (WARN_ONCE(mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)),
+		      "Module is tainted, disabling tracepoints"))
 		return 0;
 	mutex_lock(&tracepoints_mutex);
 	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);
-- 
1.8.5.3

