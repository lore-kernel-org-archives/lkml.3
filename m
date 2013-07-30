Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab3G3IP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:15:57 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52563 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050Ab3G3IPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:15:47 -0400
Message-ID: <51F7762E.7010906@hitachi.com>
Date: Tue, 30 Jul 2013 17:15:42 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if probe
 event files are open
References: <20130704033347.807661713@goodmis.org> <20130704034038.819592356@goodmis.org>
In-Reply-To: <20130704034038.819592356@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/04 12:33), Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> When one of the event files is opened, we need to prevent them from
> being removed. Modules do with with the module owner set (automated
> from the VFS layer).  The ftrace buffer instances have a ref count added
> to the trace_array when the enabled file is opened (the others are not
> that big of a deal, as they only reference the event calls which
> still exist when an instance disappears). But kprobes and uprobes
> do not have any protection.
> 
>  # cd /sys/kernel/debug/tracing
>  # echo 'p:sigprocmask sigprocmask' > kprobe_events || exit -1
>  # enable_probe() {
>     sleep 10
>     echo 1
>  }
>  # file=events/kprobes/sigprocmask/enable
>  # enable_probe > $file &
>  > kprobe_events
> 
> The above will corrupt the kprobe system, as the write to the enable
> file will happen after the kprobe was deleted.
> 
> Trying to create the probe again fails:
> 
>  # echo 'p:sigprocmask sigprocmask' > kprobe_events
>  # cat kprobe_events
> p:kprobes/sigprocmask sigprocmask
>  # ls events/kprobes/
> enable  filter
> 
> Have the unregister probe fail when the event files are open, in use
> are used by perf.
> 

Now, since the commit a232e270d makes sure that disable_trace_probe()
waits until all running handlers are done, this patch has no problem.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!


> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_kprobe.c |   21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 7ed6976..ffcaf42 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -95,7 +95,7 @@ static __kprobes bool trace_probe_is_on_module(struct trace_probe *tp)
>  }
>  
>  static int register_probe_event(struct trace_probe *tp);
> -static void unregister_probe_event(struct trace_probe *tp);
> +static int unregister_probe_event(struct trace_probe *tp);
>  
>  static DEFINE_MUTEX(probe_lock);
>  static LIST_HEAD(probe_list);
> @@ -340,9 +340,12 @@ static int unregister_trace_probe(struct trace_probe *tp)
>  	if (trace_probe_is_enabled(tp))
>  		return -EBUSY;
>  
> +	/* Will fail if probe is being used by ftrace or perf */
> +	if (unregister_probe_event(tp))
> +		return -EBUSY;
> +
>  	__unregister_trace_probe(tp);
>  	list_del(&tp->list);
> -	unregister_probe_event(tp);
>  
>  	return 0;
>  }
> @@ -621,7 +624,9 @@ static int release_all_trace_probes(void)
>  	/* TODO: Use batch unregistration */
>  	while (!list_empty(&probe_list)) {
>  		tp = list_entry(probe_list.next, struct trace_probe, list);
> -		unregister_trace_probe(tp);
> +		ret = unregister_trace_probe(tp);
> +		if (ret)
> +			goto end;
>  		free_trace_probe(tp);
>  	}
>  
> @@ -1242,11 +1247,15 @@ static int register_probe_event(struct trace_probe *tp)
>  	return ret;
>  }
>  
> -static void unregister_probe_event(struct trace_probe *tp)
> +static int unregister_probe_event(struct trace_probe *tp)
>  {
> +	int ret;
> +
>  	/* tp->event is unregistered in trace_remove_event_call() */
> -	trace_remove_event_call(&tp->call);
> -	kfree(tp->call.print_fmt);
> +	ret = trace_remove_event_call(&tp->call);
> +	if (!ret)
> +		kfree(tp->call.print_fmt);
> +	return ret;
>  }
>  
>  /* Make a debugfs interface for controlling probe points */
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


