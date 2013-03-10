Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3CJPfb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 11:35:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21252 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab3CJPf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 11:35:29 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=DnYjfxrw2YcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=q5Lrnr381qIA:10 a=xIHDTQ87ktnUATvWpo8A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130310152752.848922120@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 10 Mar 2013 11:27:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 0/4] tracing: trace_puts() and faster trace_printk()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I thought I was done with my ftrace 3.10 patches, but oh well. There's
a few more things that I want to do for 3.10.

I noticed that I used trace_printk() in my tracing_snapshot() in case
it was used incorrectly, but then I realized that those caused the
kernel to preallocate the trace_printk() context buffers all the time
(1 page per context [4 of them], and per cpu). This was not what I wanted.
Thus is started creating a special "internal to ftrace" use that
would not need the context buffers. I added a trace_puts() for this
and then realized that this would be nice for others to use as trace_printk(),
even when doing a trace_bprintk(), still requires a scan of the fmt
string when there are no arguments in use.

Then I thought it would be nice if the compiler just picked trace_puts()
when trace_printk() had no args. Thus, I pulled out my old macro wizard
robe, hat and wand and started playing again. And I came up with patch #2.
:-)

These 4 patches are specific for using ftrace by developers, as the
functions an not called anywhere and are only to be used when a developer
is debugging their code.

Enjoy,

-- Steve


Steven Rostedt (Red Hat) (4):
      tracing: Add trace_puts() for even faster trace_printk() tracing
      tracing: Optimize trace_printk() with one arg to use trace_puts()
      tracing: Add internal ftrace trace_puts() for ftrace to use
      tracing: Let tracing_snapshot() be used by modules but not NMI

----
 include/linux/kernel.h       |   64 +++++++++++++++++++++++++++-
 kernel/trace/trace.c         |   94 ++++++++++++++++++++++++++++++++++++++++--
 kernel/trace/trace.h         |   13 ++++++
 kernel/trace/trace_entries.h |   23 +++++++++--
 kernel/trace/trace_output.c  |   75 +++++++++++++++++++++++++++++++++
 kernel/trace/trace_output.h  |    2 +
 6 files changed, 261 insertions(+), 10 deletions(-)
