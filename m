Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab3BGB1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:27:55 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:48540 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab3BGB1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:27:52 -0500
From: chenggang <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: chenggang <chenggang.qin@gmail.com>, chenggang.qcg@taobao.com,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] Perf Script: Add a python script to statistic direct io behavior
Date: Thu,  7 Feb 2013 09:27:22 +0800
Message-Id: <1360200442-8126-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang.qcg@taobao.com

The last version of this patch need to introduce 2 new tracepoint events in VFS,
but introduce new tracepoint events into VFS is not a clever idea. So, I modified
this patch, and only use a existing tracepoint event (ext4:ext4_direct_IO_exit).

If the engineers want to analyze the direct io behavior of some applications
without source code, perf tools with some appropriate tracepoints events in the
VFS subsystem are excellent choice.

Many database systems use their own page cache subsystems and use the direct IO
to access the disks. Sometimes, the system engineers need to know the misses rate
of the database system's page cache. This requirements can be satisfied by recording
the database's file access behavior through the way of direct IO. So, we use
tracepoint event, ext4:ext4_direct_IO_exit, to record the system wide's direct IO behavior.
The script direct-io.py are introduced by this patch can record the tracepoint events,
ext4:ext4_direct_IO_exit, analyse the sample data, and give a concise report.

usage:
        "perf script record direct-io\n"
        "perf script report direct-io [comm|pid]\n"

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

---
 tools/perf/scripts/python/bin/direct-io-record |    2 +
 tools/perf/scripts/python/bin/direct-io-report |   21 +++
 tools/perf/scripts/python/direct-io.py         |  197 ++++++++++++++++++++++++
 3 files changed, 220 insertions(+)
 create mode 100755 tools/perf/scripts/python/bin/direct-io-record
 create mode 100644 tools/perf/scripts/python/bin/direct-io-report
 create mode 100644 tools/perf/scripts/python/direct-io.py

diff --git a/tools/perf/scripts/python/bin/direct-io-record b/tools/perf/scripts/python/bin/direct-io-record
new file mode 100755
index 0000000..f38d5fc
--- /dev/null
+++ b/tools/perf/scripts/python/bin/direct-io-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -e ext4:ext4_direct_IO_exit  $@
diff --git a/tools/perf/scripts/python/bin/direct-io-report b/tools/perf/scripts/python/bin/direct-io-report
new file mode 100644
index 0000000..828d9c6
--- /dev/null
+++ b/tools/perf/scripts/python/bin/direct-io-report
@@ -0,0 +1,21 @@
+#!/bin/bash
+# description: direct_io statistic
+# args: [comm|pid]
+n_args=0
+for i in "$@"
+do
+    if expr match "$i" "-" > /dev/null ; then
+	break
+    fi
+    n_args=$(( $n_args + 1 ))
+done
+if [ "$n_args" -gt 1 ] ; then
+    echo "usage: perf script report direct-io [comm|pid]"
+    exit
+fi
+
+if [ "$n_args" -gt 0 ] ; then
+    comm=$1
+    shift
+fi
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/python/direct-io.py $comm
diff --git a/tools/perf/scripts/python/direct-io.py b/tools/perf/scripts/python/direct-io.py
new file mode 100644
index 0000000..b609e95
--- /dev/null
+++ b/tools/perf/scripts/python/direct-io.py
@@ -0,0 +1,197 @@
+# direct IO counts
+# (c) 2013, Chenggang Qin <chenggang.qcg@alibaba-inc.com>
+# Licensed under the terms of the GNU GPL License version 2
+
+# Displays system-wide file direct IO behavior.
+# It helps us to investigate which processes trigger a direct IO,
+# and what files are accessed by these processes.
+#
+# options
+# comm, pid: show details of the file r/w behavior of a special process.
+
+import os, sys
+
+sys.path.append(os.environ['PERF_EXEC_PATH'] + \
+	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+
+from perf_trace_context import *
+from Core import *
+from Util import *
+
+MINORBITS = 20
+MINORMASK = ((1 << MINORBITS) - 1)
+
+usage = "perf script record direct-io\n" \
+	"perf script report direct-io [comm|pid]\n"
+
+for_comm = None
+for_pid = None
+pid_2_comm = None
+
+if len(sys.argv) > 2:
+	sys.exit(usage)
+
+if len(sys.argv) > 1:
+	try:
+		for_pid = int(sys.argv[1])
+	except:
+		for_comm = sys.argv[1]
+
+direct_write = autodict()
+direct_read = autodict()
+
+direct_write_bytes = autodict()
+direct_read_bytes = autodict()
+
+comm_read_info = autodict()
+comm_write_info = autodict()
+
+wevent_count = 0
+revent_count = 0
+
+comm_revent_count = 0;
+comm_wevent_count = 0;
+
+def MAJOR(dev):
+	return (dev) >> MINORBITS
+
+def MINOR(dev):
+	return (dev) & MINORMASK
+
+def trace_begin():
+	print "Press control+C to stop and show the summary"
+
+def trace_end():
+	if (for_comm is not None) or (for_pid is not None):
+		print_direct_io_event_for_comm()
+	else:
+		print_direct_io_event_totals()
+
+def ext4__ext4_direct_IO_exit(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	ino, dev, pos, len, rw, ret):
+	global wevent_count
+	global comm_wevent_count
+	global pid_2_comm
+
+	if rw is 1: #write
+		if (for_comm is not None) or (for_pid is not None):
+			if (common_comm != for_comm) and (common_pid != for_pid):
+				return
+			else:
+				if (pid_2_comm is None) and (for_pid is not None):
+					pid_2_comm = common_comm
+				comm_write_info[comm_wevent_count] = (common_pid, \
+						common_cpu, common_secs, common_nsecs, \
+						ino, dev, pos, ret)
+				comm_wevent_count += 1
+				return
+
+		wevent_count += 1
+		try:
+			direct_write[(common_pid, common_comm, ino, dev)] += 1
+			direct_write_bytes[(common_pid, common_comm, ino, dev)] += ret
+		except TypeError:
+			direct_write[(common_pid, common_comm, ino, dev)] = 1
+			direct_write_bytes[(common_pid, common_comm, ino, dev)] = ret
+
+	elif rw is 0: #read
+		if (for_comm is not None) or (for_pid is not None):
+			if (common_comm != for_comm) and (common_pid != for_pid):
+				return
+			else:
+				if (pid_2_comm is None) and (for_pid is not None):
+					pid_2_comm = common_comm
+				comm_read_info[comm_revent_count] = (common_pid, \
+						common_cpu, common_secs, common_nsecs, \
+						ino, dev, pos, ret)
+				comm_revent_count += 1
+				return
+		try:
+			revent_count += 1
+			direct_read[(common_pid, common_comm, ino, dev)] += 1
+			direct_read_bytes[(common_pid, common_comm, ino, dev)] += ret
+		except TypeError:
+			direct_read[(common_pid, common_comm, ino, dev)] = 1
+			direct_read_bytes[(common_pid, common_comm, ino, dev)] = ret
+
+def print_direct_io_event_totals():
+	clear_term()
+	print "\nDirect IO:\n\n",
+	print "All read events: %d\n" % (revent_count)
+	print "%5s %20s %10s %10s %10s %10s\n" % ("pid", "comm", "inode no", "dev", \
+	      "count", "Bytes"),
+	print "%5s %20s %10s %10s %10s %10s\n" % ("-----", "----------",\
+					      "----------", "----------", \
+					      "----------", "----------"),
+
+	for tuple, val in sorted(direct_read.iteritems(), key = lambda(k, v): (v, k), \
+				 reverse = True):
+		try:
+			print "%5d  %20s %10s %4d.%4d %10d %10d\n" % \
+			      (tuple[0], tuple[1], tuple[2], MAJOR(tuple[3]), MINOR(tuple[3]), \
+			      val, direct_read_bytes[tuple[0], tuple[1], tuple[2], tuple[3]])
+		except TypeError:
+			pass
+
+	print "\n\n"
+
+	print "All write events: %d\n" % (wevent_count)
+	print "%5s %20s %10s %10s %10s %10s\n" % ("pid", "comm", "inode no", "dev", \
+	      "count", "Bytes"),
+	print "%5s %20s %10s %10s %10s %10s\n" % ("-----", "----------",\
+					      "----------", "----------", \
+					      "----------", "----------"),
+
+	for tuple, val in sorted(direct_write.iteritems(), key = lambda(k, v): (v, k), \
+				reverse = True):
+		try:
+			print "%5d  %20s %10s %4d.%4d %10d %10d\n" % \
+			      (tuple[0], tuple[1], tuple[2], MAJOR(tuple[3]), MINOR(tuple[3]), \
+			      val, direct_write_bytes[tuple[0], tuple[1], tuple[2], tuple[3]])
+		except TypeError:
+			pass
+
+def print_direct_io_event_for_comm():
+	if for_comm is not None:
+		print "Direct IO record for %s:\n" % (for_comm)
+	else:
+		print "Direct IO record for %s (pid: %d):\n" % (pid_2_comm, for_pid)
+	print "Number of read: %d\n" % (comm_revent_count)
+	print "%5s %3s %16s %10s %10s %10s %10s\n" % ("pid", "cpu", "timestamp", \
+						"inode no", "dev", "position", "Bytes")
+	print "%5s %3s %16s %10s %10s %10s %10s\n" % ("-----", "---", "----------", \
+						 "----------", "----------", \
+						 "----------", "----------"),
+
+	for i in range(0, comm_revent_count):
+		try:
+			print "%5d %3d %6d.%09d %10s %4d.%-4d %10s %10s\n" % \
+				(comm_read_info[i][0], comm_read_info[i][1], \
+				comm_read_info[i][2], comm_read_info[i][3], \
+				comm_read_info[i][4], MAJOR(comm_read_info[i][5]), \
+				MINOR(comm_read_info[i][5]), comm_read_info[i][6], \
+				comm_read_info[i][7])
+		except TypeError:
+			pass
+
+	print "\nNumber of write: %d\n" % (comm_wevent_count)
+	for i in range(0, comm_wevent_count):
+		if i % 20 == 0:
+			print "\n%5s %3s %16s %10s %10s %10s %10s\r" %  \
+				("pid", "cpu", "timestamp", "inode no", \
+				"dev", "position", "Bytes")
+			print "%5s %3s %16s %10s %10s %10s %10s\n" % ("-----", "---", 
+							"----------", "----------",\
+							"----------", "----------",\
+							"----------"),
+		try:
+			print "%5d %3d %6d.%09d %10s %4d.%-4d %10s %10s\r" % \
+				(comm_write_info[i][0], comm_write_info[i][1], \
+				comm_write_info[i][2], comm_write_info[i][3], \
+				comm_write_info[i][4], MAJOR(comm_write_info[i][5]), \
+				MINOR(comm_write_info[i][5]), comm_write_info[i][6], \
+				comm_write_info[i][7])
+		except TypeError:
+			pass
+
-- 
1.7.9.5

