Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaHEOv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:51:58 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53298 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbaHEOvx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:51:53 -0400
MIME-Version: 1.0
In-Reply-To: <53C9143C.1060905@linutronix.de>
References: <20140603163640.GA16279@linutronix.de>
	<20140714141533.GD17761@krava.redhat.com>
	<53C9143C.1060905@linutronix.de>
Date: Tue, 5 Aug 2014 10:51:49 -0400
X-Google-Sender-Auth: tiub6nvKPqVYwy6aP9FXLw0LnII
Message-ID: <CA+jJMxum9jFVZ9NN+FkHHQhwULDSCkxa=vbRpHZ-Es-ni57ffQ@mail.gmail.com>
Subject: Re: [lttng-dev] [RFC] perf to ctf converter
From: =?UTF-8?Q?J=C3=A9r=C3=A9mie_Galarneau?= 
	<jeremie.galarneau@efficios.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jiri Olsa <jolsa@redhat.com>, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, acme@kernel.org,
        "lttng-dev@lists.lttng.org" <lttng-dev@lists.lttng.org>,
        tzanussi@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 8:34 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> On 07/14/2014 04:15 PM, Jiri Olsa wrote:
>>> for more data while reading the "events" traces. The latter will be
>>> probably replaced by https://lkml.org/lkml/2014/4/3/217.
>>> Babeltrace needs only
>>>     "ctf-writer: Add support for the cpu_id field"
>>>     https://www.mail-archive.com/lttng-dev@lists.lttng.org/msg06057.html
>>
>> any idea when this one will land in babeltrace git tree?
>
> Need to re-do them the way they asked. Could take some time. However I
> wanted first to make sure it make sense to continue that approach.
>

FYI, I have made the changes and they are now upstream in Babeltrace as of

commit 12c8a1a3121ed7125e8758065c44658d8eda1333
Author: Jérémie Galarneau <jeremie.galarneau@efficios.com>
Date:   Tue Jul 29 16:51:51 2014 -0400

    Add stream packet header accessors

    Stream packet contexts may now be modified to contain custom
    fields. The events_discarded field is now handled like a generic
    packet context field.

    Signed-off-by: Jérémie Galarneau <jeremie.galarneau@efficios.com>


Regards,
Jérémie

>>>
>>> for the assignment of the CPU number.
>>>
>>> The pickle step is nice because I see all type of events before I
>>> start writing the CTF trace and can create the necessary objects. On
>>> the other hand it eats a lot of memory for huge traces so I will try to
>>> replace it with something that saves the data in a streaming like
>>> fashion.
>>> The other limitation is that babeltrace doesn't seem to work with
>>> python2 while perf doesn't compile against python3.
>>>
>>> What I haven't figured out yet is how to pass to the meta environment
>>> informations that is displayed by "perf script --header-only -I" and if
>>> that information is really important. Probably an optional python
>>> callback will do it.
>>>
>>> The required steps:
>>> |   perf record -e raw_syscalls:* w
>>> |   perf script -s ./to-pickle.py
>>> |   ./ctf_writer
>>
>> I made similar effort in C:
>>
>> ---
>> I made some *VERY* early perf convert example, mostly to try the ctf-writer
>> interface.. you can check in here:
>>   https://git.kernel.org/cgit/linux/kernel/git/jolsa/perf.git/log/?h=perf/ctf_2
>
> Let me try it, maybe I can migrate my effort into one code basis.
>
>> It's able to convert single event (HW type) perf.data file into CTF data,
>> by adding just one integer field "period" and single stream, like:
>>
>>   [jolsa@krava perf]$ LD_LIBRARY_PATH=/opt/libbabeltrace/lib/ ./perf data convert --to-ctf=./ctf-data
>>   ...
>>   [jolsa@krava babeltrace]$ /opt/libbabeltrace/bin/babeltrace /home/jolsa/kernel.org/linux-perf/tools/perf/ctf-data
>>   [08:14:45.814456098] (+?.?????????) cycles: { }, { period = 1 }
>>   [08:14:45.814459237] (+0.000003139) cycles: { }, { period = 1 }
>>   [08:14:45.814460684] (+0.000001447) cycles: { }, { period = 9 }
>>   [08:14:45.814462073] (+0.000001389) cycles: { }, { period = 182 }
>>   [08:14:45.814463491] (+0.000001418) cycles: { }, { period = 4263 }
>>   [08:14:45.814465874] (+0.000002383) cycles: { }, { period = 97878 }
>>   [08:14:45.814506385] (+0.000040511) cycles: { }, { period = 1365965 }
>>   [08:14:45.815056528] (+0.000550143) cycles: { }, { period = 2250012 }
>> ---
>>
>> the goals for me is to have a convert tool, like in above example
>> perf data command and support in perf record/report to directl
>> write/read ctf data
>>
>> Using python for this seems nice.. I'm not experienced python coder,
>> so just small comments/questions
>
> python looked nice because I saw libraries / interfaces on both sides.
>
>> SNIP
>>
>>> +list_type_h_uint64 = [ "addr" ]
>>> +
>>> +int32_type = CTFWriter.IntegerFieldDeclaration(32)
>>> +int32_type.signed = True
>>> +
>>> +uint64_type = CTFWriter.IntegerFieldDeclaration(64)
>>> +uint64_type.signed = False
>>> +
>>> +hex_uint64_type = CTFWriter.IntegerFieldDeclaration(64)
>>> +hex_uint64_type.signed = False
>>> +hex_uint64_type.base = 16
>>> +
>>> +string_type = CTFWriter.StringFieldDeclaration()
>>> +
>>> +events = {}
>>> +last_cpu = -1
>>> +
>>> +list_ev_entry_ignore = [ "common_s", "common_ns", "common_cpu" ]
>>> +
>>> +# First create all possible event class-es
>>
>> this first iteration could be handled in the to-pickle step,
>> which could gather events description and store/pickle it
>> before the trace data
>
> yes.
>
>>> +for entry in trace:
>>> +    event_name = entry[0]
>>> +    event_record = entry[1]
>>> +
>>> +    try:
>>> +        event_class = events[event_name]
>>> +    except:
>>> +        event_class = CTFWriter.EventClass(event_name);
>>> +        for ev_entry in sorted(event_record):
>>> +            if ev_entry in list_ev_entry_ignore:
>>> +                continue
>>> +            val = event_record[ev_entry]
>>> +            if isinstance(val, int):
>>> +                if ev_entry in list_type_h_uint64:
>>> +                    event_class.add_field(hex_uint64_type, ev_entry)
>>> +                else:
>>> +                    event_class.add_field(int32_type, ev_entry)
>>> +            elif isinstance(val, str):
>>> +                event_class.add_field(string_type, ev_entry)
>>
>>
>> SNIP
>>
>>> +
>>> +def process_event(event_fields_dict):
>>> +    entry = []
>>> +    entry.append(str(event_fields_dict["ev_name"]))
>>> +    fields = {}
>>> +    fields["common_s"] = event_fields_dict["s"]
>>> +    fields["common_ns"] = event_fields_dict["ns"]
>>> +    fields["common_comm"] = event_fields_dict["comm"]
>>> +    fields["common_pid"] = event_fields_dict["pid"]
>>> +    fields["addr"] = event_fields_dict["addr"]
>>> +
>>> +    dso = ""
>>> +    symbol = ""
>>> +    try:
>>> +        dso = event_fields_dict["dso"]
>>> +    except:
>>> +        pass
>>> +    try:
>>> +        symbol = event_fields_dict["symbol"]
>>> +    except:
>>> +        pass
>>
>> I understand this is just a early stage, but we want here
>> detection of the all event arguments, right?
>
> Yes. The CTF writer is stupid and takes all arguments as-is and passes
> it over the babeltrace part of CTF writer. This works well for the
> ftrace events (handled by trace_unhandled()).
>
>
>> I wonder we could add separated python callback for that
>
> This (the to pickle part) tries come up with the common basis for the
> CPU events. Therefore it renames the first few arguments (like s to
> common_s) to make it consistent with the ftrace events.
> The dso and symbol members look optional depending whether or not this
> data was available at trace time. I *think* those may change within a
> stream say if one library has debug symbols available and the other
> does not. So I have no idea how you plan specific callbacks for those.
>
>> thanks,
>> jirka
>
> Sebastian
>
> _______________________________________________
> lttng-dev mailing list
> lttng-dev@lists.lttng.org
> http://lists.lttng.org/cgi-bin/mailman/listinfo/lttng-dev



-- 
Jérémie Galarneau
EfficiOS Inc.
http://www.efficios.com
