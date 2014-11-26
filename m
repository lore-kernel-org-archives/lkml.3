Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaKZRh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:37:27 -0500
Received: from www.linutronix.de ([62.245.132.108]:52287 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaKZRhZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:37:25 -0500
Date: Wed, 26 Nov 2014 18:37:21 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Alexandre Montplaisir <alexmonthy@voxpopuli.im>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Trace Compass Developer Discussions 
	<tracecompass-dev@eclipse.org>,
        matthew.khouzam@ericsson.com, andreas@linutronix.de
Subject: Re: Support for Perf CTF traces now in master (was Re: FW: [RFC 0/5]
 perf tools: Add perf data CTF conversion)
Message-ID: <20141126173721.GA6829@linutronix.de>
References: <53F38C74.4030300@voxpopuli.im>
 <20140820092858.GA1203@krava.brq.redhat.com>
 <53F4F38C.4080407@voxpopuli.im>
 <5457C259.8030605@linutronix.de>
 <545829CA.7040900@voxpopuli.im>
 <20141105125028.GA30087@linutronix.de>
 <545AEA37.601@voxpopuli.im>
 <5460156E.3050601@voxpopuli.im>
 <5463DBD5.9080303@voxpopuli.im>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5463DBD5.9080303@voxpopuli.im>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexandre Montplaisir | 2014-11-12 17:14:45 [-0500]:

>Just a quick note, this branch is now merged to master. So anyone who
>pulls the code from the master branch at
>git://git.eclipse.org/gitroot/tracecompass/org.eclipse.tracecompass.git
>should be able to load perf-CTF traces in the viewer. The trace type
>is now called "Common Trace Format -> Linux Kernel Trace" and should
>support both LTTng kernel and perf traces in CTF format (although
>auto-detection should work in most cases).

Thank you for all the work.
Let me try to reply to the emails at once here:
- I added to the environment metadata the following (comparing to the 
  last version):
   domain => kernel
   tracer_name => perf

  There is no tracer_major + minor. Instead I added
      version => perf's version
  On my system I have:
     release = "3.16.0-4-amd64";
     version = "3.18.rc3.g91405a";

  Because I run Debian's v3.16 and recorded the trace with perf from the
  kernel 3.18.rc3.
  There is no version of perf doing the convert of perf.data => ctf.
  Any objections, rename of the version member?

- Mathieu decided that it makes no sense to add the kernel version to 
  each event we trace. Instead each event should have its own version 
  with a major/minor member. Once the event is changed the "ABI" 
  version should be adjusted. I second this since it makes sense.
  Therefore there are no changes that were made to the converter.

- Alexandre (you) noticed that there are syscall names in the events
  recorded via "sys_enter and sys_exit". This is true, but there is a
  hint. There is an event for instance:

[03:37:07.579969498] (+?.?????????) raw_syscalls:sys_enter: { cpu_id = 2 }, { perf_ip = 0xFFFFFFFF81020EBC, perf_tid = 30004, perf_pid = 30004, perf_id = 382, perf_period = 1, common_type = 76, common_flags = 0, common_preempt_count = 0, common_pid = 30004, id = 16, args = [ [0] = 0xE, [1] = 0x2400, [2] = 0x0, [3] = 0x0, [4] = 0xA20F00, [5] = 0xA1FDA0 ] }

  By the end you notice id=16 and args. args are the Arguments passed 
  to syscall and id is the syscall number. Together with machine = 
  x86_64 you know which architecture you need to lookup the number 16.
  The numbers are from unistd.h (and may be different between architectures,
  even between i386 & x86_64). strace has for instance the following [0] table.

{ 3,    TD, sys_read,       "read"      },  /* 0 */
…
{ 3,    TD, sys_ioctl,      "ioctl"     },  /* 16 */
…

So 16 is ioctl. strace has those tables for a bunch of architectures 
so it might be helpful to suck them in. I know no other way to ease
things here.

[0] https://github.com/bnoordhuis/strace/blob/master/linux/x86_64/syscallent.h

The same thing is true for softirq_entry events for instance. This event
will give you you only vec=9 and you need to lookup that 9 => RCU. That
one is easy however:

 const char * const softirq_to_name[NR_SOFTIRQS] = {
         "HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
         "TASKLET", "SCHED", "HRTIMER", "RCU"
 };

this has been taken from kernel/softirq.c. 

>This was based on the most recent file format I was aware of, we will
>update it accordingly if required.
>
>Testing welcome!

I pushed the perf changes I mentioned to 

  git://git.breakpoint.cc/bigeasy/linux.git ctf_convert_7

It is now based on Arnaldo's perf/core. If everything goes well from 
the compass side and nobody complains here in any way, the next step 
would be to present the patches on the mailing list and compass as a
user.

I took you tree and added the patch below. I uploaded the following
files to https://breakpoint.cc/perf-ctf/:
- ctf-out6.tar.xz from perf6.data.xz 
  shows nothing

- ctf-out7.tar.xz from perf7.data.xz
  shows something

The only obvious difference is the size of the CTF data. The size of out6
is almost 300MiB and it contains 3,259,929 events. The out7 is has only
15MiB and contains 152,900 events.

>Cheers,
>Alexandre

✂

>From 7ffa619d918f2010046b391ae29063ffc5329468 Mon Sep 17 00:00:00 2001
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Wed, 26 Nov 2014 18:04:53 +0100
Subject: [PATCH] CTF: use tracer_name for perf-CTF traces

domain will be set to kernel for both, perf and lttng traces. The
tracer_name will be set to perf if the trace is generated by perf and
otherwise lttng-modules if created by thet lttng tool.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 .../tracecompass/lttng2/kernel/core/trace/LttngKernelTrace.java      | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/org.eclipse.tracecompass.lttng2.kernel.core/src/org/eclipse/tracecompass/lttng2/kernel/core/trace/LttngKernelTrace.java b/org.eclipse.tracecompass.lttng2.kernel.core/src/org/eclipse/tracecompass/lttng2/kernel/core/trace/LttngKernelTrace.java
index a58269f..03a09b9 100644
--- a/org.eclipse.tracecompass.lttng2.kernel.core/src/org/eclipse/tracecompass/lttng2/kernel/core/trace/LttngKernelTrace.java
+++ b/org.eclipse.tracecompass.lttng2.kernel.core/src/org/eclipse/tracecompass/lttng2/kernel/core/trace/LttngKernelTrace.java
@@ -96,12 +96,11 @@ public class LttngKernelTrace extends CtfTmfTrace {
          * metadata
          */
         Map<String, String> traceEnv = this.getCTFTrace().getEnvironment();
-        String domain = traceEnv.get("domain"); //$NON-NLS-1$
         String tracerName = traceEnv.get("tracer_name"); //$NON-NLS-1$
         String tracerMajor = traceEnv.get("tracer_major"); //$NON-NLS-1$
         String tracerMinor = traceEnv.get("tracer_minor"); //$NON-NLS-1$
 
-        if ("\"kernel-perf\"".equals(domain)) { //$NON-NLS-1$
+        if ("\"perf\"".equals(tracerName)) { //$NON-NLS-1$
             fOriginTracer = OriginTracer.PERF;
 
         } else if ("\"lttng-modules\"".equals(tracerName) && //$NON-NLS-1$
@@ -130,7 +129,7 @@ public class LttngKernelTrace extends CtfTmfTrace {
             CTFTrace temp = new CTFTrace(path);
             /* Make sure the domain is "kernel" in the trace's env vars */
             String dom = temp.getEnvironment().get("domain"); //$NON-NLS-1$
-            if (dom != null && dom.startsWith("\"kernel")) { //$NON-NLS-1$
+            if (dom != null && dom.equals("\"kernel\"")) { //$NON-NLS-1$
                 return new TraceValidationStatus(CONFIDENCE, Activator.PLUGIN_ID);
             }
             return new Status(IStatus.ERROR, Activator.PLUGIN_ID, Messages.LttngKernelTrace_DomainError);
-- 
2.1.3

Sebastian
