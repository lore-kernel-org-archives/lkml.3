Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaBRXgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:36:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaBRWp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:45:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: [PATCH 3.4 11/24] ftrace: Synchronize setting function_trace_op with ftrace_trace_function
Date: Tue, 18 Feb 2014 14:46:58 -0800
Message-Id: <20140218224550.547989367@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224550.221535225@linuxfoundation.org>
References: <20140218224550.221535225@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

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


