Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965775AbaLLIUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:20:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43273 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965701AbaLLIUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:20:23 -0500
Date: Fri, 12 Dec 2014 00:19:41 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-pt2u7a3b50oddggecx7rwq2n@git.kernel.org>
Cc: tglx@linutronix.de, peterz@infradead.org, bp@suse.de, jolsa@redhat.com,
        namhyung@kernel.org, hpa@zytor.com, fweisbec@gmail.com,
        acme@redhat.com, mingo@kernel.org, eranian@google.com,
        adrian.hunter@intel.com, efault@gmx.de, dsahern@gmail.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, dzickus@redhat.com
Reply-To: tglx@linutronix.de, peterz@infradead.org, bp@suse.de,
        jolsa@redhat.com, namhyung@kernel.org, hpa@zytor.com,
        fweisbec@gmail.com, acme@redhat.com, mingo@kernel.org,
        eranian@google.com, adrian.hunter@intel.com, dsahern@gmail.com,
        efault@gmx.de, paulus@samba.org, linux-kernel@vger.kernel.org,
        dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Use sysctl__read_int instead of ad-hoc copies
Git-Commit-ID: ce27309f67c347e6e49ebd45042f5362b0ccbdcc
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

Commit-ID:  ce27309f67c347e6e49ebd45042f5362b0ccbdcc
Gitweb:     http://git.kernel.org/tip/ce27309f67c347e6e49ebd45042f5362b0ccbdcc
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 11 Dec 2014 13:37:59 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 11 Dec 2014 17:53:04 -0300

perf tools: Use sysctl__read_int instead of ad-hoc copies

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
index cf69325..8acd0df 100644
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
index 41125e5..b86744f 100644
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
