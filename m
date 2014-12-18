Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaLRG3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:29:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58553 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaLRG3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:29:12 -0500
Date: Wed, 17 Dec 2014 22:28:24 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-wetzlux7mzvofu5cuji5i71i@git.kernel.org>
Cc: hpa@zytor.com, acme@redhat.com, tglx@linutronix.de,
        adrian.hunter@intel.com, mingo@kernel.org, bp@suse.de,
        namhyung@kernel.org, eranian@google.com, peterz@infradead.org,
        fweisbec@gmail.com, efault@gmx.de, jolsa@redhat.com, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, dzickus@redhat.com, paulus@samba.org
Reply-To: acme@redhat.com, hpa@zytor.com, namhyung@kernel.org, bp@suse.de,
        mingo@kernel.org, tglx@linutronix.de, adrian.hunter@intel.com,
        fweisbec@gmail.com, efault@gmx.de, jolsa@redhat.com,
        peterz@infradead.org, eranian@google.com, paulus@samba.org,
        dzickus@redhat.com, linux-kernel@vger.kernel.org, dsahern@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist:
  Clarify sterror_mmap variable names
Git-Commit-ID: e5d4a290da5366c397653c47c3e869a67b1bfa07
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5d4a290da5366c397653c47c3e869a67b1bfa07
Gitweb:     http://git.kernel.org/tip/e5d4a290da5366c397653c47c3e869a67b1bfa07
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 12 Dec 2014 15:59:51 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 16 Dec 2014 13:38:26 -0300

perf evlist: Clarify sterror_mmap variable names

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
index de7515d..d661f25 100644
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
