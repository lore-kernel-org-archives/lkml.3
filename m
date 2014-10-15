Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaJOKF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:05:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54408 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaJOKFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:05:19 -0400
Date: Wed, 15 Oct 2014 03:04:30 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-8av26cz8uxmbnihl5mmrygp9@git.kernel.org>
Cc: adrian.hunter@intel.com, acme@redhat.com, eranian@google.com,
        mingo@kernel.org, efault@gmx.de, hpa@zytor.com, peterz@infradead.org,
        paulus@samba.org, jolsa@redhat.com, tglx@linutronix.de,
        namhyung@kernel.org, dzickus@redhat.com, bp@suse.de,
        jean.pihet@linaro.org, linux-kernel@vger.kernel.org, dsahern@gmail.com,
        fweisbec@gmail.com
Reply-To: peterz@infradead.org, paulus@samba.org, mingo@kernel.org,
        hpa@zytor.com, efault@gmx.de, acme@redhat.com, eranian@google.com,
        adrian.hunter@intel.com, dsahern@gmail.com, fweisbec@gmail.com,
        jean.pihet@linaro.org, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, dzickus@redhat.com, bp@suse.de, jolsa@redhat.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf thread_map:
  Create dummy constructor out of open coded equivalent
Git-Commit-ID: 641556c98c821922a9a2121247b5fa25e4407d11
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

Commit-ID:  641556c98c821922a9a2121247b5fa25e4407d11
Gitweb:     http://git.kernel.org/tip/641556c98c821922a9a2121247b5fa25e4407d11
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 10 Oct 2014 12:03:46 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Oct 2014 17:32:52 -0300

perf thread_map: Create dummy constructor out of open coded equivalent

Create a dummy thread_map, one that has just one entry and it is -1,
meaning 'all threads', as this ends up going down to perf_event_open().

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8av26cz8uxmbnihl5mmrygp9@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread_map.c | 21 +++++++++++++--------
 tools/perf/util/thread_map.h |  1 +
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index 5d32159..f93b973 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -214,6 +214,17 @@ out_free_threads:
 	goto out;
 }
 
+struct thread_map *thread_map__new_dummy(void)
+{
+	struct thread_map *threads = malloc(sizeof(*threads) + sizeof(pid_t));
+
+	if (threads != NULL) {
+		threads->map[0]	= -1;
+		threads->nr	= 1;
+	}
+	return threads;
+}
+
 static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
 {
 	struct thread_map *threads = NULL, *nt;
@@ -224,14 +235,8 @@ static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
 	struct strlist *slist;
 
 	/* perf-stat expects threads to be generated even if tid not given */
-	if (!tid_str) {
-		threads = malloc(sizeof(*threads) + sizeof(pid_t));
-		if (threads != NULL) {
-			threads->map[0] = -1;
-			threads->nr	= 1;
-		}
-		return threads;
-	}
+	if (!tid_str)
+		return thread_map__new_dummy();
 
 	slist = strlist__new(false, tid_str);
 	if (!slist)
diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
index 0cd8b31..95313f4 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/perf/util/thread_map.h
@@ -9,6 +9,7 @@ struct thread_map {
 	pid_t map[];
 };
 
+struct thread_map *thread_map__new_dummy(void);
 struct thread_map *thread_map__new_by_pid(pid_t pid);
 struct thread_map *thread_map__new_by_tid(pid_t tid);
 struct thread_map *thread_map__new_by_uid(uid_t uid);
