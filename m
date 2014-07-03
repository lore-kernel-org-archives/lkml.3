Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbaGCQXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:23:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbaGCQXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:23:37 -0400
Date: Thu, 3 Jul 2014 18:22:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: probe_event_disable()->synchronize_sched() (Was:
	tracing/uprobes: Revert "Support mix of ftrace and perf")
Message-ID: <20140703162211.GB5610@redhat.com>
References: <20140627170116.GA18298@redhat.com> <20140627170136.GA18319@redhat.com> <87k37z54lu.fsf@sejong.aot.lge.com> <20140630184828.GA24594@redhat.com> <20140701193147.GA32492@redhat.com> <53B4EE21.2040203@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B4EE21.2040203@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03, Masami Hiramatsu wrote:
>
> (2014/07/02 4:31), Oleg Nesterov wrote:
> > And. I am puzzled by probe_event_disable()->synchronize_sched(). Why
> > do we need it? I mean, why we can't use call_rcu() ? The comment says
> > "synchronize with u{,ret}probe_trace_func" but it doesn't explain _why_
> > do we need to sync.
> >
> > I thought that perhaps the caller needs to synch with the callbacks.
> > Say, __trace_remove_event_call() can destroy the data which can be used
> > by the callbacks. But no, this is only possible if we are going to call
> > uprobe_unregister(), and this adds the necessary serialization.
>
> Hmm, similar code in the trace_kprobe.c said that trace_remove_event_call()
> will remove something, so it should be synchronized.
>
> Here, I tracked down the path from trace_remove_event_call().
>
> 1) trace_remove_event_call() locks mutexes to protect event status from
> others, and calls probe_remove_event_call()
>
> 2) probe_remove_event_call() checks call's refcount and state of files which
> related to the call. If there is any enabled file or reference, it returns
> EBUSY.

Yep. So this path is fine. uprobe_unregister() was already called
(FTRACE_EVENT_FL_ENABLED is not set), there are no callbacks in flight.

> One possible scenario is here; someone disables an event and tries to remove
> it (both will be done by different syscalls). If we don't synchronize
> the first disabling, the event flag set disabled, but the event itself
> is not disabled. Thus event handler is still possible to be running
> somewhere when it is removed.

See above. "remove" can't succed until all ftrace_event_file's are inactive.
And probe_event_disable() does uprobe_unregister() in this case which (again)
serializes with the callbacks itself.

> The other path of __trace_remove_event_call() is trace_module_remove_events()
> which is not related to kprobes/uprobes (Even so, there is no obvious check of
> that.)

Yes, uprobe can ignore modules ;)

> > So why? Looks like, the only reason is instance_rmdir() which can do
> > TRACE_REG_UNREGISTER and after that destroy this ftrace_event_file?
> > But event_trace_del_tracer() also has synchronize_sched() right after
> > __ftrace_set_clr_event_nolock() ?
>
> I think it doesn't need to call synchronize_sched() because
> event_trace_del_tracer() ensures that all events are disabled
> (handlers are not running anymore)

Not really, afaics... Well yes, it calls __ftrace_set_clr_event_nolock(),
but this can race with the callbacks; this doesn't necessary call
uprobe_unregister() because there can be other active ftrace_event_file's.
So we need to synchronize before we start to destroy the data.

So do you agree that we can remove that synchronize_sched() in trace_uprobe.c
and replace it with call_rcu?

Hmm. Off-topic, but it seems that instance_rmdir() leaks the memory? Say,
file->filter?

Oleg.

