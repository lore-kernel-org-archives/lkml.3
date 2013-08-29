Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab3H2KLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:11:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35228 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab3H2KLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:11:01 -0400
Date: Thu, 29 Aug 2013 03:10:15 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-a3twa1ia5sxt0hsxqika4efq@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Add beautifier for madvise behaviour/
 advice parm
Git-Commit-ID: 9e9716d1b929ddb6955a5954fe1d9a74b233df0d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 03:10:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e9716d1b929ddb6955a5954fe1d9a74b233df0d
Gitweb:     http://git.kernel.org/tip/9e9716d1b929ddb6955a5954fe1d9a74b233df0d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 23 Aug 2013 10:06:41 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 27 Aug 2013 11:05:50 -0300

perf trace: Add beautifier for madvise behaviour/advice parm

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
