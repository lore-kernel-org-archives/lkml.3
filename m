Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaDDP5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:57:52 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47275 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbaDDP5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:57:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAGdX0WGcx3aF6Uhsh=K2bG5CDD5iNqCyPUcf=RZWHsDehmE-qQ@mail.gmail.com>
References: <CAGdX0WEeZJ9hxq1y-gmGC=kdtU0ecLbs5gVYb_8ZE6sOW_PPvg@mail.gmail.com>
	<CAMEtUuyQZo6fSMTZ5XKPfPBdjR13916Rd3=z5dip3N_WOzvr6Q@mail.gmail.com>
	<CAGdX0WFm2wccs30q1=eduLdzjAjfxz-6oL-zGvumY6BigQ-a4g@mail.gmail.com>
	<20140404074800.GD1637@gmail.com>
	<CAGdX0WGcx3aF6Uhsh=K2bG5CDD5iNqCyPUcf=RZWHsDehmE-qQ@mail.gmail.com>
Date: Fri, 4 Apr 2014 08:57:48 -0700
Message-ID: <CAMEtUuxR5eYEcYdgNbZW3baMgQvKADGNjiD1wqSZAxo2FEbHPg@mail.gmail.com>
Subject: Re: ktap and ebpf integration
From: Alexei Starovoitov <ast@plumgrid.com>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg KH <gregkh@linuxfoundation.org>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 1:46 AM, Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
> On Fri, Apr 4, 2014 at 3:48 PM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
>>
>>> On Fri, Apr 4, 2014 at 2:26 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>>> > On Thu, Apr 3, 2014 at 6:21 PM, Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
>>> >> Hi Alexei,
>>> >>
>>> >> We talked a lot on ktap and ebpf integration in these days,
>>> >> Now I think we can put into deeply to thinking out some
>>> >> technical issues in there.
>>> >>
>>> >> Firstly, I want to make sure you are support this ktap and
>>> >> ebpf integration direction, I aware you have ongoing 'bpf filter'
>>> >> patch set work, which actually overlapping with ktap integration
>>> >> efforts (IMO the interface should be unified and simple for user,
>>> >>  so I think filter debugfs file is not a good interface), so please let
>>> >> me know your answer about this.
>>> >
>>> > I think the more choices users have the better.
>>> > I'll continue with C based filters and you can continue with ktap
>>> > syntax. That's ok. We can share all kernel pieces.
>>>
>>> Now I understand that there is no way to integrate ktap and ibpf in
>>> technical point of view, the kernel side and interface is completely
>>> different, and obviously you don't want to change current per-event
>>> filter file based interface and kernel part, that make impossible to
>>> let ktap could integrate or share with ibpf.
>>
>> In my reading that's not what Alexei wrote: he just suggested that as
>> long as the kernel bits are largely shared, the user-space bits
>> (syntax, etc.) can stay completely orthogonal and independent.
>>
> Actually I also agree this, kernel part should be unified and well
> designed, I also agree that userspace part should have unified program
> in long term, we can start from C initially, and make some part
> more simile and flexible for end user(like provide associative array
> and aggregation syntax, that's addon for C syntax)
>
>> It also does not mean that ktap is forced to use the per event filter
>> file based interface to pass BPF scripts to the kernel. BPF is already
>> used by various facilities in the kernel, with different user-space
>> APIs to interface with it.
>>
> The issue is one-event mapping with one-program design in BPF, which
> Alexei already mentioned clear on this, I'm really don't like this design,
> how about support multi-events with same probe callback? current
> ktap support this: "trace *:* {}", it means it trace all tracepoints events,
> this ktap design is constantly match with perf does now, but it will
> be strongly conflicts current BPF "one-event mapping with one-program" design

I didn't say that.
I said 'one bpf program = one function'.
'bpf program' terminology comes from old days.
the code is full of 'prog' structures and variables.
Here it may be confusing. That's why I keep saying
'bpf program = function'
Obviously nothing prevents the same program to be attached to
multiple events.

> This is why the interface really matters.
>
>> So the main technical question is: why should ktap have its own
>> separate in-kernel code execution engine, if we already have the BPF
>> virtual machine (which is well-maintained, has excellent performance
>> through JIT, etc.), which could be reused and/or enhanced?
>>
> I already mentioned I agree maintain one bytecode engine in kernel.
>
>> Is there any aspect of ktap's virtual machine that BPF does not have?
>>
> Already said, I don't want to bring ktap virtual machine to kernel even though
> I like it and putted endless effort on it, what I really want is we should
> have a well designed dynamic tracing framework, so I hope I can bring
> ktap "features"(not bytecode engine and ktap compiler) to enhance BPF:
>
> - Tracing framework which unified with perf(make possible to integrate
> with perf someday)
>   trace *"* {}
>   trace syscalls:* {}
>   trace probe:libc.so:* {}
>   trace ftrace:function {}
>
>   This basic framework is well designed and loved by ktap end user.
>   (This design heavily conflicts with BPF one-event one program.)

you misunderstood proposed architecture.

> - timer event
>   BPF insist timer should move to userspace, I doubt that, that even make
>   BPF can not profiling kernel(userspace) stack, time event must fired
>   in kernel space to get stack, this is so easy to understand, but BPF object.

please point me to the ktap script that does what you have in mind
and I can show how it can be done with ibpf

> - Global variable access
>   I also doubt how to access global variable if BPF use one-event one-function
>   one-program design.

seems you misunderstood it again.

> - Flexible associative array(kernel part)
> - Ring buffer (based on ftrace rb)
> - Library and built-in functions
>   Those part also could be reused by move to BPF.

I don't think we're on the same page yet.
ring buffer is a part of tracing. I hope you're not proposing to copy
it to ktapvm or ibpf.
bpf program can add events to ring buffer via function call.
In my earlier patches I've demonstrated it.

> - Samples
>   samples could be reuse (of course syntax need to change),
>   I think BPF should look more ktap samples before form its finial design.
>
> These is what I want to bring to current BPF design and implementation.
> But obviously these "features" could not work on BPF, the kernel part
> cannot shared between ktap and BPF, this make ktap have to
> leave away from BPF.

You're making far fetching conclusions without even trying to understand
what bpf can do.
I think the way to move forward is:
you post ktap script, I show how it's done with bpf
