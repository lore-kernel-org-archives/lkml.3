Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3KER6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:58:36 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59110 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3KER6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:58:20 -0500
Date: Tue, 5 Nov 2013 13:06:23 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Ingo Molnar <mingo@kernel.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dave Jones <davej@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: perf/ftrace lockup on 3.12-rc6 with trigger code
In-Reply-To: <20131026084836.GC14237@gmail.com>
Message-ID: <alpine.DEB.2.10.1311051259370.22719@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1310241324330.4352@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1310241422460.6573@vincent-weaver-1.um.maine.edu> <1382695687.12254.4.camel@pippen.local.home> <alpine.DEB.2.10.1310250906110.22710@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1310251726001.31246@vincent-weaver-1.um.maine.edu> <20131026084836.GC14237@gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


short summary: the check for root-only ftrace use is wrong


OK, so after wasting a lot of time on this, the underlying bug is just
that with the settings chosen by the fuzzer, the kernel gets stuck.
The function tracer keeps the CPU busy until interrupted by an interrupt, 
which is then traced, but then another interrupt comes, etc, etc, and the 
code never makes progress outside of the kernel.

So I was going to make the argument that this interface should be made 
root only, because it is too easy for a regular user to trigger this and
DoS a machine.

But I did some digging, and the initial commit for 3.4 had this:

commit ced39002f5ea736b716ae233fb68b26d59783912
Author: Jiri Olsa <jolsa@redhat.com>
Date:   Wed Feb 15 15:51:52 2012 +0100

....

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index d72af0b..fdeeb5c 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -24,6 +24,11 @@ static int   total_ref_count;
 static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
                                 struct perf_event *p_event)
 {
+       /* The ftrace function trace is allowed only for root. */
+       if (ftrace_event_is_function(tp_event) &&
+           perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+               return -EPERM;
+

The intention was to only allow root, but the check is wrong.

The poorly named
	perf_paranoid_kernel()

does

static inline bool perf_paranoid_kernel(void)
{
         return sysctl_perf_event_paranoid > 1;
}

But the "default" setting for paranoid is "1" (user and kernel access 
allowed).

So the ftrace check never triggers EPERM unless someone has configured 
paranoid to be the higher "2" value (user perf use only).

So this check should be fixed and propogated to stable and this bug that 
keeps crashing all the fuzzers will become a much less critical "root 
only" bug.

Vince
