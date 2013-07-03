Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3GCC5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 22:57:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5823 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3GCC5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 22:57:35 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ys9SgDZjGkgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_7JHcU0X-nEA:10 a=aPuqS9YRyodrUV4Gz6gA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372820252.22688.94.camel@gandalf.local.home>
Subject: Re: PATCH? trace_remove_event_call() should fail if call is active
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 02 Jul 2013 22:57:32 -0400
In-Reply-To: <51D38F8D.3010708@hitachi.com>
References: <20130626185205.GA27894@redhat.com> <51CBEE3E.70103@hitachi.com>
	 <20130627161716.GA17889@redhat.com> <51CCF8BA.4030601@hitachi.com>
	 <20130628180946.GA30838@redhat.com> <51D16E1D.5040904@hitachi.com>
	 <20130702190037.GA6289@redhat.com> <20130702193425.GA8813@redhat.com>
	 <1372799087.22688.58.camel@gandalf.local.home>
	 <20130702213808.GA24757@redhat.com> <20130702222359.GA27629@redhat.com>
	 <51D38F8D.3010708@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 11:42 +0900, Masami Hiramatsu wrote:
> (2013/07/03 7:23), Oleg Nesterov wrote:
> > On 07/02, Oleg Nesterov wrote:
> >>
> >> So please ignore modules ;)
> > 
> > Or lets discuss the change above.
> 
> No, I think this still doesn't ensure that we can remove dynamic
> event safely. Since the event is related to several files under
> events/ dir and buffer instances, someone can just stay open the
> files while the event is removed and read/write it.
> Perhaps, we need per-event_call refcounter not per-trace_array
> one, and do as below.

Or both. I need the trace-array counter for rmdir, and don't want to
check every event. But that doesn't mean we can't have a event counter.


> 
> Open file:
>  -> lock event_mutex
>  -> find event_call and event_file
>  -> get event_call
>  -> unlock event_mutex
> 
> Close:
>  -> lock event_mutex
>  -> put event_call
>  -> unlock event_mutex
> 
> Remove event (via kprobe_events):
>  -> lock event_mutex
>  -> find event_call
>  -> -EBUSY if event is enabled or refcount != 0
>     (here, no one accessing the event and not enabled)
>  -> unregister_kprobe
>  -> remove event
>  -> unlock event_mutex
> 
> The key is holding event_mutex *and* getting refcount
> under any operation.

And this would be to the event call, not the event file itself, right?

-- Steve

> And of course, we can unregister the kprobe outside of
> the event_mutex, but it still need a synchronize_sched
> for safety.
> 
>  -> lock event_mutex
>  -> wait_for_rcu (to ensure no disabled kprobe accesses the event)
>  -> find event_call
>  -> -EBUSY if event is enabled or refcount != 0
>     (here, no one accessing the event and not enabled)
>  -> remove event
>  -> unlock event_mutex
>  -> unregister_kprobe
> 
> Thank you,
> 
> 


