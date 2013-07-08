Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3GHCg5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 22:36:57 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39267 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab3GHCgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 22:36:55 -0400
Message-ID: <51DA25BF.6000701@hitachi.com>
Date: Mon, 08 Jul 2013 11:36:47 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if probe
 event files are open
References: <20130704033347.807661713@goodmis.org> <20130704034038.819592356@goodmis.org> <51D56E74.3090404@hitachi.com> <20130704184813.GA2695@redhat.com> <51D6351A.2000206@hitachi.com> <20130705172655.GA18576@redhat.com>
In-Reply-To: <20130705172655.GA18576@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/06 2:26), Oleg Nesterov wrote:
> On 07/05, Masami Hiramatsu wrote:
>>
>> (2013/07/05 3:48), Oleg Nesterov wrote:
>>> On 07/04, Masami Hiramatsu wrote:
>>>>
>>>> Actually disable_kprobe() doesn't ensure to finish the current running
>>>> kprobe handlers.
>>>
>>> Yes. in fact disable_trace_probe(file != NULL) does, but perf doesn't.
>>
>> Ah, right. we did that.
> 
> And thus we only need to synchronize kprobe_dispatcher()->kprobe_perf_func()
> path. And afaics kprobe_perf_func() doesn't use anything which can be freed
> by trace_remove_event_call?
> 
>>>> OTOH, unregister_kprobe() waits for that.
>>>
>>> Yes.
>>>
>>> So I think we only need to move kfree(tp->call.print_fmt).
> 
> OOPS. I was wrong. It seems that ->print_fmt is only for event/format ?
> Then it is fine to kfree it right after trace_remove_event_call().
> 
>>> So the sequence should be:
>>>
>>> 	if (trace_remove_event_call(...))
>>> 		return;
>>>
>>> 	/* does synchronize_sched */
>>> 	unregister_kprobe();
>>>
>>> 	kfree(everything);
>>>
>>> Agreed?
>>
>> If we can free everything after all, I'd like to do so.
>> Hmm, but AFAICS, trace_remove_event_call() supposes that
>> all event is disabled completely.
> 
> Yes, but kprobe_trace_func() is really disabled?

No, currently, doesn't. We need to fix that.
(Perhaps, uprobes too.)

>> A safe way is to wait rcu always right after disable_*probe
>> in disable_trace_probe. If we have an unused link, we can
>> free it after that.
> 
> Aaaah... I am starting to understand... Even if kprobe_perf_func()
> is fine, synchronize_sched() is calles _before_ disable_kprobe()
> and thus it can't synchronize with the handlers which hit this probe
> after we start synchronize_sched().
> 
> Did you mean this or I misssed something else?

Right, thus perf path also need to be synchronized.

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


