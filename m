Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaGNNzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:55:07 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33987 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbaGNNzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:55:02 -0400
Subject: Re: [PATCH 0/7] tracing: instance_rmdir() leaks
 ftrace_event_file->filter
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140711190622.GA19499@redhat.com>
References: <20140711190622.GA19499@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jul 2014 22:54:56 +0900
Message-ID: <1405346096.1745.17.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

2014-07-11 (금), 21:06 +0200, Oleg Nesterov:
> Hello,
> 
> Sorry for delay, I was distracted by other problems.
> 
> To remind, we discussed the potential uprobes "mix perf/ftrace" changes and
> found some off-topic problems. Lets start with ->filter fixes/cleanups.
> 
> So far I didn't even try to test this series, although it looks simple except
> perhaps the last patch. I'll try to somehow test this tomorrow, but I do not
> really now how.
> 
> So please review, these patches need acks anyway.
> 
> As for 1/7, I added BUG_ON(file->filter) into remove_event_file_dir() before
> kmem_cache_free() to verify that yes, the leak does exist. Perhaps this patch
> should go to stable, or at least to v3.16.
> 
> --------------------------------------------------------------------------------
> And could someone explain me why apply_subsystem_event_filter("0") clears
> ->filter_string first, then the whole ->filter? It seems that the only
> thing filter_free_subsystem_preds() should do is filter_disable(), no?
> IOW, why the patch below (on top of this series) is wrong?

I also think that the original code is bit strange.  I agree with your
change and name of the function should be changed to something like
'filter_disable_subsystem_filters' IMHO (it does nothing with preds).
With this change, the apply_subsystem_event_filter can simply do below:

	if (!strcmp(strstrip(filter_string), "0")) {
		filter_disable_subsystem_filters(system, tr);
		/* Ensure all filters are no longer used */
		synchronize_sched();
		filter_free_subsystem_filters(system, tr);
		__free_filter(system->filter);
		system->filter = NULL;
		goto out_unlock;
	}

Thanks,
Namhyung


> 
> Oleg.
> 
> --- x/kernel/trace/trace_events_filter.c
> +++ x/kernel/trace/trace_events_filter.c
> @@ -831,17 +831,6 @@ static int __alloc_preds(struct event_filter *filter, int n_preds)
>  	return 0;
>  }
>  
> -static inline void __remove_filter(struct ftrace_event_file *file)
> -{
> -	struct ftrace_event_call *call = file->event_call;
> -
> -	filter_disable(file);
> -	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
> -		remove_filter_string(call->filter);
> -	else
> -		remove_filter_string(file->filter);
> -}
> -
>  static void filter_free_subsystem_preds(struct event_subsystem *system,
>  					struct trace_array *tr)
>  {
> @@ -850,7 +839,7 @@ static void filter_free_subsystem_preds(struct event_subsystem *system,
>  	list_for_each_entry(file, &tr->events, list) {
>  		if (file->system->subsystem != system)
>  			continue;
> -		__remove_filter(file);
> +		filter_disable(file);
>  	}
>  }
>  
> 



