Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933922AbaKMTY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:24:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:48837 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759AbaKMTYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:24:54 -0500
Message-ID: <54650583.5000000@linutronix.de>
Date: Thu, 13 Nov 2014 20:24:51 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Alexandre Montplaisir <alexmonthy@voxpopuli.im>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC 0/5] perf tools: Add perf data CTF conversion
References: <53F38C74.4030300@voxpopuli.im> <20140820092858.GA1203@krava.brq.redhat.com> <53F4F38C.4080407@voxpopuli.im> <5457C259.8030605@linutronix.de> <545829CA.7040900@voxpopuli.im> <20141105125028.GA30087@linutronix.de> <808291558.8227.1415208064002.JavaMail.zimbra@efficios.com>
In-Reply-To: <808291558.8227.1415208064002.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 06:21 PM, Mathieu Desnoyers wrote:
> A very good example is the semantic of the sched_wakeup event. It has
> changed due to scheduler code modification, and is now called from an
> IPI context, which changes its semantic (not called from the same
> PID). Unfortunately, there is little we can do besides checking the
> kernel version to detect the semantic change from the trace viewer
> side, because neither the event nor the field names have changed.
> 
> The trace viewer could therefore care about the following information
> to identify the semantic of a trace:
> 
> - Tracer name (e.g. lttng or perf),
> - Domain (e.g. kernel or userspace),
> - Tracepoint versioning (e.g. kernel version for Perf).

this sounds reasonable. That means for "domain" I switch to kernel from
kernel-perf that I am using now. And then I need to add tracer_name.

> In summary, for perf it would be really easy: just repeat the
> kernel version in a new attribute attached to each event in the
> metadata. For LTTng we would have the flexibility to have our own
> version numbers in there. This would also cover the case of
> userspace tracing, allowing each application to advertise their
> tracepoint provider semantic changes through versioning.

So what you are saying is that I need something like:

 event {
         name = "sched:sched_process_fork";
         id = 1;
         stream_id = 0;
=>	version = "3.16";
         fields := struct {
                 integer { … } perf_ip;
                 integer { … } perf_tid;
…
         } align(8);
};

where the line marked "=>" is that one I should add.

>>> Right now, we only define LTTng event and field names:
>>> http://git.eclipse.org/c/tracecompass/org.eclipse.tracecompass.git/tree/org.eclipse.tracecompass.lttng2.kernel.core/src/org/eclipse/tracecompass/internal/lttng2/kernel/core/LttngStrings.java
>>
>> Okay. So I found this file for linuxtools now let me try tracecompass.
>> The basic renaming should do the job. Then I have to figure out how to
>> compile this thingy…
>>
>> There is this one thing where you go for "tid" while perf says "pid". I
>> guess I could figure that out once I have the rename done.
> 
> LTTng uses the semantic presented to user-space to identify threads and
> processes. What you find in /proc is what you find in a LTTng trace. The
> tracepoint semantic used by perf and ftrace uses the kernel-internal
> meaning of pid = thread ID, pgid = process ID, which differs from what is
> visible from user-space.
> 
> I guess it's up to you to decide if you want to stick to the kernel-internal
> semantic, or switch to the user-visible (/proc) semantic for perf traces.

I am happy if I can record and pass unchanged perf data :)

>> We don't have lttng_statedump_process_state, this look lttng specific. I
>> would have to look if there is a replacement event in perf.
> 
> Not that I am aware of. Perf tends to add fields to each records to keep
> track of extra state. LTTng can also do that by dynamically attaching
> context information, but it also supports dumping the initial system
> state, thus allowing trace viewers to reconstruct the system state by
> reading the trace, starting with the state dump events at the beginning.

I see. So if this is really a must-have for trace compass there would
need to be a similar event added once we start perf. But from what I
read in Alexandre's email it is not that tragic.

>> For the fields, this is one event with alle the members we have. Please
>> note that lttng saves the members with the _ prefix and I haven't seen
>> that prefix in that .java file. The members of each event:
> 
> Yeah, the _ prefix for event names. This is one decision I would like to
> find a way to revert, but we'll have to live with it unfortunately for
> CTF 1.8. The issue it's trying to fix is to allow having fields named
> "event" that don't clash with the "event" reserved keyword. When I added
> the _ prefix, I did it like this in the CTF spec:
> 
> "Replacing reserved keywords with underscore-prefixed field names is
> recommended. Fields starting with an underscore should have their leading
> underscore removed by the CTF trace readers."
> 
> Unfortunately, this introduces semantic corner-cases for event names that
> would indeed start with an underscore, unless they are prefixed with
> double-underscore in the metadata.
> 
> So far, the only fix I see to this situation is to eventually do a
> CTF 1.9, and add the notion of a $ prefix to the grammar (which is not
> part of the symbols accepted for an identifier) to be used as a field
> name prefix that ensures there is no clash with reserved keywords. I'm
> very open to suggestions there through, and I'm really not in a hurry
> to release a new CTF spec version (we should only do so when we have
> a batch of changes that are required, because it will require all trace
> readers to be updated).

Aha. I haven't seen this underscore prefix in babeltrace examples so I
wasn't aware for this. Thanks for explaining. Now should I add the
prefix to perf by all means or is okay keep it as is?

> Thanks!
> 
> Mathieu
> 
>>> Cheers,
>>> Alexandre

Sebastian
