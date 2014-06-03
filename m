Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147AbaFCW5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:57:24 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:17559 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932485AbaFCW5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:57:23 -0400
Date: Tue, 3 Jun 2014 18:57:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: fweisbec@gmail.com, mingo@redhat.com, jovi.zhangwei@huawei.com,
        namhyung.kim@lge.com, tom.zanussi@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: let user specify tracing_thresh after
 selecting function_graph
Message-ID: <20140603185720.79552fb8@gandalf.local.home>
In-Reply-To: <1401815569-10513-1-git-send-email-stfomichev@yandex-team.ru>
References: <1401815569-10513-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Jun 2014 21:12:49 +0400
Stanislav Fomichev <stfomichev@yandex-team.ru> wrote:

> Currently, tracing_thresh works only if we specify it before selecting
> function_graph tracer. If we do the opposite, tracing_thresh will change
> it's value, but it will not be applied.
> To fix it, we need to always register handlers which take tracing_thresh into
> account.
> 
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  kernel/trace/trace_functions_graph.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index deff11200261..a894031986a3 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -433,12 +433,8 @@ static int graph_trace_init(struct trace_array *tr)
>  	int ret;
>  
>  	set_graph_array(tr);
> -	if (tracing_thresh)
> -		ret = register_ftrace_graph(&trace_graph_thresh_return,
> -					    &trace_graph_thresh_entry);
> -	else
> -		ret = register_ftrace_graph(&trace_graph_return,
> -					    &trace_graph_entry);
> +	ret = register_ftrace_graph(&trace_graph_thresh_return,
> +				    &trace_graph_thresh_entry);
>  	if (ret)
>  		return ret;
>  	tracing_start_cmdline_record();

I would rather not endure the overhead of checking tracing_thresh
every time. I never use it, I didn't even know there was someone that
did ;-)

I'm not saying you can't fix this bug, I'm just saying that it
shouldn't be done this way.

Ideally there should be a callback for the tracer to deal with it, but
instead, you can for now just hardcode a function graph tracer callback
into tracing_max_lat_write(). Something like this:

	if (ptr == &tracing_thresh)
		ftrace_update_func_graph_thresh();

And then if the function tracer is active, stop it, and then restart it
with the tracing thresh function.

-- Steve
