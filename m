Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab3LVVKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 16:10:37 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:51772 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab3LVVKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 16:10:34 -0500
Message-ID: <52B75542.7040600@hitachi.com>
Date: Mon, 23 Dec 2013 06:10:26 +0900
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

Yes I could, but there are some differences between them.
- perf probe itself opens debuginfo file repeatedly for each event,
  this is just slow. Thus I recommend you to use tracing/kprobe-events
  directly.
  (this can be relaxed by introducing the wildcard support on perf
   probe, however, it still requires to walk through the debuginfo,
   this means it'll take a long time and consume huge memory)
- perf probe/kprobe tracer will slowdown registration process when
  the number of events blown up, because the "kprobe-tracer" itself
  using the linear search on a list for checking event-name conflicts.
  (this can be fixed by using the rbtree instead of the list)
- kprobe-tracer registers events as disabled, but systemtap does it
  as enabled. This means that we'll have no system slowdown which
  comes from probing overhead.

I guess the last one (runtime overhead) is what Frank complaints
about, isn't it? That is actually bigger when we add thousands of
probes. (since the hash table has only 64 slots)

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

This comes from the perf-probe's internal issue. It tries to get
actual lines and files by using debuginfo. I guess most of the time
consumed when processing huge kernel debuginfo.

> 
> Also, here's another bugreport as well: while playing around with 
> 'perf probe' I found that its usability is still very poor. For 
> example I mis-remembered the syntax and typed the obvious way to :
> 
>  # perf probe add __schedule
>  Failed to find path of kernel module.
>  Failed to open debuginfo file.
>    Error: Failed to add events. (-2)
> 
> why the heck does a simple and obvious 'perf probe add' not work, why 
> is the strange syntax of 'perf probe -a' forced? Every other perf 
> subcommand uses clean command spaces - see for example 'perf bench'.

But what happens if we have the function names "add"?
And also, as you commented 4years ago, for adding new event,
you don't need -a/--add. you just can do

 # perf probe __schedule

for that purpose. :)

> Also, the error message is totally misleading and uninformative to the 
> level of being passive-aggressive. An error message should directly 
> relate to the mistake performed and should give a good way out of the 
> situation. Who the heck cares that there was no debuginfo file to 
> open? Who cares that the 'path of kernel module' was not found? It has 
> no relation to the bug.

Sorry for confusion, but that is because syntax misunderstanding.
As I said above, the perf probe understand the options as below

 # perf probe (--add ")add (arg1=)__schedule(")

This means that perf needs a debuginfo to get the location of
"__schedule" local variable at "add" function. So, it tried to
open debuginfo and failed.

> 
> An informative error message would be:
> 
>  # perf probe add __schedule
>  Error: Could not find symbol 'add'.
> 
> and that's it. No 'failed to add events' message - obviously the event 
> is not enabled if we cannot find the symbol name.

Yeah, if you run it without __schedule, it shows such kind of error.

$ ./perf probe add
Kernel symbol 'add' not found.
  Error: Failed to add events. (-2)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


