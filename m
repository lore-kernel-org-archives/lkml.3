Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbaFZQ67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:58:59 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:30172 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757790AbaFZQ6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:58:52 -0400
Message-Id: <20140626165851.536020319@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 12:52:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: [RFA][PATCH 15/27] ftrace: Remove check for HAVE_FUNCTION_TRACE_MCOUNT_TEST
References: <20140626165221.736847419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0015-ftrace-Remove-check-for-HAVE_FUNCTION_TRACE_MCOUNT_T.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

function_trace_stop is no longer used to disable function tracing.
This means that archs are no longer limited if it does not support
checking this variable in the mcount trampoline.

No need to use the list_func for archs that do not support this
obsolete method.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace-design.txt | 26 --------------------------
 include/linux/ftrace.h                |  3 +--
 2 files changed, 1 insertion(+), 28 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index 3f669b9e8852..dd5f916b351d 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -102,30 +102,6 @@ extern void mcount(void);
 EXPORT_SYMBOL(mcount);
 
 
-HAVE_FUNCTION_TRACE_MCOUNT_TEST
--------------------------------
-
-This is an optional optimization for the normal case when tracing is turned off
-in the system.  If you do not enable this Kconfig option, the common ftrace
-code will take care of doing the checking for you.
-
-To support this feature, you only need to check the function_trace_stop
-variable in the mcount function.  If it is non-zero, there is no tracing to be
-done at all, so you can return.
-
-This additional pseudo code would simply be:
-void mcount(void)
-{
-	/* save any bare state needed in order to do initial checking */
-
-+	if (function_trace_stop)
-+		return;
-
-	extern void (*ftrace_trace_function)(unsigned long, unsigned long);
-	if (ftrace_trace_function != ftrace_stub)
-...
-
-
 HAVE_FUNCTION_GRAPH_TRACER
 --------------------------
 
@@ -328,8 +304,6 @@ void mcount(void)
 
 void ftrace_caller(void)
 {
-	/* implement HAVE_FUNCTION_TRACE_MCOUNT_TEST if you desire */
-
 	/* save all state needed by the ABI (see paragraph above) */
 
 	unsigned long frompc = ...;
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index d74a37d53271..7a21d5358b74 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -33,8 +33,7 @@
  * features, then it must call an indirect function that
  * does. Or at least does enough to prevent any unwelcomed side effects.
  */
-#if !defined(CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST) || \
-	!ARCH_SUPPORTS_FTRACE_OPS
+#if !ARCH_SUPPORTS_FTRACE_OPS
 # define FTRACE_FORCE_LIST_FUNC 1
 #else
 # define FTRACE_FORCE_LIST_FUNC 0
-- 
2.0.0


