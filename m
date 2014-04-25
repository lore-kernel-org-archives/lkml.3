Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaDYSrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:47:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:20276 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751255AbaDYSq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:46:58 -0400
Date: Fri, 25 Apr 2014 14:46:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Bharath Ravi <rbharath@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>, Laurent Chavey <chavey@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tracing: Replace usage of trace_flags with new
 accessors.
Message-ID: <20140425144656.5fc07e54@gandalf.local.home>
In-Reply-To: <1395684826-22931-2-git-send-email-rbharath@google.com>
References: <1395684826-22931-1-git-send-email-rbharath@google.com>
	<1395684826-22931-2-git-send-email-rbharath@google.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 11:13:44 -0700
Bharath Ravi <rbharath@google.com> wrote:

> The trace_flags global variable stores various trace options that are
> shared across all ftrace instances. This patch adds accessors function
> for trace_flags - a getter and a setter - and replaces usages of
> trace_flags with these.
> 
> This is in preparation for replacing the global trace_flags with
> instance specific (local) trace_flags, allowing each instance to set
> trace_flags independently.
> 
> Signed-off-by: Bharath Ravi <rbharath@google.com>
> ---
>  kernel/trace/blktrace.c              |  3 +-
>  kernel/trace/ftrace.c                |  4 +--
>  kernel/trace/trace.c                 | 64 ++++++++++++++++++++++--------------
>  kernel/trace/trace.h                 |  2 ++
>  kernel/trace/trace_events.c          |  2 +-
>  kernel/trace/trace_functions_graph.c | 10 +++---
>  kernel/trace/trace_irqsoff.c         |  4 +--
>  kernel/trace/trace_kdb.c             |  6 ++--
>  kernel/trace/trace_output.c          |  8 ++---
>  kernel/trace/trace_printk.c          |  8 ++---
>  kernel/trace/trace_sched_wakeup.c    |  3 +-
>  kernel/trace/trace_syscalls.c        |  2 +-
>  12 files changed, 68 insertions(+), 48 deletions(-)
> 
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index b418cb0..dd5112a 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -1368,7 +1368,7 @@ static enum print_line_t print_one_line(struct trace_iterator *iter,
>  
>  	t	   = te_blk_io_trace(iter->ent);
>  	what	   = t->action & ((1 << BLK_TC_SHIFT) - 1);
> -	long_act   = !!(trace_flags & TRACE_ITER_VERBOSE);
> +	long_act   = !!(global_trace_flags() & TRACE_ITER_VERBOSE);

Instead of having a global_trace_flags() function, use the trace_array
that each tracer has. For here:

	tr->trace_flags;

As if you look at my for-next branch, several tracers can now be called
by instance not just by the top directory.

-- Steve


>  	log_action = classic ? &blk_log_action_classic : &blk_log_action;
>  
>  	if (t->action == BLK_TN_MESSAGE) {
> @@ -1429,6 +1429,7 @@ static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
>  
>  static int blk_tracer_set_flag(u32 old_flags, u32 bit, int set)
>  {
> +	unsigned long trace_flags = global_trace_flags();
>  	/* don't output context-info for blk_classic output */
>  	if (bit == TRACE_BLK_OPT_CLASSIC) {
>  		if (set)
