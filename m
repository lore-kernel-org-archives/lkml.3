Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaFZVCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 17:02:06 -0400
Received: from mail.kernel.org ([198.145.19.201]:44732 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbaFZVCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 17:02:01 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/5] perf scripts: Fallback to syscalls:* when raw_syscalls:* is not available
Date: Thu, 26 Jun 2014 18:01:43 -0300
Message-Id: <1403816507-12943-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403816507-12943-1-git-send-email-acme@kernel.org>
References: <1403816507-12943-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@redhat.com>

Older kernels (e.g., RHEL6) do system call tracing via the
syscalls:sys_{enter,exit} tracepoints rather than using raw_syscalls:*.

Update perf python and perl scripts to fallback to syscalls:* when
raw_syscalls:* isn't available.

Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/5a6c64081a3375bc3bc66351b14559678ef4d71e.1402507908.git.bristot@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index 8104895a7b67..74685f318379 100644
--- a/tools/perf/scripts/perl/bin/failed-syscalls-record
+++ b/tools/perf/scripts/perl/bin/failed-syscalls-record
@@ -1,2 +1,3 @@
 #!/bin/bash
-perf record -e raw_syscalls:sys_exit $@
+(perf record -e raw_syscalls:sys_exit $@ || \
+ perf record -e syscalls:sys_exit $@) 2> /dev/null
diff --git a/tools/perf/scripts/perl/failed-syscalls.pl b/tools/perf/scripts/perl/failed-syscalls.pl
index 94bc25a347eb..55e7ae4c5c88 100644
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
index 8104895a7b67..74685f318379 100644
--- a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
+++ b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
@@ -1,2 +1,3 @@
 #!/bin/bash
-perf record -e raw_syscalls:sys_exit $@
+(perf record -e raw_syscalls:sys_exit $@ || \
+ perf record -e syscalls:sys_exit $@) 2> /dev/null
diff --git a/tools/perf/scripts/python/bin/sctop-record b/tools/perf/scripts/python/bin/sctop-record
index 4efbfaa7f6a5..d6940841e54f 100644
--- a/tools/perf/scripts/python/bin/sctop-record
+++ b/tools/perf/scripts/python/bin/sctop-record
@@ -1,2 +1,3 @@
 #!/bin/bash
-perf record -e raw_syscalls:sys_enter $@
+(perf record -e raw_syscalls:sys_enter $@ || \
+ perf record -e syscalls:sys_enter $@) 2> /dev/null
diff --git a/tools/perf/scripts/python/bin/syscall-counts-by-pid-record b/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
index 4efbfaa7f6a5..d6940841e54f 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
+++ b/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
@@ -1,2 +1,3 @@
 #!/bin/bash
-perf record -e raw_syscalls:sys_enter $@
+(perf record -e raw_syscalls:sys_enter $@ || \
+ perf record -e syscalls:sys_enter $@) 2> /dev/null
diff --git a/tools/perf/scripts/python/bin/syscall-counts-record b/tools/perf/scripts/python/bin/syscall-counts-record
index 4efbfaa7f6a5..d6940841e54f 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-record
+++ b/tools/perf/scripts/python/bin/syscall-counts-record
@@ -1,2 +1,3 @@
 #!/bin/bash
-perf record -e raw_syscalls:sys_enter $@
+(perf record -e raw_syscalls:sys_enter $@ || \
+ perf record -e syscalls:sys_enter $@) 2> /dev/null
diff --git a/tools/perf/scripts/python/failed-syscalls-by-pid.py b/tools/perf/scripts/python/failed-syscalls-by-pid.py
index 85805fac4116..266a8364bce5 100644
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
index 42c267e292fa..c9f3058b7dd4 100644
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
index c64d1c55d745..cf2054c529c9 100644
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
index b435d3f188e8..92b29381bd39 100644
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

