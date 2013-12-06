Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab3LFGNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:13:00 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:38134 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab3LFGM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:12:58 -0500
Message-ID: <52A16AD7.6040500@hitachi.com>
Date: Fri, 06 Dec 2013 15:12:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and
 fixes crash bugs
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal> <20131204084551.GA31772@gmail.com> <529FBA71.6070107@hitachi.com> <y0mvbz3pd3z.fsf@fche.csb>
In-Reply-To: <y0mvbz3pd3z.fsf@fche.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/05 23:49), Frank Ch. Eigler wrote:
> 
> Hi, Masami -
> 
> masami.hiramatsu.pt wrote:
> 
>> [...]
>> For the safeness of kprobes, I have an idea; introduce a whitelist
>> for dynamic events. AFAICS, the biggest unstable issue of kprobes
>> comes from putting *many* probes on the functions called from tracers.
> 
> Why do you think so?

Oh, because I actually hit this problem when enabling kprobe-events
on every *ftrace-related* functions(ring buffer, trace filter etc.)
It doesn't crash the kernel but it slows down the machine very much.
And finally I have to reboot it forcibly. But when I just enables a
few probes on those functions, the system has no problem.

In this case, almost probes are miss-hit because of recursion, but
anyway each miss-hit involves int3/debug interrupts and it increases
the processing time of one event handling by ftrace as below.

1. hit a kprobe outside of ftrace
2. kprobe calls event handler
3. the event handler calls ftrace-related functions to reserve
   buffer, check filter, commit buffer etc.
  3-1. each ftrace/ringbuffer function hits a kprobe
  3-2. the kprobe detect recursion and just do single-step and return
4. do single stepping
5. return from kprobe

Note that all the problem happens inside the event handler.

>  We have had problems with single kprobes in the
> "wrong" spot.  The main reason I showed spraying them widely is to get
> wide coverage with minimal information/effort, not to suggest that the
> number of concurrent probes per se is a problem.  (We have had
> systemtap scripts probing some areas of the kernel with thousands of
> active kprobes, e.g. for statement-by-statement variable-watching
> jobs, and these have worked fine.)

Ah, sorry for confusion. Agreed. I just tried to explain that kprobes
can cause a performance problem under *very specific* operation.
So the whitelist is just for keeping people away from it.

>> It doesn't crash the kernel but slows down so much, because every
>> probes hit many other nested miss-hit probes. 
> 
> (kprobes does have code to detect & handle reentrancy.)

Right. :)

>> This gives us a big performance impact. [...]
> 
> Sure, but I'd expect to see pure slowdowns show their impact with
> time-related problems like watchdogs firing or timeouts.

I doubt it can cause, because each probe processing time is
still small enough to slip through the watchdog.

>> [...]  Then, I'd like to propose this new whitelist feature in
>> kprobe-tracer (not raw kprobe itself). And a sysctl knob for
>> disabling the whitelist.  That knob will be
>> /proc/sys/debug/kprobe-event-whitelist and disabling it will mark
>> kernel tainted so that we can check it from bug reports.
> 
> How would one assemble a reliable whitelist, if we haven't fully
> characterized the problems that make the blacklist necessary?

As I said, we can use function graph tracer's list as the whitelist,
since it doesn't include any functions invoked from ftrace's event
handler. (Note that I don't mention the Systemtap or other user here)

Whitelist is just for keeping the people away from the quantitative
issue, who just want to trace their subsystems except for ftrace.
For example, such people may try to probe every functions
(e.g. perf probe --add '* $vars' : actually this is why I don't
release wildcard support on perf probe yet).
Of course I can implement the whitelist feature in perf probe only,
that will allow me to support wildcard on perf probe. :)

For the long term solution, I think we can introduce some kind of
performance gatekeeper as systemtap does. Counting the miss-hit rate
per second and if it go over a threshold, disable next miss-hit (or
most miss-hit) probe (as OOM killer does).

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


