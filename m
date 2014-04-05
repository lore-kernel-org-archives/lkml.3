Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaDEOX6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 10:23:58 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:45975 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbaDEOX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 10:23:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAMEtUuxuTXo9Q-KMvZsH96Uzt5VsCLh1wHGtwn+k_P4iM8FTaw@mail.gmail.com>
References: <CAGdX0WEeZJ9hxq1y-gmGC=kdtU0ecLbs5gVYb_8ZE6sOW_PPvg@mail.gmail.com>
	<CAMEtUuyQZo6fSMTZ5XKPfPBdjR13916Rd3=z5dip3N_WOzvr6Q@mail.gmail.com>
	<CAGdX0WFm2wccs30q1=eduLdzjAjfxz-6oL-zGvumY6BigQ-a4g@mail.gmail.com>
	<20140404074800.GD1637@gmail.com>
	<CAGdX0WGcx3aF6Uhsh=K2bG5CDD5iNqCyPUcf=RZWHsDehmE-qQ@mail.gmail.com>
	<CAMEtUuxuTXo9Q-KMvZsH96Uzt5VsCLh1wHGtwn+k_P4iM8FTaw@mail.gmail.com>
Date: Sat, 5 Apr 2014 22:23:56 +0800
Message-ID: <CAGdX0WEbUszQv=xVK35aes=Qcw=D-0HztML0jBJsKy6hVCH8cA@mail.gmail.com>
Subject: Re: ktap and ebpf integration
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg KH <gregkh@linuxfoundation.org>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 5, 2014 at 1:28 AM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> On Fri, Apr 4, 2014 at 7:20 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
>> BTW I agree that EBPF won't work for ktap. The models
>> (static vs dynamic typing etc.) are just too different.
>
> If you meant 'static vs dynamic safety checking' then yes.
> This is a main difference between bpf and ktap approach to safety.
> bpf engine and checker are disjoint.
> Interpreter is dumb and just executes instructions.
> ktap interpreter has to do all sorts of checking, since it cannot
> trust instructions it sees.
> In this sense, loops are not supported by ibpf today, since they
> require run-time checks. I can think of a way to add such
> support, but rather not. Such 'anti-feature' is not needed.
>
> 'ktap syntax' from user space point of view, can use ibpf as-is.
> Show me the script and I can show how ibpf can run it.

Well, please don't engage 'ktap syntax' in here, if you think
"Integration" only means ktap compiler compiles ktap syntax
into BPF bytecode, then that's entirely misunderstood what's
the real problem in there, some ktap samples in below:

1). trace syscalls:* { print(argstr) }
Register many events.
I posted this script in previous mail, but don't get the answer
how to support this in BPF.
Note ktap implement this by library function(kdebug,trace_by_id),
not change object file, can BPF does this?

2). print("hello world")
This is simplest hello world script in ktap, note that the
executing context is not probe context, but in main ktap
context, BPF main context only allow declare table,
nothing else.
(You may think this helloworld script is not useful, but not
true, many script don't have to run in probe context, for
example, the script just want to read some global variable in kernel)

3). var s = {}; trace *:* { s[probename] += 1 }
variable table s is allocated in main context, same as above,
BPF disallow allocate table in this flexible way, ktap allow
assign table entries before register events, BPF also don't support.

4) var i = 0; trace *:* { i += 1}
Assign global variable in here, there also can assign other
value not 0, please show me how BPF do this.
(See complex global usage example in samples/schedule/schedtimes.kp)

5) kdebug.kprobe("SyS_futex", function () { print(pid) })
ktap register event through function call, not change any core vm,
obviously BPF cannot support this flexible callback mechanism.

6). time.profile { print(stack()) }
print kernel stack in timer manner. Note ktap implement this by library
function, not change any bytecode object file format.

7). trace_end
Note there may have execute logic in trace_end part, not just only
dump everything as you said, so I don't understand why BPF
want to move trace_end to userspace, Dtrace/stap both support
this, why BPF object this?
And ktap implement trace_end by function call, not change
any core vm design, hope BPF can do this without introduce any
change in BPF object file format.

8) call user defined function
It seems BPF cannot call user defined function(not inlined),
user defined function is useful when dynamic tracing solution
support tapset in future(IMO it's hard to avoid user defined tapset).

Note that all those above ktap examples don't change
any core ktap virtual machine and object file format,
table and event register both implemented by library, ktap
decouples features and vm very well, table/aggregation should
be a feature, not be in core vm, but BPF glue everything together,
in summary, three key issues in BPF:

1) BPF couples table in compiler/validation program.
Similar with table design, I think if BPF want to support aggregation
in future, it must need to change compiler and validation, and
will keep changes if BPF support more features.

2) BPF don't allow execute in main context
This is the main issue to for ktap integration, ktap allow
assign global variable, call allowed function before register
events to initiate things, this is mandatory for ktap, and
IMO it is mandatory for all generic dynamic tracing tools.

3) BPF mix event register logic in object format file
ktap object file don't aware any event logic, it's just a normal
function all in ktap, but in BPF object file, there even have a "event"
section.

IMO, BPF engine should be a simple and generic script engine,
just focus on the script engine, not features(table/aggregation/
event registration/trace_end/timer/etc), this is why ktap is so simple
and flexible, this is what I really want BPF can do, we are
have different opinions on those features, if it decouples with core
BPF vm and object file design, then everything will be solve, let
each part implement specific features though own library function.
this is not only useful for ktap, but may also benefit for other kernel
subsystem and external modules as well.

All these issues make we cannot let ktap run on BPF engine because
of current BPF limited and specific design.

Thanks.

Jovi
