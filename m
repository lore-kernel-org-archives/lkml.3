Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbaGCFfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 01:35:33 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55182 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaGCFfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 01:35:32 -0400
Message-ID: <53B4EB9C.7050508@hitachi.com>
Date: Thu, 03 Jul 2014 14:35:24 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: probe_event_disable()->synchronize_sched() (Was: tracing/uprobes:
 Revert "Support mix of ftrace and perf")
References: <20140627170116.GA18298@redhat.com> <20140627170136.GA18319@redhat.com> <87k37z54lu.fsf@sejong.aot.lge.com> <20140630184828.GA24594@redhat.com> <20140701193147.GA32492@redhat.com>
In-Reply-To: <20140701193147.GA32492@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/02 4:31), Oleg Nesterov wrote:
> Namhyung, Masami,
> 
> Please look at the question below. Perhaps we discussed this before,
> but I can recall nothing.
> 
> 
> On 06/30, Oleg Nesterov wrote:
>>
>> Actually, I'll probably try to make the patch tomorrow. It looks simple
>> enough, the main complication is CONFIG_PERF. And, to keep this patch
>> simple, I won't try to optimize (say) the TP_FLAG_TRACE-comes-first
>> case which could avoid uprobe_apply().
> 
> I regret very much I said this ;) OK, I'll probably try anyway, but...
> 
>> Yes, I still think it would be better to change the register/unregister
>> API first, but I do not know when I do this ;)
> 
> OK, we can do this later.
> 
> But it turns out that trace_uprobe.c needs other cleanups, and I simply
> can't uglify this code more without these cleanups... Starting from
> set/clear TP_FLAG_*. I'll recheck, but it seems that there is no reason
> to carefully set (say) TP_FLAG_TRACE before uprobe_register() and then
> clear it if _register() fails. And uprobe_dispatcher() is very ugly if
> is_ret_probe(). And more. So it needs a series.
> 
> -------------------------------------------------------------------------
> And. I am puzzled by probe_event_disable()->synchronize_sched(). Why
> do we need it? I mean, why we can't use call_rcu() ? The comment says
> "synchronize with u{,ret}probe_trace_func" but it doesn't explain _why_
> do we need to sync.
> 
> I thought that perhaps the caller needs to synch with the callbacks.
> Say, __trace_remove_event_call() can destroy the data which can be used
> by the callbacks. But no, this is only possible if we are going to call
> uprobe_unregister(), and this adds the necessary serialization.

Hmm, similar code in the trace_kprobe.c said that trace_remove_event_call()
will remove something, so it should be synchronized.

Here, I tracked down the path from trace_remove_event_call().

1) trace_remove_event_call() locks mutexes to protect event status from
others, and calls probe_remove_event_call()

2) probe_remove_event_call() checks call's refcount and state of files which
related to the call. If there is any enabled file or reference, it returns
EBUSY.
If there is no active user of the call, it calls __trace_remove_event_call()

3) __trace_remove_event_call() calls event_remove(call) and after that it
releases all objects related to the call [*1].

4) Finally, event_remove() tries to disable each file on the call and soon
after that calls destroy_preds() [*2]. Here, to disable the file, it calls
ftrace_event_enable_disable() and it finally calls probe_event_disable(),
only if the event is *enabled*.

And as above described, probe_remove_event_call() already checked that
no user enables this event. This means that nobody calls probe_event_disable()
on the path from trace_remove_event_call().


Hmm, however, for [*1] and [*2], both are free event_file related objects
right after disabling the event. This means those expects that calling
ftrace_event_enable_disable() ensures no event handlers running.
synchronize_sched makes it true, but as long as calling
__trace_remove_event_call() from probe_remove_event_call(),
probe_event_disable() is not called at all because the event has to be
disabled when probe_remove_event_call() is called.

One possible scenario is here; someone disables an event and tries to remove
it (both will be done by different syscalls). If we don't synchronize
the first disabling, the event flag set disabled, but the event itself
is not disabled. Thus event handler is still possible to be running
somewhere when it is removed.

The other path of __trace_remove_event_call() is trace_module_remove_events()
which is not related to kprobes/uprobes (Even so, there is no obvious check of
that.)

> So why? Looks like, the only reason is instance_rmdir() which can do
> TRACE_REG_UNREGISTER and after that destroy this ftrace_event_file?
> But event_trace_del_tracer() also has synchronize_sched() right after
> __ftrace_set_clr_event_nolock() ?

I think it doesn't need to call synchronize_sched() because
event_trace_del_tracer() ensures that all events are disabled
(handlers are not running anymore)

Thank you,

>
> So please tell me why do we need this synchronize_sched ;) And imo
> this should be documented.


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


