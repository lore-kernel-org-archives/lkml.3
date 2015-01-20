Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbbATDzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:55:42 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:65418 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbbATDzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:55:40 -0500
MIME-Version: 1.0
From: Alexei Starovoitov <ast@plumgrid.com>
Date: Mon, 19 Jan 2015 19:55:18 -0800
Message-ID: <CAMEtUuwrpqRG4a=Hqnj3JBKuLbC4yV+trVAZhevKLbCsm_6U4Q@mail.gmail.com>
Subject: Re: Re: [PATCH tip 0/9] tracing: attach eBPF programs to tracepoints/syscalls/kprobe
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 6:58 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
>>
>> it's done already... one can do the same skb->dev->name logic
>> in kprobe attached program... so from bpf program point of view,
>> tracepoints and kprobes feature-wise are exactly the same.
>> Only input is different.
>
> No, I meant that the input should also be same, at least for the first step.
> I guess it is easy to hook the ring buffer committing and fetch arguments
> from the event entry.

No. That would be very slow. See my comment to Steven
and more detailed numbers below.
Allocating ring buffer takes too much time.

> And what I expected scenario was
>
> 1. setup kprobe traceevent with fd, buf, count by using perf-probe.
> 2. load bpf module
> 3. the module processes given event arguments.

from ring buffer? that's too slow.
It's not usable for high frequency events which
need this in-kernel aggregation.
If events are rare, then just dumping everything
into trace buffer is just fine. No in-kernel program is needed.

> Hmm, it sounds making another systemtap on top of tracepoint and kprobes.
> Why don't you just reuse the existing facilities (perftools and ftrace)
> instead of co-exist?

hmm. I don't think we're on the same page yet...
ring buffer and tracing interface is fully reused.
programs are run as soon as event triggers.
They can return non-zero and kernel will allocate ring
buffer which user space will consume.
Please take a look at tracex1

>> Just look how ktap scripts look alike for kprobes and tracepoints.
>
> Ktap is a good example, it provides only a language parser and a runtime engine.
> Actually, currently it lacks a feature to execute "perf-probe" helper from
> script, but it is easy to add such feature.
...
> For this usecase, I've made --output option for perf probe
> https://lkml.org/lkml/2014/10/31/210

you're proposing to call perf binary from ktap binary?
I think packaging headaches and error conditions
will make such approach very hard to use.
it would be much cleaner to have ktap as part of perf
generating bpf on the fly and feeding into kernel.
'perf probe' parsing and functions don't belong in kernel
when userspace can generate them in more efficient way.

Speaking of performance...
I've added temporary tracepoint like this:
TRACE_EVENT(sys_write,
        TP_PROTO(int count),
        TP_fast_assign(
                __entry->cnt = count;
        ),
and call it from SYSCALL_DEFINE3(write,..., count):
 trace_sys_write(count);

and run the following test:
dd if=/dev/zero of=/dev/null count=5000000

1.19343 s, 2.1 GB/s - raw base line
1.53301 s, 1.7 GB/s - echo 1 > enable
1.62742 s, 1.6 GB/s - echo cnt==1234 > filter
and profile looks like:
     6.23%  dd       [kernel.vmlinux]  [k] __clear_user
     6.19%  dd       [kernel.vmlinux]  [k] __srcu_read_lock
     5.94%  dd       [kernel.vmlinux]  [k] system_call
     4.54%  dd       [kernel.vmlinux]  [k] __srcu_read_unlock
     4.14%  dd       [kernel.vmlinux]  [k] system_call_after_swapgs
     3.96%  dd       [kernel.vmlinux]  [k] fsnotify
     3.74%  dd       [kernel.vmlinux]  [k] ring_buffer_discard_commit
     3.18%  dd       [kernel.vmlinux]  [k] rb_reserve_next_event
     1.69%  dd       [kernel.vmlinux]  [k] rb_add_time_stamp

the slowdown due to unconditional buffer allocation
is too high to use this in production for aggregation
of high frequency events.
There is little reason to run bpf program in kernel after
such penalty. User space can just read trace_pipe_raw
and process data there.

Now if program is run right after tracepoint fires
the profile will look like:
    10.01%  dd             [kernel.vmlinux]            [k] __clear_user
     7.50%  dd             [kernel.vmlinux]            [k] system_call
     6.95%  dd             [kernel.vmlinux]            [k] __srcu_read_lock
     6.02%  dd             [kernel.vmlinux]            [k] __srcu_read_unlock
...
     1.15%  dd             [kernel.vmlinux]            [k]
ftrace_raw_event_sys_write
     0.90%  dd             [kernel.vmlinux]            [k] __bpf_prog_run
this is much more usable.
For empty bpf program that does 'return 0':
1.23418 s, 2.1 GB/s
For full tracex4 example that does map[log2(count)]++
1.2589 s, 2.0 GB/s

so the cost of doing such in-kernel aggregation is
1.19/1.25 is ~ 5%
which makes the whole solution usable as live
monitoring/analytics tool.
We would only need good set of tracepoints.
kprobe via fentry overhead is also not cheap.
Same tracex4 example via kprobe (instead of tracepoint)
1.45673 s, 1.8 GB/s
So tracepoints are 1.45/1.25 ~ 15% faster than kprobes.
which is huge when the cost of running bpf program
is just 5%.
