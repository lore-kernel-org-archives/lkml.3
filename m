Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaFKTJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:09:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbaFKTJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:09:38 -0400
From: Daniel Bristot de Oliveira <bristot@redhat.com>
To: acme@ghostprotocols.net
Cc: paulus@samba.org, lgoncalv@redhat.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        bristot@redhat.com
Subject: [PATCH] perf scripts: fallback to syscalls when raw_syscalls support is not available
Date: Wed, 11 Jun 2014 16:09:08 -0300
Message-Id: <5a6c64081a3375bc3bc66351b14559678ef4d71e.1402507908.git.bristot@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Older kernels (e.g., RHEL6) do system call tracing via
syscalls:sys_{enter,exit} rather than raw_syscalls.
Update perf-scripts to fallback to syscalls in the
lack of raw_syscall support.

Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
---
 tools/perf/scripts/perl/bin/failed-syscalls-record          | 3 ++-
 tools/perf/scripts/perl/failed-syscalls.pl                  | 5 +++++
 tools/perf/scripts/python/bin/failed-syscalls-by-pid-record | 3 ++-
 tools/perf/scripts/python/bin/sctop-record                  | 3 ++-
 tools/perf/scripts/python/bin/syscall-counts-by-pid-record  | 3 ++-
 tools/perf/scripts/python/bin/syscall-counts-record         | 3 ++-
 tools/perf/scripts/python/failed-syscalls-by-pid.py         | 5 +++++
 tools/perf/scripts/python/sctop.py                          | 5 +++++
 tools/perf/scripts/python/syscall-counts-by-pid.py          | 5 +++++
 tools/perf/scripts/python/syscall-counts.py                 | 5 +++++
 10 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/tools/perf/scripts/perl/bin/failed-syscalls-record b/tools/perf/scripts/perl/bin/failed-syscalls-record
index 8104895..74685f3 100644
--- a/tools/perf/scripts/perl/bin/failed-syscalls-record
+++ b/tools/perf/scripts/perl/bin/failed-syscalls-record
@@ -1,2 +1,3 @@
 #!/bin/bash
-perf record -e raw_syscalls:sys_exit $@
+(perf record -e raw_syscalls:sys_exit $@ || \
+ perf record -e syscalls:sys_exit $@) 2> /dev/null
diff --git a/tools/perf/scripts/perl/failed-syscalls.pl b/tools/perf/scripts/perl/failed-syscalls.pl
index 94bc25a..55e7ae4 100644
--- a/tools/perf/scripts/perl/failed-syscalls.pl
+++ b/tools/perf/scripts/perl/failed-syscalls.pl
@@ -26,6 +26,11 @@ sub raw_syscalls::sys_exit
 	}
 }
 
+sub syscalls::sys_exit
+{
+	raw_syscalls::sys_exit(@_)
+}
+
 sub trace_end
 {
     printf("\nfailed syscalls by comm:\n\n");
diff --git a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
index 8104895..74685f3 100644
--- a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
+++ b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
@@ -1,2 +1,3 @@
 #!/bin/bash
-perf record -e raw_syscalls:sys_exit $@
+(perf record -e raw_syscalls:sys_exit $@ || \
+ perf record -e syscalls:sys_exit $@) 2> /dev/null
diff --git a/tools/perf/scripts/python/bin/sctop-record b/tools/perf/scripts/python/bin/sctop-record
index 4efbfaa..d694084 100644
--- a/tools/perf/scripts/python/bin/sctop-record
+++ b/tools/perf/scripts/python/bin/sctop-record
@@ -1,2 +1,3 @@
 #!/bin/bash
-perf record -e raw_syscalls:sys_enter $@
+(perf record -e raw_syscalls:sys_enter $@ || \
+ perf record -e syscalls:sys_enter $@) 2> /dev/null
diff --git a/tools/perf/scripts/python/bin/syscall-counts-by-pid-record b/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
index 4efbfaa..d694084 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
+++ b/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
@@ -1,2 +1,3 @@
 #!/bin/bash
-perf record -e raw_syscalls:sys_enter $@
+(perf record -e raw_syscalls:sys_enter $@ || \
+ perf record -e syscalls:sys_enter $@) 2> /dev/null
diff --git a/tools/perf/scripts/python/bin/syscall-counts-record b/tools/perf/scripts/python/bin/syscall-counts-record
index 4efbfaa..d694084 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-record
+++ b/tools/perf/scripts/python/bin/syscall-counts-record
@@ -1,2 +1,3 @@
 #!/bin/bash
-perf record -e raw_syscalls:sys_enter $@
+(perf record -e raw_syscalls:sys_enter $@ || \
+ perf record -e syscalls:sys_enter $@) 2> /dev/null
diff --git a/tools/perf/scripts/python/failed-syscalls-by-pid.py b/tools/perf/scripts/python/failed-syscalls-by-pid.py
index 85805fa..266a836 100644
--- a/tools/perf/scripts/python/failed-syscalls-by-pid.py
+++ b/tools/perf/scripts/python/failed-syscalls-by-pid.py
@@ -50,6 +50,11 @@ def raw_syscalls__sys_exit(event_name, context, common_cpu,
 		except TypeError:
 			syscalls[common_comm][common_pid][id][ret] = 1
 
+def syscalls__sys_exit(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	id, ret):
+	raw_syscalls__sys_exit(**locals())
+
 def print_error_totals():
     if for_comm is not None:
 	    print "\nsyscall errors for %s:\n\n" % (for_comm),
diff --git a/tools/perf/scripts/python/sctop.py b/tools/perf/scripts/python/sctop.py
index 42c267e..c9f3058 100644
--- a/tools/perf/scripts/python/sctop.py
+++ b/tools/perf/scripts/python/sctop.py
@@ -53,6 +53,11 @@ def raw_syscalls__sys_enter(event_name, context, common_cpu,
 	except TypeError:
 		syscalls[id] = 1
 
+def syscalls__sys_enter(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	id, args):
+	raw_syscalls__sys_enter(**locals())
+
 def print_syscall_totals(interval):
 	while 1:
 		clear_term()
diff --git a/tools/perf/scripts/python/syscall-counts-by-pid.py b/tools/perf/scripts/python/syscall-counts-by-pid.py
index c64d1c5..cf2054c 100644
--- a/tools/perf/scripts/python/syscall-counts-by-pid.py
+++ b/tools/perf/scripts/python/syscall-counts-by-pid.py
@@ -48,6 +48,11 @@ def raw_syscalls__sys_enter(event_name, context, common_cpu,
 	except TypeError:
 		syscalls[common_comm][common_pid][id] = 1
 
+def syscalls__sys_enter(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	id, args):
+	raw_syscalls__sys_enter(**locals())
+
 def print_syscall_totals():
     if for_comm is not None:
 	    print "\nsyscall events for %s:\n\n" % (for_comm),
diff --git a/tools/perf/scripts/python/syscall-counts.py b/tools/perf/scripts/python/syscall-counts.py
index b435d3f..92b2938 100644
--- a/tools/perf/scripts/python/syscall-counts.py
+++ b/tools/perf/scripts/python/syscall-counts.py
@@ -44,6 +44,11 @@ def raw_syscalls__sys_enter(event_name, context, common_cpu,
 	except TypeError:
 		syscalls[id] = 1
 
+def syscalls__sys_enter(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	id, args):
+	raw_syscalls__sys_enter(**locals())
+
 def print_syscall_totals():
     if for_comm is not None:
 	    print "\nsyscall events for %s:\n\n" % (for_comm),
-- 
1.9.3

