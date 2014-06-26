Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbaFZREO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:04:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:56063 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757792AbaFZQ6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:58:53 -0400
Message-Id: <20140626165849.694583919@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 12:52:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>,
        Helge Deller <deller@gmx.de>, Kyle McMartin <kyle@mcmartin.ca>
Subject: [RFA][PATCH 08/27] parisc: ftrace: Add call to ftrace_graph_is_dead() in function graph
 code
References: <20140626165221.736847419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0008-parisc-ftrace-Add-call-to-ftrace_graph_is_dead-in-fu.patch
X-RR-Connecting-IP: 107.14.168.118:25
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

Cc: Helge Deller <deller@gmx.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/parisc/kernel/ftrace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/parisc/kernel/ftrace.c b/arch/parisc/kernel/ftrace.c
index 5beb97bafbb1..5512ab32c5e0 100644
--- a/arch/parisc/kernel/ftrace.c
+++ b/arch/parisc/kernel/ftrace.c
@@ -112,6 +112,9 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	unsigned long long calltime;
 	struct ftrace_graph_ent trace;
 
+	if (unlikely(ftrace_graph_is_dead()))
+		return;
+
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
-- 
2.0.0


