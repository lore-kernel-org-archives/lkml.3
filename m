Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3AaK6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:58:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36280 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab3AaK6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:58:22 -0500
Date: Thu, 31 Jan 2013 02:57:56 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-43f8e76e6b96eb1327cff62ac1cc733a51f31068@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <1359078284-32080-1-git-send-email-namhyung@kernel.org>
References: <1359078284-32080-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Fix memory leaks on evsel->counts
Git-Commit-ID: 43f8e76e6b96eb1327cff62ac1cc733a51f31068
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 02:58:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  43f8e76e6b96eb1327cff62ac1cc733a51f31068
Gitweb:     http://git.kernel.org/tip/43f8e76e6b96eb1327cff62ac1cc733a51f31068
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 25 Jan 2013 10:44:44 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 Jan 2013 10:37:04 -0300

perf evsel: Fix memory leaks on evsel->counts

The ->counts field was never freed in the current code.  Add
perf_evsel__free_counts() function to free it properly.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1359078284-32080-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c                | 1 +
 tools/perf/tests/open-syscall-all-cpus.c | 1 +
 tools/perf/util/evsel.c                  | 5 +++++
 tools/perf/util/evsel.h                  | 1 +
 4 files changed, 8 insertions(+)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 493043a..0368a10 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1372,6 +1372,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 out_free_fd:
 	list_for_each_entry(pos, &evsel_list->entries, node) {
 		perf_evsel__free_stat_priv(pos);
+		perf_evsel__free_counts(pos);
 		perf_evsel__free_prev_raw_counts(pos);
 	}
 	perf_evlist__delete_maps(evsel_list);
diff --git a/tools/perf/tests/open-syscall-all-cpus.c b/tools/perf/tests/open-syscall-all-cpus.c
index 9b920a0..b0657a9 100644
--- a/tools/perf/tests/open-syscall-all-cpus.c
+++ b/tools/perf/tests/open-syscall-all-cpus.c
@@ -98,6 +98,7 @@ int test__open_syscall_event_on_all_cpus(void)
 		}
 	}
 
+	perf_evsel__free_counts(evsel);
 out_close_fd:
 	perf_evsel__close_fd(evsel, 1, threads->nr);
 out_evsel_delete:
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index dbdcca4..baa26dd 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -640,6 +640,11 @@ void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 		}
 }
 
+void perf_evsel__free_counts(struct perf_evsel *evsel)
+{
+	free(evsel->counts);
+}
+
 void perf_evsel__exit(struct perf_evsel *evsel)
 {
 	assert(list_empty(&evsel->node));
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3a4cd60..cbf4232 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -117,6 +117,7 @@ int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
 void perf_evsel__free_fd(struct perf_evsel *evsel);
 void perf_evsel__free_id(struct perf_evsel *evsel);
+void perf_evsel__free_counts(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 void __perf_evsel__set_sample_bit(struct perf_evsel *evsel,
