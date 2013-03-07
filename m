Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab3CGGN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 01:13:59 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:54842 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3CGGN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 01:13:58 -0500
X-Greylist: delayed 65900 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Mar 2013 01:13:57 EST
X-AuditID: 85900ec0-d24c6b900000151e-19-513830226bf2
Message-ID: <51382FC1.2050508@hitachi.com>
Date: Thu, 07 Mar 2013 15:12:17 +0900
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
User-Agent: unknown
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH 1/2] tracing: Add help of snapshot feature when snapshot
 is empty
References: <20130306134916.923746858@goodmis.org> <20130306135122.335164503@goodmis.org>
In-Reply-To: <20130306135122.335164503@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(03/06/2013 10:49 PM), Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)"<srostedt@redhat.com>
> 
> When cat'ing the snapshot file, instead of showing an empty trace
> header like the trace file does, show how to use the snapshot
> feature.
> 
> Also, this is a good place to show if the snapshot has been allocated
> or not. Users may want to "pre allocate" the snapshot to have a fast
> "swap" of the current buffer. Otherwise, a swap would be slow and might
> fail as it would need to allocate the snapshot buffer, and that might
> fail under tight memory constraints.
> 
> Here's what it looked like before:
> 
>   # tracer: nop
>   #
>   # entries-in-buffer/entries-written: 0/0   #P:4
>   #
>   #                              _-----=> irqs-off
>   #                             / _----=> need-resched
>   #                            | / _---=> hardirq/softirq
>   #                            || / _--=> preempt-depth
>   #                            ||| /     delay
>   #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
>   #              | |       |   ||||       |         |
> 
> Here's what it looks like now:
> 
>   # tracer: nop
>   #
>   #
>   # * Snapshot is freed *
>   #
>   # Snapshot commands:
>   # echo 0 > snapshot : Clears and frees snapshot buffer
>   # echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.
>   #                      Takes a snapshot of the main buffer.
>   # echo 2 > snapshot : Clears snapshot buffer (but does not allocate)
>   #                      (Doesn't have to be '2' works with any number that
>   #                       is not a '0' or '1')
> 
> Cc: Hiraku Toyooka<hiraku.toyooka.gu@hitachi.com>
> Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
> ---

Acked-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>

>   kernel/trace/trace.c |   25 ++++++++++++++++++++++++-
>   1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index c2e2c23..9e3120b 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2400,6 +2400,27 @@ static void test_ftrace_alive(struct seq_file *m)
>   	seq_printf(m, "#          MAY BE MISSING FUNCTION EVENTS\n");
>   }
>   
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +static void print_snapshot_help(struct seq_file *m, struct trace_iterator *iter)
> +{
> +	if (iter->trace->allocated_snapshot)
> +		seq_printf(m, "#\n# * Snapshot is allocated *\n#\n");
> +	else
> +		seq_printf(m, "#\n# * Snapshot is freed *\n#\n");
> +
> +	seq_printf(m, "# Snapshot commands:\n");
> +	seq_printf(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n");
> +	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
> +	seq_printf(m, "#                      Takes a snapshot of the main buffer.\n");
> +	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate)\n");
> +	seq_printf(m, "#                      (Doesn't have to be '2' works with any number that\n");
> +	seq_printf(m, "#                       is not a '0' or '1')\n");
> +}
> +#else
> +/* Should never be called */
> +static inline void print_snapshot_help(struct seq_file *m, struct trace_iterator *iter) { }
> +#endif
> +
>   static int s_show(struct seq_file *m, void *v)
>   {
>   	struct trace_iterator *iter = v;
> @@ -2411,7 +2432,9 @@ static int s_show(struct seq_file *m, void *v)
>   			seq_puts(m, "#\n");
>   			test_ftrace_alive(m);
>   		}
> -		if (iter->trace && iter->trace->print_header)
> +		if (iter->snapshot && trace_empty(iter))
> +			print_snapshot_help(m, iter);
> +		else if (iter->trace && iter->trace->print_header)
>   			iter->trace->print_header(m);
>   		else
>   			trace_default_header(m);
> -- 1.7.10.4 .
> 

