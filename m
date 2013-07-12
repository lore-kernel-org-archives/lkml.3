Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3GLCi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 22:38:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17434 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab3GLCi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 22:38:57 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=TyVgHLz5XD0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=oLtpoGhtZv4A:10 a=LcwtFZqVcudtIxIXw7UA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373596735.17876.84.camel@gandalf.local.home>
Subject: Re: [PATCH] kernel: trace: remove __init from
 race_selftest_startup_function() and trace_selftest_startup_function_graph()
From: Steven Rostedt <rostedt@goodmis.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 11 Jul 2013 22:38:55 -0400
In-Reply-To: <51DF62DB.3010409@asianux.com>
References: <51DDFCF8.2090808@asianux.com>
	  <1373561279.17876.45.camel@gandalf.local.home>
	  <51DF44FA.9060000@asianux.com>
	 <1373593261.17876.61.camel@gandalf.local.home>
	 <51DF62DB.3010409@asianux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 09:58 +0800, Chen Gang wrote:
> On 07/12/2013 09:41 AM, Steven Rostedt wrote:
> > On Fri, 2013-07-12 at 07:51 +0800, Chen Gang wrote:
> > 
> >> > Hmm, can all trace_selftest_startup_* (*selftest* in trace_selftest.c)
> >> > use '__init', so not waste memory keeping them around ?
> > Yeah, they should all be set to __init, but that's pretty low on the
> > totem poll, as distros don't enable selftests in their main kernels.
> 
> Excuse me, my English is not quite well, I guess your meaning is:
> 
>   they should all be set to '__init', although it is minor in real world.
> 
> Is it correct ?

Correct.

> 
> 
> For me, I recommend to let all *selftest* as the same: "all add '
> __init' or none add '__init'" (if choose add, all report warnings).
> 
> Is it suitable to still send new related patch for it ? If so, could
> you provide your suggesting choice (all add, or none add) ?

Does this patch fix your warning?

-- Steve

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index a4ed382..5e794d1 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -680,6 +680,15 @@ extern int trace_selftest_startup_sched_switch(struct tracer *trace,
 					       struct trace_array *tr);
 extern int trace_selftest_startup_branch(struct tracer *trace,
 					 struct trace_array *tr);
+/*
+ * Tracer data references selftest functions that only occur
+ * on boot up. These can be __init functions. Thus, when selftests
+ * are enabled, then the tracers need to reference __init functions.
+ */
+#define __tracer_data		__refdata
+#else
+/* Tracers are seldom changed. Optimize when selftests are disabled. */
+#define __tracer_data		__read_mostly
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
 
 extern void *head_page(struct trace_array_cpu *data);
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index b863f93..38fe148 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -199,7 +199,7 @@ static int func_set_flag(u32 old_flags, u32 bit, int set)
 	return 0;
 }
 
-static struct tracer function_trace __read_mostly =
+static struct tracer function_trace __tracer_data =
 {
 	.name		= "function",
 	.init		= function_trace_init,


