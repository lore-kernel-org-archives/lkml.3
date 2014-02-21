Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbaBUNCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:02:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47685 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075AbaBUNCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 24/60] ftrace: Synchronize setting function_trace_op with ftrace_trace_function
Date: Fri, 21 Feb 2014 13:00:51 +0000
Message-Id: <1392987687-15367-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 405e1d834807e51b2ebd3dea81cb51e53fb61504 upstream.

[ Partial commit backported to 3.4. The ftrace_sync() code by this is
  required for other fixes that 3.4 needs. ]

ftrace_trace_function is a variable that holds what function will be called
directly by the assembly code (mcount). If just a single function is
registered and it handles recursion itself, then the assembly will call that
function directly without any helper function. It also passes in the
ftrace_op that was registered with the callback. The ftrace_op to send is
stored in the function_trace_op variable.

The ftrace_trace_function and function_trace_op needs to be coordinated such
that the called callback wont be called with the wrong ftrace_op, otherwise
bad things can happen if it expected a different op. Luckily, there's no
callback that doesn't use the helper functions that requires this. But
there soon will be and this needs to be fixed.

Use a set_function_trace_op to store the ftrace_op to set the
function_trace_op to when it is safe to do so (during the update function
within the breakpoint or stop machine calls). Or if dynamic ftrace is not
being used (static tracing) then we have to do a bit more synchronization
when the ftrace_trace_function is set as that takes affect immediately
(as oppose to dynamic ftrace doing it with the modification of the trampoline).

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/ftrace.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 524243e..6aa8159 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -222,6 +222,23 @@ static void update_global_ops(void)
 	global_ops.func = func;
 }
 
+static void ftrace_sync(struct work_struct *work)
+{
+	/*
+	 * This function is just a stub to implement a hard force
+	 * of synchronize_sched(). This requires synchronizing
+	 * tasks even in userspace and idle.
+	 *
+	 * Yes, function tracing is rude.
+	 */
+}
+
+static void ftrace_sync_ipi(void *data)
+{
+	/* Probably not needed, but do it anyway */
+	smp_rmb();
+}
+
 static void update_ftrace_function(void)
 {
 	ftrace_func_t func;
-- 
1.9.0

