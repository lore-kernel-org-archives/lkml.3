Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360AbaGSNQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:16:45 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:11686 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754859AbaGSNQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:12 -0400
Message-Id: <20140719131610.123549600@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 06/32] ftrace/x86: Add call to ftrace_graph_is_dead() in function graph code
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0006-ftrace-x86-Add-call-to-ftrace_graph_is_dead-in-funct.patch
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

Link: http://lkml.kernel.org/r/53C54D18.3020602@zytor.com

Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index cbc4a91b131e..3386dc9aa333 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -703,6 +703,9 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 	unsigned long return_hooker = (unsigned long)
 				&return_to_handler;
 
+	if (unlikely(ftrace_graph_is_dead()))
+		return;
+
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
-- 
2.0.1


