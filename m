Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522Ab3CNCJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 22:09:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22428 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab3CNCJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 22:09:08 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=qyopD3fBDQ4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=6naRQuOZ-EEA:10 a=waCHHPEWWAXJ2XoQu0gA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363226945.25967.25.camel@gandalf.local.home>
Subject: Question about a patch for stable
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 13 Mar 2013 22:09:05 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I was bringing Documentation/trace/ftrace.txt up to date, and obviously
I found some minor bugs in the code while doing so :-)  One of the
things I've discovered, is that the new -mfentry option for gcc used for
function tracing (for only x86 and gcc >= 4.6.0), the stack tracer gives
some bogus results:

     # cat stack_trace
            Depth    Size   Location    (48 entries)
            -----    ----   --------
      0)     4824     216   ftrace_call+0x5/0x2f
      1)     4608     112   ____cache_alloc+0xb7/0x22d
      2)     4496      80   kmem_cache_alloc+0x63/0x12f
[...]

One thing is that it shows the ftrace_call label of the function tracer
instead of the top function and its stack. This is due to fentry being
called as the first operation of a function instead of the way mcount is
called, which is after the stack frame is set up. Because the function
is traced before the stack frame was set up, we lose what function
called the current function. Not only that, the stack frame size (216)
is a combination of that function we missed as well as the ftrace_call
stack size used to save registers.

I have a couple of small fixes that make this more correct:

     # cat stack_trace
            Depth    Size   Location    (14 entries)
            -----    ----   --------
      0)     2640      48   update_group_power+0x26/0x187
      1)     2592     224   update_sd_lb_stats+0x2a5/0x4ac
      2)     2368     160   find_busiest_group+0x31/0x1f1
      3)     2208     256   load_balance+0xd9/0x662

The bug only affects that first entry. Do you think its worth adding to
stable. The changes are solely contained in kernel/trace/trace_stack.c
and do not affect anything else.

I'm not sure I'm going to even submit this for 3.9, and just let it go
into 3.9.1.

I also noticed that the contents of the file stack_max_size doesn't
match the depth (2640 from above), because it also includes the stack
size of the overhead of the stack tracer itself. I have a fix for that
too, but I believe this has always been broken (with and without
-mfentry) and I'm not sure that deserves to be back ported. I'm going to
queue the fix for 3.10. I'm not sure people care about this one or not.

What's your thoughts?

Thanks,

-- Steve




