Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaKCR7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:59:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:54548 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbaKCR6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:58:54 -0500
Message-ID: <5457C259.8030605@linutronix.de>
Date: Mon, 03 Nov 2014 18:58:49 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Alexandre Montplaisir <alexmonthy@voxpopuli.im>,
        Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: FW: [RFC 0/5] perf tools: Add perf data CTF conversion
References: <53F38C74.4030300@voxpopuli.im> <20140820092858.GA1203@krava.brq.redhat.com> <53F4F38C.4080407@voxpopuli.im>
In-Reply-To: <53F4F38C.4080407@voxpopuli.im>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 09:14 PM, Alexandre Montplaisir wrote:
> On 08/20/2014 05:28 AM, Jiri Olsa wrote:
>>
>> ok, easy enough ;-) so I'm guessing this governs the expected
>> CTF layout for event/stream headers/contexts, right?
> 
> Correct, if the domain is "kernel" we then assume that the rest of the
> trace contains the expected elements of a kernel trace.

So that is one thing that I had to add.

> Of course, one could craft a CTF trace to advertize itself as "kernel"
> or "ust", and not actually have the layout of that trace type, in which
> case it would fail parsing later on.
> 
>> Also judging from the trace display, you have hardcoded specific
>> displays/actions for specific events? That's all connected/specific
>> under trace type?
> 
> Yes the trace type is the main "provider" of functionality. I could go
> into more details, but we use Eclipse extension points to define which
> columns to put in the event table, which views are available, etc. for
> each supported trace type.
> 
>>> Once we have some views or analysis specific to perf CTF traces, we
>>> could
>>> definitely add a separate trace type for those too.
>> I guess tracepoints and breakpoints should display something like
>> the standard kernel trace. As for HW events it's usual to display
>> profile infomation as the perf report does:
>>   
>> https://perf.wiki.kernel.org/index.php/Tutorial#Sampling_with_perf_record
> 
> Interesting, I haven't tried the perf CTF output yet, but I could see it
> using the Statistics view (which by default just prints the % of events,
> per event type) to print the results of the different "perf reports",
> calculated from the CTF events. Eventually with pie charts!

I did on the linux side:

|perf record \
| -e sched:sched_switch \
| -a

This gave me perf.data trace. No with the new extension I converted it
into CTF data stream (perf data convert -i perf.data --to-ctf ctf) and
imported it into eclipse as a new trace. By setting 'domain = "kernel"'
I managed to get it accepted as a kernel trace.

Additionally I had to:
- rename sched:sched_switch -> sched_switch (I dropped the other events)
- rename "perf_cpu" to "cpu_id" and move it within "packet context"
  (had a patch for that but we wanted to merge this later)
- I added "prev_tid" with the content of "prev_pid" and I added
  "next_tid" with the content of "next_pid". Now exclipse does not
  "freeze" after loading the first entry
- I prefixed every entry with _ (so "prev_tid" becomes "_prev_tid") and
  now it seems to be recognized by the tracing plugin.

puh. Now I have something in "cpu usage", "control flow" windows.
The cpu_id field change will be addressed soon on our side.
Now, the remaining things:
The "domain = kernel" thingy (or another identifier if desired) is
something we could add.
What do we do on the naming convention?

The converter takes basically the event names the way they come from
perf. That is why we have a "system" prefix.
For the member fields, we take all the specific ones as perf serves
them. The only exception is for the generic fields which get a "perf_"
prefix in order not to clash with the specific ones.
And there is this _ prefix in front of every data member.

Now that I identified the differences between the CTF from lttng and
perf, any suggestions / ideas how this could be solved?

> Cheers,
> Alexandre

Sebastian
