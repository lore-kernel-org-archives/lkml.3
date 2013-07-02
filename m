Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab3GBWtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:49:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31391 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932793Ab3GBWt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:49:28 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ys9SgDZjGkgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_7JHcU0X-nEA:10 a=maXIUhv72Fdg4Jm-8tsA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372805365.22688.68.camel@gandalf.local.home>
Subject: Re: PATCH? trace_remove_event_call() should fail if call is active
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 02 Jul 2013 18:49:25 -0400
In-Reply-To: <20130702222359.GA27629@redhat.com>
References: <20130626185205.GA27894@redhat.com> <51CBEE3E.70103@hitachi.com>
	 <20130627161716.GA17889@redhat.com> <51CCF8BA.4030601@hitachi.com>
	 <20130628180946.GA30838@redhat.com> <51D16E1D.5040904@hitachi.com>
	 <20130702190037.GA6289@redhat.com> <20130702193425.GA8813@redhat.com>
	 <1372799087.22688.58.camel@gandalf.local.home>
	 <20130702213808.GA24757@redhat.com> <20130702222359.GA27629@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 00:23 +0200, Oleg Nesterov wrote:
> On 07/02, Oleg Nesterov wrote:
> >
> > So please ignore modules ;)
> 
> Or lets discuss the change above.

I like this better than your first change, as the module code really
can't fail to remove events, as that will complicate things more than
they already are ;-)

> 
> Oleg.
> 
> --- x/kernel/trace/trace_events.c
> +++ x/kernel/trace/trace_events.c
> @@ -1611,14 +1611,40 @@ static void __trace_remove_event_call(st
>  	destroy_preds(call);
>  }
>  
> +static int event_can_remove(struct ftrace_event_call *call)

Should rename this to "event_is_busy" as we are only seeing if the event
is active or not, as we do allow for events to be removed when active.
This may confuse new reviewers.

> +{
> +	struct trace_array *tr;
> +	struct ftrace_event_file *file;
> +
> +#ifdef CONFIG_PERF_EVENTS
> +	if (call->perf_refcount)
> +		return -EBUSY;
> +#endif
> +	do_for_each_event_file(tr, file) {
> +		if (file->event_call != call)
> +			continue;
> +		if (file->flags & FTRACE_EVENT_FL_ENABLED)
> +			return -EBUSY;
> +		break;
> +	} while_for_each_event_file();
> +
> +	return 0;
> +}
> +
>  /* Remove an event_call */
> -void trace_remove_event_call(struct ftrace_event_call *call)
> +int trace_remove_event_call(struct ftrace_event_call *call)

Probably should rename this to trace_probe_remove_event_call() as this
deals only with the probe callers (kprobe and uprobe). Also this code
will need to be documented a bit more.

Other than that, sure, go with it. Masami, you have any comments?

-- Steve

>  {
> +	int err;
> +
>  	mutex_lock(&event_mutex);
>  	down_write(&trace_event_sem);
> -	__trace_remove_event_call(call);
> +	err = event_can_remove(call);
> +	if (!err)
> +		__trace_remove_event_call(call);
>  	up_write(&trace_event_sem);
>  	mutex_unlock(&event_mutex);
> +
> +	return err;
>  }
>  
>  #define for_each_event(event, start, end)			\


