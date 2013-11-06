Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3KFTr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:47:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:41822 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753042Ab3KFTrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:47:55 -0500
Date: Wed, 6 Nov 2013 14:47:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        stable <stable@vger.kernel.org>, Kees Cook <keescook@google.com>
Subject: Re: [GIT PULL][PATCH] perf/ftrace: Fix paranoid level for enabling
 function tracer
Message-ID: <20131106144753.0ec28187@gandalf.local.home>
In-Reply-To: <20131106094649.4abc704f@gandalf.local.home>
References: <20131105162407.59393ee1@gandalf.local.home>
	<20131106094649.4abc704f@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013 09:46:49 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> As I usually send you signed tag pull releases, I made one of those too:
> 
> 

I just included Vince's tested-by tag. Here's a new tag you can pull.

-- Steve


Linus,

Please pull the latest ftrace-urgent-3.12-v2 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
ftrace-urgent-3.12-v2

Tag SHA1: 84665f63eaea429fc56c9bc8c1b4e2da1ed697d5
Head SHA1: 12ae030d54ef250706da5642fc7697cc60ad0df7


Steven Rostedt (1):
      perf/ftrace: Fix paranoid level for enabling function tracer

----
 kernel/trace/trace_event_perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---------------------------
commit 12ae030d54ef250706da5642fc7697cc60ad0df7
Author: Steven Rostedt <rostedt@goodmis.org>
Date:   Tue Nov 5 12:51:11 2013 -0500

    perf/ftrace: Fix paranoid level for enabling function tracer
    
    The current default perf paranoid level is "1" which has
    "perf_paranoid_kernel()" return false, and giving any operations that
    use it, access to normal users. Unfortunately, this includes function
    tracing and normal users should not be allowed to enable function
    tracing by default.
    
    The proper level is defined at "-1" (full perf access), which
    "perf_paranoid_tracepoint_raw()" will only give access to. Use that
    check instead for enabling function tracing.
    
    Reported-by: Dave Jones <davej@redhat.com>
    Reported-by: Vince Weaver <vincent.weaver@maine.edu>
    Tested-by: Vince Weaver <vincent.weaver@maine.edu>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Ingo Molnar <mingo@kernel.org>
    Cc: Jiri Olsa <jolsa@redhat.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: stable@vger.kernel.org # 3.4+
    CVE: CVE-2013-2930
    Fixes: ced39002f5ea ("ftrace, perf: Add support to use function tracepoint in perf")
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 80c36bc..78e27e3 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -26,7 +26,7 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 {
 	/* The ftrace function trace is allowed only for root. */
 	if (ftrace_event_is_function(tp_event) &&
-	    perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+	    perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* No tracing, just counting, so no obvious leak */
