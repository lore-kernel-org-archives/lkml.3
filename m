Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab3HUPJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:09:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8052 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3HUPJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:09:45 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=DtbtDvHGLq0A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pDL76QfPkxEA:10 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8 a=OwFa8-9HDxm41Ajb3IwA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=B7-YBXcGuVcA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 21 Aug 2013 11:09:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiejing Zhang <kzjeef@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Eric Miao <emiao@nvidia.com>,
        Jiejing Zhang <jiejzhang@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] ftrace: add tgid information in task switch event.
Message-ID: <20130821110944.32bdf03a@gandalf.local.home>
In-Reply-To: <1377097520-24898-1-git-send-email-jasozhang@nvidia.com>
References: <1377097520-24898-1-git-send-email-jasozhang@nvidia.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch needs to be decided by Peter.

Also, the subject should not read "ftrace:" it should have "sched:" as
tracepoints are the property of the subsystem they exist in, not the
tracing facility itself, as it's not just ftrace that uses tracepoints.

-- Steve


On Wed, 21 Aug 2013 15:05:20 +0000
Jiejing Zhang <kzjeef@gmail.com> wrote:

> From: Jiejing Zhang <jiejzhang@nvidia.com>
> 
> ftrace only report pid in task switch event, which is
> actually thread ID in user space view, the comm of
> the thread will be like "Thread-1", "Compiler", etc
> in android system, it's useful if we can add tgid
> information in ftrace event to find out the process
> id, and the process id's comm will help us to figure
> out the application, which was useful on data analysis
> tools.
> 
> Change-Id: Ia99f58a56d691d770b3beb2f76de0351e6194a4a
> Signed-off-by: Jiejing Zhang <jiejzhang@nvidia.com>
> ---
>  include/trace/events/sched.h | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> index e5586ca..3fbcddb 100644
> --- a/include/trace/events/sched.h
> +++ b/include/trace/events/sched.h
> @@ -124,32 +124,37 @@ TRACE_EVENT(sched_switch,
>  	TP_STRUCT__entry(
>  		__array(	char,	prev_comm,	TASK_COMM_LEN	)
>  		__field(	pid_t,	prev_pid			)
> +		__field(	pid_t,	prev_tgid			)
>  		__field(	int,	prev_prio			)
>  		__field(	long,	prev_state			)
>  		__array(	char,	next_comm,	TASK_COMM_LEN	)
>  		__field(	pid_t,	next_pid			)
> +		__field(	pid_t,	next_tgid			)
>  		__field(	int,	next_prio			)
>  	),
>  
>  	TP_fast_assign(
>  		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
>  		__entry->prev_pid	= prev->pid;
> +		__entry->prev_tgid	= prev->tgid;
>  		__entry->prev_prio	= prev->prio;
>  		__entry->prev_state	= __trace_sched_switch_state(prev);
>  		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
>  		__entry->next_pid	= next->pid;
> +		__entry->next_tgid	= next->tgid;
>  		__entry->next_prio	= next->prio;
>  	),
>  
> -	TP_printk("prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s%s ==> next_comm=%s next_pid=%d next_prio=%d",
> -		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
> +	TP_printk("prev_comm=%s prev_pid=%d prev_tgid=%d prev_prio=%d prev_state=%s%s ==> next_comm=%s next_pid=%d next_tgid=%d next_prio=%d",
> +		__entry->prev_comm, __entry->prev_pid,
> +		__entry->prev_tgid,  __entry->prev_prio,
>  		__entry->prev_state & (TASK_STATE_MAX-1) ?
> -		  __print_flags(__entry->prev_state & (TASK_STATE_MAX-1), "|",
> +		__print_flags(__entry->prev_state & (TASK_STATE_MAX-1), "|",
>  				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
>  				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
>  				{ 128, "K" }, { 256, "W" }, { 512, "P" }) : "R",
>  		__entry->prev_state & TASK_STATE_MAX ? "+" : "",
> -		__entry->next_comm, __entry->next_pid, __entry->next_prio)
> +		__entry->next_comm, __entry->next_pid, __entry->next_tgid, __entry->next_prio)
>  );
>  
>  /*

