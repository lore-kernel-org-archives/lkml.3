Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaKFDZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:25:56 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:44711 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311AbaKFDZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:25:52 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au8NAOatTlRFpamy/2dsb2JhbABcgw5UWIMGtkoGk2WGflQCgRwXAQF8hAIBAQEBAgEjDwEFHiMFCwsYAgIFFA0CAg8CKBUJBg0BBwEBiDQJDbZvlHYBAQEBAQUBAQEBAQEcgSyFCIg3gh0HgneBVAWWT4hDg0mCcoxTgW+DeTwvAQEBAYJHAQEB
X-IPAS-Result: Au8NAOatTlRFpamy/2dsb2JhbABcgw5UWIMGtkoGk2WGflQCgRwXAQF8hAIBAQEBAgEjDwEFHiMFCwsYAgIFFA0CAg8CKBUJBg0BBwEBiDQJDbZvlHYBAQEBAQUBAQEBAQEcgSyFCIg3gh0HgneBVAWWT4hDg0mCcoxTgW+DeTwvAQEBAYJHAQEB
X-IronPort-AV: E=Sophos;i="5.04,797,1406606400"; 
   d="scan'208";a="96075480"
Message-ID: <545AEA37.601@voxpopuli.im>
Date: Thu, 06 Nov 2014 04:25:43 +0100
From: Alexandre Montplaisir <alexmonthy@voxpopuli.im>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: FW: [RFC 0/5] perf tools: Add perf data CTF conversion
References: <53F38C74.4030300@voxpopuli.im> <20140820092858.GA1203@krava.brq.redhat.com> <53F4F38C.4080407@voxpopuli.im> <5457C259.8030605@linutronix.de> <545829CA.7040900@voxpopuli.im> <20141105125028.GA30087@linutronix.de>
In-Reply-To: <20141105125028.GA30087@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/05/2014 01:50 PM, Sebastian Andrzej Siewior wrote:
> [...]
>> If the trace events from both LTTng and perf represent the same thing
>> (and I assume they should, since they come from the same tracepoints,
>> right?), then we could just add a wrapper on the viewer side to
>> decide which event/field names to use, depending on the trace type.
>>
>> Right now, we only define LTTng event and field names:
>> http://git.eclipse.org/c/tracecompass/org.eclipse.tracecompass.git/tree/org.eclipse.tracecompass.lttng2.kernel.core/src/org/eclipse/tracecompass/internal/lttng2/kernel/core/LttngStrings.java
> Okay. So I found this file for linuxtools now let me try tracecompass.
> The basic renaming should do the job. Then I have to figure out how to
> compile this thingy…

"mvn clean install". It is the Maven equivalent of "./configure && make" ;)

Or if you want to build a standalone application (RCP):
mvn clean install -Pbuild-rcp -Dmaven.test.skip=true

see the README file in the git tree for details.

>
> There is this one thing where you go for "tid" while perf says "pid". I
> guess I could figure that out once I have the rename done.
> We don't have lttng_statedump_process_state, this look lttng specific. I
> would have to look if there is a replacement event in perf.

Yes, the state dump is something specific to LTTng. It allows us to know 
about processes that exist on the system, even if they are sleeping for 
the whole duration of the trace (and thus, would not show up in the 
trace at all).

But even if these events are not present, we can still know about active 
processes when they do shed_switch's for example.

> I have no idea what we could do about the "unknown" events, say someone
> enbales skb tracing. But this is probably something for once we are
> done with the basic integration.
>
>> But if you could for example tell me the perf equivalents of all the
>> strings in that file, I could hack together such wrapper. With that,
>> in theory, perf traces should behave exactly the same as LTTng traces
>> in the viewer!
> Oooh, that would be awesome. So I installed maven but didn't get much
> further. Let me gather this for you.

Awesome, thanks!

I am travelling this week, so I'm a bit busy, but I will try to 
prototype a "wrapper" for the kernel analysis, and adding support for 
the perf events, whenever I have a chance. I'll keep you posted.

>
> So first the renaming:
> diff --git a/LttngStrings.java b/LttngStrings.java
> --- a/LttngStrings.java
> +++ b/LttngStrings.java
> @@ -27,17 +27,17 @@ public interface LttngStrings {
>   
>       /* Event names */
>       static final String EXIT_SYSCALL = "exit_syscall";
> -    static final String IRQ_HANDLER_ENTRY = "irq_handler_entry";
> -    static final String IRQ_HANDLER_EXIT = "irq_handler_exit";
> -    static final String SOFTIRQ_ENTRY = "softirq_entry";
> -    static final String SOFTIRQ_EXIT = "softirq_exit";
> -    static final String SOFTIRQ_RAISE = "softirq_raise";
> -    static final String SCHED_SWITCH = "sched_switch";
> -    static final String SCHED_WAKEUP = "sched_wakeup";
> -    static final String SCHED_WAKEUP_NEW = "sched_wakeup_new";
> -    static final String SCHED_PROCESS_FORK = "sched_process_fork";
> -    static final String SCHED_PROCESS_EXIT = "sched_process_exit";
> -    static final String SCHED_PROCESS_FREE = "sched_process_free";
> +    static final String IRQ_HANDLER_ENTRY = "irq:irq_handler_entry";
> +    static final String IRQ_HANDLER_EXIT = "irq:irq_handler_exit";
> +    static final String SOFTIRQ_ENTRY = "irq:softirq_entry";
> +    static final String SOFTIRQ_EXIT = "irq:softirq_exit";
> +    static final String SOFTIRQ_RAISE = "irq:softirq_raise";
> +    static final String SCHED_SWITCH = "sched:sched_switch";
> +    static final String SCHED_WAKEUP = "sched:sched_wakeup";
> +    static final String SCHED_WAKEUP_NEW = "sched:sched_wakeup_new";
> +    static final String SCHED_PROCESS_FORK = "sched:sched_process_fork";
> +    static final String SCHED_PROCESS_EXIT = "sched:sched_process_exit";
> +    static final String SCHED_PROCESS_FREE = "sched:sched_process_free";
>       static final String STATEDUMP_PROCESS_STATE = "lttng_statedump_process_state";
>   
>       /* System call names */
>
> I have no idea how exit_syscall is different from irq_handler_exit and I
> think we have to skip for now on STATEDUMP_PROCESS_STATE.
>
> For the syscalls:
>
> - static final String SYSCALL_PREFIX = "sys_";
>    It is bassicaly:
>      syscalls:sys_enter_
>      syscalls:sys_exit_
>    depending what you are looking for.
>
> - static final String COMPAT_SYSCALL_PREFIX = "compat_sys_";
>    I haven't found this. Could it be that we don't record the compat_sys
>    at all?

IIRC, compat_sys is for instance for 32-bit system calls on a 64-bit 
kernel. Perhaps the "compat" system calls are recorded as standard 
system call events with perf? We could test it once we get the base 
things working.

> - static final String SYS_CLONE = "sys_clone";
>    here we have
>      syscalls:sys_enter_clone
>      syscalls:sys_exit_clone
>    I guess the enter is what you are looking for.
>
> For the fields, this is one event with alle the members we have. Please
> note that lttng saves the members with the _ prefix and I haven't seen
> that prefix in that .java file.

As Mathieu explained in his reply, in LTTng-CTF they have a _ before 
field names. In our parser, we take out the first character if it is an 
underscore. So it should still work with underscore-less fields.


Cheers,
Alexandre
