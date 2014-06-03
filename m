Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765AbaFCQgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 12:36:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:56804 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933715AbaFCQgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 12:36:44 -0400
Date: Tue, 3 Jun 2014 18:36:40 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, acme@kernel.org,
        namhyung.kim@lge.com, tzanussi@gmail.com
Subject: [RFC] perf to ctf converter
Message-ID: <20140603163640.GA16279@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been playing with python bindings of perf and babeltrace and came
up with a way to covert the perf trace into the CTF format. It supports
both ftrace events (perf record -e raw_syscalls:* w) and perf counters
(perf record -e cache-misses w).

The recorded trace is first read via the "perf script" interface and
saved as python pickle. In a second step the pickled-data is converted
into a CTF file format. 

The perf part requires
    "perf script: move the number processing into its own function"
    "perf script: handle the num array type in python properly"
    https://lkml.org/lkml/2014/5/27/434

for array support and
    "perf script: pass more arguments to the python event handler"
    https://lkml.org/lkml/2014/5/30/392

for more data while reading the "events" traces. The latter will be
probably replaced by https://lkml.org/lkml/2014/4/3/217.
Babeltrace needs only
    "ctf-writer: Add support for the cpu_id field"
    https://www.mail-archive.com/lttng-dev@lists.lttng.org/msg06057.html

for the assignment of the CPU number.

The pickle step is nice because I see all type of events before I
start writing the CTF trace and can create the necessary objects. On
the other hand it eats a lot of memory for huge traces so I will try to
replace it with something that saves the data in a streaming like
fashion.
The other limitation is that babeltrace doesn't seem to work with
python2 while perf doesn't compile against python3.

What I haven't figured out yet is how to pass to the meta environment
informations that is displayed by "perf script --header-only -I" and if
that information is really important. Probably an optional python
callback will do it.

The required steps:
|   perf record -e raw_syscalls:* w
|   perf script -s ./to-pickle.py
|   ./ctf_writer

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

diff -pruN a/ctf_writer.py b/ctf_writer.py
--- a/ctf_writer.py	1970-01-01 01:00:00.000000000 +0100
+++ b/ctf_writer.py	2014-06-03 17:23:53.852207400 +0200
@@ -0,0 +1,132 @@
+#!/usr/bin/env python3
+# ctf_writer.py
+#
+
+from babeltrace import *
+import pickle
+
+trace_file = "ctf-data.pickle"
+trace_path = "ctf-out"
+
+print("Writing trace at %s from %s" %(trace_path, trace_file))
+
+trace = pickle.load(open(trace_file, "rb"))
+
+writer = CTFWriter.Writer(trace_path)
+
+clock = CTFWriter.Clock("monotonic")
+clock.description = "Monotonic Clock"
+clock.offset = 0 # XXX
+
+writer.add_clock(clock)
+writer.add_environment_field("hostname", "bach")
+writer.add_environment_field("domain", "kernel")
+writer.add_environment_field("sysname", "Linux")
+writer.add_environment_field("kernel_release", "3.6.0") # XXX
+writer.add_environment_field("kernel_version", "#8 SMP Fri May 23 15:29:41 CEST 2014") # XXX
+writer.add_environment_field("tracer_name", "perf")
+writer.add_environment_field("tracer_major", "2")
+writer.add_environment_field("tracer_minor", "4")
+writer.add_environment_field("tracer_patchlevel", "0")
+
+stream_class = CTFWriter.StreamClass("stream")
+stream_class.clock = clock
+
+# certain file types may be 32bit or 64bit. Even the first event we find and
+# build our type might pass NULL which would mean 32bit. The second event
+# might pass a 64bit.
+# For now we default hex to u64 for array, have a list of hex u64 and everything
+# else is s32.
+list_type_h_uint64 = [ "addr" ]
+
+int32_type = CTFWriter.IntegerFieldDeclaration(32)
+int32_type.signed = True
+
+uint64_type = CTFWriter.IntegerFieldDeclaration(64)
+uint64_type.signed = False
+
+hex_uint64_type = CTFWriter.IntegerFieldDeclaration(64)
+hex_uint64_type.signed = False
+hex_uint64_type.base = 16
+
+string_type = CTFWriter.StringFieldDeclaration()
+
+events = {}
+last_cpu = -1
+
+list_ev_entry_ignore = [ "common_s", "common_ns", "common_cpu" ]
+
+# First create all possible event class-es
+for entry in trace:
+    event_name = entry[0]
+    event_record = entry[1]
+
+    try:
+        event_class = events[event_name]
+    except:
+        event_class = CTFWriter.EventClass(event_name);
+        for ev_entry in sorted(event_record):
+            if ev_entry in list_ev_entry_ignore:
+                continue
+            val = event_record[ev_entry]
+            if isinstance(val, int):
+                if ev_entry in list_type_h_uint64:
+                    event_class.add_field(hex_uint64_type, ev_entry)
+                else:
+                    event_class.add_field(int32_type, ev_entry)
+            elif isinstance(val, str):
+                event_class.add_field(string_type, ev_entry)
+            elif isinstance(val, list):
+                array_type = CTFWriter.ArrayFieldDeclaration(hex_uint64_type, len(val))
+                event_class.add_field(array_type, ev_entry)
+            else:
+                print("Unknown type in trace: %s" %(type(event_record[ev_entry])))
+                raise Exception("Unknown type in trace.")
+
+        # Add complete class with all event members.
+        print("New event type: %s" %(event_name))
+        stream_class.add_event_class(event_class)
+        events[event_name] = event_class
+
+print("Event types complete")
+stream = writer.create_stream(stream_class)
+
+# Step two, fill it with data
+for entry in trace:
+    event_name = entry[0]
+    event_record = entry[1]
+
+    ts = int((int(event_record["common_s"]) * 1e9 + int(event_record["common_ns"])))
+
+    event_class = events[event_name]
+    event = CTFWriter.Event(event_class)
+
+    clock.time = ts
+
+    for ev_entry in event_record:
+        if ev_entry in list_ev_entry_ignore:
+            continue
+
+        field = event.payload(ev_entry)
+        val = event_record[ev_entry]
+        if isinstance(val, int):
+            field.value = int(val)
+        elif isinstance(val, str):
+            field.value = val
+        elif isinstance(val, list):
+            for i in range(len(val)):
+                a_idx = field.field(i)
+                a_idx.value = int(val[i])
+        else:
+            print("Unexpected entry type: %s" %(type(val)))
+            raise Exception("Unexpected type in trace.")
+
+    stream.append_event(event)
+    cur_cpu = int(event_record["common_cpu"])
+    if cur_cpu != last_cpu:
+        stream.append_cpu_id(cur_cpu)
+        last_cpu = cur_cpu
+        stream.flush()
+
+stream.flush()
+print("Done.")
diff -pruN a/to-pickle.py b/to-pickle.py
--- a/to-pickle.py	1970-01-01 01:00:00.000000000 +0100
+++ b/to-pickle.py	2014-06-03 17:23:53.864208292 +0200
@@ -0,0 +1,57 @@
+# perf script event handlers, generated by perf script -g python
+# Licensed under the terms of the GNU GPL License version 2
+
+import os
+import sys
+import cPickle as pickle
+
+sys.path.append(os.environ['PERF_EXEC_PATH'] + \
+	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+
+from perf_trace_context import *
+from Core import *
+
+trace = []
+
+def trace_begin():
+    pass
+
+def trace_end():
+    pickle.dump(trace, open("ctf-data.pickle", "wb"))
+    print "Dump complete"
+
+def trace_unhandled(event_name, context, event_fields_dict):
+    entry = []
+    entry.append(str(event_name))
+    entry.append(event_fields_dict.copy())
+    trace.append(entry)
+
+def process_event(event_fields_dict):
+    entry = []
+    entry.append(str(event_fields_dict["ev_name"]))
+    fields = {}
+    fields["common_s"] = event_fields_dict["s"]
+    fields["common_ns"] = event_fields_dict["ns"]
+    fields["common_comm"] = event_fields_dict["comm"]
+    fields["common_pid"] = event_fields_dict["pid"]
+    fields["addr"] = event_fields_dict["addr"]
+
+    dso = ""
+    symbol = ""
+    try:
+        dso = event_fields_dict["dso"]
+    except:
+        pass
+    try:
+        symbol = event_fields_dict["symbol"]
+    except:
+        pass
+
+    fields["symbol"] = symbol
+    fields["dso"] = dso
+
+    # no CPU entry
+    fields["common_cpu"] = 0
+
+    entry.append(fields)
+    trace.append(entry)
