Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbaBJLcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:32:05 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56188 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaBJLcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:32:02 -0500
Message-ID: <52F8B8A9.6010600@hitachi.com>
Date: Mon, 10 Feb 2014 20:31:53 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v6 00/22] kprobes: introduce NOKPROBE_SYMBOL(), cleanup
 and fixes crash bugs
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal> <y0m38loefhx.fsf@fche.csb> <52B3C5E6.2040802@hitachi.com> <20131220082056.GA15934@gmail.com> <52B40E79.8040701@hitachi.com> <20131220104615.GA22609@gmail.com> <52E8E487.2090007@hitachi.com> <20140209143709.GA31608@gmail.com> <52F84F61.7060103@hitachi.com>
In-Reply-To: <52F84F61.7060103@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/10 13:02), Masami Hiramatsu wrote:
> (2014/02/09 23:37), Ingo Molnar wrote:
>>
>> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>
>>> I guess the second reason is why the stap takes so long time to set 
>>> probes. stap tries to register kprobes without disabled flag, that 
>>> means we enables thousands of probes (overheads).
>>>
>>> So the similar thing happens when we enables events as below;
>>>
>>>   # for i in /sys/kernel/debug/tracing/events/kprobes/* ; do date; echo 1 > $i; done
>>>   Wed Jan 29 10:44:50 UTC 2014
>>>   ...
>>>
>>> I tried it and canceled after 4 min passed. It enabled about 17k 
>>> events and slowed down my system very much(I almost got hang check 
>>> timer).
>>
>> Ok, I guess that's the slowdown bug that Frank reported.
>>
>>> I think we should have some performance statistics (hit count?) and 
>>> if it goes over a threshold, we should stop enabling other events.
>>
>> That really feels like a hack. How about fixing the root cause? Does 
>> the enabling of all probes have to be so slow?
> 
> When I tried to use perf top, most of the time was consumed in
> kprobe_ftrace_handler and optimized_callback, both of them
> are the handler of kprobes. Since I just tried on a VM guest and it
> didn't support NMI nor PMU, thus I have to use a bare metal machine
> for deeper investigation (and I'll do).
> And yes, it seems that the performance problem comes from probing
> and tracing itself.

OK, I've tested and collected some information,

At first, to evaluate the performance of kprobes itself, I set the
ftrace tracing_on=0 (no record) before testing.

For setting probes on all symbols, I ran the below script;
 ----
#!/bin/bash
TRACE_DIR=/sys/kernel/debug/tracing/

echo "Disable tracing to remove tracing overhead"
echo 0 > $TRACE_DIR/tracing_on

echo > $TRACE_DIR/kprobe_events
echo "Setup events on all functions"
grep -iw t /proc/kallsyms | awk 'BEGIN{i=0};{print("p:"$3"_"i, "0x"$1); i++}' | \
while read l; do echo $l >> $TRACE_DIR/kprobe_events || echo "Failed: $l" ; done
 ----

And I enabled just 2000(2k) probes, and ran perf top. Here are the result
 ----
Samples: 12K of event 'cycles', Event count (approx.): 3526908766
 77.41%  [kernel]                         [k] get_kprobe
  3.17%  [kernel]                         [k] acpi_processor_ffh_cstate_enter
  0.93%  [kernel]                         [k] acpi_os_read_port

Samples: 9K of event 'cache-misses', Event count (approx.): 6180338
 80.66%  [kernel]                            [k] get_kprobe
  2.41%  [kernel]                            [k] clear_page_c
  0.48%  perf                                [.] rb_next
 ----

Even with just 2k probes, get_kprobe has very high overhead!
The reason is that we currently have just 64 entries for the
hlist (perf annotate said that the most of the cache-misses
happened at where accessing hlist->next).
This is too small for handing more than 10k probes.

Thus, I tried to enlarge the hlist_head to 4096 entries and
measured the performance again.

With 2k probes, I got below numbers;
 ----
Samples: 12K of event 'cycles', Event count (approx.): 1952272318
 19.08%  [kernel]                            [k] get_kprobe
  6.51%  [kernel]                            [k] acpi_processor_ffh_cstate_enter
  2.51%  [kernel]                            [k] avtab_search_node

Samples: 1K of event 'cache-misses', Event count (approx.): 1016756
 31.81%  [kernel]                      [k] clear_page_c
  5.39%  [kernel]                      [k] shmem_getpage_gfp
  3.04%  [kernel]                      [k] get_kprobe
 ----
OK, now the get_kprobe is cooled down.
And with 8k probes, it still be better, and we can see the
overhead percentage is going up.
----
Samples: 13K of event 'cycles', Event count (approx.): 2119001528
 33.17%  [kernel]                      [k] get_kprobe
  6.98%  [kernel]                      [k] acpi_processor_ffh_cstate_enter
  3.36%  [kernel]                      [k] ftrace_lookup_ip
Samples: 6K of event 'cache-misses', Event count (approx.): 2662552
 19.14%  [kernel]                            [k] clear_page_c
 15.26%  [kernel]                            [k] get_kprobe
  4.16%  [kernel]                            [k] shmem_getpage_gfp
----

And finally, when I tried to 16k probes, it slowed down too much and
couldn't run perf.
I have another idea to solve this, the per-cpu cache for active kprobes,
which can reduce the random memory access on the hlist (but will
consume more memory).

But anyway, for handling massive multiple probes, we cannot escape from
the slowdown finally. As I said, if we consume even 0.1 usec/probe,
it can hit more than 10,000,000 times/sec (because all function call hit
it). As a result, it consumes 1sec / 1sec (this means your machine slows
down to 1/2). And cache miss makes things much worse than that.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
