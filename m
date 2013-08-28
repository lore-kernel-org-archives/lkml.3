Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3H1PE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:04:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40591 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab3H1O7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:59:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 17/21] perf trace: Add beautifier for mmap prot parm
Date: Wed, 28 Aug 2013 11:59:33 -0300
Message-Id: <1377701977-2085-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377701977-2085-1-git-send-email-acme@infradead.org>
References: <1377701977-2085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[root@zoo ~]# perf trace -e mmap,mprotect sleep 1
     0.984 ( 0.015 ms): mmap(addr: 0, len: 4096, prot: READ|WRITE, flags: 34, fd: 4294967295, off: 0) = 0xd62ae000
     1.114 ( 0.016 ms): mmap(addr: 0, len: 125100, prot: READ, flags: 2, fd: 3, off: 0        ) = 0xd628f000
     1.252 ( 0.020 ms): mmap(addr: 0x33c1600000, len: 3896312, prot: EXEC|READ, flags: 2050, fd: 3, off: 0) = 0xc1600000
     1.282 ( 0.024 ms): mprotect(start: 0x33c17ad000, len: 2097152, prot: NONE                ) = 0
     1.315 ( 0.026 ms): mmap(addr: 0x33c19ad000, len: 24576, prot: READ|WRITE, flags: 2066, fd: 3, off: 1757184) = 0xc19ad000
     1.352 ( 0.017 ms): mmap(addr: 0x33c19b3000, len: 17400, prot: READ|WRITE, flags: 50, fd: 4294967295, off: 0) = 0xc19b3000
     1.415 ( 0.011 ms): mmap(addr: 0, len: 4096, prot: READ|WRITE, flags: 34, fd: 4294967295, off: 0) = 0xd628e000
     1.440 ( 0.011 ms): mmap(addr: 0, len: 8192, prot: READ|WRITE, flags: 34, fd: 4294967295, off: 0) = 0xd628c000
     1.569 ( 0.019 ms): mprotect(start: 0x606000, len: 4096, prot: READ                       ) = 0
     1.591 ( 0.017 ms): mprotect(start: 0x33c19ad000, len: 16384, prot: READ                  ) = 0
     1.616 ( 0.016 ms): mprotect(start: 0x33c1420000, len: 4096, prot: READ                   ) = 0
     2.105 ( 0.018 ms): mmap(addr: 0, len: 104789808, prot: READ, flags: 2, fd: 3, off: 0     ) = 0xcfe9c000
[root@zoo ~]#

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-q1ubhdd9wigxneam616ggdsn@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 60ee811..81c20a6 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -11,6 +11,7 @@
 
 #include <libaudit.h>
 #include <stdlib.h>
+#include <sys/mman.h>
 
 static size_t syscall_arg__scnprintf_hex(char *bf, size_t size, unsigned long arg)
 {
@@ -19,6 +20,36 @@ static size_t syscall_arg__scnprintf_hex(char *bf, size_t size, unsigned long ar
 
 #define SCA_HEX syscall_arg__scnprintf_hex
 
+static size_t syscall_arg__scnprintf_mmap_prot(char *bf, size_t size, unsigned long arg)
+{
+	int printed = 0, prot = arg;
+
+	if (prot == PROT_NONE)
+		return scnprintf(bf, size, "NONE");
+#define	P_MMAP_PROT(n) \
+	if (prot & PROT_##n) { \
+		printed += scnprintf(bf + printed, size - printed, "%s%s", printed ? "|" : "", #n); \
+		prot &= ~PROT_##n; \
+	}
+
+	P_MMAP_PROT(EXEC);
+	P_MMAP_PROT(READ);
+	P_MMAP_PROT(WRITE);
+#ifdef PROT_SEM
+	P_MMAP_PROT(SEM);
+#endif
+	P_MMAP_PROT(GROWSDOWN);
+	P_MMAP_PROT(GROWSUP);
+#undef P_MMAP_PROT
+
+	if (prot)
+		printed += scnprintf(bf + printed, size - printed, "%s%#x", printed ? "|" : "", prot);
+
+	return printed;
+}
+
+#define SCA_MMAP_PROT syscall_arg__scnprintf_mmap_prot
+
 static struct syscall_fmt {
 	const char *name;
 	const char *alias;
@@ -40,10 +71,14 @@ static struct syscall_fmt {
 	  .arg_scnprintf = { [2] = SCA_HEX, /* arg */ }, },
 	{ .name	    = "lstat",	    .errmsg = true, .alias = "newlstat", },
 	{ .name	    = "mmap",	    .hexret = true,
-	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
+	  .arg_scnprintf = { [0] = SCA_HEX,	  /* addr */
+			     [2] = SCA_MMAP_PROT, /* prot */ }, },
 	{ .name	    = "mprotect",   .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
-	{ .name	    = "mremap",	    .hexret = true, },
+	  .arg_scnprintf = { [0] = SCA_HEX, /* start */
+			     [2] = SCA_MMAP_PROT, /* prot */ }, },
+	{ .name	    = "mremap",	    .hexret = true,
+	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */
+			     [4] = SCA_HEX, /* new_addr */ }, },
 	{ .name	    = "munmap",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
 	{ .name	    = "open",	    .errmsg = true, },
-- 
1.8.1.4

