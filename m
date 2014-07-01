Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422AbaGATdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:33:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850AbaGATdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:33:12 -0400
Date: Tue, 1 Jul 2014 21:31:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: probe_event_disable()->synchronize_sched() (Was: tracing/uprobes:
	Revert "Support mix of ftrace and perf")
Message-ID: <20140701193147.GA32492@redhat.com>
References: <20140627170116.GA18298@redhat.com> <20140627170136.GA18319@redhat.com> <87k37z54lu.fsf@sejong.aot.lge.com> <20140630184828.GA24594@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630184828.GA24594@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung, Masami,

Please look at the question below. Perhaps we discussed this before,
but I can recall nothing.


On 06/30, Oleg Nesterov wrote:
>
> Actually, I'll probably try to make the patch tomorrow. It looks simple
> enough, the main complication is CONFIG_PERF. And, to keep this patch
> simple, I won't try to optimize (say) the TP_FLAG_TRACE-comes-first
> case which could avoid uprobe_apply().

I regret very much I said this ;) OK, I'll probably try anyway, but...

> Yes, I still think it would be better to change the register/unregister
> API first, but I do not know when I do this ;)

OK, we can do this later.

But it turns out that trace_uprobe.c needs other cleanups, and I simply
can't uglify this code more without these cleanups... Starting from
set/clear TP_FLAG_*. I'll recheck, but it seems that there is no reason
to carefully set (say) TP_FLAG_TRACE before uprobe_register() and then
clear it if _register() fails. And uprobe_dispatcher() is very ugly if
is_ret_probe(). And more. So it needs a series.

-------------------------------------------------------------------------
And. I am puzzled by probe_event_disable()->synchronize_sched(). Why
do we need it? I mean, why we can't use call_rcu() ? The comment says
"synchronize with u{,ret}probe_trace_func" but it doesn't explain _why_
do we need to sync.

I thought that perhaps the caller needs to synch with the callbacks.
Say, __trace_remove_event_call() can destroy the data which can be used
by the callbacks. But no, this is only possible if we are going to call
uprobe_unregister(), and this adds the necessary serialization.

So why? Looks like, the only reason is instance_rmdir() which can do
TRACE_REG_UNREGISTER and after that destroy this ftrace_event_file?
But event_trace_del_tracer() also has synchronize_sched() right after
__ftrace_set_clr_event_nolock() ?

So please tell me why do we need this synchronize_sched ;) And imo
this should be documented.

Oleg.

