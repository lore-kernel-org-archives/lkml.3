Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaGSNQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:16:33 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:10810 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755114AbaGSNQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:13 -0400
Message-Id: <20140719131610.301075715@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Simek <monstr@monstr.eu>
Subject: [for-next][PATCH 07/32] microblaze: ftrace: Add call to ftrace_graph_is_dead() in function
 graph code
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0007-microblaze-ftrace-Add-call-to-ftrace_graph_is_dead-i.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

ftrace_stop() is going away as it disables parts of function tracing
that affects users that should not be affected. But ftrace_graph_stop()
is built on ftrace_stop(). Here's another example of killing all of
function tracing because something went wrong with function graph
tracing.

Instead of disabling all users of function tracing on function graph
error, disable only function graph tracing. To do this, the arch code
must call ftrace_graph_is_dead() before it implements function graph.

Link: http://lkml.kernel.org/r/53C8D874.9090601@monstr.eu

Tested-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/microblaze/kernel/ftrace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/microblaze/kernel/ftrace.c b/arch/microblaze/kernel/ftrace.c
index bbcd2533766c..fc7b48a52cd5 100644
--- a/arch/microblaze/kernel/ftrace.c
+++ b/arch/microblaze/kernel/ftrace.c
@@ -27,6 +27,9 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	unsigned long return_hooker = (unsigned long)
 				&return_to_handler;
 
+	if (unlikely(ftrace_graph_is_dead()))
+		return;
+
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
-- 
2.0.1


