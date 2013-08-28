Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab3H1PBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:01:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40605 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab3H1O7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:59:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 19/21] perf trace: Add beautifier for madvise behaviour/advice parm
Date: Wed, 28 Aug 2013 11:59:35 -0300
Message-Id: <1377701977-2085-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377701977-2085-1-git-send-email-acme@infradead.org>
References: <1377701977-2085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

  [root@zoo ~]# perf trace -e madvise -a
    35299.631 ( 0.019 ms): 19553 madvise(start: 0x7f5b101d4000, len_in: 4063232, behavior: DONTNEED    ) = 0

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-a3twa1ia5sxt0hsxqika4efq@git.kernel.org
[ ifdef DO(NT)?DUMP to fix build on f16, from David Ahern ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 034152c..b72afc7 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -88,6 +88,43 @@ static size_t syscall_arg__scnprintf_mmap_flags(char *bf, size_t size, unsigned
 
 #define SCA_MMAP_FLAGS syscall_arg__scnprintf_mmap_flags
 
+static size_t syscall_arg__scnprintf_madvise_behavior(char *bf, size_t size, unsigned long arg)
+{
+	int behavior = arg;
+
+	switch (behavior) {
+#define	P_MADV_BHV(n) case MADV_##n: return scnprintf(bf, size, #n)
+	P_MADV_BHV(NORMAL);
+	P_MADV_BHV(RANDOM);
+	P_MADV_BHV(SEQUENTIAL);
+	P_MADV_BHV(WILLNEED);
+	P_MADV_BHV(DONTNEED);
+	P_MADV_BHV(REMOVE);
+	P_MADV_BHV(DONTFORK);
+	P_MADV_BHV(DOFORK);
+	P_MADV_BHV(HWPOISON);
+#ifdef MADV_SOFT_OFFLINE
+	P_MADV_BHV(SOFT_OFFLINE);
+#endif
+	P_MADV_BHV(MERGEABLE);
+	P_MADV_BHV(UNMERGEABLE);
+	P_MADV_BHV(HUGEPAGE);
+	P_MADV_BHV(NOHUGEPAGE);
+#ifdef MADV_DONTDUMP
+	P_MADV_BHV(DONTDUMP);
+#endif
+#ifdef MADV_DODUMP
+	P_MADV_BHV(DODUMP);
+#endif
+#undef P_MADV_PHV
+	default: break;
+	}
+
+	return scnprintf(bf, size, "%#x", behavior);
+}
+
+#define SCA_MADV_BHV syscall_arg__scnprintf_madvise_behavior
+
 static struct syscall_fmt {
 	const char *name;
 	const char *alias;
@@ -108,6 +145,9 @@ static struct syscall_fmt {
 	{ .name	    = "ioctl",	    .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_HEX, /* arg */ }, },
 	{ .name	    = "lstat",	    .errmsg = true, .alias = "newlstat", },
+	{ .name     = "madvise",    .errmsg = true,
+	  .arg_scnprintf = { [0] = SCA_HEX,	 /* start */
+			     [2] = SCA_MADV_BHV, /* behavior */ }, },
 	{ .name	    = "mmap",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX,	  /* addr */
 			     [2] = SCA_MMAP_PROT, /* prot */
-- 
1.8.1.4

