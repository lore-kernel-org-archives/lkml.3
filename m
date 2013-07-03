Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3GCCmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 22:42:25 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49950 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3GCCmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 22:42:24 -0400
Message-ID: <51D38F8D.3010708@hitachi.com>
Date: Wed, 03 Jul 2013 11:42:21 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: PATCH? trace_remove_event_call() should fail if call is active
References: <20130626185205.GA27894@redhat.com> <51CBEE3E.70103@hitachi.com> <20130627161716.GA17889@redhat.com> <51CCF8BA.4030601@hitachi.com> <20130628180946.GA30838@redhat.com> <51D16E1D.5040904@hitachi.com> <20130702190037.GA6289@redhat.com> <20130702193425.GA8813@redhat.com> <1372799087.22688.58.camel@gandalf.local.home> <20130702213808.GA24757@redhat.com> <20130702222359.GA27629@redhat.com>
In-Reply-To: <20130702222359.GA27629@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/03 7:23), Oleg Nesterov wrote:
> On 07/02, Oleg Nesterov wrote:
>>
>> So please ignore modules ;)
> 
> Or lets discuss the change above.

No, I think this still doesn't ensure that we can remove dynamic
event safely. Since the event is related to several files under
events/ dir and buffer instances, someone can just stay open the
files while the event is removed and read/write it.
Perhaps, we need per-event_call refcounter not per-trace_array
one, and do as below.

Open file:
 -> lock event_mutex
 -> find event_call and event_file
 -> get event_call
 -> unlock event_mutex

Close:
 -> lock event_mutex
 -> put event_call
 -> unlock event_mutex

Remove event (via kprobe_events):
 -> lock event_mutex
 -> find event_call
 -> -EBUSY if event is enabled or refcount != 0
    (here, no one accessing the event and not enabled)
 -> unregister_kprobe
 -> remove event
 -> unlock event_mutex

The key is holding event_mutex *and* getting refcount
under any operation.
And of course, we can unregister the kprobe outside of
the event_mutex, but it still need a synchronize_sched
for safety.

 -> lock event_mutex
 -> wait_for_rcu (to ensure no disabled kprobe accesses the event)
 -> find event_call
 -> -EBUSY if event is enabled or refcount != 0
    (here, no one accessing the event and not enabled)
 -> remove event
 -> unlock event_mutex
 -> unregister_kprobe

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


