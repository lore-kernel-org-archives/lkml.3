Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaB0RJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 12:09:27 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:58947 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751663AbaB0RJ0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 12:09:26 -0500
Date: Thu, 27 Feb 2014 12:09:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [RFA][PATCH 5/5] tracepoint: Warn and notify if tracepoints are
 not loaded due to module taint
Message-ID: <20140227120925.7da36f0b@gandalf.local.home>
In-Reply-To: <1493277105.31789.1393518830647.JavaMail.zimbra@efficios.com>
References: <20140227154616.703252665@goodmis.org>
	<20140227154923.563572071@goodmis.org>
	<1493277105.31789.1393518830647.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 16:33:50 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:


> I'd recommend the following message instead:
> 
>  pr_err("Module '%s' is tainted, ignoring its tracepoints\n",
> 

Better?

-- Steve

>From 08ea384dc937d75a2a1444a06c3e4553bd118fc1 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Mon, 24 Feb 2014 11:06:04 -0500
Subject: [PATCH] tracepoint: Warn and notify if tracepoints are not loaded due
 to module taint

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
index 63630ae..1d33831 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -649,8 +649,12 @@ static int tracepoint_module_coming(struct module *mod)
 	 * module headers (for forced load), to make sure we don't cause a crash.
 	 * Staging and out-of-tree GPL modules are fine.
 	 */
-	if (trace_module_has_bad_taint(mod))
+	if (trace_module_has_bad_taint(mod)) {
+		pr_err("Module '%s' is tainted, ignoring its tracepoints\n",
+		       mod->name);
 		return 0;
+	}
+
 	mutex_lock(&tracepoints_mutex);
 	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);
 	if (!tp_mod) {
-- 
1.8.1.4

