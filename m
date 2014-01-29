Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaA2LWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 06:22:55 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:35562 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaA2LWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 06:22:54 -0500
Message-ID: <52E8E487.2090007@hitachi.com>
Date: Wed, 29 Jan 2014 20:22:47 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
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
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal> <y0m38loefhx.fsf@fche.csb> <52B3C5E6.2040802@hitachi.com> <20131220082056.GA15934@gmail.com> <52B40E79.8040701@hitachi.com> <20131220104615.GA22609@gmail.com>
In-Reply-To: <20131220104615.GA22609@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

(2013/12/20 19:46), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2013/12/20 17:20), Ingo Molnar wrote:
>>>
>>> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>
>>>>>  But a closer look indicates that the insertion of kprobes is 
>>>>> taking about three (!!) orders of magnitude longer than before, as 
>>>>> judged by the rate of increase of 'wc -l 
>>>>> /sys/kernel/debug/kprobes/list'.
>>>>
>>>> Right, because kprobes are not designed for thousands of probes.
>>>
>>> Then this needs to be fixed, because right now this bug is making it 
>>> near impossible to properly test kprobes robustness.
>>>
>>> For example a hash table (hashed by probe address) could be used in 
>>> addition to the list, to speed up basic operations.
>>
>> kprobe itself is already using hlist (6bits hash table).
>> Maybe we'd better expand the table bits. However, the iteration
>> of the list on debugfs is just doing seq_printf()s. I'm not exactly
>> sure what Frank complaints about...
> 
> Well, Frank reported that the test he performed takes hours to finish, 
> and he mentioned a specific script line he used to produce that:
> 
>   # stap -te "probe kprobe.function("*") {}"
> 
> I suspect an equivalent perf probe sequence would be something like:
> 
>   # for FUNC in $(grep -iw t /proc/kallsyms | cut -d' ' -f3); do date; perf probe -a $FUNC; done
> 
> (totally untested.)
> 
> Can you reproduce that slowdown, using his method?

OK, when I used ftrace interface, it didn't slows things down at all
(at this point :))
  ----
  # time (grep -iw t /proc/kallsyms | awk '{print "p:"$3,"0x"$1}' | xargs --max-lines=1 echo >> /sys/kernel/debug/tracing/kprobe_events )

  real    0m36.303s
  user    0m0.420s
  sys     0m2.428s

  # wc -l /sys/kernel/debug/tracing/kprobe_events
  26980 /sys/kernel/debug/tracing/kprobe_events

  # time cat /sys/kernel/debug/tracing/kprobe_events > /dev/null

  real    0m0.054s
  user    0m0.000s
  sys     0m0.052s
  ----

This is because of two reasons:
 - ftrace interface doesn't access any files, it just parses the event
   and sets it up.
 - ftrace (and perf probe) doesn't enable the event while setting.

I guess the second reason is why the stap takes so long time to set
probes. stap tries to register kprobes without disabled flag, that
means we enables thousands of probes (overheads).

So the similar thing happens when we enables events as below;

  # for i in /sys/kernel/debug/tracing/events/kprobes/* ; do date; echo 1 > $i; done
  Wed Jan 29 10:44:50 UTC 2014
  ...

I tried it and canceled after 4 min passed. It enabled about 17k events
and slowed down my system very much(I almost got hang check timer).

I think we should have some performance statistics (hit count?) and
if it goes over a threshold, we should stop enabling other events.
(Note that kprobes and other events take a time, one event may just
 consume a small amount of time, usually less than 0.5usec. but what
 happens if it hits 1,000,000 times per 1 sec...?)


> I can reproduce one weirdness, with just 13 probes added, 'perf probe 
> -l' [which should really be 'perf probe list'!] executes very slowly:
> 
>  # perf stat --null --repeat 3 perf probe -l
> 
>  Performance counter stats for 'perf probe -l' (3 runs):
> 
>        0.763640098 seconds time elapsed                                          ( +-  1.61% )
> 
> 0.7 seconds is ridiculously long.

As you can see, listing up the probes via ftrace interface just
takes 0.05sec/26980probes. Perf probe may take a time for
list up events because it tries to find symbols/lines from
kallsyms or debuginfo.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


