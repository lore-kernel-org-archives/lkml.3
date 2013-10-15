Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055Ab3JOFtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:49:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60975 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758325Ab3JOFVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:21:40 -0400
Date: Mon, 14 Oct 2013 22:20:41 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-5f9jhbq8my4ojarhtlygveox@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Use strarray for ltrace's whence arg
Git-Commit-ID: efe6b882cda2a9967a629fa14b6106b6a9a558a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:20:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  efe6b882cda2a9967a629fa14b6106b6a9a558a2
Gitweb:     http://git.kernel.org/tip/efe6b882cda2a9967a629fa14b6106b6a9a558a2
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 3 Sep 2013 16:15:12 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:09:46 -0300

perf trace: Use strarray for ltrace's whence arg

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-5f9jhbq8my4ojarhtlygveox@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 386ca20..7cb6052 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -72,31 +72,6 @@ static size_t syscall_arg__scnprintf_hex(char *bf, size_t size,
 
 #define SCA_HEX syscall_arg__scnprintf_hex
 
-static size_t syscall_arg__scnprintf_whence(char *bf, size_t size,
-					    struct syscall_arg *arg)
-{
-	int whence = arg->val;
-
-	switch (whence) {
-#define P_WHENCE(n) case SEEK_##n: return scnprintf(bf, size, #n)
-	P_WHENCE(SET);
-	P_WHENCE(CUR);
-	P_WHENCE(END);
-#ifdef SEEK_DATA
-	P_WHENCE(DATA);
-#endif
-#ifdef SEEK_HOLE
-	P_WHENCE(HOLE);
-#endif
-#undef P_WHENCE
-	default: break;
-	}
-
-	return scnprintf(bf, size, "%#x", whence);
-}
-
-#define SCA_WHENCE syscall_arg__scnprintf_whence
-
 static size_t syscall_arg__scnprintf_mmap_prot(char *bf, size_t size,
 					       struct syscall_arg *arg)
 {
@@ -254,10 +229,20 @@ static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, struct sysc
 	return printed;
 }
 
+#define SCA_FUTEX_OP  syscall_arg__scnprintf_futex_op
+
 static const char *itimers[] = { "REAL", "VIRTUAL", "PROF", };
 static DEFINE_STRARRAY(itimers);
 
-#define SCA_FUTEX_OP  syscall_arg__scnprintf_futex_op
+static const char *whences[] = { "SET", "CUR", "END",
+#ifdef SEEK_DATA
+"DATA",
+#endif
+#ifdef SEEK_HOLE
+"HOLE",
+#endif
+};
+static DEFINE_STRARRAY(whences);
 
 static size_t syscall_arg__scnprintf_open_flags(char *bf, size_t size,
 					       struct syscall_arg *arg)
@@ -340,7 +325,8 @@ static struct syscall_fmt {
 	{ .name	    = "ioctl",	    .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_HEX, /* arg */ }, },
 	{ .name	    = "lseek",	    .errmsg = true,
-	  .arg_scnprintf = { [2] = SCA_WHENCE, /* whence */ }, },
+	  .arg_scnprintf = { [2] = SCA_STRARRAY, /* whence */ },
+	  .arg_parm	 = { [2] = &strarray__whences, /* whence */ }, },
 	{ .name	    = "lstat",	    .errmsg = true, .alias = "newlstat", },
 	{ .name     = "madvise",    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_HEX,	 /* start */
