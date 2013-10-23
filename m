Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab3JWFF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 01:05:58 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56598 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3JWFF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 01:05:57 -0400
Subject: [PATCH v4 3/3] Documentation regarding perf/sdt
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com
Date: Wed, 23 Oct 2013 10:35:50 +0530
Message-ID: <20131023050524.1886.13639.stgit@hemant-fedora>
In-Reply-To: <20131023044511.1886.82571.stgit@hemant-fedora>
References: <20131023044511.1886.82571.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102305-3864-0000-0000-00000AB313AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds documentation for perf support to SDT notes/markers.

Signed-off-by: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-probe.txt |   17 +++
 tools/perf/Documentation/sdt-probes.txt |  184 +++++++++++++++++++++++++++++++
 2 files changed, 199 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/Documentation/sdt-probes.txt

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index b715cb7..f0169d9 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -99,10 +99,15 @@ OPTIONS
 --max-probes::
 	Set the maximum number of probe points for an event. Default is 128.
 
+-M::
+--markers::
+	View the SDT markers present in a user space application/library.
+
 -x::
 --exec=PATH::
 	Specify path to the executable or shared library file for user
-	space tracing. Can also be used with --funcs option.
+	space tracing. Can also be used with --funcs option and must be used
+	with --markers/-M option.
 
 In absence of -m/-x options, perf probe checks if the first argument after
 the options is an absolute path name. If its an absolute path, perf probe
@@ -121,11 +126,15 @@ Probe points are defined by following syntax.
     3) Define event based on source file with lazy pattern
      [EVENT=]SRC;PTN [ARG ...]
 
+    4) Define event based on SDT marker
+     [[EVENT=]%PROVIDER:MARKER
+
 
-'EVENT' specifies the name of new event, if omitted, it will be set the name of the probed function. Currently, event group name is set as 'probe'.
+'EVENT' specifies the name of new event, if omitted, it will be set the name of the probed function. Currently, event group name is set as 'probe' except in case of SDT markers where it is set to provider name.
 'FUNC' specifies a probed function name, and it may have one of the following options; '+OFFS' is the offset from function entry address in bytes, ':RLN' is the relative-line number from function entry line, and '%return' means that it probes function return. And ';PTN' means lazy matching pattern (see LAZY MATCHING). Note that ';PTN' must be the end of the probe point definition.  In addition, '@SRC' specifies a source file which has that function.
 It is also possible to specify a probe point by the source line number or lazy matching by using 'SRC:ALN' or 'SRC;PTN' syntax, where 'SRC' is the source file path, ':ALN' is the line number and ';PTN' is the lazy matching pattern.
 'ARG' specifies the arguments of this probe point, (see PROBE ARGUMENT).
+'%PROVIDER:MARKER' is the syntax of SDT markers present in an ELF.
 
 PROBE ARGUMENT
 --------------
@@ -200,6 +209,10 @@ Add probes at malloc() function on libc
 
  ./perf probe -x /lib/libc.so.6 malloc or ./perf probe /lib/libc.so.6 malloc
 
+Add probes at longjmp SDT marker on libc
+
+ ./perf probe -x /lib64/libc.so.6 %libc:longjmp
+
 SEE ALSO
 --------
 linkperf:perf-trace[1], linkperf:perf-record[1]
diff --git a/tools/perf/Documentation/sdt-probes.txt b/tools/perf/Documentation/sdt-probes.txt
new file mode 100644
index 0000000..d5556b7
--- /dev/null
+++ b/tools/perf/Documentation/sdt-probes.txt
@@ -0,0 +1,184 @@
+Perf probing on SDT markers:
+
+Goal:
+Probe dtrace style markers(SDT) present in user space applications.
+
+Scope:
+Put probe points at SDT markers in user space applications and libraries
+and also probe them using perf.
+
+Why supprt SDT markers? :
+We have lots of applications which use SDT markers today like:
+Postgresql, MySql, Mozilla, Perl, Python, Java, Ruby, libvirt, QEMU, glib
+
+These markers are placed at important places by the developers. Now, these
+markers have a negligible overhead when not enabled. We can enable them
+and probe at these places and find some important information like the
+arguments' values, etc.
+
+How to add SDT markers into user applications:
+We need to have this header sys/sdt.h present.
+sys/sdt.h used is version 3.
+If not present, install systemtap-sdt-devel package.
+
+A very simple example:
+
+$ cat user_app.c
+
+#include <sys/sdt.h>
+
+void main () {
+       /* ... */
+       /* 
+        * user_app is the provider name
+	* test_probe is the marker name
+	*/
+       STAP_PROBE(user_app, test_mark);
+       /* ... */
+}
+
+$ gcc user_app.c
+$ perf probe -M -x ./a.out
+%user_app:test_mark
+
+A different example to show the same:
+- Create a file with .d extension and mention the probe names in it with
+provider name and marker name.
+
+$ cat probes.d
+provider user_app {
+         probe foo_start();
+         probe fun_start();
+};
+
+- Now create the probes.h and probes.o file :
+$ dtrace -C -h -s probes.d -o probes.h
+$ dtrace -C -G -s probes.d -o probes.o
+
+- A program using the markers:
+
+$ cat user_app.c
+
+#include <stdio.h>
+#include "probes.h"
+
+void foo(void)
+{
+        USER_APP_FOO_START();
+        printf("This is foo\n");
+}
+
+void fun(void)
+{
+        USER_APP_FUN_START();
+        printf("Inside fun\n");
+}
+int main(void)
+{
+	printf("In main\n");
+        foo();
+        fun();
+        return 0;
+}
+
+- Compile it and also provide probes.o file to linker:
+$ gcc user_app.c probes.o -o user_app
+
+- Now use perf to list the markers in the app:
+# perf probe --markers -x ./user_app
+
+%user_app:foo_start
+%user_app:fun_start
+
+- And  then use perf probe to add a probe point :
+
+# perf probe -x ./user_app 'my_event=%user_app:foo_start'
+
+Added new event :
+user_app:my_event      (on 0x530)
+
+You can now use it on all perf tools such as :
+
+     perf record -e user_app:my_event -aR sleep 1
+
+# perf record -e probe_user:my_event -aR ./user_app
+In main
+This is foo
+Inside fun
+[ perf record: Woken up 1 times to write data ]
+[ perf record: Captured and wrote 0.235 MB perf.data (~10279 samples) ]
+
+- Then use perf tools to analyze it.
+# perf report --stdio
+
+# ========
+# captured on: Tue Sep  3 16:19:55 2013
+# hostname : hemant-fedora
+# os release : 3.11.0-rc3+
+# perf version : 3.9.4-200.fc18.x86_64
+# arch : x86_64
+# nrcpus online : 2
+# nrcpus avail : 2
+# cpudesc : QEMU Virtual CPU version 1.2.2
+# cpuid : GenuineIntel,6,2,3
+# total memory : 2051912 kBIf these are not enabled, they are present in the ELF as nop.
+
+# cmdline : /usr/bin/perf record -e probe_user:foo_start -aR ./user_app
+# event : name = probe_user:foo_start, type = 2, config = 0x38e, config1
+= 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0,
+excl_guest = 1, precise_ip = 0
+# HEADER_CPU_TOPOLOGY info available, use -I to display
+# HEADER_NUMA_TOPOLOGY info available, use -I to display
+# pmu mappings: software = 1, tracepoint = 2, breakpoint = 5
+# ========
+#
+# Samples: 1  of event 'probe_user:foo_start'
+# Event count (approx.): 1
+#
+# Overhead   Command  Shared Object   Symbol
+# ........  ........  .............  .......
+#
+   100.00%  user_app  user_app       [.] foo
+
+
+#
+# (For a higher level overview, try: perf report --sort comm,dso)
+#
+
+
+We can see the existing markers in libc (if present) :
+$ perf probe --markers -x /lib64/libc.so.6
+
+%libc:setjmp
+%libc:longjmp
+%libc:longjmp_target
+%libc:lll_futex_wake
+%libc:lll_lock_wait_private
+%libc:longjmp
+%libc:longjmp_target
+%libc:lll_futex_wake
+
+- And then use perf to probe into any marker:
+
+# perf probe -x /lib64/libc.so.6 %libc:setjmp
+Added new event:
+  libc:setjmp          (on 0x35981)
+
+You can now use it in all perf tools, such as:
+
+    perf record -e libc:setjmp -aR sleep 1
+
+
+This link shows an example of marker probing with Systemtap:
+https://sourceware.org/systemtap/wiki/AddingUserSpaceProbingToApps
+
+And, this link shows more info on SDT markers:
+http://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation
+
+- Markers in binaries :
+These SDT markers are present in the ELF in the section named
+".note.stapsdt".
+Here, the name of the marker, its provider, type, location, base
+address, semaphore address, arguments are present.
+We can retrieve these values using the members name_off and desc_off in
+Nhdr structure. If these are not enabled, they are present in the ELF as nop.

