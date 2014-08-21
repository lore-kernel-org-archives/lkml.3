Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaHURwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:52:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbaHURwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:52:31 -0400
Date: Thu, 21 Aug 2014 18:58:41 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Alexandre Montplaisir <alexmonthy@voxpopuli.im>
Cc: linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: FW: [RFC 0/5] perf tools: Add perf data CTF conversion
Message-ID: <20140821165841.GA32088@krava.brq.redhat.com>
References: <53F38C74.4030300@voxpopuli.im>
 <20140820092858.GA1203@krava.brq.redhat.com>
 <53F4F38C.4080407@voxpopuli.im>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F4F38C.4080407@voxpopuli.im>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 03:14:20PM -0400, Alexandre Montplaisir wrote:
> On 08/20/2014 05:28 AM, Jiri Olsa wrote:
> >
> >ok, easy enough ;-) so I'm guessing this governs the expected
> >CTF layout for event/stream headers/contexts, right?
> 
> Correct, if the domain is "kernel" we then assume that the rest of the trace
> contains the expected elements of a kernel trace.
> 
> Of course, one could craft a CTF trace to advertize itself as "kernel" or
> "ust", and not actually have the layout of that trace type, in which case it
> would fail parsing later on.
> 
> >Also judging from the trace display, you have hardcoded specific
> >displays/actions for specific events? That's all connected/specific
> >under trace type?
> 
> Yes the trace type is the main "provider" of functionality. I could go into
> more details, but we use Eclipse extension points to define which columns to
> put in the event table, which views are available, etc. for each supported
> trace type.
> 
> >>Once we have some views or analysis specific to perf CTF traces, we could
> >>definitely add a separate trace type for those too.
> >I guess tracepoints and breakpoints should display something like
> >the standard kernel trace. As for HW events it's usual to display
> >profile infomation as the perf report does:
> >   https://perf.wiki.kernel.org/index.php/Tutorial#Sampling_with_perf_record
> 
> Interesting, I haven't tried the perf CTF output yet, but I could see it
> using the Statistics view (which by default just prints the % of events, per
> event type) to print the results of the different "perf reports", calculated
> from the CTF events. Eventually with pie charts!

Basically, perf monitors single HW event and reports its hits/samples
distribution across the workload processes.

Just by running:
  $ perf record ls ; perf report

you'll get report of HW event 'cycles' distribution over/during the
ls process life:

Samples: 29  of event 'cycles', Event count (approx.): 3763985
   9.65%  ls  [kernel.kallsyms]  [k] find_get_page
   5.09%  ls  [kernel.kallsyms]  [k] perf_event_context_sched_in
   5.09%  ls  ls                 [.] calculate_columns
   5.08%  ls  [kernel.kallsyms]  [k] tty_insert_flip_string_fixed_flag
   5.07%  ls  libc-2.17.so       [.] get_next_seq
   5.06%  ls  [kernel.kallsyms]  [k] down_read_trylock
   5.04%  ls  ls                 [.] xstrcoll_name
   5.03%  ls  libc-2.17.so       [.] __memmove_sse2
   5.03%  ls  libc-2.17.so       [.] _dl_addr
   5.00%  ls  [kernel.kallsyms]  [k] ext4_release_file
   4.99%  ls  [kernel.kallsyms]  [k] filemap_fault
   4.88%  ls  ld-2.17.so         [.] _dl_map_object_from_fd

> 
> >I tried to record/display lttng event perf:cpu:cycles, but got nothing
> >displayed in eclipse. Looks like this data provides only summary count
> >of the event for the workload?
> 
> Just to be sure I understand, you recorded an LTTng kernel trace, in which
> you enabled the "perf:cpu:cycles" context? Did this trace display anything
> in Babeltrace?
> It should display the same in the Eclipse viewer, the value of the context
> will be visible in the "Contents" column in the the table (and in the
> Properties view), although for now we don't make any use of it.

hum, I've got nothing from babeltrace:

[jolsa@krava ~]$ su
Password: 
[root@krava jolsa]# lttng create perf
Spawning a session daemon
Session perf created.
Traces will be written in /root/lttng-traces/perf-20140821-184956
[root@krava jolsa]# lttng add-context -k -t prio -t perf:cpu:cycles
kernel context prio added to all channels
kernel context perf:cpu:cycles added to all channels
[root@krava jolsa]# lttng start
Tracing started for session perf
[root@krava jolsa]# lttng stop
Waiting for data availability.
Tracing stopped for session perf
[root@krava jolsa]# lttng destroy
Session perf destroyed
[root@krava jolsa]# babeltrace ~/lttng-traces/perf-20140821-184956/
[root@krava jolsa]# babeltrace ~/lttng-traces/perf-20140821-184956/kernel/
[root@krava jolsa]#

and empty view in eclipse

thanks,
jirka
