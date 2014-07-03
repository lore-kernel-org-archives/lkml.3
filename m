Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaGCAzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 20:55:01 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:39846 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaGCAzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 20:55:00 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: probe_event_disable()->synchronize_sched()
References: <20140627170116.GA18298@redhat.com>
	<20140627170136.GA18319@redhat.com>
	<87k37z54lu.fsf@sejong.aot.lge.com>
	<20140630184828.GA24594@redhat.com>
	<20140701193147.GA32492@redhat.com>
Date: Thu, 03 Jul 2014 09:54:57 +0900
In-Reply-To: <20140701193147.GA32492@redhat.com> (Oleg Nesterov's message of
	"Tue, 1 Jul 2014 21:31:47 +0200")
Message-ID: <87pphn45y6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Tue, 1 Jul 2014 21:31:47 +0200, Oleg Nesterov wrote:
> Namhyung, Masami,
>
> Please look at the question below. Perhaps we discussed this before,
> but I can recall nothing.

I'm not sure I grok the code enough to answer your question, but...

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

Okay, I'd like to see it. :)


>
> -------------------------------------------------------------------------
> And. I am puzzled by probe_event_disable()->synchronize_sched(). Why
> do we need it? I mean, why we can't use call_rcu() ? The comment says
> "synchronize with u{,ret}probe_trace_func" but it doesn't explain _why_
> do we need to sync.

It looks like the code was copied from trace_kprobe.c file.  But IIUC,
unlike kprobes, uprobe events are always called in a process context.

Also u{,ret}probe_trace_func() call handlers under rcu_read_lock() not
rcu_read_lock_sched() so I guess the synchronize_sched() can go.

Thanks,
Namhyung


>
> I thought that perhaps the caller needs to synch with the callbacks.
> Say, __trace_remove_event_call() can destroy the data which can be used
> by the callbacks. But no, this is only possible if we are going to call
> uprobe_unregister(), and this adds the necessary serialization.
>
> So why? Looks like, the only reason is instance_rmdir() which can do
> TRACE_REG_UNREGISTER and after that destroy this ftrace_event_file?
> But event_trace_del_tracer() also has synchronize_sched() right after
> __ftrace_set_clr_event_nolock() ?
>
> So please tell me why do we need this synchronize_sched ;) And imo
> this should be documented.
>
> Oleg.
