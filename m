Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752Ab3GECxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 22:53:25 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51296 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab3GECxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 22:53:24 -0400
Message-ID: <51D6351A.2000206@hitachi.com>
Date: Fri, 05 Jul 2013 11:53:14 +0900
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
References: <20130704033347.807661713@goodmis.org> <20130704034038.819592356@goodmis.org> <51D56E74.3090404@hitachi.com> <20130704184813.GA2695@redhat.com>
In-Reply-To: <20130704184813.GA2695@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/05 3:48), Oleg Nesterov wrote:
> On 07/04, Masami Hiramatsu wrote:
>>
>> (2013/07/04 12:33), Steven Rostedt wrote:
>>> +	/* Will fail if probe is being used by ftrace or perf */
>>> +	if (unregister_probe_event(tp))
>>> +		return -EBUSY;
>>> +
>>>  	__unregister_trace_probe(tp);
>>>  	list_del(&tp->list);
>>> -	unregister_probe_event(tp);
>>>
>>>  	return 0;
>>>  }
>>
>> This may cause an unexpected access violation at kprobe handler because
>> unregister_probe_event frees event_call/event_files and it will be
>> accessed until kprobe is *completely* disabled.
> 
> I don't think so... Please correct me.
> 
> (but yes I think the patch needs a small update, see below).
> 
>> Actually disable_kprobe() doesn't ensure to finish the current running
>> kprobe handlers.
> 
> Yes. in fact disable_trace_probe(file != NULL) does, but perf doesn't.

Ah, right. we did that.

> 
>> Thus, even if trace_probe_is_enabled() returns false,
>> we must do synchronize_sched() for waiting, before unregister_probe_event().
> 
> No, I think we should simply kill trace_probe_is_enabled() here.
> And synchronize_sched() _before_ unregister_probe_event() can't
> help, exactly because trace_probe_is_enabled() is racy.

Right, it should be useless.


>> OTOH, unregister_kprobe() waits for that.
> 
> Yes.
> 
> So I think we only need to move kfree(tp->call.print_fmt). In fact I
> already wrote the patch assuming that trace_remove_event_call() will
> be changed as we discussed.
> 
> So the sequence should be:
> 
> 	if (trace_remove_event_call(...))
> 		return;
> 
> 	/* does synchronize_sched */
> 	unregister_kprobe();
> 
> 	kfree(everything);
> 
> Agreed?

If we can free everything after all, I'd like to do so.
Hmm, but AFAICS, trace_remove_event_call() supposes that
all event is disabled completely.

A safe way is to wait rcu always right after disable_*probe
in disable_trace_probe. If we have an unused link, we can
free it after that.

Or, do more aggressively, introducing a dying-bit for each
trace-probe could be another way. If the bit is set, all
enable operations are failed. It works like as a per-event lock.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


