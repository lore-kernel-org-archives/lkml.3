Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686Ab3GaTt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 15:49:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29471 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab3GaTtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 15:49:55 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=0VS4G58IZu0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=laNjaRT52OkA:10 a=HpRuFPVUsIMZKc_IP30A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375300192.5418.17.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if probe
 event files are open
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 31 Jul 2013 15:49:52 -0400
In-Reply-To: <20130704034038.819592356@goodmis.org>
References: <20130704033347.807661713@goodmis.org>
	 <20130704034038.819592356@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 23:33 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0003-tracing-kprobes-Fail-to-unregister-if-probe-event-fi.patch)
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

Oleg,

The above no longer triggers the bug due to your changes. The race is
much tighter now and requires a process with the enable file opened and
races with a write to enable it where the removal of the trace file
checks the trace disabled, sees that it is, continues, but then the
write enables it just as it gets deleted.

Is this correct?

Do you know of a way to trigger this bug? Probably requires writing
something in C and hammer at writing '0's and '1's into the enable file,
and then remove it. Check if it succeeds and try again.

Hmm, what happens without this patch now? If it is active, and we delete
it? It will call back into the kprobes and access a tracepoint that does
not exist? Would this cause a crash?

-- Steve



> 
> Have the unregister probe fail when the event files are open, in use
> are used by perf.
> 
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


