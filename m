Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3H1PDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:03:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40596 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3H1O7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:59:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 18/21] perf trace: Add beautifier for mmap flags parm
Date: Wed, 28 Aug 2013 11:59:34 -0300
Message-Id: <1377701977-2085-19-git-send-email-acme@infradead.org>
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
     0.992 ( 0.015 ms): mmap(addr: 0, len: 4096, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: 4294967295, off: 0) = 0xa60be000
     1.108 ( 0.012 ms): mmap(addr: 0, len: 125100, prot: READ, flags: PRIVATE, fd: 3, off: 0  ) = 0xa609f000
     1.209 ( 0.014 ms): mmap(addr: 0x33c1600000, len: 3896312, prot: EXEC|READ, flags: PRIVATE|DENYWRITE, fd: 3, off: 0) = 0xc1600000
     1.232 ( 0.018 ms): mprotect(start: 0x33c17ad000, len: 2097152, prot: NONE                ) = 0
     1.255 ( 0.018 ms): mmap(addr: 0x33c19ad000, len: 24576, prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 1757184) = 0xc19ad000
     1.281 ( 0.011 ms): mmap(addr: 0x33c19b3000, len: 17400, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS|FIXED, fd: 4294967295, off: 0) = 0xc19b3000
     1.328 ( 0.008 ms): mmap(addr: 0, len: 4096, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: 4294967295, off: 0) = 0xa609e000
     1.346 ( 0.008 ms): mmap(addr: 0, len: 8192, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: 4294967295, off: 0) = 0xa609c000
     1.443 ( 0.013 ms): mprotect(start: 0x606000, len: 4096, prot: READ                       ) = 0
     1.459 ( 0.011 ms): mprotect(start: 0x33c19ad000, len: 16384, prot: READ                  ) = 0
     1.477 ( 0.011 ms): mprotect(start: 0x33c1420000, len: 4096, prot: READ                   ) = 0
     1.855 ( 0.013 ms): mmap(addr: 0, len: 104789808, prot: READ, flags: PRIVATE, fd: 3, off: 0) = 0x9fcac000
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
 tools/perf/builtin-trace.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 81c20a6..034152c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -50,6 +50,44 @@ static size_t syscall_arg__scnprintf_mmap_prot(char *bf, size_t size, unsigned l
 
 #define SCA_MMAP_PROT syscall_arg__scnprintf_mmap_prot
 
+static size_t syscall_arg__scnprintf_mmap_flags(char *bf, size_t size, unsigned long arg)
+{
+	int printed = 0, flags = arg;
+
+#define	P_MMAP_FLAG(n) \
+	if (flags & MAP_##n) { \
+		printed += scnprintf(bf + printed, size - printed, "%s%s", printed ? "|" : "", #n); \
+		flags &= ~MAP_##n; \
+	}
+
+	P_MMAP_FLAG(SHARED);
+	P_MMAP_FLAG(PRIVATE);
+	P_MMAP_FLAG(32BIT);
+	P_MMAP_FLAG(ANONYMOUS);
+	P_MMAP_FLAG(DENYWRITE);
+	P_MMAP_FLAG(EXECUTABLE);
+	P_MMAP_FLAG(FILE);
+	P_MMAP_FLAG(FIXED);
+	P_MMAP_FLAG(GROWSDOWN);
+	P_MMAP_FLAG(HUGETLB);
+	P_MMAP_FLAG(LOCKED);
+	P_MMAP_FLAG(NONBLOCK);
+	P_MMAP_FLAG(NORESERVE);
+	P_MMAP_FLAG(POPULATE);
+	P_MMAP_FLAG(STACK);
+#ifdef MAP_UNINITIALIZED
+	P_MMAP_FLAG(UNINITIALIZED);
+#endif
+#undef P_MMAP_FLAG
+
+	if (flags)
+		printed += scnprintf(bf + printed, size - printed, "%s%#x", printed ? "|" : "", flags);
+
+	return printed;
+}
+
+#define SCA_MMAP_FLAGS syscall_arg__scnprintf_mmap_flags
+
 static struct syscall_fmt {
 	const char *name;
 	const char *alias;
@@ -72,7 +110,8 @@ static struct syscall_fmt {
 	{ .name	    = "lstat",	    .errmsg = true, .alias = "newlstat", },
 	{ .name	    = "mmap",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX,	  /* addr */
-			     [2] = SCA_MMAP_PROT, /* prot */ }, },
+			     [2] = SCA_MMAP_PROT, /* prot */
+			     [3] = SCA_MMAP_FLAGS, /* flags */ }, },
 	{ .name	    = "mprotect",   .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* start */
 			     [2] = SCA_MMAP_PROT, /* prot */ }, },
-- 
1.8.1.4

