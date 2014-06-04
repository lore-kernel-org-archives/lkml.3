Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaFDMb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:31:28 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:35979 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044AbaFDMbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:31:25 -0400
Message-ID: <538F0BF2.1010806@tu-dresden.de>
Date: Wed, 04 Jun 2014 14:07:14 +0200
From: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Add callchain to generic and tracepoint events.
References: <53031D2C.2050009@tu-dresden.de>	<20140307141857.GA3153@ghostprotocols.net>	<533D2283.3090703@tu-dresden.de> <87wqd5f7j5.fsf@sejong.aot.lge.com>
In-Reply-To: <87wqd5f7j5.fsf@sejong.aot.lge.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080108050009010704070207"
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080108050009010704070207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Add callchain to generic and tracepoint events.
Since this alters the interface for the python scripts,=20
also adjust the script generation and the provided scripts.

Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Acked-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
---
 .../python/Perf-Trace-Util/lib/Perf/Trace/Core.py  |   3 +-
 tools/perf/scripts/python/check-perf-trace.py      |   4 +-
 .../perf/scripts/python/failed-syscalls-by-pid.py  |   2 +-
 tools/perf/scripts/python/futex-contention.py      |   4 +-
 tools/perf/scripts/python/net_dropmonitor.py       |   2 +-
 tools/perf/scripts/python/netdev-times.py          |  26 ++---
 tools/perf/scripts/python/sched-migration.py       |  41 ++++----
 tools/perf/scripts/python/sctop.py                 |   2 +-
 tools/perf/scripts/python/syscall-counts-by-pid.py |   2 +-
 tools/perf/scripts/python/syscall-counts.py        |   2 +-
 .../util/scripting-engines/trace-event-python.c    | 106 +++++++++++++++=
+++++-
 11 files changed, 146 insertions(+), 48 deletions(-)

diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Cor=
e.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
index de7211e..38dfb72 100644
--- a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
@@ -107,12 +107,13 @@ def taskState(state):
=20
 class EventHeaders:
 	def __init__(self, common_cpu, common_secs, common_nsecs,
-		     common_pid, common_comm):
+		     common_pid, common_comm, common_callchain):
 		self.cpu =3D common_cpu
 		self.secs =3D common_secs
 		self.nsecs =3D common_nsecs
 		self.pid =3D common_pid
 		self.comm =3D common_comm
+		self.callchain =3D common_callchain
=20
 	def ts(self):
 		return (self.secs * (10 ** 9)) + self.nsecs
diff --git a/tools/perf/scripts/python/check-perf-trace.py b/tools/perf/s=
cripts/python/check-perf-trace.py
index 4647a76..334599c 100644
--- a/tools/perf/scripts/python/check-perf-trace.py
+++ b/tools/perf/scripts/python/check-perf-trace.py
@@ -27,7 +27,7 @@ def trace_end():
=20
 def irq__softirq_entry(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	vec):
+	common_callchain, vec):
 		print_header(event_name, common_cpu, common_secs, common_nsecs,
 			common_pid, common_comm)
=20
@@ -38,7 +38,7 @@ def irq__softirq_entry(event_name, context, common_cpu,=

=20
 def kmem__kmalloc(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	call_site, ptr, bytes_req, bytes_alloc,
+	common_callchain, call_site, ptr, bytes_req, bytes_alloc,
 	gfp_flags):
 		print_header(event_name, common_cpu, common_secs, common_nsecs,
 			common_pid, common_comm)
diff --git a/tools/perf/scripts/python/failed-syscalls-by-pid.py b/tools/=
perf/scripts/python/failed-syscalls-by-pid.py
index 85805fa..24c97a5 100644
--- a/tools/perf/scripts/python/failed-syscalls-by-pid.py
+++ b/tools/perf/scripts/python/failed-syscalls-by-pid.py
@@ -39,7 +39,7 @@ def trace_end():
=20
 def raw_syscalls__sys_exit(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	id, ret):
+	common_callchain, id, ret):
 	if (for_comm and common_comm !=3D for_comm) or \
 	   (for_pid  and common_pid  !=3D for_pid ):
 		return
diff --git a/tools/perf/scripts/python/futex-contention.py b/tools/perf/s=
cripts/python/futex-contention.py
index 11e70a3..0f5cf43 100644
--- a/tools/perf/scripts/python/futex-contention.py
+++ b/tools/perf/scripts/python/futex-contention.py
@@ -21,7 +21,7 @@ thread_blocktime =3D {}
 lock_waits =3D {} # long-lived stats on (tid,lock) blockage elapsed time=

 process_names =3D {} # long-lived pid-to-execname mapping
=20
-def syscalls__sys_enter_futex(event, ctxt, cpu, s, ns, tid, comm,
+def syscalls__sys_enter_futex(event, ctxt, cpu, s, ns, tid, comm, callch=
ain,
 			      nr, uaddr, op, val, utime, uaddr2, val3):
 	cmd =3D op & FUTEX_CMD_MASK
 	if cmd !=3D FUTEX_WAIT:
@@ -31,7 +31,7 @@ def syscalls__sys_enter_futex(event, ctxt, cpu, s, ns, =
tid, comm,
 	thread_thislock[tid] =3D uaddr
 	thread_blocktime[tid] =3D nsecs(s, ns)
=20
-def syscalls__sys_exit_futex(event, ctxt, cpu, s, ns, tid, comm,
+def syscalls__sys_exit_futex(event, ctxt, cpu, s, ns, tid, comm, callcha=
in,
 			     nr, ret):
 	if thread_blocktime.has_key(tid):
 		elapsed =3D nsecs(s, ns) - thread_blocktime[tid]
diff --git a/tools/perf/scripts/python/net_dropmonitor.py b/tools/perf/sc=
ripts/python/net_dropmonitor.py
index b574059..0b6ce8c 100755
--- a/tools/perf/scripts/python/net_dropmonitor.py
+++ b/tools/perf/scripts/python/net_dropmonitor.py
@@ -66,7 +66,7 @@ def trace_end():
 	print_drop_table()
=20
 # called from perf, when it finds a correspoinding event
-def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm,
+def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm, callchain,
 		   skbaddr, location, protocol):
 	slocation =3D str(location)
 	try:
diff --git a/tools/perf/scripts/python/netdev-times.py b/tools/perf/scrip=
ts/python/netdev-times.py
index 9aa0a32..4d21ef2 100644
--- a/tools/perf/scripts/python/netdev-times.py
+++ b/tools/perf/scripts/python/netdev-times.py
@@ -224,75 +224,75 @@ def trace_end():
 			(len(rx_skb_list), of_count_rx_skb_list)
=20
 # called from perf, when it finds a correspoinding event
-def irq__softirq_entry(name, context, cpu, sec, nsec, pid, comm, vec):
+def irq__softirq_entry(name, context, cpu, sec, nsec, pid, comm, callcha=
in, vec):
 	if symbol_str("irq__softirq_entry", "vec", vec) !=3D "NET_RX":
 		return
 	event_info =3D (name, context, cpu, nsecs(sec, nsec), pid, comm, vec)
 	all_event_list.append(event_info)
=20
-def irq__softirq_exit(name, context, cpu, sec, nsec, pid, comm, vec):
+def irq__softirq_exit(name, context, cpu, sec, nsec, pid, comm, callchai=
n, vec):
 	if symbol_str("irq__softirq_entry", "vec", vec) !=3D "NET_RX":
 		return
 	event_info =3D (name, context, cpu, nsecs(sec, nsec), pid, comm, vec)
 	all_event_list.append(event_info)
=20
-def irq__softirq_raise(name, context, cpu, sec, nsec, pid, comm, vec):
+def irq__softirq_raise(name, context, cpu, sec, nsec, pid, comm, callcha=
in, vec):
 	if symbol_str("irq__softirq_entry", "vec", vec) !=3D "NET_RX":
 		return
 	event_info =3D (name, context, cpu, nsecs(sec, nsec), pid, comm, vec)
 	all_event_list.append(event_info)
=20
 def irq__irq_handler_entry(name, context, cpu, sec, nsec, pid, comm,
-			irq, irq_name):
+			callchain, irq, irq_name):
 	event_info =3D (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			irq, irq_name)
 	all_event_list.append(event_info)
=20
-def irq__irq_handler_exit(name, context, cpu, sec, nsec, pid, comm, irq,=
 ret):
+def irq__irq_handler_exit(name, context, cpu, sec, nsec, pid, comm, call=
chain, irq, ret):
 	event_info =3D (name, context, cpu, nsecs(sec, nsec), pid, comm, irq, r=
et)
 	all_event_list.append(event_info)
=20
-def napi__napi_poll(name, context, cpu, sec, nsec, pid, comm, napi, dev_=
name):
+def napi__napi_poll(name, context, cpu, sec, nsec, pid, comm, callchain,=
 napi, dev_name):
 	event_info =3D (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			napi, dev_name)
 	all_event_list.append(event_info)
=20
-def net__netif_receive_skb(name, context, cpu, sec, nsec, pid, comm, skb=
addr,
+def net__netif_receive_skb(name, context, cpu, sec, nsec, pid, comm, cal=
lchain, skbaddr,
 			skblen, dev_name):
 	event_info =3D (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			skbaddr, skblen, dev_name)
 	all_event_list.append(event_info)
=20
-def net__netif_rx(name, context, cpu, sec, nsec, pid, comm, skbaddr,
+def net__netif_rx(name, context, cpu, sec, nsec, pid, comm, callchain, s=
kbaddr,
 			skblen, dev_name):
 	event_info =3D (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			skbaddr, skblen, dev_name)
 	all_event_list.append(event_info)
=20
-def net__net_dev_queue(name, context, cpu, sec, nsec, pid, comm,
+def net__net_dev_queue(name, context, cpu, sec, nsec, pid, comm, callcha=
in,
 			skbaddr, skblen, dev_name):
 	event_info =3D (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			skbaddr, skblen, dev_name)
 	all_event_list.append(event_info)
=20
-def net__net_dev_xmit(name, context, cpu, sec, nsec, pid, comm,
+def net__net_dev_xmit(name, context, cpu, sec, nsec, pid, comm, callchai=
n,
 			skbaddr, skblen, rc, dev_name):
 	event_info =3D (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			skbaddr, skblen, rc ,dev_name)
 	all_event_list.append(event_info)
=20
-def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm,
+def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm, callchain,
 			skbaddr, protocol, location):
 	event_info =3D (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			skbaddr, protocol, location)
 	all_event_list.append(event_info)
=20
-def skb__consume_skb(name, context, cpu, sec, nsec, pid, comm, skbaddr):=

+def skb__consume_skb(name, context, cpu, sec, nsec, pid, comm, callchain=
, skbaddr):
 	event_info =3D (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			skbaddr)
 	all_event_list.append(event_info)
=20
-def skb__skb_copy_datagram_iovec(name, context, cpu, sec, nsec, pid, com=
m,
+def skb__skb_copy_datagram_iovec(name, context, cpu, sec, nsec, pid, com=
m, callchain,
 	skbaddr, skblen):
 	event_info =3D (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			skbaddr, skblen)
diff --git a/tools/perf/scripts/python/sched-migration.py b/tools/perf/sc=
ripts/python/sched-migration.py
index 74d55ec..de66cb3 100644
--- a/tools/perf/scripts/python/sched-migration.py
+++ b/tools/perf/scripts/python/sched-migration.py
@@ -369,93 +369,92 @@ def trace_end():
=20
 def sched__sched_stat_runtime(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, runtime, vruntime):
+	common_callchain, comm, pid, runtime, vruntime):
 	pass
=20
 def sched__sched_stat_iowait(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, delay):
+	common_callchain, comm, pid, delay):
 	pass
=20
 def sched__sched_stat_sleep(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, delay):
+	common_callchain, comm, pid, delay):
 	pass
=20
 def sched__sched_stat_wait(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, delay):
+	common_callchain, comm, pid, delay):
 	pass
=20
 def sched__sched_process_fork(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	parent_comm, parent_pid, child_comm, child_pid):
+	common_callchain, parent_comm, parent_pid, child_comm, child_pid):
 	pass
=20
 def sched__sched_process_wait(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, prio):
+	common_callchain, comm, pid, prio):
 	pass
=20
 def sched__sched_process_exit(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, prio):
+	common_callchain, comm, pid, prio):
 	pass
=20
 def sched__sched_process_free(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, prio):
+	common_callchain, comm, pid, prio):
 	pass
=20
 def sched__sched_migrate_task(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, prio, orig_cpu,
+	common_callchain, comm, pid, prio, orig_cpu,
 	dest_cpu):
 	headers =3D EventHeaders(common_cpu, common_secs, common_nsecs,
-				common_pid, common_comm)
+				common_pid, common_comm, common_callchain)
 	parser.migrate(headers, pid, prio, orig_cpu, dest_cpu)
=20
 def sched__sched_switch(event_name, context, common_cpu,
-	common_secs, common_nsecs, common_pid, common_comm,
+	common_secs, common_nsecs, common_pid, common_comm, common_callchain,
 	prev_comm, prev_pid, prev_prio, prev_state,
 	next_comm, next_pid, next_prio):
=20
 	headers =3D EventHeaders(common_cpu, common_secs, common_nsecs,
-				common_pid, common_comm)
+				common_pid, common_comm, common_callchain)
 	parser.sched_switch(headers, prev_comm, prev_pid, prev_prio, prev_state=
,
 			 next_comm, next_pid, next_prio)
=20
 def sched__sched_wakeup_new(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, prio, success,
+	common_callchain, comm, pid, prio, success,
 	target_cpu):
 	headers =3D EventHeaders(common_cpu, common_secs, common_nsecs,
-				common_pid, common_comm)
+				common_pid, common_comm, common_callchain)
 	parser.wake_up(headers, comm, pid, success, target_cpu, 1)
=20
 def sched__sched_wakeup(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, prio, success,
+	common_callchain, comm, pid, prio, success,
 	target_cpu):
 	headers =3D EventHeaders(common_cpu, common_secs, common_nsecs,
-				common_pid, common_comm)
+				common_pid, common_comm, common_callchain)
 	parser.wake_up(headers, comm, pid, success, target_cpu, 0)
=20
 def sched__sched_wait_task(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, prio):
+	common_callchain, comm, pid, prio):
 	pass
=20
 def sched__sched_kthread_stop_ret(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	ret):
+	common_callchain, ret):
 	pass
=20
 def sched__sched_kthread_stop(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid):
+	common_callchain, comm, pid):
 	pass
=20
-def trace_unhandled(event_name, context, common_cpu, common_secs, common=
_nsecs,
-		common_pid, common_comm):
+def trace_unhandled(event_name, context, event_fields_dict):
 	pass
diff --git a/tools/perf/scripts/python/sctop.py b/tools/perf/scripts/pyth=
on/sctop.py
index 42c267e..df65a30 100644
--- a/tools/perf/scripts/python/sctop.py
+++ b/tools/perf/scripts/python/sctop.py
@@ -44,7 +44,7 @@ def trace_begin():
=20
 def raw_syscalls__sys_enter(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	id, args):
+	common_callchain, id, args):
 	if for_comm is not None:
 		if common_comm !=3D for_comm:
 			return
diff --git a/tools/perf/scripts/python/syscall-counts-by-pid.py b/tools/p=
erf/scripts/python/syscall-counts-by-pid.py
index c64d1c5..9b07b39 100644
--- a/tools/perf/scripts/python/syscall-counts-by-pid.py
+++ b/tools/perf/scripts/python/syscall-counts-by-pid.py
@@ -38,7 +38,7 @@ def trace_end():
=20
 def raw_syscalls__sys_enter(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	id, args):
+	common_callchain, id, args):
=20
 	if (for_comm and common_comm !=3D for_comm) or \
 	   (for_pid  and common_pid  !=3D for_pid ):
diff --git a/tools/perf/scripts/python/syscall-counts.py b/tools/perf/scr=
ipts/python/syscall-counts.py
index b435d3f..5899ce5 100644
--- a/tools/perf/scripts/python/syscall-counts.py
+++ b/tools/perf/scripts/python/syscall-counts.py
@@ -35,7 +35,7 @@ def trace_end():
=20
 def raw_syscalls__sys_enter(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	id, args):
+	common_callchain, id, args):
 	if for_comm is not None:
 		if common_comm !=3D for_comm:
 			return
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/too=
ls/perf/util/scripting-engines/trace-event-python.c
index 8454dc9..4f81dc7 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -32,6 +32,7 @@
 #include "../event.h"
 #include "../thread.h"
 #include "../trace-event.h"
+#include "../machine.h"
=20
 PyMODINIT_FUNC initperf_trace_context(void);
=20
@@ -236,12 +237,90 @@ static inline struct event_format *find_cache_event=
(struct perf_evsel *evsel)
 	return event;
 }
=20
+
+static PyObject *python_process_callchain(struct perf_sample *sample,
+					 struct perf_evsel *evsel,
+					 struct addr_location *al)
+{
+	PyObject *pylist;
+
+	pylist =3D PyList_New(0);
+	if (!pylist)
+		Py_FatalError("couldn't create Python list");
+
+	if (!symbol_conf.use_callchain || !sample->callchain)
+		goto exit;
+
+	if (machine__resolve_callchain(al->machine, evsel, al->thread,
+					   sample, NULL, NULL,
+					   PERF_MAX_STACK_DEPTH) !=3D 0) {
+		pr_err("Failed to resolve callchain. Skipping\n");
+		goto exit;
+	}
+	callchain_cursor_commit(&callchain_cursor);
+
+
+	while (1) {
+		PyObject *pyelem;
+		struct callchain_cursor_node *node;
+		node =3D callchain_cursor_current(&callchain_cursor);
+		if (!node)
+			break;
+
+		pyelem =3D PyDict_New();
+		if (!pyelem)
+			Py_FatalError("couldn't create Python dictionary");
+
+
+		pydict_set_item_string_decref(pyelem, "ip",
+				PyLong_FromUnsignedLongLong(node->ip));
+
+		if (node->sym) {
+			PyObject *pysym  =3D PyDict_New();
+			if (!pysym)
+				Py_FatalError("couldn't create Python dictionary");
+			pydict_set_item_string_decref(pysym, "start",
+					PyLong_FromUnsignedLongLong(node->sym->start));
+			pydict_set_item_string_decref(pysym, "end",
+					PyLong_FromUnsignedLongLong(node->sym->end));
+			pydict_set_item_string_decref(pysym, "binding",
+					PyInt_FromLong(node->sym->binding));
+			pydict_set_item_string_decref(pysym, "name",
+					PyString_FromStringAndSize(node->sym->name,
+							node->sym->namelen));
+			pydict_set_item_string_decref(pyelem, "sym", pysym);
+		}
+
+		if (node->map) {
+			struct map *map =3D node->map;
+			const char *dsoname =3D "[unknown]";
+			if (map && map->dso && (map->dso->name || map->dso->long_name)) {
+				if (symbol_conf.show_kernel_path && map->dso->long_name)
+					dsoname =3D map->dso->long_name;
+				else if (map->dso->name)
+					dsoname =3D map->dso->name;
+			}
+			pydict_set_item_string_decref(pyelem, "dso",
+					PyString_FromString(dsoname));
+		}
+
+		callchain_cursor_advance(&callchain_cursor);
+		PyList_Append(pylist, pyelem);
+		Py_DECREF(pyelem);
+	}
+
+exit:
+	return pylist;
+}
+
+
 static void python_process_tracepoint(struct perf_sample *sample,
 				      struct perf_evsel *evsel,
 				      struct thread *thread,
 				      struct addr_location *al)
 {
-	PyObject *handler, *retval, *context, *t, *obj, *dict =3D NULL;
+	PyObject *handler, *retval, *context, *t, *obj, *callchain;
+	PyObject *dict =3D NULL;
 	static char handler_name[256];
 	struct format_field *field;
 	unsigned long long val;
@@ -285,18 +364,23 @@ static void python_process_tracepoint(struct perf_s=
ample *sample,
 	PyTuple_SetItem(t, n++, PyString_FromString(handler_name));
 	PyTuple_SetItem(t, n++, context);
=20
+	/* ip unwinding */
+	callchain =3D python_process_callchain(sample, evsel, al);
+
 	if (handler) {
 		PyTuple_SetItem(t, n++, PyInt_FromLong(cpu));
 		PyTuple_SetItem(t, n++, PyInt_FromLong(s));
 		PyTuple_SetItem(t, n++, PyInt_FromLong(ns));
 		PyTuple_SetItem(t, n++, PyInt_FromLong(pid));
 		PyTuple_SetItem(t, n++, PyString_FromString(comm));
+		PyTuple_SetItem(t, n++, callchain);
 	} else {
 		pydict_set_item_string_decref(dict, "common_cpu", PyInt_FromLong(cpu))=
;
 		pydict_set_item_string_decref(dict, "common_s", PyInt_FromLong(s));
 		pydict_set_item_string_decref(dict, "common_ns", PyInt_FromLong(ns));
 		pydict_set_item_string_decref(dict, "common_pid", PyInt_FromLong(pid))=
;
 		pydict_set_item_string_decref(dict, "common_comm", PyString_FromString=
(comm));
+		pydict_set_item_string_decref(dict, "common_callchain", callchain);
 	}
 	for (field =3D event->format.fields; field; field =3D field->next) {
 		if (field->flags & FIELD_IS_STRING) {
@@ -329,6 +413,7 @@ static void python_process_tracepoint(struct perf_sam=
ple *sample,
 			pydict_set_item_string_decref(dict, field->name, obj);
=20
 	}
+
 	if (!handler)
 		PyTuple_SetItem(t, n++, dict);
=20
@@ -360,7 +445,7 @@ static void python_process_general_event(struct perf_=
sample *sample,
 					 struct thread *thread,
 					 struct addr_location *al)
 {
-	PyObject *handler, *retval, *t, *dict;
+	PyObject *handler, *retval, *t, *dict, *callchain;
 	static char handler_name[64];
 	unsigned n =3D 0;
=20
@@ -400,6 +485,10 @@ static void python_process_general_event(struct perf=
_sample *sample,
 			PyString_FromString(al->sym->name));
 	}
=20
+	/* ip unwinding */
+	callchain =3D python_process_callchain(sample, evsel, al);
+	pydict_set_item_string_decref(dict, "callchain", callchain);
+
 	PyTuple_SetItem(t, n++, dict);
 	if (_PyTuple_Resize(&t, n) =3D=3D -1)
 		Py_FatalError("error resizing Python tuple");
@@ -596,6 +685,7 @@ static int python_generate_script(struct pevent *peve=
nt, const char *outfile)
 		fprintf(ofp, "common_nsecs, ");
 		fprintf(ofp, "common_pid, ");
 		fprintf(ofp, "common_comm,\n\t");
+		fprintf(ofp, "common_callchain, ");
=20
 		not_first =3D 0;
 		count =3D 0;
@@ -638,7 +728,7 @@ static int python_generate_script(struct pevent *peve=
nt, const char *outfile)
 				fprintf(ofp, "%%u");
 		}
=20
-		fprintf(ofp, "\\n\" %% \\\n\t\t(");
+		fprintf(ofp, "\" %% \\\n\t\t(");
=20
 		not_first =3D 0;
 		count =3D 0;
@@ -674,7 +764,15 @@ static int python_generate_script(struct pevent *pev=
ent, const char *outfile)
 				fprintf(ofp, "%s", f->name);
 		}
=20
-		fprintf(ofp, "),\n\n");
+		fprintf(ofp, ")\n\n");
+
+		fprintf(ofp, "\t\tfor node in common_callchain:");
+		fprintf(ofp, "\n\t\t\tif 'sym' in node:");
+		fprintf(ofp, "\n\t\t\t\tprint \"\\t[%%x] %%s\" %% (node['ip'], node['s=
ym']['name'])");
+		fprintf(ofp, "\n\t\t\telse:");
+		fprintf(ofp, "\n\t\t\t\tprint \"\t[%%x]\" %% (node['ip'])\n\n");
+		fprintf(ofp, "\t\tprint \"\\n\"\n\n");
+
 	}
=20
 	fprintf(ofp, "def trace_unhandled(event_name, context, "
--=20
1.8.1.2



--------------ms080108050009010704070207
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIPPTCC
BHQwggNcoAMCAQICCQCJkBEVWD6HmzANBgkqhkiG9w0BAQsFADBxMQswCQYDVQQGEwJERTEc
MBoGA1UEChMTRGV1dHNjaGUgVGVsZWtvbSBBRzEfMB0GA1UECxMWVC1UZWxlU2VjIFRydXN0
IENlbnRlcjEjMCEGA1UEAxMaRGV1dHNjaGUgVGVsZWtvbSBSb290IENBIDIwHhcNMTQwMjEx
MTMxMTQ1WhcNMTkwNzA5MjM1OTAwWjBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZl
cmVpbjEQMA4GA1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFs
IC0gRzAxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6ZvDZ4X5Da71jVTDllA1
PWLpbkztlNcAW5UidNQg6zSP1uzAMQQLmYHiphTSUqAoI4SLdIkEXlvg4njBeMsWyyg1OXst
kEXQ7aAAeny/Sg4bAMOG6VwrMRF7DPOCJEOMHDiLamgAmu7cT3ir0sYTm3at7t4m6O8Br3QP
wQmi9mvOvdPNFDBP9eXjpMhim4IaAycwDQJlYE3t0QkjKpY1WCfTdsZxtpAdxO3/NYZ9bzOz
2w/FEcKKg6GUXUFr2NIQ9Uz9ylGs2b3vkoO72uuLFlZWQ8/h1RM9ph8nMM1JVNvJEzSacXXF
bOqnC5j5IZ0nrz6jOTlIaoytyZn7wxLyvQIDAQABo4IBJDCCASAwDgYDVR0PAQH/BAQDAgEG
MB0GA1UdDgQWBBRJt8bP6D0ff+pEexMp9/EKcD7eZDAfBgNVHSMEGDAWgBQxw3kbuvVT1xfg
iXotF2wKsyudMzASBgNVHRMBAf8ECDAGAQH/AgECMD8GA1UdHwQ4MDYwNKAyoDCGLmh0dHA6
Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL3JsL0RUX1JPT1RfQ0FfMi5jcmwweQYIKwYBBQUHAQEE
bTBrMCwGCCsGAQUFBzABhiBodHRwOi8vb2NzcDAzMzYudGVsZXNlYy5kZS9vY3NwcjA7Bggr
BgEFBQcwAoYvaHR0cDovL29jc3AwMzM2LnRlbGVzZWMuZGUvY3J0L0RUX1JPT1RfQ0FfMi5j
ZXIwDQYJKoZIhvcNAQELBQADggEBACwvqeBeQy8FcNxRlXVdgI47DMFjWFSBMIOcXalRh8m2
1w8runhIJGBCzPGi4jPhMh4ym1ETlXnGtazQJO0YFLwvKuovq7ITrEkdXgALBBhqmmXU6Ec1
vK7t33S22PGAUGWgxtojm41TR8psu0DJlV1OYHor5LtmQFWvtjPB6iMhbvxUnd0zQm5Ma9Xk
w/LqBrdaMmoyRXS2tW/+6v8cY6q7iNH4WK8gfo+///b3OHeLGrZQP609R3lGw1e0F2KHvZ6j
NiUHaCSqIvL2rynsN6UUma66AWCGdS1hFbp4loe1ks/hUJGeWToV7J5axob8KD5mutTZNa+t
PEkihYfub48wggUTMIID+6ADAgECAgQKlyQtMA0GCSqGSIb3DQEBBQUAMFoxCzAJBgNVBAYT
AkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAwDgYDVQQLEwdERk4tUEtJMSQwIgYDVQQDExtE
Rk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEwHhcNMDcwNjE5MDk0OTE4WhcNMTkwNjE4MDAw
MDAwWjCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2huaXNjaGUgVW5pdmVyc2l0YWV0
IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUgRHJlc2RlbiBDQSAtIEcwMjEg
MB4GCSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQDBDh6T80T27NAn91B6YQsENBWT/LEfbGPagOzhM1w1Cjx3ICCilYCgJeIP
QmBZT9RalxxF2z2OGDPcRTuqcaFPkgtdGaw1BFEIX+kGe3Itz2GlaKLPnQBHwcp+ODj8Odgv
D4wZqYkvsjaDx1ck2spHHVxLEh/7ybexJL3f1zatqPJkK2fJuOeeUz3Ip74sPqhKn3QA5Q5E
4JUHlvh3l4TDFrbmEIMntRqrJ+LaG2JCQ2G9hfEUvxeo3Zr6y88IdG+d7Hbp+XJkZYoOenVI
tm9z+atzo+NBxdmW8nD00xJAG52xQSwN4HR+qtj0CcnMtj41zXv6ul2E7ltRubqNM3snAgMB
AAGjggGzMIIBrzASBgNVHRMBAf8ECDAGAQH/AgEBMAsGA1UdDwQEAwIBBjAdBgNVHQ4EFgQU
xStTkxeDyfVGQu1Dat+2gKZH8uAwHwYDVR0jBBgwFoAUSbfGz+g9H3/qRHsTKffxCnA+3mQw
HAYDVR0RBBUwE4ERcGtpQHR1LWRyZXNkZW4uZGUwgYgGA1UdHwSBgDB+MD2gO6A5hjdodHRw
Oi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMD2g
O6A5hjdodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jcmwvY2Fj
cmwuY3JsMIGiBggrBgEFBQcBAQSBlTCBkjBHBggrBgEFBQcwAoY7aHR0cDovL2NkcDEucGNh
LmRmbi5kZS9nbG9iYWwtcm9vdC1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwRwYIKwYBBQUH
MAKGO2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3QtY2EvcHViL2NhY2VydC9j
YWNlcnQuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQDYoP/Eb/pk88i3a3VtkbGM676qLxkSwEcU
xbe6ZCldsKWY3xxXsqRiSt9MP9ATwVXRL4WjKap/Wr3MlfAyjnBcC+Go8NS4xyNxrsXugKrm
Y8mqsDT5h3W25BOfrfvuPy5ubi6QZTGEJPLYSKVCaiBS0LRv8A5m3Jw1zoyKr7007wm6jT3K
UYex/jbRuEILnu/pa5dE4Bq/ZdO2/McRQuGtIS/nuRHG2FMrl8TX3D86k+3NEb40O0UB2/Z0
+tWUOHCH5vuPUNMKaTcJ+S1XXM2xzzpU91yqU7QIFIDUv5dc8F6XTcOATMStJ3w8NynBn4o8
FitEtgHFzBvMqTFI+7KUMIIFqjCCBJKgAwIBAgIHFr0+Fq4AGTANBgkqhkiG9w0BAQUFADCB
hTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2huaXNjaGUgVW5pdmVyc2l0YWV0IERyZXNk
ZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUgRHJlc2RlbiBDQSAtIEcwMjEgMB4GCSqG
SIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUwHhcNMTMxMjAzMTEyOTEwWhcNMTYxMjAyMTEy
OTEwWjBgMQswCQYDVQQGEwJERTEoMCYGA1UEChMfVGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQg
RHJlc2RlbjEMMAoGA1UECxMDWklIMRkwFwYDVQQDExBKb3NlcGggU2NodWNoYXJ0MIIBIjAN
BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtp784m+f4qwkmx2yLZT4xVDtjvN3WXBRI53C
mFu6lm/3cMyj32EHPE/PLs/J2yYqSI2dUPUNQpg+PX1rbofQcxXCEYCAErs/p7ynofEeJoQf
5BF0BbtXBqD+1PaHXOALbk51lWFbyDDaLsCEh15ruOC60HRTdRz8ztDf+jQDeidqZBijFjU7
cUIShnxOCxnCOna11aiamDqCZDatlwE/9bj5C8JNYQLmMNo2AHaQLF4e3e9DtcGdCPRDjwwr
L+Dl/EmyEyQTy4CljQjSjlKS4jtW+uFNOffU2t7RfBeNJx8xgQe+JxZK2tzlPWh72JM96AiP
HpHAY2X2cUhpheqPdQIDAQABo4ICQTCCAj0wLwYDVR0gBCgwJjARBg8rBgEEAYGtIYIsAQEE
AwEwEQYPKwYBBAGBrSGCLAIBBAMBMAkGA1UdEwQCMAAwCwYDVR0PBAQDAgXgMB0GA1UdJQQW
MBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQU2IlmQWpeOkXl+dw+0arfnVk2FEkw
HwYDVR0jBBgwFoAUxStTkxeDyfVGQu1Dat+2gKZH8uAwKQYDVR0RBCIwIIEeam9zZXBoLnNj
aHVjaGFydEB0dS1kcmVzZGVuLmRlMIGLBgNVHR8EgYMwgYAwPqA8oDqGOGh0dHA6Ly9jZHAx
LnBjYS5kZm4uZGUvdHUtZHJlc2Rlbi1jYS9wdWIvY3JsL2dfY2FjcmwuY3JsMD6gPKA6hjho
dHRwOi8vY2RwMi5wY2EuZGZuLmRlL3R1LWRyZXNkZW4tY2EvcHViL2NybC9nX2NhY3JsLmNy
bDCB2QYIKwYBBQUHAQEEgcwwgckwMwYIKwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnBjYS5kZm4u
ZGUvT0NTUC1TZXJ2ZXIvT0NTUDBIBggrBgEFBQcwAoY8aHR0cDovL2NkcDEucGNhLmRmbi5k
ZS90dS1kcmVzZGVuLWNhL3B1Yi9jYWNlcnQvZ19jYWNlcnQuY3J0MEgGCCsGAQUFBzAChjxo
dHRwOi8vY2RwMi5wY2EuZGZuLmRlL3R1LWRyZXNkZW4tY2EvcHViL2NhY2VydC9nX2NhY2Vy
dC5jcnQwDQYJKoZIhvcNAQEFBQADggEBACoeSNfgyIAGxawrnghOIhIaD3xIsPvZP7ZFMV1a
Q9ltzHiZgUxnnaEUJEV0f+ASblYavp+0T/up0Nre+fKqm9/VMNyYG8068m6jNC+72NywQD9B
KWCTWgDZ3RqChwzrfBq7URSqNJhLSKj/Q7e+k7mCFIqwpnhMeFCZhAkORPUNiuMbyFYO9aht
buIujiF4c3FYDQJZFf83HWZ4neG4ioc8qhsOuXaBlN0AtExPw1KfpHqw1kwMaxZ10Yin8M4k
8gOPNIbm6vl1F8yFCHQka2ZnaDBueswhj+ntj1WUjqHED1hovfievMMW7Fd3njo+T9RODMi3
kNC7VObz0hu0cs0xggPUMIID0AIBATCBkTCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1Rl
Y2huaXNjaGUgVW5pdmVyc2l0YWV0IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMT
VFUgRHJlc2RlbiBDQSAtIEcwMjEgMB4GCSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUC
Bxa9PhauABkwCQYFKw4DAhoFAKCCAhcwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMTQwNjA0MTIwNzE0WjAjBgkqhkiG9w0BCQQxFgQU0AAckcMlfAoXsrPS
up34g4WiNrowbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoG
CCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDCBogYJKwYBBAGCNxAEMYGUMIGRMIGFMQswCQYDVQQGEwJERTEoMCYGA1UE
ChMfVGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQgRHJlc2RlbjEMMAoGA1UECxMDWklIMRwwGgYD
VQQDExNUVSBEcmVzZGVuIENBIC0gRzAyMSAwHgYJKoZIhvcNAQkBFhFwa2lAdHUtZHJlc2Rl
bi5kZQIHFr0+Fq4AGTCBpAYLKoZIhvcNAQkQAgsxgZSggZEwgYUxCzAJBgNVBAYTAkRFMSgw
JgYDVQQKEx9UZWNobmlzY2hlIFVuaXZlcnNpdGFldCBEcmVzZGVuMQwwCgYDVQQLEwNaSUgx
HDAaBgNVBAMTE1RVIERyZXNkZW4gQ0EgLSBHMDIxIDAeBgkqhkiG9w0BCQEWEXBraUB0dS1k
cmVzZGVuLmRlAgcWvT4WrgAZMA0GCSqGSIb3DQEBAQUABIIBACa3U1cTd35OGPn9zBA4+/Lz
95+2HOMdj8crXbt0WSbdYQ3k7ydMHLKTBr8gUg6vXfwkx2j7/9Ygdd1Rbd3A+4+FYWQOfkxi
1cqx3OTFSMIyD/AtV8TzB7iUdBJyPabSrxDqjGk/LePCENCDMmN1U6MnGxKBEPgi4wAfkyZW
IKygQoV1Q2Zr3BYZ6byaFSbb3IHuP1yS/DxXlfeY0akn8CO8MB1pcQOYk351bV7T/WrLzTvw
XFDSOocxI6WAheynQPE6BA53DXUlSIKsIiNM8D+yPKRSIIb/JjjgbPZSn8WtHrQ4kGx/9y+n
ofIgJWXEf4GSOGrdDKr8AFMcxhEOlAoAAAAAAAA=
--------------ms080108050009010704070207--
