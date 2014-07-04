Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbaGDEqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 00:46:52 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:57464 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaGDEqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 00:46:50 -0400
Message-ID: <53B631B2.6000105@hitachi.com>
Date: Fri, 04 Jul 2014 13:46:42 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: probe_event_disable()->synchronize_sched() (Was: tracing/uprobes:
 Revert "Support mix of ftrace and perf")
References: <20140627170116.GA18298@redhat.com> <20140627170136.GA18319@redhat.com> <87k37z54lu.fsf@sejong.aot.lge.com> <20140630184828.GA24594@redhat.com> <20140701193147.GA32492@redhat.com> <53B4EE21.2040203@hitachi.com> <20140703162211.GB5610@redhat.com>
In-Reply-To: <20140703162211.GB5610@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/04 1:22), Oleg Nesterov wrote:

>> One possible scenario is here; someone disables an event and tries to remove
>> it (both will be done by different syscalls). If we don't synchronize
>> the first disabling, the event flag set disabled, but the event itself
>> is not disabled. Thus event handler is still possible to be running
>> somewhere when it is removed.
> 
> See above. "remove" can't succed until all ftrace_event_file's are inactive.
> And probe_event_disable() does uprobe_unregister() in this case which (again)
> serializes with the callbacks itself.

Ah, I see. kprobes uses disable_kprobe() instead of unregister, and that
is not serialized.

>> The other path of __trace_remove_event_call() is trace_module_remove_events()
>> which is not related to kprobes/uprobes (Even so, there is no obvious check of
>> that.)
> 
> Yes, uprobe can ignore modules ;)
> 
>>> So why? Looks like, the only reason is instance_rmdir() which can do
>>> TRACE_REG_UNREGISTER and after that destroy this ftrace_event_file?
>>> But event_trace_del_tracer() also has synchronize_sched() right after
>>> __ftrace_set_clr_event_nolock() ?
>>
>> I think it doesn't need to call synchronize_sched() because
>> event_trace_del_tracer() ensures that all events are disabled
>> (handlers are not running anymore)
> 
> Not really, afaics... Well yes, it calls __ftrace_set_clr_event_nolock(),
> but this can race with the callbacks; this doesn't necessary call
> uprobe_unregister() because there can be other active ftrace_event_file's.
> So we need to synchronize before we start to destroy the data.
> 
> So do you agree that we can remove that synchronize_sched() in trace_uprobe.c
> and replace it with call_rcu?

Yes for uprobes, kprobes still need it.　:)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


