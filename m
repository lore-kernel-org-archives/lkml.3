Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaKEWfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:35:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:25942 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750834AbaKEWfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:35:10 -0500
Date: Wed, 5 Nov 2014 17:34:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] trace: Replace seq_printf by simpler equivalents
Message-ID: <20141105173454.7aa47289@gandalf.local.home>
In-Reply-To: <1410513954-28909-5-git-send-email-linux@rasmusvillemoes.dk>
References: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk>
	<1410513954-28909-5-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 11:25:52 +0200
Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> Using seq_printf to print a simple string or a single character is a
> lot more expensive than it needs to be, since seq_puts and seq_putc
> exist.
> 
> These patches do
> 
>   seq_printf(m, s) -> seq_puts(m, s)
>   seq_printf(m, "%s", s) -> seq_puts(m, s)
>   seq_printf(m, "%c", c) -> seq_putc(m, c)
> 
> Subsequent patches will simplify further.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  kernel/trace/ftrace.c                | 30 ++++++++++++------------
>  kernel/trace/trace.c                 | 44 ++++++++++++++++++------------------
>  kernel/trace/trace_branch.c          | 24 +++++++++-----------
>  kernel/trace/trace_events.c          |  4 ++--
>  kernel/trace/trace_events_trigger.c  |  2 +-
>  kernel/trace/trace_functions.c       |  2 +-
>  kernel/trace/trace_functions_graph.c | 28 +++++++++++------------
>  kernel/trace/trace_kprobe.c          |  4 ++--
>  kernel/trace/trace_uprobe.c          |  2 +-
>  9 files changed, 69 insertions(+), 71 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 5916a8e..7b9ce28 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -556,13 +556,13 @@ static int function_stat_cmp(void *p1, void *p2)
>  static int function_stat_headers(struct seq_file *m)
>  {
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> -	seq_printf(m, "  Function                               "
> -		   "Hit    Time            Avg             s^2\n"
> -		      "  --------                               "
> -		   "---    ----            ---             ---\n");
> +	seq_puts(m,
> +		 "  Function                               " "Hit    Time            Avg             s^2\n"
> +		 "  --------                               " "---    ----            ---             ---\n");

Please keep the original format. I know that it's considered bad form
to split strings like this, but I consider this one of the exceptions
to the rule.

>  #else
> -	seq_printf(m, "  Function                               Hit\n"
> -		      "  --------                               ---\n");
> +	seq_puts(m,
> +		 "  Function                               Hit\n"
> +		 "  --------                               ---\n");
>  #endif
>  	return 0;
>  }



> @@ -3250,7 +3250,7 @@ static int t_show(struct seq_file *m, void *v)
>  	if (!t)
>  		return 0;
>  
> -	seq_printf(m, "%s", t->name);
> +	seq_puts(m, t->name);

This is wrong and dangerous.

What happens if "t->name" contains "%d" or "%s"?


>  	if (t->next)
>  		seq_putc(m, ' ');
>  	else
> @@ -5752,10 +5752,10 @@ ftrace_snapshot_print(struct seq_file *m, unsigned long ip,
>  
>  	seq_printf(m, "%ps:", (void *)ip);
>  
> -	seq_printf(m, "snapshot");
> +	seq_puts(m, "snapshot");
>  
>  	if (count == -1)
> -		seq_printf(m, ":unlimited\n");
> +		seq_puts(m, ":unlimited\n");
>  	else
>  		seq_printf(m, ":count=%ld\n", count);
>  


>  static int all_branch_stat_headers(struct seq_file *m)
>  {
> -	seq_printf(m, "   miss      hit    %% ");
> -	seq_printf(m, "       Function                "
> -			      "  File              Line\n"
> -			      " ------- ---------  - "
> -			      "       --------                "
> -			      "  ----              ----\n");
> +	seq_puts(m, "   miss      hit    % ");
> +	seq_puts(m,
> +		 "       Function                " "  File              Line\n" " ------- ---------  - " "       --------                " "  ----              ----\n");

Again, keep the original formatting. We can fix it up later, but not
with this patch.


>  	return 0;
>  }
>  


> --- a/kernel/trace/trace_events_trigger.c
> +++ b/kernel/trace/trace_events_trigger.c
> @@ -373,7 +373,7 @@ event_trigger_print(const char *name, struct seq_file *m,
>  {
>  	long count = (long)data;
>  
> -	seq_printf(m, "%s", name);
> +	seq_puts(m, name);

Again, this is wrong and dangerous.

-- Steve

>  
>  	if (count == -1)
>  		seq_puts(m, ":unlimited");


