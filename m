Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbaGNTUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:20:42 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:49403 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932257AbaGNTUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:20:31 -0400
Date: Mon, 14 Jul 2014 15:20:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] tracing: change filter_free_subsystem_*() to check
 ->subsystem rather then ->name
Message-ID: <20140714152029.21bd22f6@gandalf.local.home>
In-Reply-To: <20140711190655.GA19549@redhat.com>
References: <20140711190622.GA19499@redhat.com>
	<20140711190655.GA19549@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014 21:06:55 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> filter_free_subsystem_preds() and filter_free_subsystem_filters()
> can rely on file->system->subsystem and avoid strcmp().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_events_filter.c |    9 ++-------
>  1 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 54a125c..59655bc 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -846,13 +846,10 @@ static void filter_free_subsystem_preds(struct event_subsystem *system,
>  					struct trace_array *tr)
>  {
>  	struct ftrace_event_file *file;
> -	struct ftrace_event_call *call;
>  
>  	list_for_each_entry(file, &tr->events, list) {
> -		call = file->event_call;
> -		if (strcmp(call->class->system, system->name) != 0)
> +		if (file->system->subsystem != system)

This is only used on one place. What about just passing in dir instead
of system and then do:

		if (file->system != dir)
>  			continue;

-- Steve

> -
>  		__remove_filter(file);
>  	}
>  }
> @@ -874,11 +871,9 @@ static void filter_free_subsystem_filters(struct event_subsystem *system,
>  					  struct trace_array *tr)
>  {
>  	struct ftrace_event_file *file;
> -	struct ftrace_event_call *call;
>  
>  	list_for_each_entry(file, &tr->events, list) {
> -		call = file->event_call;
> -		if (strcmp(call->class->system, system->name) != 0)
> +		if (file->system->subsystem != system)
>  			continue;
>  		__free_subsystem_filter(file);
>  	}

