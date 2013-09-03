Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642Ab3ICHVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:21:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36318 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3ICHVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:21:47 -0400
Date: Tue, 3 Sep 2013 00:16:09 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-2eiuhwz9jbnhj80q6jaqeji4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Add beautifier for lseek's whence arg
Git-Commit-ID: 579e7865b2d431bb7d380a1b4ea0aa8eb8a10fd4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 03 Sep 2013 00:16:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  579e7865b2d431bb7d380a1b4ea0aa8eb8a10fd4
Gitweb:     http://git.kernel.org/tip/579e7865b2d431bb7d380a1b4ea0aa8eb8a10fd4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 2 Sep 2013 15:37:32 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Sep 2013 15:37:32 -0300

perf trace: Add beautifier for lseek's whence arg

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
