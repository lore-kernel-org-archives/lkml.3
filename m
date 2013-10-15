Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab3JOFjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:39:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab3JOFb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:31:58 -0400
Date: Mon, 14 Oct 2013 22:31:17 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-k1ce6uqyt4qar9edrj3mevod@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Allow specifying index offset in strarrays
Git-Commit-ID: 03e3adc9f4d8b57dc83475c8c4c6e462a78ff709
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:31:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03e3adc9f4d8b57dc83475c8c4c6e462a78ff709
Gitweb:     http://git.kernel.org/tip/03e3adc9f4d8b57dc83475c8c4c6e462a78ff709
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 8 Oct 2013 16:00:21 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:59 -0300

perf trace: Allow specifying index offset in strarrays

So that the index passed doesn't have to start at zero, being
decremented from an offset specified when declaring the strarray before
being used as the real array index.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-k1ce6uqyt4qar9edrj3mevod@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index addc3e1..7424298 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -44,6 +44,7 @@ struct syscall_arg {
 };
 
 struct strarray {
+	int	    offset;
 	int	    nr_entries;
 	const char **entries;
 };
@@ -53,14 +54,20 @@ struct strarray {
 	.entries = array, \
 }
 
+#define DEFINE_STRARRAY_OFFSET(array, off) struct strarray strarray__##array = { \
+	.offset	    = off, \
+	.nr_entries = ARRAY_SIZE(array), \
+	.entries = array, \
+}
+
 static size_t syscall_arg__scnprintf_strarray(char *bf, size_t size,
 					      struct syscall_arg *arg)
 {
-	int idx = arg->val;
 	struct strarray *sa = arg->parm;
+	int idx = arg->val - sa->offset;
 
 	if (idx < 0 || idx >= sa->nr_entries)
-		return scnprintf(bf, size, "%d", idx);
+		return scnprintf(bf, size, "%d", arg->val);
 
 	return scnprintf(bf, size, "%s", sa->entries[idx]);
 }
@@ -288,8 +295,8 @@ static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, struct sysc
 
 #define SCA_FUTEX_OP  syscall_arg__scnprintf_futex_op
 
-static const char *epoll_ctl_ops[] = { [1] = "ADD", "DEL", "MOD", };
-static DEFINE_STRARRAY(epoll_ctl_ops);
+static const char *epoll_ctl_ops[] = { "ADD", "DEL", "MOD", };
+static DEFINE_STRARRAY_OFFSET(epoll_ctl_ops, 1);
 
 static const char *itimers[] = { "REAL", "VIRTUAL", "PROF", };
 static DEFINE_STRARRAY(itimers);
