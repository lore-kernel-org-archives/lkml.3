Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3AaJJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:09:32 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:33906 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3AaJJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:09:28 -0500
From: chenggang.qin@gmail.com
To: linux-kernel@vger.kernel.org
Cc: chenggang <chenggang.qin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@alibaba-inc.com>
Subject: [PATCH] perf script: Add a python script to statistic direct io behavior
Date: Thu, 31 Jan 2013 17:08:56 +0800
Message-Id: <510a34c6.c750420a.037e.74c6@mx.google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang.qin@gmail.com

This patch depends on a prev patch: https://lkml.org/lkml/2013/1/29/47

If the engineers want to analyze the direct io behavior of some applications
without source code, perf tools with some appropriate tracepoints events in the
VFS subsystem are excellent choice.

Many database systems use their own page cache subsystems and use the direct IO
to access the disks. Sometimes, the system engineers need to know the misses rate
of the database system's page cache. This requirements can be satisfied by recording
the database's file access behavior through the way of direct IO. So, we use 2
tracepoint events to record the system wide's direct IO behavior. The 2 tracepoint
events are:
1) vfs:direct_io_read
2) vfs:direct_io_write
they were introduced by the patch: https://lkml.org/lkml/2013/1/29/47
The script direct-io.py are introduced by this patch can record the 2 tracepoint
events, analyse the sample data, and give a concise report.

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
Signed-off-by: Chenggang Qin <chenggang.qcg@alibaba-inc.com>
---
 tools/perf/scripts/python/bin/direct-io-record |    2 +
 tools/perf/scripts/python/bin/direct-io-report |   21 +++
 tools/perf/scripts/python/direct-io.py         |  185 ++++++++++++++++++++++++
 3 files changed, 208 insertions(+)
 create mode 100755 tools/perf/scripts/python/bin/direct-io-record
 create mode 100644 tools/perf/scripts/python/bin/direct-io-report
 create mode 100644 tools/perf/scripts/python/direct-io.py

diff --git a/tools/perf/scripts/python/bin/direct-io-record b/tools/perf/scripts/python/bin/direct-io-record
new file mode 100755
index 0000000..4857097
--- /dev/null
+++ b/tools/perf/scripts/python/bin/direct-io-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -e vfs:direct_io_read -e vfs:direct_io_write $@
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
index 0000000..321ff8e
--- /dev/null
+++ b/tools/perf/scripts/python/direct-io.py
@@ -0,0 +1,185 @@
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
+file_write = autodict()
+file_read = autodict()
+
+file_write_bytes = autodict()
+file_read_bytes = autodict()
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
+def trace_begin():
+	print "Press control+C to stop and show the summary"
+
+def trace_end():
+	if (for_comm is not None) or (for_pid is not None):
+		print_direct_io_event_for_comm()
+	else:
+		print_direct_io_event_totals()
+
+def vfs__direct_io_write(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	pos, bytes, fname):
+	global wevent_count
+	global comm_wevent_count
+	global pid_2_comm
+
+	if (for_comm is not None) or (for_pid is not None):
+		if (common_comm != for_comm) and (common_pid != for_pid):
+			return
+		else:
+			if (pid_2_comm is None) and (for_pid is not None):
+				pid_2_comm = common_comm
+			comm_write_info[comm_wevent_count] = (common_pid, \
+					common_cpu, common_secs, common_nsecs, \
+					fname, pos, bytes)
+			comm_wevent_count += 1
+			return
+
+	wevent_count += 1
+	try:
+		file_write[(common_pid, common_comm, fname)] += 1
+		file_write_bytes[(common_pid, common_comm, fname)] += bytes
+	except TypeError:
+		file_write[(common_pid, common_comm, fname)] = 1
+		file_write_bytes[(common_pid, common_comm, fname)] = bytes
+
+def vfs__direct_io_read(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	pos, bytes, fname):
+	global revent_count
+	global comm_revent_count
+	global pid_2_comm
+
+	if (for_comm is not None) or (for_pid is not None):
+		if (common_comm != for_comm) and (common_pid != for_pid):
+			return
+		else:
+			if (pid_2_comm is None) and (for_pid is not None):
+				pid_2_comm = common_comm
+			comm_read_info[comm_revent_count] = (common_pid, \
+					common_cpu, common_secs, common_nsecs, \
+					fname, pos, bytes)
+			comm_revent_count += 1
+			return
+
+	try:
+		revent_count += 1
+		file_read[(common_pid, common_comm, fname)] += 1
+		file_read_bytes[(common_pid, common_comm, fname)] += bytes
+	except TypeError:
+		file_read[(common_pid, common_comm, fname)] = 1
+		file_read_bytes[(common_pid, common_comm, fname)] = bytes
+
+def print_direct_io_event_totals():
+	clear_term()
+	print "\nDirect IO:\n\n",
+	print "All read events: %d\n" % (revent_count)
+	print "%5s %20s  %40s %10s %10s\n" % ("pid", "comm", "read file", "count", "Bytes"),
+	print "%5s %20s  %40s %10s %10s\n" % ("-----", "----------",\
+					      "----------", "----------", \
+					      "----------"),
+
+	for tuple, val in sorted(file_read.iteritems(), key = lambda(k, v): (v, k), \
+				 reverse = True):
+		try:
+			print "%5d  %20s %40s %10d %10d\n" % \
+			      (tuple[0], tuple[1], tuple[2][:40], val, \
+			      file_read_bytes[tuple[0], tuple[1], tuple[2]])
+		except TypeError:
+			pass
+
+	print "\n\n"
+
+	print "All write events: %d\n" % (wevent_count)
+	print "%5s %20s  %40s %10s %10s\n" % ("pid", "comm", "write file", "count", "Bytes"),
+	print "%5s %20s  %40s %10s %10s\n" % ("-----", "----------",\
+					      "----------", "----------", \
+					      "----------"),
+
+	for tuple, val in sorted(file_write.iteritems(), key = lambda(k, v): (v, k), \
+				reverse = True):
+		try:
+			print "%5d  %20s %40s %10d %10d\n" % \
+			      (tuple[0], tuple[1], tuple[2][:40], val, \
+			      file_write_bytes[tuple[0], tuple[1], tuple[2]])
+		except TypeError:
+			pass
+
+def print_direct_io_event_for_comm():
+	if for_comm is not None:
+		print "Direct IO record for %s:\n" % (for_comm)
+	else:
+		print "Direct IO record for %s (pid: %d):\n" % (pid_2_comm, for_pid)
+	print "Number of read: %d\n" % (comm_revent_count)
+	print "%5s %3s %16s %40s %10s %10s\n" % ("pid", "cpu", "timestamp", "file name", \
+						 "position", "Bytes")
+	print "%5s %3s %16s %40s %10s %10s\n" % ("-----", "---", "----------", \
+						 "----------", "----------", \
+						 "----------"),
+
+	for i in range(0, comm_revent_count):
+		try:
+			print "%5d %3d %6d.%9d %40s %10s %10s\n" % (comm_read_info[i][0], \
+				comm_read_info[i][1], comm_read_info[i][2], \
+				comm_read_info[i][3], comm_read_info[i][4], \
+				comm_read_info[i][5], comm_read_info[i][6])
+		except TypeError:
+			pass
+
+	print "\nNumber of write: %d\n" % (comm_wevent_count)
+	print "%5s %3s %16s %40s %10s %10s\n" % ("pid", "cpu", "timestamp", "file name", \
+						 "position", "Bytes")
+	print "%5s %3s %16s %40s %10s %10s\n" % ("-----", "---", "----------", \
+						 "----------", "----------", \
+						 "----------"),
+	for i in range(0, comm_wevent_count):
+		try:
+			print "%5d %3d %6d.%9d %40s %10s %10s\n" % (comm_write_info[i][0], \
+				comm_write_info[i][1], comm_write_info[i][2], \
+				comm_write_info[i][3], comm_write_info[i][4], \
+				comm_write_info[i][5], comm_write_info[i][6])
+		except TypeError:
+			pass
+
-- 
1.7.9.5

