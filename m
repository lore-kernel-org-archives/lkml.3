Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbaGIIP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:15:59 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:53866 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaGIIPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:15:55 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3]  perf script: Add callchain to generic and tracepoint events
References: <53031D2C.2050009@tu-dresden.de>
	<20140307141857.GA3153@ghostprotocols.net>
	<533D2283.3090703@tu-dresden.de> <87wqd5f7j5.fsf@sejong.aot.lge.com>
	<538F0BF2.1010806@tu-dresden.de>
	<20140707171706.GA20752@krava.redhat.com>
	<53BCF1F2.70100@tu-dresden.de>
Date: Wed, 09 Jul 2014 17:15:42 +0900
In-Reply-To: <53BCF1F2.70100@tu-dresden.de> (Joseph Schuchart's message of
	"Wed, 09 Jul 2014 09:40:34 +0200")
Message-ID: <87zjgj2bip.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2014 09:40:34 +0200, Joseph Schuchart wrote:
> [PATCH 2/3]  perf script: Add callchain to generic and tracepoint events.  Since

This [PATCH x/x] part should go.


>  this alters the interface for the python scripts, also adjust the script 
>  generation and the provided scripts.
>
> Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
> Acked-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>

Anyway,

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  .../python/Perf-Trace-Util/lib/Perf/Trace/Core.py  |   3 +-
>  tools/perf/scripts/python/check-perf-trace.py      |   4 +-
>  .../perf/scripts/python/failed-syscalls-by-pid.py  |   2 +-
>  tools/perf/scripts/python/futex-contention.py      |   4 +-
>  tools/perf/scripts/python/net_dropmonitor.py       |   2 +-
>  tools/perf/scripts/python/netdev-times.py          |  26 ++---
>  tools/perf/scripts/python/sched-migration.py       |  41 ++++----
>  tools/perf/scripts/python/sctop.py                 |   2 +-
>  tools/perf/scripts/python/syscall-counts-by-pid.py |   2 +-
>  tools/perf/scripts/python/syscall-counts.py        |   2 +-
>  .../util/scripting-engines/trace-event-python.c    | 106 ++++++++++++++++++++-
>  11 files changed, 146 insertions(+), 48 deletions(-)
>
> diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
> index de7211e..38dfb72 100644
> --- a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
> +++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
> @@ -107,12 +107,13 @@ def taskState(state):
>  
>  class EventHeaders:
>  	def __init__(self, common_cpu, common_secs, common_nsecs,
> -		     common_pid, common_comm):
> +		     common_pid, common_comm, common_callchain):
>  		self.cpu = common_cpu
>  		self.secs = common_secs
>  		self.nsecs = common_nsecs
>  		self.pid = common_pid
>  		self.comm = common_comm
> +		self.callchain = common_callchain
>  
>  	def ts(self):
>  		return (self.secs * (10 ** 9)) + self.nsecs
> diff --git a/tools/perf/scripts/python/check-perf-trace.py b/tools/perf/scripts/python/check-perf-trace.py
> index 4647a76..334599c 100644
> --- a/tools/perf/scripts/python/check-perf-trace.py
> +++ b/tools/perf/scripts/python/check-perf-trace.py
> @@ -27,7 +27,7 @@ def trace_end():
>  
>  def irq__softirq_entry(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	vec):
> +	common_callchain, vec):
>  		print_header(event_name, common_cpu, common_secs, common_nsecs,
>  			common_pid, common_comm)
>  
> @@ -38,7 +38,7 @@ def irq__softirq_entry(event_name, context, common_cpu,
>  
>  def kmem__kmalloc(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	call_site, ptr, bytes_req, bytes_alloc,
> +	common_callchain, call_site, ptr, bytes_req, bytes_alloc,
>  	gfp_flags):
>  		print_header(event_name, common_cpu, common_secs, common_nsecs,
>  			common_pid, common_comm)
> diff --git a/tools/perf/scripts/python/failed-syscalls-by-pid.py b/tools/perf/scripts/python/failed-syscalls-by-pid.py
> index 266a836..cafeff3 100644
> --- a/tools/perf/scripts/python/failed-syscalls-by-pid.py
> +++ b/tools/perf/scripts/python/failed-syscalls-by-pid.py
> @@ -39,7 +39,7 @@ def trace_end():
>  
>  def raw_syscalls__sys_exit(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	id, ret):
> +	common_callchain, id, ret):
>  	if (for_comm and common_comm != for_comm) or \
>  	   (for_pid  and common_pid  != for_pid ):
>  		return
> diff --git a/tools/perf/scripts/python/futex-contention.py b/tools/perf/scripts/python/futex-contention.py
> index 11e70a3..0f5cf43 100644
> --- a/tools/perf/scripts/python/futex-contention.py
> +++ b/tools/perf/scripts/python/futex-contention.py
> @@ -21,7 +21,7 @@ thread_blocktime = {}
>  lock_waits = {} # long-lived stats on (tid,lock) blockage elapsed time
>  process_names = {} # long-lived pid-to-execname mapping
>  
> -def syscalls__sys_enter_futex(event, ctxt, cpu, s, ns, tid, comm,
> +def syscalls__sys_enter_futex(event, ctxt, cpu, s, ns, tid, comm, callchain,
>  			      nr, uaddr, op, val, utime, uaddr2, val3):
>  	cmd = op & FUTEX_CMD_MASK
>  	if cmd != FUTEX_WAIT:
> @@ -31,7 +31,7 @@ def syscalls__sys_enter_futex(event, ctxt, cpu, s, ns, tid, comm,
>  	thread_thislock[tid] = uaddr
>  	thread_blocktime[tid] = nsecs(s, ns)
>  
> -def syscalls__sys_exit_futex(event, ctxt, cpu, s, ns, tid, comm,
> +def syscalls__sys_exit_futex(event, ctxt, cpu, s, ns, tid, comm, callchain,
>  			     nr, ret):
>  	if thread_blocktime.has_key(tid):
>  		elapsed = nsecs(s, ns) - thread_blocktime[tid]
> diff --git a/tools/perf/scripts/python/net_dropmonitor.py b/tools/perf/scripts/python/net_dropmonitor.py
> index b574059..0b6ce8c 100755
> --- a/tools/perf/scripts/python/net_dropmonitor.py
> +++ b/tools/perf/scripts/python/net_dropmonitor.py
> @@ -66,7 +66,7 @@ def trace_end():
>  	print_drop_table()
>  
>  # called from perf, when it finds a correspoinding event
> -def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm,
> +def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm, callchain,
>  		   skbaddr, location, protocol):
>  	slocation = str(location)
>  	try:
> diff --git a/tools/perf/scripts/python/netdev-times.py b/tools/perf/scripts/python/netdev-times.py
> index 9aa0a32..4d21ef2 100644
> --- a/tools/perf/scripts/python/netdev-times.py
> +++ b/tools/perf/scripts/python/netdev-times.py
> @@ -224,75 +224,75 @@ def trace_end():
>  			(len(rx_skb_list), of_count_rx_skb_list)
>  
>  # called from perf, when it finds a correspoinding event
> -def irq__softirq_entry(name, context, cpu, sec, nsec, pid, comm, vec):
> +def irq__softirq_entry(name, context, cpu, sec, nsec, pid, comm, callchain, vec):
>  	if symbol_str("irq__softirq_entry", "vec", vec) != "NET_RX":
>  		return
>  	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm, vec)
>  	all_event_list.append(event_info)
>  
> -def irq__softirq_exit(name, context, cpu, sec, nsec, pid, comm, vec):
> +def irq__softirq_exit(name, context, cpu, sec, nsec, pid, comm, callchain, vec):
>  	if symbol_str("irq__softirq_entry", "vec", vec) != "NET_RX":
>  		return
>  	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm, vec)
>  	all_event_list.append(event_info)
>  
> -def irq__softirq_raise(name, context, cpu, sec, nsec, pid, comm, vec):
> +def irq__softirq_raise(name, context, cpu, sec, nsec, pid, comm, callchain, vec):
>  	if symbol_str("irq__softirq_entry", "vec", vec) != "NET_RX":
>  		return
>  	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm, vec)
>  	all_event_list.append(event_info)
>  
>  def irq__irq_handler_entry(name, context, cpu, sec, nsec, pid, comm,
> -			irq, irq_name):
> +			callchain, irq, irq_name):
>  	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
>  			irq, irq_name)
>  	all_event_list.append(event_info)
>  
> -def irq__irq_handler_exit(name, context, cpu, sec, nsec, pid, comm, irq, ret):
> +def irq__irq_handler_exit(name, context, cpu, sec, nsec, pid, comm, callchain, irq, ret):
>  	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm, irq, ret)
>  	all_event_list.append(event_info)
>  
> -def napi__napi_poll(name, context, cpu, sec, nsec, pid, comm, napi, dev_name):
> +def napi__napi_poll(name, context, cpu, sec, nsec, pid, comm, callchain, napi, dev_name):
>  	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
>  			napi, dev_name)
>  	all_event_list.append(event_info)
>  
> -def net__netif_receive_skb(name, context, cpu, sec, nsec, pid, comm, skbaddr,
> +def net__netif_receive_skb(name, context, cpu, sec, nsec, pid, comm, callchain, skbaddr,
>  			skblen, dev_name):
>  	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
>  			skbaddr, skblen, dev_name)
>  	all_event_list.append(event_info)
>  
> -def net__netif_rx(name, context, cpu, sec, nsec, pid, comm, skbaddr,
> +def net__netif_rx(name, context, cpu, sec, nsec, pid, comm, callchain, skbaddr,
>  			skblen, dev_name):
>  	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
>  			skbaddr, skblen, dev_name)
>  	all_event_list.append(event_info)
>  
> -def net__net_dev_queue(name, context, cpu, sec, nsec, pid, comm,
> +def net__net_dev_queue(name, context, cpu, sec, nsec, pid, comm, callchain,
>  			skbaddr, skblen, dev_name):
>  	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
>  			skbaddr, skblen, dev_name)
>  	all_event_list.append(event_info)
>  
> -def net__net_dev_xmit(name, context, cpu, sec, nsec, pid, comm,
> +def net__net_dev_xmit(name, context, cpu, sec, nsec, pid, comm, callchain,
>  			skbaddr, skblen, rc, dev_name):
>  	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
>  			skbaddr, skblen, rc ,dev_name)
>  	all_event_list.append(event_info)
>  
> -def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm,
> +def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm, callchain,
>  			skbaddr, protocol, location):
>  	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
>  			skbaddr, protocol, location)
>  	all_event_list.append(event_info)
>  
> -def skb__consume_skb(name, context, cpu, sec, nsec, pid, comm, skbaddr):
> +def skb__consume_skb(name, context, cpu, sec, nsec, pid, comm, callchain, skbaddr):
>  	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
>  			skbaddr)
>  	all_event_list.append(event_info)
>  
> -def skb__skb_copy_datagram_iovec(name, context, cpu, sec, nsec, pid, comm,
> +def skb__skb_copy_datagram_iovec(name, context, cpu, sec, nsec, pid, comm, callchain,
>  	skbaddr, skblen):
>  	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
>  			skbaddr, skblen)
> diff --git a/tools/perf/scripts/python/sched-migration.py b/tools/perf/scripts/python/sched-migration.py
> index 74d55ec..de66cb3 100644
> --- a/tools/perf/scripts/python/sched-migration.py
> +++ b/tools/perf/scripts/python/sched-migration.py
> @@ -369,93 +369,92 @@ def trace_end():
>  
>  def sched__sched_stat_runtime(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	comm, pid, runtime, vruntime):
> +	common_callchain, comm, pid, runtime, vruntime):
>  	pass
>  
>  def sched__sched_stat_iowait(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	comm, pid, delay):
> +	common_callchain, comm, pid, delay):
>  	pass
>  
>  def sched__sched_stat_sleep(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	comm, pid, delay):
> +	common_callchain, comm, pid, delay):
>  	pass
>  
>  def sched__sched_stat_wait(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	comm, pid, delay):
> +	common_callchain, comm, pid, delay):
>  	pass
>  
>  def sched__sched_process_fork(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	parent_comm, parent_pid, child_comm, child_pid):
> +	common_callchain, parent_comm, parent_pid, child_comm, child_pid):
>  	pass
>  
>  def sched__sched_process_wait(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	comm, pid, prio):
> +	common_callchain, comm, pid, prio):
>  	pass
>  
>  def sched__sched_process_exit(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	comm, pid, prio):
> +	common_callchain, comm, pid, prio):
>  	pass
>  
>  def sched__sched_process_free(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	comm, pid, prio):
> +	common_callchain, comm, pid, prio):
>  	pass
>  
>  def sched__sched_migrate_task(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	comm, pid, prio, orig_cpu,
> +	common_callchain, comm, pid, prio, orig_cpu,
>  	dest_cpu):
>  	headers = EventHeaders(common_cpu, common_secs, common_nsecs,
> -				common_pid, common_comm)
> +				common_pid, common_comm, common_callchain)
>  	parser.migrate(headers, pid, prio, orig_cpu, dest_cpu)
>  
>  def sched__sched_switch(event_name, context, common_cpu,
> -	common_secs, common_nsecs, common_pid, common_comm,
> +	common_secs, common_nsecs, common_pid, common_comm, common_callchain,
>  	prev_comm, prev_pid, prev_prio, prev_state,
>  	next_comm, next_pid, next_prio):
>  
>  	headers = EventHeaders(common_cpu, common_secs, common_nsecs,
> -				common_pid, common_comm)
> +				common_pid, common_comm, common_callchain)
>  	parser.sched_switch(headers, prev_comm, prev_pid, prev_prio, prev_state,
>  			 next_comm, next_pid, next_prio)
>  
>  def sched__sched_wakeup_new(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	comm, pid, prio, success,
> +	common_callchain, comm, pid, prio, success,
>  	target_cpu):
>  	headers = EventHeaders(common_cpu, common_secs, common_nsecs,
> -				common_pid, common_comm)
> +				common_pid, common_comm, common_callchain)
>  	parser.wake_up(headers, comm, pid, success, target_cpu, 1)
>  
>  def sched__sched_wakeup(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	comm, pid, prio, success,
> +	common_callchain, comm, pid, prio, success,
>  	target_cpu):
>  	headers = EventHeaders(common_cpu, common_secs, common_nsecs,
> -				common_pid, common_comm)
> +				common_pid, common_comm, common_callchain)
>  	parser.wake_up(headers, comm, pid, success, target_cpu, 0)
>  
>  def sched__sched_wait_task(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	comm, pid, prio):
> +	common_callchain, comm, pid, prio):
>  	pass
>  
>  def sched__sched_kthread_stop_ret(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	ret):
> +	common_callchain, ret):
>  	pass
>  
>  def sched__sched_kthread_stop(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	comm, pid):
> +	common_callchain, comm, pid):
>  	pass
>  
> -def trace_unhandled(event_name, context, common_cpu, common_secs, common_nsecs,
> -		common_pid, common_comm):
> +def trace_unhandled(event_name, context, event_fields_dict):
>  	pass
> diff --git a/tools/perf/scripts/python/sctop.py b/tools/perf/scripts/python/sctop.py
> index c9f3058..61621b9 100644
> --- a/tools/perf/scripts/python/sctop.py
> +++ b/tools/perf/scripts/python/sctop.py
> @@ -44,7 +44,7 @@ def trace_begin():
>  
>  def raw_syscalls__sys_enter(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	id, args):
> +	common_callchain, id, args):
>  	if for_comm is not None:
>  		if common_comm != for_comm:
>  			return
> diff --git a/tools/perf/scripts/python/syscall-counts-by-pid.py b/tools/perf/scripts/python/syscall-counts-by-pid.py
> index cf2054c..daf314c 100644
> --- a/tools/perf/scripts/python/syscall-counts-by-pid.py
> +++ b/tools/perf/scripts/python/syscall-counts-by-pid.py
> @@ -38,7 +38,7 @@ def trace_end():
>  
>  def raw_syscalls__sys_enter(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	id, args):
> +	common_callchain, id, args):
>  
>  	if (for_comm and common_comm != for_comm) or \
>  	   (for_pid  and common_pid  != for_pid ):
> diff --git a/tools/perf/scripts/python/syscall-counts.py b/tools/perf/scripts/python/syscall-counts.py
> index 92b2938..e66a773 100644
> --- a/tools/perf/scripts/python/syscall-counts.py
> +++ b/tools/perf/scripts/python/syscall-counts.py
> @@ -35,7 +35,7 @@ def trace_end():
>  
>  def raw_syscalls__sys_enter(event_name, context, common_cpu,
>  	common_secs, common_nsecs, common_pid, common_comm,
> -	id, args):
> +	common_callchain, id, args):
>  	if for_comm is not None:
>  		if common_comm != for_comm:
>  			return
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index 631aa85..dae78e4 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -32,6 +32,7 @@
>  #include "../event.h"
>  #include "../thread.h"
>  #include "../trace-event.h"
> +#include "../machine.h"
>  
>  PyMODINIT_FUNC initperf_trace_context(void);
>  
> @@ -237,12 +238,90 @@ static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
>  	return event;
>  }
>  
> +
> +static PyObject *python_process_callchain(struct perf_sample *sample,
> +					 struct perf_evsel *evsel,
> +					 struct addr_location *al)
> +{
> +	PyObject *pylist;
> +
> +	pylist = PyList_New(0);
> +	if (!pylist)
> +		Py_FatalError("couldn't create Python list");
> +
> +	if (!symbol_conf.use_callchain || !sample->callchain)
> +		goto exit;
> +
> +	if (machine__resolve_callchain(al->machine, evsel, al->thread,
> +					   sample, NULL, NULL,
> +					   PERF_MAX_STACK_DEPTH) != 0) {
> +		pr_err("Failed to resolve callchain. Skipping\n");
> +		goto exit;
> +	}
> +	callchain_cursor_commit(&callchain_cursor);
> +
> +
> +	while (1) {
> +		PyObject *pyelem;
> +		struct callchain_cursor_node *node;
> +		node = callchain_cursor_current(&callchain_cursor);
> +		if (!node)
> +			break;
> +
> +		pyelem = PyDict_New();
> +		if (!pyelem)
> +			Py_FatalError("couldn't create Python dictionary");
> +
> +
> +		pydict_set_item_string_decref(pyelem, "ip",
> +				PyLong_FromUnsignedLongLong(node->ip));
> +
> +		if (node->sym) {
> +			PyObject *pysym  = PyDict_New();
> +			if (!pysym)
> +				Py_FatalError("couldn't create Python dictionary");
> +			pydict_set_item_string_decref(pysym, "start",
> +					PyLong_FromUnsignedLongLong(node->sym->start));
> +			pydict_set_item_string_decref(pysym, "end",
> +					PyLong_FromUnsignedLongLong(node->sym->end));
> +			pydict_set_item_string_decref(pysym, "binding",
> +					PyInt_FromLong(node->sym->binding));
> +			pydict_set_item_string_decref(pysym, "name",
> +					PyString_FromStringAndSize(node->sym->name,
> +							node->sym->namelen));
> +			pydict_set_item_string_decref(pyelem, "sym", pysym);
> +		}
> +
> +		if (node->map) {
> +			struct map *map = node->map;
> +			const char *dsoname = "[unknown]";
> +			if (map && map->dso && (map->dso->name || map->dso->long_name)) {
> +				if (symbol_conf.show_kernel_path && map->dso->long_name)
> +					dsoname = map->dso->long_name;
> +				else if (map->dso->name)
> +					dsoname = map->dso->name;
> +			}
> +			pydict_set_item_string_decref(pyelem, "dso",
> +					PyString_FromString(dsoname));
> +		}
> +
> +		callchain_cursor_advance(&callchain_cursor);
> +		PyList_Append(pylist, pyelem);
> +		Py_DECREF(pyelem);
> +	}
> +
> +exit:
> +	return pylist;
> +}
> +
> +
>  static void python_process_tracepoint(struct perf_sample *sample,
>  				      struct perf_evsel *evsel,
>  				      struct thread *thread,
>  				      struct addr_location *al)
>  {
> -	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
> +	PyObject *handler, *retval, *context, *t, *obj, *callchain;
> +	PyObject *dict = NULL;
>  	static char handler_name[256];
>  	struct format_field *field;
>  	unsigned long long val;
> @@ -286,18 +365,23 @@ static void python_process_tracepoint(struct perf_sample *sample,
>  	PyTuple_SetItem(t, n++, PyString_FromString(handler_name));
>  	PyTuple_SetItem(t, n++, context);
>  
> +	/* ip unwinding */
> +	callchain = python_process_callchain(sample, evsel, al);
> +
>  	if (handler) {
>  		PyTuple_SetItem(t, n++, PyInt_FromLong(cpu));
>  		PyTuple_SetItem(t, n++, PyInt_FromLong(s));
>  		PyTuple_SetItem(t, n++, PyInt_FromLong(ns));
>  		PyTuple_SetItem(t, n++, PyInt_FromLong(pid));
>  		PyTuple_SetItem(t, n++, PyString_FromString(comm));
> +		PyTuple_SetItem(t, n++, callchain);
>  	} else {
>  		pydict_set_item_string_decref(dict, "common_cpu", PyInt_FromLong(cpu));
>  		pydict_set_item_string_decref(dict, "common_s", PyInt_FromLong(s));
>  		pydict_set_item_string_decref(dict, "common_ns", PyInt_FromLong(ns));
>  		pydict_set_item_string_decref(dict, "common_pid", PyInt_FromLong(pid));
>  		pydict_set_item_string_decref(dict, "common_comm", PyString_FromString(comm));
> +		pydict_set_item_string_decref(dict, "common_callchain", callchain);
>  	}
>  	for (field = event->format.fields; field; field = field->next) {
>  		if (field->flags & FIELD_IS_STRING) {
> @@ -330,6 +414,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
>  			pydict_set_item_string_decref(dict, field->name, obj);
>  
>  	}
> +
>  	if (!handler)
>  		PyTuple_SetItem(t, n++, dict);
>  
> @@ -361,7 +446,7 @@ static void python_process_general_event(struct perf_sample *sample,
>  					 struct thread *thread,
>  					 struct addr_location *al)
>  {
> -	PyObject *handler, *retval, *t, *dict;
> +	PyObject *handler, *retval, *t, *dict, *callchain;
>  	static char handler_name[64];
>  	unsigned n = 0;
>  
> @@ -401,6 +486,10 @@ static void python_process_general_event(struct perf_sample *sample,
>  			PyString_FromString(al->sym->name));
>  	}
>  
> +	/* ip unwinding */
> +	callchain = python_process_callchain(sample, evsel, al);
> +	pydict_set_item_string_decref(dict, "callchain", callchain);
> +
>  	PyTuple_SetItem(t, n++, dict);
>  	if (_PyTuple_Resize(&t, n) == -1)
>  		Py_FatalError("error resizing Python tuple");
> @@ -597,6 +686,7 @@ static int python_generate_script(struct pevent *pevent, const char *outfile)
>  		fprintf(ofp, "common_nsecs, ");
>  		fprintf(ofp, "common_pid, ");
>  		fprintf(ofp, "common_comm,\n\t");
> +		fprintf(ofp, "common_callchain, ");
>  
>  		not_first = 0;
>  		count = 0;
> @@ -640,7 +730,7 @@ static int python_generate_script(struct pevent *pevent, const char *outfile)
>  				fprintf(ofp, "%%u");
>  		}
>  
> -		fprintf(ofp, "\\n\" %% \\\n\t\t(");
> +		fprintf(ofp, "\" %% \\\n\t\t(");
>  
>  		not_first = 0;
>  		count = 0;
> @@ -676,7 +766,15 @@ static int python_generate_script(struct pevent *pevent, const char *outfile)
>  				fprintf(ofp, "%s", f->name);
>  		}
>  
> -		fprintf(ofp, "),\n\n");
> +		fprintf(ofp, ")\n\n");
> +
> +		fprintf(ofp, "\t\tfor node in common_callchain:");
> +		fprintf(ofp, "\n\t\t\tif 'sym' in node:");
> +		fprintf(ofp, "\n\t\t\t\tprint \"\\t[%%x] %%s\" %% (node['ip'], node['sym']['name'])");
> +		fprintf(ofp, "\n\t\t\telse:");
> +		fprintf(ofp, "\n\t\t\t\tprint \"\t[%%x]\" %% (node['ip'])\n\n");
> +		fprintf(ofp, "\t\tprint \"\\n\"\n\n");
> +
>  	}
>  
>  	fprintf(ofp, "def trace_unhandled(event_name, context, "
