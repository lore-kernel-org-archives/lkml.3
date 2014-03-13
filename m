Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbaCMTyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 15:54:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:44200 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbaCMTyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 15:54:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,648,1389772800"; 
   d="scan'208";a="471871825"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, tools: Add script to easily decode addresses
Date: Thu, 13 Mar 2014 12:53:58 -0700
Message-Id: <1394740438-27343-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Haswell has the nice ability to record addresses and l1 hits
for cycles:pp and several other PEBS events.  Normally we just throw
this data away. It can be already record with -d, but perf
was lacking a nice way to display it.

This patch adds a perf script to display this data.

The script can be run with perf script or for specific
IP samples from the TUI browser (with 'r')

Example:

% perf record -e cycles:pp -c 1000 -d ls
...
[ perf record: Captured and wrote 0.157 MB perf.data (~6880 samples) ]
%  perf script -s ~/libexec/perf-core/scripts/python/addr.py
total samples seen 2863
number of address samples seen 2219 77.51%
samples without address: 22.49%
number of unique addresses seen: 903
...
total samples seen 2863
number of address samples seen 2219 77.51%
samples without address: 22.49%
number of unique addresses seen: 903

addresses per symbol
SYM                                        ADDR  PCT-IP PCT-TOTAL
_raw_spin_lock_irqsave         ffffffff81f991f0  21.95%   2.43%
_raw_spin_lock_irqsave         ffff8802134f9a20  17.48%   1.94%
_raw_spin_lock_irqsave         ffff88015aef69c0  17.07%   1.89%
preempt_schedule               ffff8801b72b801c  59.02%   1.62%

...
type of access per IP
IP               DATA_SRC                        PCT-IP PCT-TOTAL
ffffffff815a6b96  STORE?                         84.69%   7.48%
ffffffff815a6c85  STORE?                         86.67%   2.34%
ffffffff815a6b96  STORE? L1 HITM  L1             15.31%   1.35%
ffffffff8107bede  STORE?                         90.32%   1.26%
ffffffff812dba96  STORE?                        100.00%   1.26%
ffffffff815a67ae  STORE?                        100.00%   1.22%
ffffffff815a67a0  STORE?                        100.00%   1.13%
ffffffff815a555b  STORE?                         96.15%   1.13%
ffffffff815a67b7  STORE?                         80.77%   0.95%
ffffffff812dbd49  STORE?                         82.61%   0.86%

address ranges per symbol
SYM                                    DATA-MIN         DATA-MAX RANGE
_raw_spin_lock_irqsave         ffff8801030fa6e4 ffffffff81f991f0 122873.98G
_raw_spin_unlock_irqrestore    ffff8801030fa6e4 ffffffff81f991f0 122873.98G
_raw_spin_lock                 ffff8801b72b801c ffffffff81c07184 122871.17G
preempt_schedule               ffff8801b72b8010 ffff8801b72b9df8 7.48G
__queue_work                   ffff8801b72b9d80 ffffffff81cb5038 122871.17G
enqueue_entity                 ffff8801030fc840 ffffffff81f365e0 122873.98G
n_tty_write                    ffff88003786a832 ffffffff8165e748 122877.15G
try_to_wake_up                 ffff8801030fa080 ffffffff81cb73c0 122873.98G
finish_task_switch             ffff8801030fa290 ffffffff815ae970 122873.97G

Cannot show the the perf report mode with 'r', but that's the
primary use case for it. Just type perf report, select a symbol,
then type 'r' and select addr. Note perf has to be installed
first for this to work, otherwise perf report cannot find the script.

Opens:
right now it only outputs symbols and numeric IP.
Would need to fix perf to pass srcline.
Some plotting may be useful
perf currently reports all these addresses as stores, even though they
might be loads. I'll send a kernel patch for this separately.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/scripts/python/addr.py         | 187 ++++++++++++++++++++++++++++++
 tools/perf/scripts/python/bin/addr-record |   8 ++
 tools/perf/scripts/python/bin/addr-report |   3 +
 3 files changed, 198 insertions(+)
 create mode 100644 tools/perf/scripts/python/addr.py
 create mode 100644 tools/perf/scripts/python/bin/addr-record
 create mode 100644 tools/perf/scripts/python/bin/addr-report

diff --git a/tools/perf/scripts/python/addr.py b/tools/perf/scripts/python/addr.py
new file mode 100644
index 0000000..ebeb6c0
--- /dev/null
+++ b/tools/perf/scripts/python/addr.py
@@ -0,0 +1,187 @@
+# Print address statistics
+# usage: perf record -d -e cycles:pp ...
+# perf script -s addr.py
+# or run it from perf report menu mode 'r'
+
+import struct
+import sys
+import os
+import collections
+
+# top-X to print
+NUM_PRINT = 10
+
+sys.path.append(os.environ['PERF_EXEC_PATH'] + \
+        '/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+
+from perf_trace_context import *
+from EventClass import *
+
+addresses = collections.Counter()
+address_sym = collections.Counter()
+address_ip = collections.Counter()
+datasrc_ip = collections.Counter()
+ip_address = collections.Counter()
+sym_address = collections.Counter()
+total = 0
+skipped = 0
+
+def trace_begin():
+    pass
+
+#struct perf_sample {
+#        u64 ip;
+#        u32 pid, tid;
+#        u64 time;
+#        u64 addr;
+#        u64 id;
+#        u64 stream_id;
+#        u64 period;
+#        u64 weight;
+#        u64 transaction;
+#        u32 cpu;
+#        u32 raw_size;
+#        u64 data_src;
+
+def process_event(param_dict):
+    global total
+    global skipped
+
+    event_attr = param_dict["attr"]
+    sample     = param_dict["sample"]
+    raw_buf    = param_dict["raw_buf"]
+    comm       = param_dict["comm"]
+    name       = param_dict["ev_name"]
+
+    # Symbol and dso info are not always resolved
+    if (param_dict.has_key("dso")):
+        dso = param_dict["dso"]
+    else:
+        dso = "Unknown_dso"
+
+    if (param_dict.has_key("symbol")):
+        symbol = param_dict["symbol"]
+    else:
+        symbol = "Unknown symbol"
+
+    (ip, pid, tid, time, addr, id, sid, period, weight, txn, cpu, raws, data_src) = (
+            struct.unpack("QIIQQQQQQQIIQ", sample[:11 * 8]))
+
+    if addr == 0:
+        skipped += 1
+        return
+
+    #print "%s %s %x %x" % (dso, symbol, ip, addr)
+
+    total += 1
+    addresses[addr] += 1
+    address_ip[(ip, addr)] += 1
+    ip_address[ip] += 1
+    sym_address[symbol] += 1
+    address_sym[(symbol, addr)] += 1
+    datasrc_ip[(ip, data_src)] += 1
+
+def MASK(bits):
+    return (1 << bits) - 1
+
+def decode_bits(val, names, bits, shift):
+    v = (val >> shift) & MASK(bits)
+    s = ""
+    for name, index in zip(names, range(0, len(names))):
+        if v & (1 << index):
+            s += " " + name
+    return s
+
+#        __u64   mem_op:5,       /* type of opcode */
+#                mem_lvl:14,     /* memory hierarchy level */
+#                mem_snoop:5,    /* snoop mode */
+#                mem_lock:2,     /* lock instr */
+#                mem_dtlb:7,     /* tlb access */
+#                mem_rsvd:31;
+
+def decode_datasrc(d):
+    s = ""
+    s += decode_bits(d, ['', 'LOAD', 'STORE?', 'PREFETCH', 'EXEC'], 5, 0)
+    s += decode_bits(d, ['', 'HIT', 'MISS', 'L1', 'LFB', 'L2', 'L3',
+                         'LOC_RAM', 'REM-RAM-1', 'REM-RAM-2', 'REM-CACHE-1'
+                         'REM-CACHE-2', 'REM-IO', 'REM-UNCACHED'], 14, 5)
+    s += decode_bits(d, ['', 'NONE', 'MISS', 'HITM'], 19, 5)
+    s += decode_bits(d, ['', 'LOCKED'], 24, 2)
+    s += decode_bits(d, ['', 'L1', 'L2', 'WK', 'OS'], 26, 7)
+    return s
+
+def pct(a, b):
+    return "%2.2f%%" % (100. * (float(a) / b))
+
+def unit(a):
+    if a >= 1024**3:
+        return "%.2fG" % (float(a) / (1024**3))
+    if a >= 1024**2:
+        return "%.2fG" % (float(a) / (1024**2))
+    if a >= 1024:
+        return "%.2fG" % (float(a) / (1024))
+    return "%d" % (a)
+
+def trace_end():
+    all_samples = skipped + total
+    print "total samples seen", all_samples
+    print "number of address samples seen", total, "%2.2f%%" % (
+            100.*(float(total) / all_samples))
+    print "samples without address: %2.2f%%" % (
+            100.*(float(skipped) / all_samples))
+    print "number of unique addresses seen: %u" % (len(ip_address.keys()))
+
+    print "\naddresses per symbol"
+    print "%-30s %16s %7s %7s" % ("SYM", "ADDR", "PCT-IP", "PCT-TOTAL")
+    for j in address_sym.most_common(NUM_PRINT):
+        sym, addr = j[0]
+        print "%-30s %-16x %7s %7s" % (
+                sym, addr,
+                pct(j[1], sym_address[sym]),
+                pct(j[1], total))
+
+    # XXX use srcline, but need to fix perf to pass this in first
+    print "\naddresses per IP"
+    print "%-16s %16s %7s %7s" % ("IP", "ADDR", "PCT-IP", "PCT-TOTAL")
+    for j in address_ip.most_common(NUM_PRINT):
+        ip, addr = j[0]
+        print "%-16x %-16x %7s %7s" % (
+                ip, addr,
+                pct(j[1], ip_address[ip]),
+                pct(j[1], total))
+
+    print "\ntype of access per IP"
+    print "%-16s %-30s %7s %7s" % ("IP", "DATA_SRC", "PCT-IP", "PCT-TOTAL")
+    for j in datasrc_ip.most_common(NUM_PRINT):
+        ip, data_src = j[0]
+        print "%-16x %-30s %7s %7s" % (
+                ip,
+                decode_datasrc(data_src),
+                pct(j[1], ip_address[ip]),
+                pct(j[1], total))
+
+    print "\naddress ranges per symbol"
+    print "%-30s %16s %16s %16s" % ("SYM", "DATA-MIN", "DATA-MAX", "RANGE")
+    for j in sym_address.most_common(NUM_PRINT):
+        if j[0] == "Unknown symbol":
+            continue
+        # XXX crappy algorithm. should do proper join
+        addr = filter(lambda x: x[0] == j[0], address_sym.keys())
+        min_addr = min([x[1] for x in addr])
+        max_addr = max([x[1] for x in addr])
+        print "%-30s %16x %16x %16s" % (j[0], min_addr, max_addr, unit(max_addr - min_addr))
+
+    print "\naddress ranges per IP"
+    print "%-16s %16s %16s %16s" % ("IP", "DATA-MIN", "DATA-MAX", "RANGE")
+    for j in ip_address.most_common(NUM_PRINT):
+        # XXX crappy algorithm. should do proper join
+        addr = filter(lambda x: x[0] == j[0], address_ip.keys())
+        min_addr = min([x[1] for x in addr])
+        max_addr = max([x[1] for x in addr])
+        print "%-16x %16x %16x %16s" % (j[0], min_addr, max_addr, unit(max_addr - min_addr))
+
+    ### XXX would be nice to get some information on mmaps from perf
+
+
+def trace_unhandled(event_name, context, event_fields_dict):
+    print ' '.join(['%s=%s'%(k,str(v))for k,v in sorted(event_fields_dict.items())])
diff --git a/tools/perf/scripts/python/bin/addr-record b/tools/perf/scripts/python/bin/addr-record
new file mode 100644
index 0000000..b6a3cc4
--- /dev/null
+++ b/tools/perf/scripts/python/bin/addr-record
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+#
+# can cover all type of perf samples including
+# the tracepoints, so no special record requirements, just record what
+# you want to analyze.
+#
+perf record -d $@
diff --git a/tools/perf/scripts/python/bin/addr-report b/tools/perf/scripts/python/bin/addr-report
new file mode 100644
index 0000000..998e80d
--- /dev/null
+++ b/tools/perf/scripts/python/bin/addr-report
@@ -0,0 +1,3 @@
+#!/bin/bash
+# description: analyze all perf samples
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/python/addr.py
-- 
1.8.5.3

