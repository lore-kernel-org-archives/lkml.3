Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaLPQ5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:57:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:46724 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaLPQ5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:57:40 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/18] perf evlist: Clarify sterror_mmap variable names
Date: Tue, 16 Dec 2014 13:57:04 -0300
Message-Id: <1418749040-31807-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418749040-31807-1-git-send-email-acme@kernel.org>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Prep patch for doing further checks like when the number of pages that
is being attempted is actually below /proc/sys/kernel/perf_event_mlock_kb but
the operation fails because the user doesn't have CAP_IPC_LOCK.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-wetzlux7mzvofu5cuji5i71i@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index de7515dd683a..d661f252b891 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1487,16 +1487,16 @@ int perf_evlist__strerror_open(struct perf_evlist *evlist __maybe_unused,
 int perf_evlist__strerror_mmap(struct perf_evlist *evlist, int err, char *buf, size_t size)
 {
 	char sbuf[STRERR_BUFSIZE], *emsg = strerror_r(err, sbuf, sizeof(sbuf));
-	int value;
+	int pages_attempted = evlist->mmap_len / 1024, pages_max_per_user;
 
 	switch (err) {
 	case EPERM:
-		sysctl__read_int("kernel/perf_event_mlock_kb", &value);
+		sysctl__read_int("kernel/perf_event_mlock_kb", &pages_max_per_user);
 		scnprintf(buf, size, "Error:\t%s.\n"
 				     "Hint:\tCheck /proc/sys/kernel/perf_event_mlock_kb (%d kB) setting.\n"
 				     "Hint:\tTried using %zd kB.\n"
 				     "Hint:\tTry using a smaller -m/--mmap-pages value.",
-				     emsg, value, evlist->mmap_len / 1024);
+				     emsg, pages_max_per_user, pages_attempted);
 		break;
 	default:
 		scnprintf(buf, size, "%s", emsg);
-- 
1.9.3

