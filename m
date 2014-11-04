Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbaKDBaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:30:07 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:7337 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750856AbaKDBaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:30:00 -0500
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Nov 2014 20:30:00 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvENAOatTlRFpamy/2dsb2JhbABcgw5UWIMGtkoGk2WGflQCgRwXAQF8hAIBAQEBAgEjBBEeIgEFCwsYAgIFFAILAgIJAwIBAgEnFQkGAQwBBwEBiDQJDbZvlHYBAQEBAQEBAwEBAQEBAQEBGoEshQiEPIN7gh0HgneBVAEElk+CQ4Y8hX+HaIRrgW+DeTwvAQEBAYJHAQEB
X-IPAS-Result: AvENAOatTlRFpamy/2dsb2JhbABcgw5UWIMGtkoGk2WGflQCgRwXAQF8hAIBAQEBAgEjBBEeIgEFCwsYAgIFFAILAgIJAwIBAgEnFQkGAQwBBwEBiDQJDbZvlHYBAQEBAQEBAwEBAQEBAQEBGoEshQiEPIN7gh0HgneBVAEElk+CQ4Y8hX+HaIRrgW+DeTwvAQEBAYJHAQEB
X-IronPort-AV: E=Sophos;i="5.04,797,1406606400"; 
   d="scan'208";a="95892338"
Message-ID: <545829CA.7040900@voxpopuli.im>
Date: Tue, 04 Nov 2014 02:20:10 +0100
From: Alexandre Montplaisir <alexmonthy@voxpopuli.im>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: FW: [RFC 0/5] perf tools: Add perf data CTF conversion
References: <53F38C74.4030300@voxpopuli.im> <20140820092858.GA1203@krava.brq.redhat.com> <53F4F38C.4080407@voxpopuli.im> <5457C259.8030605@linutronix.de>
In-Reply-To: <5457C259.8030605@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On 11/03/2014 06:58 PM, Sebastian Andrzej Siewior wrote:
> [...]
> I did on the linux side:
>
> |perf record \
> | -e sched:sched_switch \
> | -a
>
> This gave me perf.data trace. No with the new extension I converted it
> into CTF data stream (perf data convert -i perf.data --to-ctf ctf) and
> imported it into eclipse as a new trace. By setting 'domain = "kernel"'
> I managed to get it accepted as a kernel trace.
>
> Additionally I had to:
> - rename sched:sched_switch -> sched_switch (I dropped the other events)
> - rename "perf_cpu" to "cpu_id" and move it within "packet context"
>    (had a patch for that but we wanted to merge this later)
> - I added "prev_tid" with the content of "prev_pid" and I added
>    "next_tid" with the content of "next_pid". Now exclipse does not
>    "freeze" after loading the first entry
> - I prefixed every entry with _ (so "prev_tid" becomes "_prev_tid") and
>    now it seems to be recognized by the tracing plugin.
>
> puh. Now I have something in "cpu usage", "control flow" windows.

This is really great! Initially, I had believed that we would have 
needed to add a separate parser plugin, and to consider "perf traces" as 
a completely different beast from LTTng traces. However if you can get 
this close to they way LTTng presents its data, then we can probably 
re-use most of the existing code. In which case we could rename the 
"LTTng Kernel Trace" type in the UI to simply "Linux Kernel Trace". And 
that would cover both LTTng kernel traces and CTF-perf traces.

> The cpu_id field change will be addressed soon on our side.
> Now, the remaining things:
> The "domain = kernel" thingy (or another identifier if desired) is
> something we could add.

Unless the event data is exactly the same, it would be easier to use a 
different name. Like "kernel-perf" for instance?
 From the user's point of view, both would still be Linux Kernel Traces, 
but we could use the domain internally to determine which event/field 
layout to use.

Mathieu, any thoughts on how CTF domains should be namespaced?

> What do we do on the naming convention?
>
> The converter takes basically the event names the way they come from
> perf. That is why we have a "system" prefix.
> For the member fields, we take all the specific ones as perf serves
> them. The only exception is for the generic fields which get a "perf_"
> prefix in order not to clash with the specific ones.
> And there is this _ prefix in front of every data member.
>
> Now that I identified the differences between the CTF from lttng and
> perf, any suggestions / ideas how this could be solved?

I suppose it would be better/cleaner if the event and field names would 
remain the same, or at least be similar, in the perf.data and perf-CTF 
formats.

If the trace events from both LTTng and perf represent the same thing 
(and I assume they should, since they come from the same tracepoints, 
right?), then we could just add a wrapper on the viewer side to decide 
which event/field names to use, depending on the trace type.

Right now, we only define LTTng event and field names:
http://git.eclipse.org/c/tracecompass/org.eclipse.tracecompass.git/tree/org.eclipse.tracecompass.lttng2.kernel.core/src/org/eclipse/tracecompass/internal/lttng2/kernel/core/LttngStrings.java

But if you could for example tell me the perf equivalents of all the 
strings in that file, I could hack together such wrapper. With that, in 
theory, perf traces should behave exactly the same as LTTng traces in 
the viewer!


Cheers,
Alexandre

ps.  fyi, we have recently moved the trace viewer code to its own 
project, now called "Trace Compass". We will still support the Linux 
Tools plugins for the time being, but all new developments are done in 
Trace Compass. If you want to check it out: http://eclipse.org/tracecompass

