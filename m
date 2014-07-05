Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbaGEKlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:41:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57797 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbaGEKlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:41:20 -0400
Date: Sat, 5 Jul 2014 03:40:46 -0700
From: tip-bot for Daniel Bristot de Oliveira <tipbot@zytor.com>
Message-ID: <tip-07100877ea8fd9b2feabb4dd78f3322892f6bd77@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, lgoncalv@redhat.com, bristot@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, lgoncalv@redhat.com,
        a.p.zijlstra@chello.nl, bristot@redhat.com, tglx@linutronix.de
In-Reply-To: <5a6c64081a3375bc3bc66351b14559678ef4d71e.1402507908.git.bristot@redhat.com>
References: <5a6c64081a3375bc3bc66351b14559678ef4d71e.1402507908.git.bristot@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf scripts: Fallback to syscalls:
 * when raw_syscalls:* is not available
Git-Commit-ID: 07100877ea8fd9b2feabb4dd78f3322892f6bd77
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07100877ea8fd9b2feabb4dd78f3322892f6bd77
Gitweb:     http://git.kernel.org/tip/07100877ea8fd9b2feabb4dd78f3322892f6bd77
Author:     Daniel Bristot de Oliveira <bristot@redhat.com>
AuthorDate: Wed, 11 Jun 2014 16:09:08 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Jun 2014 12:26:56 -0300

perf scripts: Fallback to syscalls:* when raw_syscalls:* is not available

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
