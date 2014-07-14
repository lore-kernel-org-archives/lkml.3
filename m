Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbaGNOQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:16:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850AbaGNOQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:16:08 -0400
Date: Mon, 14 Jul 2014 16:15:33 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, acme@kernel.org,
        namhyung.kim@lge.com, tzanussi@gmail.com
Subject: Re: [RFC] perf to ctf converter
Message-ID: <20140714141533.GD17761@krava.redhat.com>
References: <20140603163640.GA16279@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603163640.GA16279@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 06:36:40PM +0200, Sebastian Andrzej Siewior wrote:
> I've been playing with python bindings of perf and babeltrace and came
> up with a way to covert the perf trace into the CTF format. It supports
> both ftrace events (perf record -e raw_syscalls:* w) and perf counters
> (perf record -e cache-misses w).
> 
> The recorded trace is first read via the "perf script" interface and
> saved as python pickle. In a second step the pickled-data is converted
> into a CTF file format. 
> 
> The perf part requires
>     "perf script: move the number processing into its own function"
>     "perf script: handle the num array type in python properly"
>     https://lkml.org/lkml/2014/5/27/434

I saw those 2 already in Arnaldo's tree

> 
> for array support and
>     "perf script: pass more arguments to the python event handler"
>     https://lkml.org/lkml/2014/5/30/392

and there's some other replacement for this one comming in soon IIUC

> 
> for more data while reading the "events" traces. The latter will be
> probably replaced by https://lkml.org/lkml/2014/4/3/217.
> Babeltrace needs only
>     "ctf-writer: Add support for the cpu_id field"
>     https://www.mail-archive.com/lttng-dev@lists.lttng.org/msg06057.html

any idea when this one will land in babeltrace git tree?

> 
> for the assignment of the CPU number.
> 
> The pickle step is nice because I see all type of events before I
> start writing the CTF trace and can create the necessary objects. On
> the other hand it eats a lot of memory for huge traces so I will try to
> replace it with something that saves the data in a streaming like
> fashion.
> The other limitation is that babeltrace doesn't seem to work with
> python2 while perf doesn't compile against python3.
> 
> What I haven't figured out yet is how to pass to the meta environment
> informations that is displayed by "perf script --header-only -I" and if
> that information is really important. Probably an optional python
> callback will do it.
> 
> The required steps:
> |   perf record -e raw_syscalls:* w
> |   perf script -s ./to-pickle.py
> |   ./ctf_writer

I made similar effort in C:

---
I made some *VERY* early perf convert example, mostly to try the ctf-writer
interface.. you can check in here:
  https://git.kernel.org/cgit/linux/kernel/git/jolsa/perf.git/log/?h=perf/ctf_2

It's able to convert single event (HW type) perf.data file into CTF data,
by adding just one integer field "period" and single stream, like:

  [jolsa@krava perf]$ LD_LIBRARY_PATH=/opt/libbabeltrace/lib/ ./perf data convert --to-ctf=./ctf-data
  ...
  [jolsa@krava babeltrace]$ /opt/libbabeltrace/bin/babeltrace /home/jolsa/kernel.org/linux-perf/tools/perf/ctf-data
  [08:14:45.814456098] (+?.?????????) cycles: { }, { period = 1 }
  [08:14:45.814459237] (+0.000003139) cycles: { }, { period = 1 }
  [08:14:45.814460684] (+0.000001447) cycles: { }, { period = 9 }
  [08:14:45.814462073] (+0.000001389) cycles: { }, { period = 182 }
  [08:14:45.814463491] (+0.000001418) cycles: { }, { period = 4263 }
  [08:14:45.814465874] (+0.000002383) cycles: { }, { period = 97878 }
  [08:14:45.814506385] (+0.000040511) cycles: { }, { period = 1365965 }
  [08:14:45.815056528] (+0.000550143) cycles: { }, { period = 2250012 }
---

the goals for me is to have a convert tool, like in above example
perf data command and support in perf record/report to directl
write/read ctf data

Using python for this seems nice.. I'm not experienced python coder,
so just small comments/questions

SNIP

> +list_type_h_uint64 = [ "addr" ]
> +
> +int32_type = CTFWriter.IntegerFieldDeclaration(32)
> +int32_type.signed = True
> +
> +uint64_type = CTFWriter.IntegerFieldDeclaration(64)
> +uint64_type.signed = False
> +
> +hex_uint64_type = CTFWriter.IntegerFieldDeclaration(64)
> +hex_uint64_type.signed = False
> +hex_uint64_type.base = 16
> +
> +string_type = CTFWriter.StringFieldDeclaration()
> +
> +events = {}
> +last_cpu = -1
> +
> +list_ev_entry_ignore = [ "common_s", "common_ns", "common_cpu" ]
> +
> +# First create all possible event class-es

this first iteration could be handled in the to-pickle step,
which could gather events description and store/pickle it
before the trace data

> +for entry in trace:
> +    event_name = entry[0]
> +    event_record = entry[1]
> +
> +    try:
> +        event_class = events[event_name]
> +    except:
> +        event_class = CTFWriter.EventClass(event_name);
> +        for ev_entry in sorted(event_record):
> +            if ev_entry in list_ev_entry_ignore:
> +                continue
> +            val = event_record[ev_entry]
> +            if isinstance(val, int):
> +                if ev_entry in list_type_h_uint64:
> +                    event_class.add_field(hex_uint64_type, ev_entry)
> +                else:
> +                    event_class.add_field(int32_type, ev_entry)
> +            elif isinstance(val, str):
> +                event_class.add_field(string_type, ev_entry)


SNIP

> +
> +def process_event(event_fields_dict):
> +    entry = []
> +    entry.append(str(event_fields_dict["ev_name"]))
> +    fields = {}
> +    fields["common_s"] = event_fields_dict["s"]
> +    fields["common_ns"] = event_fields_dict["ns"]
> +    fields["common_comm"] = event_fields_dict["comm"]
> +    fields["common_pid"] = event_fields_dict["pid"]
> +    fields["addr"] = event_fields_dict["addr"]
> +
> +    dso = ""
> +    symbol = ""
> +    try:
> +        dso = event_fields_dict["dso"]
> +    except:
> +        pass
> +    try:
> +        symbol = event_fields_dict["symbol"]
> +    except:
> +        pass

I understand this is just a early stage, but we want here
detection of the all event arguments, right?

I wonder we could add separated python callback for that

thanks,
jirka
