Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab3H0UIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:08:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17550 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3H0UI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:08:29 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=xQxuxMh46K0A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=RZDpadHLlpEA:10 a=QyXUC8HyAAAA:8 a=MdiO-UM4OaDA5CW3-KIA:9 a=CjuIK1q_8ugA:10 a=UUuBHfsIenzBBrxg:21 a=JdVvTYwZNHPPwk7n:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 27 Aug 2013 16:08:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 01/10] tracing: Add support for SOFT_DISABLE to
 syscall events
Message-ID: <20130827160827.1661a056@gandalf.local.home>
In-Reply-To: <a21a85892674dedf8ded3b2f0e83bd8106f5c22f.1377631572.git.tom.zanussi@linux.intel.com>
References: <cover.1377631572.git.tom.zanussi@linux.intel.com>
	<a21a85892674dedf8ded3b2f0e83bd8106f5c22f.1377631572.git.tom.zanussi@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013 14:40:13 -0500
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:

> @@ -415,9 +429,14 @@ static void unreg_event_syscall_enter(struct ftrace_event_file *file,
>  		return;
>  	mutex_lock(&syscall_trace_lock);
>  	tr->sys_refcount_enter--;
> -	clear_bit(num, tr->enabled_enter_syscalls);
> +	rcu_assign_pointer(tr->enter_syscall_files[num], NULL);
>  	if (!tr->sys_refcount_enter)
>  		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
> +	/*
> +	 * Callers expect the event to be completely disabled on
> +	 * return, so wait for current handlers to finish.
> +	 */
> +	synchronize_sched();
>  	mutex_unlock(&syscall_trace_lock);
>  }
>  
> @@ -435,7 +454,7 @@ static int reg_event_syscall_exit(struct ftrace_event_file *file,
>  	if (!tr->sys_refcount_exit)
>  		ret = register_trace_sys_exit(ftrace_syscall_exit, tr);
>  	if (!ret) {
> -		set_bit(num, tr->enabled_exit_syscalls);
> +		rcu_assign_pointer(tr->exit_syscall_files[num], file);
>  		tr->sys_refcount_exit++;
>  	}
>  	mutex_unlock(&syscall_trace_lock);
> @@ -453,9 +472,14 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
>  		return;
>  	mutex_lock(&syscall_trace_lock);
>  	tr->sys_refcount_exit--;
> -	clear_bit(num, tr->enabled_exit_syscalls);
> +	rcu_assign_pointer(tr->exit_syscall_files[num], NULL);
>  	if (!tr->sys_refcount_exit)
>  		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
> +	/*
> +	 * Callers expect the event to be completely disabled on
> +	 * return, so wait for current handlers to finish.
> +	 */
> +	synchronize_sched();
>  	mutex_unlock(&syscall_trace_lock);

Can we do the synchronize_sched() after the mutex unlock in these two
places?

-- Steve


>  }
>  

