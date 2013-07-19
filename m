Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794Ab3GSQ1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:27:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26660 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760612Ab3GSQ07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:26:59 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=GW4zEVj-RJIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=EWstSE_Q4awA:10 a=20KFwNOVAAAA:8 a=tIm3vvxcxbiu0MFZikIA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374251217.3356.12.camel@gandalf.local.home>
Subject: Re: [PATCH 1/1] tracing: Simplify trace_array_get()
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 19 Jul 2013 12:26:57 -0400
In-Reply-To: <20130719155101.GA19509@redhat.com>
References: <20130719155041.GA19501@redhat.com>
	 <20130719155101.GA19509@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-19 at 17:51 +0200, Oleg Nesterov wrote:
> trace_array_get() scans the global ftrace_trace_arrays list
> to ensure that "this_tr" was not removed by instance_delete().
> 
> This looks a bit confusing, we can simply use list_empty() with
> the same result. list_empty() == F can not be false positive,
> new_instance_create() does everything under the same lock and
> tracer_alloc_buffers() which plays with global_trace is __init.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace.c |   12 ++++--------
>  1 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 0cd500b..ee471fb 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -206,16 +206,12 @@ LIST_HEAD(ftrace_trace_arrays);
>  
>  int trace_array_get(struct trace_array *this_tr)
>  {
> -	struct trace_array *tr;
>  	int ret = -ENODEV;
>  
>  	mutex_lock(&trace_types_lock);
> -	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
> -		if (tr == this_tr) {
> -			tr->ref++;
> -			ret = 0;
> -			break;
> -		}
> +	if (!list_empty(&this_tr->list)) {

Because this_tr can be freed outside the lock. Accessing this_tr->list
can cause a crash.

The point of the search is, if it's on the list, it will not be freed.

-- Steve


> +		this_tr->ref++;
> +		ret = 0;
>  	}
>  	mutex_unlock(&trace_types_lock);
>  
> @@ -6019,7 +6015,7 @@ static int instance_delete(const char *name)
>  	if (tr->ref)
>  		goto out_unlock;
>  
> -	list_del(&tr->list);
> +	list_del_init(&tr->list); /* trace_array_get() checks list_empty() */
>  
>  	event_trace_del_tracer(tr);
>  	debugfs_remove_recursive(tr->dir);


