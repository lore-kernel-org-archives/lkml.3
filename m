Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521AbaLKV1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:27:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:44532 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965482AbaLKV1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:27:34 -0500
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
Subject: [PATCH 16/18] perf tools: Use sysctl__read_int instead of ad-hoc copies
Date: Thu, 11 Dec 2014 18:26:04 -0300
Message-Id: <1418333166-15429-17-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418333166-15429-1-git-send-email-acme@kernel.org>
References: <1418333166-15429-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
Link: http://lkml.kernel.org/n/tip-pt2u7a3b50oddggecx7rwq2n@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/record.c | 11 +----------
 tools/perf/util/util.c   |  9 +--------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index cf69325b985f..8acd0df88b5c 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -137,16 +137,7 @@ void perf_evlist__config(struct perf_evlist *evlist, struct record_opts *opts)
 
 static int get_max_rate(unsigned int *rate)
 {
-	char path[PATH_MAX];
-	const char *procfs = procfs__mountpoint();
-
-	if (!procfs)
-		return -1;
-
-	snprintf(path, PATH_MAX,
-		 "%s/sys/kernel/perf_event_max_sample_rate", procfs);
-
-	return filename__read_int(path, (int *) rate);
+	return sysctl__read_int("kernel/perf_event_max_sample_rate", (int *)rate);
 }
 
 static int record_opts__config_freq(struct record_opts *opts)
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 41125e5b011e..b86744f29eef 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -506,16 +506,9 @@ const char *get_filename_for_perf_kvm(void)
 
 int perf_event_paranoid(void)
 {
-	char path[PATH_MAX];
-	const char *procfs = procfs__mountpoint();
 	int value;
 
-	if (!procfs)
-		return INT_MAX;
-
-	scnprintf(path, PATH_MAX, "%s/sys/kernel/perf_event_paranoid", procfs);
-
-	if (filename__read_int(path, &value))
+	if (sysctl__read_int("kernel/perf_event_paranoid", &value))
 		return INT_MAX;
 
 	return value;
-- 
1.9.3

