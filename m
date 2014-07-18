Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966006AbaGRRgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:36:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:45175 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965869AbaGRRgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:36:17 -0400
Date: Fri, 18 Jul 2014 13:36:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        =?ISO-8859-1?B?RnLpZOlyaWM=?= Weisbecker <fweisbec@gmail.com>,
        "<m.chehab@samsung.com> Xie XiuQi" <xiexiuqi@huawei.com>
Subject: Re: [PATCH-v2] tracing: Fix wraparound problems in "uptime" tracer
Message-ID: <20140718133609.3125e72d@gandalf.local.home>
In-Reply-To: <CA+8MBb++z4px4wBCh6EzfgO6rQeLdBWNY+j8Aub352v5ONQiAw@mail.gmail.com>
References: <20140630144017.2abc48ba@gandalf.local.home>
	<b29c17f74d39d1b9240385e7479f63f44c988b8b.1404160039.git.tony.luck@intel.com>
	<CA+8MBbKgHqwzLbY17-6o_Y-EULatnXgTdgn2kUhhOabELYGV6w@mail.gmail.com>
	<20140717220849.735bec65@gandalf.local.home>
	<CA+8MBb++z4px4wBCh6EzfgO6rQeLdBWNY+j8Aub352v5ONQiAw@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014 10:05:00 -0700
Tony Luck <tony.luck@gmail.com> wrote:

> On Thu, Jul 17, 2014 at 7:08 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >> Do we really need to convert to nanoseconds? Couldn't we just return
> >> jiffies:
> >
> > Sure, and we can make it a "counter". That is, the counters don't hide
> > 1000 counts on output.
> 
> Can you explain that a bit more ... how do we mark it as a "counter"?

My mistake, I should have said, mark it as not "in_ns"...

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bda9621..291397e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -823,7 +823,7 @@ static struct {
 	{ trace_clock_local,	"local",	1 },
 	{ trace_clock_global,	"global",	1 },
 	{ trace_clock_counter,	"counter",	0 },
-	{ trace_clock_jiffies,	"uptime",	1 },
+	{ trace_clock_jiffies,	"uptime",	0 },
 	{ trace_clock,		"perf",		1 },
 	ARCH_TRACE_CLOCKS
 };

> 
> >> u64 notrace trace_clock_jiffies(void)
> >> {
> >>        return jiffies_64 - INITIAL_JIFFIES;
> >> }
> 
> Hmm it seems that we make it hard for applications to see what HZ
> value the kernel is actually using. All user-facing interfaces should
> convert to USER_HZ (100).  So we should say:

Yeah, I remember theses conversations in the past. Basically, HZ is an
internal kernel operation and userspace shouldn't know what it is,
otherwise you may have tools doing whacky things based on it.

Which is a good thing when we eventually get rid of the HZ idea.

> 
> u64 notrace trace_clock_jiffies(void)
> {
>         return jiffies_64_to_clock_t(jiffies_64 - INITIAL_JIFFIES);
> }
> 
> Do we need to change anything in Documentation/trace/ftrace.txt?
> 
> Currently it says:
> 
>           uptime: This uses the jiffies counter and the time stamp
>                   is relative to the time since boot up.

Yeah, and even if we change it to be converted, I believe that comment
is still correct. It does use the jiffies counter, and the time stamp
is still relative to system boot up.

-- Steve
