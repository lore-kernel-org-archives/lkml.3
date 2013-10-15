Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382Ab3JOFcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:32:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33619 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3JOFcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:32:00 -0400
Date: Mon, 14 Oct 2013 22:31:26 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-nsvy06sqj64qvnkmzvwxsx2v@git.kernel.org>
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
  Prepare the strarray scnprintf method for reuse
Git-Commit-ID: 975b7c2f40d431da4fdb46dd8b9d90c129eecc12
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:31:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  975b7c2f40d431da4fdb46dd8b9d90c129eecc12
Gitweb:     http://git.kernel.org/tip/975b7c2f40d431da4fdb46dd8b9d90c129eecc12
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 8 Oct 2013 17:17:43 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:18:00 -0300

perf trace: Prepare the strarray scnprintf method for reuse

Right now when an index passed to that method has no string associated
it'll print the index as a decimal number, prepare it so that we can use
it to print it in hex as well, for ioctls, for instance.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-nsvy06sqj64qvnkmzvwxsx2v@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 7424298..0d4af1d 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -60,18 +60,25 @@ struct strarray {
 	.entries = array, \
 }
 
-static size_t syscall_arg__scnprintf_strarray(char *bf, size_t size,
-					      struct syscall_arg *arg)
+static size_t __syscall_arg__scnprintf_strarray(char *bf, size_t size,
+						const char *intfmt,
+					        struct syscall_arg *arg)
 {
 	struct strarray *sa = arg->parm;
 	int idx = arg->val - sa->offset;
 
 	if (idx < 0 || idx >= sa->nr_entries)
-		return scnprintf(bf, size, "%d", arg->val);
+		return scnprintf(bf, size, intfmt, arg->val);
 
 	return scnprintf(bf, size, "%s", sa->entries[idx]);
 }
 
+static size_t syscall_arg__scnprintf_strarray(char *bf, size_t size,
+					      struct syscall_arg *arg)
+{
+	return __syscall_arg__scnprintf_strarray(bf, size, "%d", arg);
+}
+
 #define SCA_STRARRAY syscall_arg__scnprintf_strarray
 
 static size_t syscall_arg__scnprintf_fd(char *bf, size_t size,
