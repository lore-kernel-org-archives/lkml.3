Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3AKCyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 21:54:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24769 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3AKCyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 21:54:36 -0500
X-Authority-Analysis: v=2.0 cv=T70Ovo2Q c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=YVIWcjBVNvEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=B2Q2Fn0tczoA:10 a=ayC55rCoAAAA:8 a=m0D0claWAAAA:8 a=-90oljrv8j-shKSv9rgA:9 a=PUjeQqilurYA:10 a=E6k37eg1NvgA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357872874.5141.28.camel@gandalf.local.home>
Subject: Re: Ftrace test failure on MIPS - Looking for insight..
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips <linux-mips@linux-mips.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 10 Jan 2013 21:54:34 -0500
In-Reply-To: <50EF71C9.4010907@caviumnetworks.com>
References: <50EF71C9.4010907@caviumnetworks.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-10 at 17:58 -0800, David Daney wrote:
> Hi Steven,
> 
> I am trying to track down the cause of:
> 
> .
> .
> .
> Brought up 32 CPUs
> Testing tracer function: PASSED
> Testing dynamic ftrace: .. filter failed count=0 ..FAILED!
> ------------[ cut here ]------------
> WARNING: at kernel/trace/trace.c:878 register_tracer+0x23c/0x300()
> Modules linked in:
> Call Trace:
> [<ffffffff815a0578>] dump_stack+0x14/0x40
> [<ffffffff8113e8fc>] warn_slowpath_common+0x84/0xb0
> [<ffffffff811bd04c>] register_tracer+0x23c/0x300
> [<ffffffff81100538>] do_one_initcall+0x110/0x178
> [<ffffffff8159234c>] kernel_init+0x174/0x318
> [<ffffffff81119de4>] ret_from_kernel_thread+0x14/0x1c
> 
> ---[ end trace 204112383c2d190e ]---
> .
> .
> .
> 
> 
> This is a MIPS64 kernel build from Linus' tree of today (commit 
> 254adaa465c40151df11fc1f88f93e6e86eb61d4)
> 
> I think the failure is long standing (since 3.4.x at least).
> 
> If you have any ideas off the top of your head as to what the cause 
> might be, I would love to hear them.
> 
> In any event, I will try to track down the root cause and fix it.  But 
> if something jumped out at you, that could speed up my search for the cause.

The failure is that it set the tracing filter to be DYN_FTRACE_TEST_NAME
(which is defined as trace_selftest_dynamic_test_func) and then it
called the function and then checked how many events were in the trace.
But there wasn't any (count=0). For some reason dynamic function tracing
didn't trace the function when it was called.

Some reasons fro this to happen:

1) tracing was some how disabled (tracing_on set to zero). But as the
function tracer passed, I don't think this would be the case.

2) the function wasn't properly set in the filter. That is, could mips
have another name for that function? Where it wouldn't add it?

3) well, just about anything :-)

I could suggest adding printks in the code, and that might help you.
Look into ftrace_set_global_filter (kernel/trace/ftrace.c) and follow
that code. Follow it all the way to __ftrace_hash_rec_update(), and make
sure the rec get's updated. You may add a printk right after the inc
(although, you may also want to set a variable to not do that printk
until the dynamic test runs).

Something like this:

	rec->flags++;
	if (ok_to_printk)
		printk("setting rec %p %pS\n", (void*)rec->ip, (void*)rec->ip);

and at the start of the dynamic test have:

	ok_to_printk = 1;
	pr_info("Testing dynamic ftarce: ");

You should see the record being set. If not, you know why it broke.

-- Steve


