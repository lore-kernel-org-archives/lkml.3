Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbaGUPgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:36:41 -0400
Received: from mail.efficios.com ([78.47.125.74]:40951 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322AbaGUPgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:36:39 -0400
Date: Mon, 21 Jul 2014 15:36:40 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jeremie Galarneau <jgalar@efficios.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        lttng-dev@lists.lttng.org, acme@kernel.org,
        namhyung kim <namhyung.kim@lge.com>, tzanussi@gmail.com
Message-ID: <646184656.17805.1405957000357.JavaMail.zimbra@efficios.com>
In-Reply-To: <53C9143C.1060905@linutronix.de>
References: <20140603163640.GA16279@linutronix.de> <20140714141533.GD17761@krava.redhat.com> <53C9143C.1060905@linutronix.de>
Subject: Re: [RFC] perf to ctf converter
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [173.246.29.13]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF30 (Linux)/8.0.7_GA_6021)
Thread-Topic: perf to ctf converter
Thread-Index: Wc9wU4RYgyeu5jqiER80H1OCvfmmVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
> To: "Jiri Olsa" <jolsa@redhat.com>
> Cc: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
> acme@kernel.org, "namhyung kim" <namhyung.kim@lge.com>, tzanussi@gmail.com
> Sent: Friday, July 18, 2014 8:34:04 AM
> Subject: Re: [RFC] perf to ctf converter
> 
> On 07/14/2014 04:15 PM, Jiri Olsa wrote:
> >> for more data while reading the "events" traces. The latter will be
> >> probably replaced by https://lkml.org/lkml/2014/4/3/217.
> >> Babeltrace needs only
> >>     "ctf-writer: Add support for the cpu_id field"
> >>     https://www.mail-archive.com/lttng-dev@lists.lttng.org/msg06057.html
> > 
> > any idea when this one will land in babeltrace git tree?
> 
> Need to re-do them the way they asked. Could take some time. However I
> wanted first to make sure it make sense to continue that approach.

CCing Jérémie, co-maintainer of Babeltrace. He will be able to answer your
questions and help out.

Thanks!

Mathieu

> 
> >>
> >> for the assignment of the CPU number.
> >>
> >> The pickle step is nice because I see all type of events before I
> >> start writing the CTF trace and can create the necessary objects. On
> >> the other hand it eats a lot of memory for huge traces so I will try to
> >> replace it with something that saves the data in a streaming like
> >> fashion.
> >> The other limitation is that babeltrace doesn't seem to work with
> >> python2 while perf doesn't compile against python3.
> >>
> >> What I haven't figured out yet is how to pass to the meta environment
> >> informations that is displayed by "perf script --header-only -I" and if
> >> that information is really important. Probably an optional python
> >> callback will do it.
> >>
> >> The required steps:
> >> |   perf record -e raw_syscalls:* w
> >> |   perf script -s ./to-pickle.py
> >> |   ./ctf_writer
> > 
> > I made similar effort in C:
> > 
> > ---
> > I made some *VERY* early perf convert example, mostly to try the ctf-writer
> > interface.. you can check in here:
> >   https://git.kernel.org/cgit/linux/kernel/git/jolsa/perf.git/log/?h=perf/ctf_2
> 
> Let me try it, maybe I can migrate my effort into one code basis.
> 
> > It's able to convert single event (HW type) perf.data file into CTF data,
> > by adding just one integer field "period" and single stream, like:
> > 
> >   [jolsa@krava perf]$ LD_LIBRARY_PATH=/opt/libbabeltrace/lib/ ./perf data
> >   convert --to-ctf=./ctf-data
> >   ...
> >   [jolsa@krava babeltrace]$ /opt/libbabeltrace/bin/babeltrace
> >   /home/jolsa/kernel.org/linux-perf/tools/perf/ctf-data
> >   [08:14:45.814456098] (+?.?????????) cycles: { }, { period = 1 }
> >   [08:14:45.814459237] (+0.000003139) cycles: { }, { period = 1 }
> >   [08:14:45.814460684] (+0.000001447) cycles: { }, { period = 9 }
> >   [08:14:45.814462073] (+0.000001389) cycles: { }, { period = 182 }
> >   [08:14:45.814463491] (+0.000001418) cycles: { }, { period = 4263 }
> >   [08:14:45.814465874] (+0.000002383) cycles: { }, { period = 97878 }
> >   [08:14:45.814506385] (+0.000040511) cycles: { }, { period = 1365965 }
> >   [08:14:45.815056528] (+0.000550143) cycles: { }, { period = 2250012 }
> > ---
> > 
> > the goals for me is to have a convert tool, like in above example
> > perf data command and support in perf record/report to directl
> > write/read ctf data
> > 
> > Using python for this seems nice.. I'm not experienced python coder,
> > so just small comments/questions
> 
> python looked nice because I saw libraries / interfaces on both sides.
> 
> > SNIP
> > 
> >> +list_type_h_uint64 = [ "addr" ]
> >> +
> >> +int32_type = CTFWriter.IntegerFieldDeclaration(32)
> >> +int32_type.signed = True
> >> +
> >> +uint64_type = CTFWriter.IntegerFieldDeclaration(64)
> >> +uint64_type.signed = False
> >> +
> >> +hex_uint64_type = CTFWriter.IntegerFieldDeclaration(64)
> >> +hex_uint64_type.signed = False
> >> +hex_uint64_type.base = 16
> >> +
> >> +string_type = CTFWriter.StringFieldDeclaration()
> >> +
> >> +events = {}
> >> +last_cpu = -1
> >> +
> >> +list_ev_entry_ignore = [ "common_s", "common_ns", "common_cpu" ]
> >> +
> >> +# First create all possible event class-es
> > 
> > this first iteration could be handled in the to-pickle step,
> > which could gather events description and store/pickle it
> > before the trace data
> 
> yes.
> 
> >> +for entry in trace:
> >> +    event_name = entry[0]
> >> +    event_record = entry[1]
> >> +
> >> +    try:
> >> +        event_class = events[event_name]
> >> +    except:
> >> +        event_class = CTFWriter.EventClass(event_name);
> >> +        for ev_entry in sorted(event_record):
> >> +            if ev_entry in list_ev_entry_ignore:
> >> +                continue
> >> +            val = event_record[ev_entry]
> >> +            if isinstance(val, int):
> >> +                if ev_entry in list_type_h_uint64:
> >> +                    event_class.add_field(hex_uint64_type, ev_entry)
> >> +                else:
> >> +                    event_class.add_field(int32_type, ev_entry)
> >> +            elif isinstance(val, str):
> >> +                event_class.add_field(string_type, ev_entry)
> > 
> > 
> > SNIP
> > 
> >> +
> >> +def process_event(event_fields_dict):
> >> +    entry = []
> >> +    entry.append(str(event_fields_dict["ev_name"]))
> >> +    fields = {}
> >> +    fields["common_s"] = event_fields_dict["s"]
> >> +    fields["common_ns"] = event_fields_dict["ns"]
> >> +    fields["common_comm"] = event_fields_dict["comm"]
> >> +    fields["common_pid"] = event_fields_dict["pid"]
> >> +    fields["addr"] = event_fields_dict["addr"]
> >> +
> >> +    dso = ""
> >> +    symbol = ""
> >> +    try:
> >> +        dso = event_fields_dict["dso"]
> >> +    except:
> >> +        pass
> >> +    try:
> >> +        symbol = event_fields_dict["symbol"]
> >> +    except:
> >> +        pass
> > 
> > I understand this is just a early stage, but we want here
> > detection of the all event arguments, right?
> 
> Yes. The CTF writer is stupid and takes all arguments as-is and passes
> it over the babeltrace part of CTF writer. This works well for the
> ftrace events (handled by trace_unhandled()).
> 
> 
> > I wonder we could add separated python callback for that
> 
> This (the to pickle part) tries come up with the common basis for the
> CPU events. Therefore it renames the first few arguments (like s to
> common_s) to make it consistent with the ftrace events.
> The dso and symbol members look optional depending whether or not this
> data was available at trace time. I *think* those may change within a
> stream say if one library has debug symbols available and the other
> does not. So I have no idea how you plan specific callbacks for those.
> 
> > thanks,
> > jirka
> 
> Sebastian
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
