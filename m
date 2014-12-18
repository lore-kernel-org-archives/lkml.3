Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaLRG3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:29:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58568 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaLRG3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:29:23 -0500
Date: Wed, 17 Dec 2014 22:28:41 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-yqdie3c8qvdgenwleri267d4@git.kernel.org>
Cc: hpa@zytor.com, paulus@samba.org, jolsa@redhat.com, tglx@linutronix.de,
        peterz@infradead.org, bp@suse.de, mingo@kernel.org, eranian@google.com,
        dsahern@gmail.com, namhyung@kernel.org, acme@redhat.com,
        adrian.hunter@intel.com, efault@gmx.de, linux-kernel@vger.kernel.org,
        dzickus@redhat.com, fweisbec@gmail.com
Reply-To: mingo@kernel.org, paulus@samba.org, hpa@zytor.com, jolsa@redhat.com,
        peterz@infradead.org, bp@suse.de, tglx@linutronix.de,
        fweisbec@gmail.com, dsahern@gmail.com, eranian@google.com,
        adrian.hunter@intel.com, acme@redhat.com, namhyung@kernel.org,
        efault@gmx.de, dzickus@redhat.com, linux-kernel@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist: Improve the strerror_mmap method
Git-Commit-ID: e965bea1ad1a8062b306f7fcc5c3e05dc5213b7c
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

Commit-ID:  e965bea1ad1a8062b306f7fcc5c3e05dc5213b7c
Gitweb:     http://git.kernel.org/tip/e965bea1ad1a8062b306f7fcc5c3e05dc5213b7c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 12 Dec 2014 16:25:33 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 16 Dec 2014 13:38:26 -0300

perf evlist: Improve the strerror_mmap method

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
index d661f25..7847f38 100644
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
