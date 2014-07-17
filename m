Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503AbaGRKUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:20:45 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:41867 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761460AbaGRKUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:20:41 -0400
Subject: [PATCH v2 3/3] perf/sdt: Documentation
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Date: Thu, 17 Jul 2014 11:26:31 +0530
Message-ID: <20140717055609.19995.43454.stgit@hemant-fedora>
In-Reply-To: <20140717054826.19995.61782.stgit@hemant-fedora>
References: <20140717054826.19995.61782.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071810-9574-0000-0000-00000016204C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the required documentation for perf support to SDT markers.

---
 tools/perf/Documentation/SDT-markers.txt |  123 ++++++++++++++++++++++++++++++
 tools/perf/Documentation/perf-list.txt   |    7 +-
 2 files changed, 129 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/Documentation/SDT-markers.txt

diff --git a/tools/perf/Documentation/SDT-markers.txt b/tools/perf/Documentation/SDT-markers.txt
new file mode 100644
index 0000000..420ba2e
--- /dev/null
+++ b/tools/perf/Documentation/SDT-markers.txt
@@ -0,0 +1,123 @@
+Support to perf for listing the SDT markers :
+
+This helps in listing dtrace style markers(SDT) present in user space
+applications through perf. Notes/markers are placed at important places by the
+developers. They have a negligible overhead when not enabled.
+We can enable them and probe at these places and find some important information
+like the arguments' values, etc.
+
+How to add SDT markers into user applications:
+We need to have this header sys/sdt.h present.
+sys/sdt.h used is version 3.
+If not present, install systemtap-sdt-devel package (for fedora-18).
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
+$ perf list sdt ./a.out
+./a.out:
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
+        printf("In main\n");
+        foo();
+        fun();
+        return 0;
+}
+- Compile it and also provide probes.o file to linker:
+$ gcc user_app.c probes.o -o user_app
+
+- Now use perf to list the markers in the app:
+# perf list sdt ./user_app
+
+./user_app :
+%user_app:foo_start
+%user_app:fun_start
+
+Also, we can see the SDT markers present in our system in the usual binaries.
+First, scan the binaries using :
+# perf list sdt --scan
+
+Creating a cache of SDT markers...
+perf sdt cache created!
+ Use : "perf list sdt"
+ to see the SDT markers
+
+After the sdt cache file is created, use perf list to view the markers :
+# perf list sdt
+
+%rtld : init_start
+%rtld : init_complete
+%rtld : map_failed
+%rtld : map_start
+%rtld : lll_futex_wake
+...
+...
+%libgcc : unwind
+%libvirt : rpc_server_client_auth_allow
+%libvirt : rpc_server_client_auth_fail
+%libvirt : rpc_server_client_auth_deny
+
+Using "perf list sdt <file-name>" after this will update the entries related to that
+<file-name> in the cache.
+
+Also, this link provides important info regarding SDT notes:
+http://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation
+
+This link shows an example of marker probing with Systemtap:
+https://sourceware.org/systemtap/wiki/AddingUserSpaceProbingToApps
+
+- Markers in binaries :
+These SDT markers are present in the ELF in the section named
+".note.stapsdt".
+Here, the name of the marker, its provider, type, location, base
+address, semaphore address.
+We can retrieve these values using the members name_off and desc_off in
+Nhdr structure. If these are not enabled, they are present in the ELF as nop.
diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 6fce6a6..f146e53 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -8,7 +8,7 @@ perf-list - List all symbolic event types
 SYNOPSIS
 --------
 [verse]
-'perf list' [hw|sw|cache|tracepoint|pmu|event_glob]
+'perf list' [hw|sw|cache|tracepoint|pmu|event_glob|sdt]
 
 DESCRIPTION
 -----------
@@ -108,6 +108,11 @@ To limit the list use:
 
 . 'pmu' to print the kernel supplied PMU events.
 
+. 'sdt' to print the SDT markers present in dsos and binaries. An additional
+  argument of filename will instruct perf to look for SDT markers only in that
+  file. If that file is already present in the cache and if there is any change,
+  then the entries for that file will be updated in the cache.
+
 . If none of the above is matched, it will apply the supplied glob to all
   events, printing the ones that match.
 

