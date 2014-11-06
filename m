Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaKFExg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:53:36 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:36694 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbaKFExf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:53:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvENAOatTlRFpamy/2dsb2JhbABSCoMOVFiDBrZKBpNlhn5UAoEcFwEBfIQCAQEBAQIBIw8BBR4iAQULCxgCAgUWCwICCQMCAQIBJx4GAQwBBwEBiDQJDbZvlHYBAQEBAQEEAQEBAQEBARuBLIUIiDeBQVcFB4J3gVQBBJZPgkOGAINJgnKFMIcjgW+DeTwvAQEBAYJHAQEB
X-IPAS-Result: AvENAOatTlRFpamy/2dsb2JhbABSCoMOVFiDBrZKBpNlhn5UAoEcFwEBfIQCAQEBAQIBIw8BBR4iAQULCxgCAgUWCwICCQMCAQIBJx4GAQwBBwEBiDQJDbZvlHYBAQEBAQEEAQEBAQEBARuBLIUIiDeBQVcFB4J3gVQBBJZPgkOGAINJgnKFMIcjgW+DeTwvAQEBAYJHAQEB
X-IronPort-AV: E=Sophos;i="5.04,797,1406606400"; 
   d="scan'208";a="96077570"
Message-ID: <545AFEC7.9070403@voxpopuli.im>
Date: Thu, 06 Nov 2014 05:53:27 +0100
From: Alexandre Montplaisir <alexmonthy@voxpopuli.im>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC 0/5] perf tools: Add perf data CTF conversion
References: <53F38C74.4030300@voxpopuli.im> <20140820092858.GA1203@krava.brq.redhat.com> <53F4F38C.4080407@voxpopuli.im> <5457C259.8030605@linutronix.de> <545829CA.7040900@voxpopuli.im> <20141105125028.GA30087@linutronix.de> <808291558.8227.1415208064002.JavaMail.zimbra@efficios.com>
In-Reply-To: <808291558.8227.1415208064002.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,


On 11/05/2014 06:21 PM, Mathieu Desnoyers wrote:
> [...]
>>>> The cpu_id field change will be addressed soon on our side.
>>>> Now, the remaining things:
>>>> The "domain = kernel" thingy (or another identifier if desired) is
>>>> something we could add.
>>> Unless the event data is exactly the same, it would be easier to use
>>> a different name. Like "kernel-perf" for instance?
>> Some kind of a namespace / identifier is probably not wrong. The lttng
>> tracer added a tracer version probably in case the format changes
>> between version for some reason. Perf comes with the kernel so for this
>> the kernel version should sufficient.
> Yes, using the kernel version for Perf makes sense. I reach a similar
> conclusion for LTTng: we should add tracepoint semantic versioning
> somewhere in the CTF metadata, because the semantic of an event can
> change based on the LTTng version, and based on which kernel version
> LTTng is tracing.
>
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

Sounds good. So perf-CTF traces could still use the "kernel" domain, but 
the CTF environment metadata would also mention the tracer, which could 
be so far either lttng or perf. For now we only look at the domain to 
infer the trace type, but we could also look at the tracer, and tracer 
version, to determine which event and field naming to use for the analysis.

I can also see how in general, versioning the "instrumentation" of an 
instrumented program could be useful. For example, LTTng changed the 
name of their syscall events in 2.6. The event still represents the same 
thing from an analysis's point of view, only the name changed.

> Because CTF supports both kernel and userspace tracing, we also want
> to solve this semantic detection problem both for the kernel and
> userspace. Therefore, we should consider how the userspace
> tracepoints could save version information in the user-space metadata
> too.
>
> Since we have traces shared across applications (per user-ID buffers)
> in lttng-ust, the semantic info, and therefore the versioning, should
> be done on a per-provider (or per-event) basis, rather than trace-wide,
> because a single trace could contain events from various applications,
> each with their own set of providers, therefore each with their
> versioning info.

Hmm, where would this per-tracepoint version come from? From the version 
of the application? From a new "instrumentation version" defined 
somewhere? Or would the maintainers of the application have to manually 
version every single tracepoint in their program?

Per-tracepoint versioning, at first glance, seems a bit heavy. I'd have 
to understand more about it to make an informed opinion though ;) But 
this seems to be a problem for userspace traces only, right? Because 
with kernel traces
1) the tracers put the kernel version in the environment metadata and
2) you can't have more than one kernel provider in the same CTF trace 
(can you?)

But from a trace viewer's analysis point of view, I think it would make 
sense. If events in the trace supply a version (in addition to its 
name/type), then the analysis may decide to handle different versions of 
an event in different ways.


>
> So if we apply this description scheme to the kernel tracing case,
> this would mean that each event in the CTF metadata would have
> version information. For Perf, this could very well be the kernel
> version that we simply repeat for each event metadata entry. For
> LTTng-modules, we would have our own versioning that is independent
> of the kernel version, since the semantic of the events we expose
> can change for a given kernel version as lttng-modules evolves.
>
> In summary, for perf it would be really easy: just repeat the
> kernel version in a new attribute attached to each event in the
> metadata. For LTTng we would have the flexibility to have our own
> version numbers in there. This would also cover the case of
> userspace tracing, allowing each application to advertise their
> tracepoint provider semantic changes through versioning.
>
>> >From the user's point of view, both would still be Linux Kernel
>>> Traces, but we could use the domain internally to determine which
>>> event/field layout to use.
>>>
>>> Mathieu, any thoughts on how CTF domains should be namespaced?
> (see above)
>
>>>> Now that I identified the differences between the CTF from lttng and
>>>> perf, any suggestions / ideas how this could be solved?
>>> I suppose it would be better/cleaner if the event and field names
>>> would remain the same, or at least be similar, in the perf.data and
>>> perf-CTF formats.
>> Yes, that would be cool. Especially if we teach perf to record straight
>> to CTF.
>>
>>> If the trace events from both LTTng and perf represent the same thing
>>> (and I assume they should, since they come from the same tracepoints,
>>> right?), then we could just add a wrapper on the viewer side to
>>> decide which event/field names to use, depending on the trace type.
> I think we might want to keep a different semantic namespace for
> perf and lttng, because LTTng has the luxury to change event semantic
> mapping between minor LTTng versions in order to add/remove/tweak event
> content as necessary, and Perf is really tied to each kernel version
> it is shipped with.
>
>>> Right now, we only define LTTng event and field names:
>>> http://git.eclipse.org/c/tracecompass/org.eclipse.tracecompass.git/tree/org.eclipse.tracecompass.lttng2.kernel.core/src/org/eclipse/tracecompass/internal/lttng2/kernel/core/LttngStrings.java
>> Okay. So I found this file for linuxtools now let me try tracecompass.
>> The basic renaming should do the job. Then I have to figure out how to
>> compile this thingy…
>>
>> There is this one thing where you go for "tid" while perf says "pid". I
>> guess I could figure that out once I have the rename done.
> LTTng uses the semantic presented to user-space to identify threads and
> processes. What you find in /proc is what you find in a LTTng trace. The
> tracepoint semantic used by perf and ftrace uses the kernel-internal
> meaning of pid = thread ID, pgid = process ID, which differs from what is
> visible from user-space.
>
> I guess it's up to you to decide if you want to stick to the kernel-internal
> semantic, or switch to the user-visible (/proc) semantic for perf traces.

This is something I will have to look more into. We do use TIDs for most 
of the kernel analysis, because that is what LTTng is usually providing, 
but we also track PID's, with events like the statedump and fork's. We 
just need to make sure we match the field values to the right thing.

>
>> We don't have lttng_statedump_process_state, this look lttng specific. I
>> would have to look if there is a replacement event in perf.
> Not that I am aware of. Perf tends to add fields to each records to keep
> track of extra state. LTTng can also do that by dynamically attaching
> context information, but it also supports dumping the initial system
> state, thus allowing trace viewers to reconstruct the system state by
> reading the trace, starting with the state dump events at the beginning.
>
>> I have no idea what we could do about the "unknown" events, say someone
>> enbales skb tracing. But this is probably something for once we are
>> done with the basic integration.
>>
>>> But if you could for example tell me the perf equivalents of all the
>>> strings in that file, I could hack together such wrapper. With that,
>>> in theory, perf traces should behave exactly the same as LTTng traces
>>> in the viewer!
> Ideally, the Trace Compass views should only care about a model of the OS.
> Populating this model can be done by various "state gathering" plugins,
> e.g. one for lttng, one for perf, which know about versioning and semantic
> of the events contained in each trace.

Exactly, the "wrapper" I was talking about previously would be something 
like an interface that only exposes the *concepts* present in the 
application, in this case the Linux kernel. It would then be up to the 
support of each tracer (or tracer version) to provide which events and 
fields to use for each of those concepts.


Cheers!
Alexandre

>
> [...]
>
>> For the fields, this is one event with alle the members we have. Please
>> note that lttng saves the members with the _ prefix and I haven't seen
>> that prefix in that .java file. The members of each event:
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
>
> Thanks!
>
> Mathieu
>
>>> Cheers,
>>> Alexandre
>> Sebastian
>>

