Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbaEPVnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:43:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:16599 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbaEPVnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:43:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1069,1389772800"; 
   d="scan'208";a="541822765"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>,
        linux-kbuild@vger.kernel.org, mmarek@suse.cz
Subject: [PATCH 8/8] Kbuild: add inline-account tool to find inline bloat
Date: Fri, 16 May 2014 14:43:15 -0700
Message-Id: <1400276595-6965-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a tool to hunt for inline bloat. It uses objdump -S to account
inlines.

Example output:

Total code bytes seen 10463206

Code bytes by functions:
Function                                           Total          Avg   Num
kmalloc                                            37132 (0.00%)  11    3310
ixgbe_read_reg                                     35440 (0.00%)  24    1444
spin_lock                                          28975 (0.00%)  11    2575
constant_test_bit                                  26387 (0.00%)  5     4642
arch_spin_unlock                                   24986 (0.00%)  7     3364
spin_unlock_irqrestore                             24928 (0.00%)  11    2258
readl                                              24584 (0.00%)  4     5344
writel                                             23199 (0.00%)  6     3643
perf_fetch_caller_regs                             22436 (0.00%)  27    821
get_current                                        22076 (0.00%)  9     2288
_radeon_msleep                                     19680 (0.00%)  55    353
INIT_LIST_HEAD                                     19410 (0.00%)  11    1747
list_del                                           19270 (0.00%)  16    1176
__ew32_prepare                                     19080 (0.00%)  25    740
__list_add                                         17830 (0.00%)  12    1406

Cc: linux-kbuild@vger.kernel.org
Cc: mmarek@suse.cz
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/inline-account.py | 164 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 164 insertions(+)
 create mode 100755 scripts/inline-account.py

diff --git a/scripts/inline-account.py b/scripts/inline-account.py
new file mode 100755
index 0000000..2dfbf7c
--- /dev/null
+++ b/scripts/inline-account.py
@@ -0,0 +1,164 @@
+#!/usr/bin/python
+# account code bytes per source code / functions from objdump -Sl output
+# useful to find inline bloat
+# Author: Andi Kleen
+import os, sys, re, argparse, multiprocessing
+from collections import Counter
+
+p = argparse.ArgumentParser(
+        description="""
+Account code bytes per source code / functions from objdump.
+Useful to find inline bloat.
+
+The line numbers are the beginning of a block, so the actual code can be later.
+Line numbers can be a also little off due to objdump bugs
+also some misaccounting can happen due to inexact gcc debug information.
+The number output for functions may account a single large function multiple
+times.  program/object files need to be built with -g.
+
+This is somewhat slow due to objdump -S being slow. It helps to have
+plenty of cores.""")
+p.add_argument('--min-bytes', type=int, help='minimum bytes to report', default=100)
+p.add_argument('--threads', '-t', type=int, default=multiprocessing.cpu_count(),
+               help='Number of objdump processes to run')
+p.add_argument('file', help='object file/program as input')
+args = p.parse_args()
+
+def get_syms(fn):
+    f = os.popen("nm  --print-size " + fn)
+    syms = []
+    pc = None
+    for l in f:
+        n = l.split()
+        if len(n) > 2 and n[2].upper() == "T":
+            pc = int(n[0], 16)
+            syms.append(pc)
+            ln = int(n[1], 16)
+    f.close()
+    if not pc:
+        sys.exit(fn + " has no symbols")
+    syms.append(pc + ln)
+    return syms
+
+class Account:
+    pass
+
+def add_account(a, b):
+    a.funcbytes += b.funcbytes
+    a.linebytes += b.linebytes
+    a.funccount += b.funccount
+    a.nolinebytes += a.nolinebytes
+    a.nofuncbytes += a.nofuncbytes
+    a.total += b.total
+    return a
+
+# dont add sys.exit here, causes deadlocks
+def account_range(r):
+    a = Account()
+    a.funcbytes = Counter()
+    a.linebytes = Counter()
+    a.funccount = Counter()
+    a.nolinebytes = 0
+    a.nofuncbytes = 0
+    a.total = 0
+
+    line = None
+    func = None
+    codefunc = None
+
+    cmd = ("objdump -Sl %s --start-address=%#x --stop-address=%#x" %
+                (args.file, r[0], r[1]))
+    f = os.popen(cmd)
+    for l in f:
+        #      250:       e8 00 00 00 00          callq  255 <proc_skip_spaces+0x5>
+        m = re.match(r'\s*([0-9a-fA-F]+):\s+(.*)', l)
+        if m:
+            #print "iscode", func, l,
+            bytes = len(re.findall(r'[0-9a-f][0-9a-f] ', m.group(2)))
+            if not func:
+                a.nofuncbytes += bytes
+                continue
+            if not line:
+                a.nolinebytes += bytes
+                continue
+            a.total += bytes
+            a.funcbytes[func] += bytes
+            a.linebytes[(file, line)] += bytes
+            codefunc = func
+            continue
+
+        # sysctl_init():
+        m = re.match(r'([a-zA-Z_][a-zA-Z0-9_]*)\(\):$', l)
+        if m:
+            if codefunc and m.group(1) != codefunc:
+                a.funccount[codefunc] += 1
+                codefunc = None
+            func = m.group(1)
+            continue
+
+        # /sysctl.c:1666
+        m = re.match(r'^([^:]+):(\d+)$', l)
+        if m:
+            file, line = m.group(1), int(m.group(2))
+            continue
+    f.close()
+
+    if codefunc:
+        a.funccount[codefunc] += 1
+    return a
+
+# objdump -S is slow, so we parallelize
+
+# split symbol table into chunks for parallelization
+# we split on functions boundaries to avoid mis-accounting
+# assumes functions have roughly similar length
+syms = sorted(get_syms(args.file))
+chunk = min((len(syms) - 1) / args.threads, len(syms) - 1)
+boundaries = [syms[x] for x in range(0, len(syms) - 1, chunk)] + [syms[-1]]
+ranges = [(boundaries[x], boundaries[x+1]) for x in range(0, len(boundaries) - 1)]
+assert ranges[0][0] == syms[0]
+assert ranges[-1][1] == syms[-1]
+
+# map-reduce
+if args.threads == 1:
+    al = map(account_range, ranges)
+else:
+    al = multiprocessing.Pool(args.threads).map(account_range, ranges)
+a = reduce(add_account, al)
+
+print "Total code bytes seen", a.total
+#print "Bytes with no function %d (%.2f%%)" % (a.nofuncbytes, 100.0*(float(a.nofuncbytes)/a.total))
+#print "Bytes with no lines %d (%.2f%%)" % (a.nolinebytes, 100.0*(float(a.nolinebytes)/a.total))
+
+def sort_map(m):
+    return sorted(m.keys(), key=lambda x: m[x], reverse=True)
+
+print "\nCode bytes by functions:"
+print "%-50s %-5s  %-5s   %-5s %-5s" % ("Function", "Total", "", "Avg", "Num")
+for j in sort_map(a.funcbytes):
+    if a.funcbytes[j] < args.min_bytes:
+        break
+    print "%-50s %-5d (%.2f%%)  %-5d %-5d" % (
+            j,
+            a.funcbytes[j],
+            a.funcbytes[j] / float(a.total),
+            a.funcbytes[j] / a.funccount[j],
+            a.funccount[j])
+
+for j in a.linebytes.keys():
+    if a.linebytes[j] < args.min_bytes:
+        del a.linebytes[j]
+
+# os.path.commonprefix fails with >50k entries
+# just use the first 10 
+prefix = os.path.commonprefix(map(lambda x: x[0], a.linebytes.keys()[:10]))
+
+print "\nCode bytes by nearby source line blocks:"
+print "prefix", prefix
+
+print "%-50s %-5s" % ("Line", "Total")
+for j in sort_map(a.linebytes):
+    print "%-50s %-5d (%.2f%%)" % (
+            "%s:%d" % (j[0].replace(prefix, ""), j[1]),
+            a.linebytes[j],
+            a.linebytes[j] / float(a.total))
-- 
1.9.0

