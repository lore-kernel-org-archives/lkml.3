Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964999Ab3GDMqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:46:37 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38255 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964934Ab3GDMpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:45:50 -0400
Message-ID: <51D56E74.3090404@hitachi.com>
Date: Thu, 04 Jul 2013 21:45:40 +0900
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

This may cause an unexpected access violation at kprobe handler because
unregister_probe_event frees event_call/event_files and it will be
accessed until kprobe is *completely* disabled.
Actually disable_kprobe() doesn't ensure to finish the current running
kprobe handlers. Thus, even if trace_probe_is_enabled() returns false,
we must do synchronize_sched() for waiting, before unregister_probe_event().
OTOH, unregister_kprobe() waits for that. That's why I do
__unregister_trace_probe(tp) first here.

I think there are 2 solutions, one is adding a wait after disable_k*probe
at disable_trace_probe(), another is adding a wait before unregister_probe_event()
at unregister_trace_probe().

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


