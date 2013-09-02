Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179Ab3IBU57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 16:57:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48862 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759029Ab3IBU4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 16:56:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/10] perf trace: Add beautifier for lseek's whence arg
Date: Mon,  2 Sep 2013 17:56:31 -0300
Message-Id: <1378155393-7993-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378155393-7993-1-git-send-email-acme@infradead.org>
References: <1378155393-7993-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

 [root@zoo ~]# perf trace -a -e lseek | head -1
    546.922 ( 0.004 ms): 1184 lseek(fd: 26, offset: 0, whence: CUR) = 2
 [root@zoo ~]#

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2eiuhwz9jbnhj80q6jaqeji4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 1a6cb74..02aaea6 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -24,6 +24,31 @@ static size_t syscall_arg__scnprintf_hex(char *bf, size_t size,
 
 #define SCA_HEX syscall_arg__scnprintf_hex
 
+static size_t syscall_arg__scnprintf_whence(char *bf, size_t size,
+					    unsigned long arg, u8 *arg_mask __maybe_unused)
+{
+	int whence = arg;
+
+	switch (whence) {
+#define P_WHENCE(n) case SEEK_##n: return scnprintf(bf, size, #n)
+	P_WHENCE(SET);
+	P_WHENCE(CUR);
+	P_WHENCE(END);
+#ifdef SEEK_DATA
+	P_WHENCE(DATA);
+#endif
+#ifdef SEEK_HOLE
+	P_WHENCE(HOLE);
+#endif
+#undef P_WHENCE
+	default: break;
+	}
+
+	return scnprintf(bf, size, "%#x", whence);
+}
+
+#define SCA_WHENCE syscall_arg__scnprintf_whence
+
 static size_t syscall_arg__scnprintf_mmap_prot(char *bf, size_t size,
 					       unsigned long arg, u8 *arg_mask __maybe_unused)
 {
@@ -201,6 +226,8 @@ static struct syscall_fmt {
 	  .arg_scnprintf = { [1] = SCA_FUTEX_OP, /* op */ }, },
 	{ .name	    = "ioctl",	    .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_HEX, /* arg */ }, },
+	{ .name	    = "lseek",	    .errmsg = true,
+	  .arg_scnprintf = { [2] = SCA_WHENCE, /* whence */ }, },
 	{ .name	    = "lstat",	    .errmsg = true, .alias = "newlstat", },
 	{ .name     = "madvise",    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_HEX,	 /* start */
-- 
1.8.1.4

