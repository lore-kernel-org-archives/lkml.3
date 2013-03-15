Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab3COTzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:55:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18130 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab3COTvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:24 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Fys9Do3HPPwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=uRXPymCsUBYA:10 a=MJK-I7ubaS4zwoti6WIA:9 a=QEXdDO2ut3YA:10 a=_bU_HdracCP6Y5SxxbAA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315193935.359219613@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 00/20] tracing: function triggers, stack tracer fixes, clocks and documenation
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Here's another set of patches.

Mostly I updated the function triggers. You know the kind:

 echo bad_area_nosemaphore:traceoff > set_ftrace_filter

I cleaned up the code and also added a few more triggers.
What we already had was just traceon and traceoff. These turn on and
off tracing when a function is hit.

What was added was:

 snapshot:  Take a snapshot of the buffer (swap buffers with the live
	    and "snapshot" buffer) when a function is hit. Note, it
	    will not snapshot in an NMI.

 stacktrace: Write the current kernel stacktrace into the ring buffer.

 enable_event: Enable a specified event to start tracing.

 disable_event: Have a specified event to stop tracing.

I also added two new trace_clocks:

  uptime - counts jiffies since boot up and reports in nanoseconds.

  perf   - uses perf's local_clock(). This will help later when
	   perf can read ftrace buffers and can interleave them.

Finally, I updated Documentation/trace/ftrace.txt to reflect all these
changes, as well as changes that have been done since it was last updated.
That file was suffering from some major bit rot.

I'll keep these in linux-next for a while before doing my pull request
to Ingo.

Enjoy,

-- Steve


Steven Rostedt (Red Hat) (20):
      tracing: Consolidate updating of count for traceon/off
      tracing: Consolidate ftrace_trace_onoff_unreg() into callback
      ftrace: Separate unlimited probes from count limited probes
      ftrace: Fix function probe to only enable needed functions
      tracing: Add alloc/free_snapshot() to replace duplicate code
      tracing: Add snapshot trigger to function probes
      tracing: Fix comments for ftrace_event_file/call flags
      ftrace: Clean up function probe methods
      ftrace: Use manual free after synchronize_sched() not call_rcu_sched()
      tracing: Add a way to soft disable trace events
      tracing: Add function probe triggers to enable/disable events
      tracing: Add skip argument to trace_dump_stack()
      tracing: Add function probe to trigger stack traces
      tracing: Use stack of calling function for stack tracer
      tracing: Fix stack tracer with fentry use
      tracing: Remove most or all of stack tracer stack size from stack_max=
_size
      tracing: Add function-trace option to disable function tracing of lat=
ency tracers
      tracing: Add "uptime" trace clock that uses jiffies
      tracing: Add "perf" trace_clock
      tracing: Bring Documentation/trace/ftrace.txt up to date

----
 Documentation/trace/ftrace.txt    | 2097 ++++++++++++++++++++++++++-------=
----
 include/linux/ftrace.h            |    6 +-
 include/linux/ftrace_event.h      |   37 +-
 include/linux/kernel.h            |    2 +-
 include/linux/trace_clock.h       |    1 +
 include/trace/ftrace.h            |    8 +
 kernel/trace/ftrace.c             |   73 +-
 kernel/trace/trace.c              |  208 +++-
 kernel/trace/trace.h              |    1 +
 kernel/trace/trace_clock.c        |   10 +
 kernel/trace/trace_events.c       |  354 ++++++-
 kernel/trace/trace_functions.c    |  199 +++-
 kernel/trace/trace_irqsoff.c      |   67 +-
 kernel/trace/trace_sched_wakeup.c |   63 +-
 kernel/trace/trace_stack.c        |   74 +-
 15 files changed, 2418 insertions(+), 782 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u3AAoJEOdOSU1xswtMuNIIANFqoy9YFmPUvLiLhMToEChF
xfMCrXF2C9npcWWFYnU7oPL012Bv1QlxR50fQT04jiaVM0+dwvkObucfgOIu+80p
dkjs2rwtcvA3/gSQV+nf61F6U1CZnVAF1+U9Fi5916ePbz/5iZ4ywHaVjY/1UYBu
e9IrrqTI9h5/B14k9Wc37RT+T2dB2/7Gfe0yMz6/LHOoLtJVj6wz5teDLPJ7Xu5w
yXM32LzmtKuGYMSVGHEz5yep97tOThC861nLoqNvRONGvHIrJTTnSpsjGRN+Z998
wdxmP2YrmNzzeTPeVWxeiovp3QvMDcxSiLVZLBGRN2kDOQiuHV16emCbMsAWcj0=
=9rGs
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
