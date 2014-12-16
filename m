Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaLPQ5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:57:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:46741 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaLPQ5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:57:45 -0500
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
Subject: [PATCH 03/18] perf evlist: Improve the strerror_mmap method
Date: Tue, 16 Dec 2014 13:57:05 -0300
Message-Id: <1418749040-31807-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418749040-31807-1-git-send-email-acme@kernel.org>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Considering the per user locked pages limit, improve the message when a
user uses multiple simultaneous perf mmap calls:

When the request is more than the current maximum:

  [acme@ssdandy linux]$ trace -m 128 usleep 1
  Error: Operation not permitted.
  Hint:  Check /proc/sys/kernel/perf_event_mlock_kb (516 kB) setting.
  Hint:  Tried using 516 kB.
  Hint:  Try 'sudo sh -c "echo 1032 > /proc/sys/kernel/perf_event_mlock_kb"', or
  Hint:  Try using a smaller -m/--mmap-pages value.
  [acme@ssdandy linux]$

And when the limit is less than that:

  [acme@ssdandy linux]$ trace -m 512 usleep 1
  Error: Operation not permitted.
  Hint:  Check /proc/sys/kernel/perf_event_mlock_kb (2056 kB) setting.
  Hint:  Tried using 2052 kB.
  Hint:  Try using a smaller -m/--mmap-pages value.
  [acme@ssdandy linux]$

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
Link: http://lkml.kernel.org/n/tip-yqdie3c8qvdgenwleri267d4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d661f252b891..7847f3885081 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1487,16 +1487,25 @@ int perf_evlist__strerror_open(struct perf_evlist *evlist __maybe_unused,
 int perf_evlist__strerror_mmap(struct perf_evlist *evlist, int err, char *buf, size_t size)
 {
 	char sbuf[STRERR_BUFSIZE], *emsg = strerror_r(err, sbuf, sizeof(sbuf));
-	int pages_attempted = evlist->mmap_len / 1024, pages_max_per_user;
+	int pages_attempted = evlist->mmap_len / 1024, pages_max_per_user, printed = 0;
 
 	switch (err) {
 	case EPERM:
 		sysctl__read_int("kernel/perf_event_mlock_kb", &pages_max_per_user);
-		scnprintf(buf, size, "Error:\t%s.\n"
+		printed += scnprintf(buf + printed, size - printed,
+				     "Error:\t%s.\n"
 				     "Hint:\tCheck /proc/sys/kernel/perf_event_mlock_kb (%d kB) setting.\n"
-				     "Hint:\tTried using %zd kB.\n"
-				     "Hint:\tTry using a smaller -m/--mmap-pages value.",
+				     "Hint:\tTried using %zd kB.\n",
 				     emsg, pages_max_per_user, pages_attempted);
+
+		if (pages_attempted >= pages_max_per_user) {
+			printed += scnprintf(buf + printed, size - printed,
+					     "Hint:\tTry 'sudo sh -c \"echo %d > /proc/sys/kernel/perf_event_mlock_kb\"', or\n",
+					     pages_max_per_user + pages_attempted);
+		}
+
+		printed += scnprintf(buf + printed, size - printed,
+				     "Hint:\tTry using a smaller -m/--mmap-pages value.");
 		break;
 	default:
 		scnprintf(buf, size, "%s", emsg);
-- 
1.9.3

