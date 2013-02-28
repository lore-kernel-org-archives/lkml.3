Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab3B1DXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 22:23:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21214 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab3B1DX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 22:23:27 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=6sTwnNPpnDYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=dkBOD8IEPmgA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=L8gsoqZCD2LpnyAUK58A:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362021805.1231.18.camel@gandalf.local.home>
Subject: [PATCH][3.9] ftrace: Update the kconfig for DYNAMIC_FTRACE
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Ezequiel Garcia <elezegarcia@gmail.com>
Date: Wed, 27 Feb 2013 22:23:25 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

At ELC I watched a presentation by Ezequiel about a tool he wrote to
analyze memory wasted by kmalloc and friends. He incorrectly stated that
you need to enable DYNAMIC_FTRACE in order to get events. I pointed out
that this was incorrect, but he showed me that the prompt for
DYNAMIC_FTRACE said it enabled/disabled ftrace tracepoints dynamically.
And sure enough, it did say that. But this was written when ftrace was
first created and hasn't been updated since. It was written well before
tracepoints made it into the kernel. Heck, it even references that damn
daemon!

As the merge window is still opened, and even if it wasn't, this fix
should go mainline ASAP. It should also go into stable. This is
definitely a bug. It may only be documentation (which means it's low
risk to add), but it's documentation on how to set up your kernel, and
that being wrong creates unexpected results for the user. Just like any
other bug would.

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: db05021d49a994ee40a9735d9c3cb0060c9babb8


Steven Rostedt (1):
      ftrace: Update the kconfig for DYNAMIC_FTRACE

----
 kernel/trace/Kconfig |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)
---------------------------
commit db05021d49a994ee40a9735d9c3cb0060c9babb8
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Feb 27 21:48:09 2013 -0500

    ftrace: Update the kconfig for DYNAMIC_FTRACE
    
    The prompt to enable DYNAMIC_FTRACE (the ability to nop and
    enable function tracing at run time) had a confusing statement:
    
     "enable/disable ftrace tracepoints dynamically"
    
    This was written before tracepoints were added to the kernel,
    but now that tracepoints have been added, this is very confusing
    and has confused people enough to give wrong information during
    presentations.
    
    Not only that, I looked at the help text, and it still references
    that dreaded daemon that use to wake up once a second to update
    the nop locations and brick NICs, that hasn't been around for over
    five years.
    
    Time to bring the text up to the current decade.
    
    Cc: stable@vger.kernel.org
    Reported-by: Ezequiel Garcia <elezegarcia@gmail.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 3656756..b516a8e 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -429,24 +429,28 @@ config PROBE_EVENTS
 	def_bool n
 
 config DYNAMIC_FTRACE
-	bool "enable/disable ftrace tracepoints dynamically"
+	bool "enable/disable function tracing dynamically"
 	depends on FUNCTION_TRACER
 	depends on HAVE_DYNAMIC_FTRACE
 	default y
 	help
-          This option will modify all the calls to ftrace dynamically
-	  (will patch them out of the binary image and replace them
-	  with a No-Op instruction) as they are called. A table is
-	  created to dynamically enable them again.
+	  This option will modify all the calls to function tracing
+	  dynamically (will patch them out of the binary image and
+	  replace them with a No-Op instruction) on boot up. During
+	  compile time, a table is made of all the locations that ftrace
+	  can function trace, and this table is linked into the kernel
+	  image. When this is enabled, functions can be individually
+	  enabled, and the functions not enabled will not affect
+	  performance of the system.
+
+	  See the files in /sys/kernel/debug/tracing:
+	    available_filter_functions
+	    set_ftrace_filter
+	    set_ftrace_notrace
 
 	  This way a CONFIG_FUNCTION_TRACER kernel is slightly larger, but
 	  otherwise has native performance as long as no tracing is active.
 
-	  The changes to the code are done by a kernel thread that
-	  wakes up once a second and checks to see if any ftrace calls
-	  were made. If so, it runs stop_machine (stops all CPUS)
-	  and modifies the code to jump over the call to ftrace.
-
 config DYNAMIC_FTRACE_WITH_REGS
 	def_bool y
 	depends on DYNAMIC_FTRACE


