Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbaAWREt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:04:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55617 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbaAWREr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:04:47 -0500
Date: Thu, 23 Jan 2014 09:03:57 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-8a398897ff21f73cb8b15a19514660f032926882@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1389972846-6566-2-git-send-email-eranian@google.com>
References: <1389972846-6566-2-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf stat:
  fix NULL pointer reference bug with event unit
Git-Commit-ID: 8a398897ff21f73cb8b15a19514660f032926882
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 23 Jan 2014 09:04:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a398897ff21f73cb8b15a19514660f032926882
Gitweb:     http://git.kernel.org/tip/8a398897ff21f73cb8b15a19514660f032926882
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 17 Jan 2014 16:34:05 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 20 Jan 2014 16:19:08 -0300

perf stat: fix NULL pointer reference bug with event unit

This patch fixes a problem with the handling of the newly introduced
optional event unit. The following cmdline caused a segfault:

 $ perf stat -e cpu/event-0x3c/ ls

This patch fixes the problem with the default setting for alias->unit
which was eventually causing the segfault.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389972846-6566-2-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |  2 +-
 tools/perf/util/pmu.c          | 24 ++++++++++++++++++++----
 tools/perf/util/pmu.h          |  2 +-
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a7f1b6a..d248fca 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -635,7 +635,7 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	struct perf_event_attr attr;
 	struct perf_pmu *pmu;
 	struct perf_evsel *evsel;
-	char *unit;
+	const char *unit;
 	double scale;
 
 	pmu = perf_pmu__find(name);
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index d9cab4d..b752ecb 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -105,7 +105,7 @@ static int perf_pmu__parse_scale(struct perf_pmu_alias *alias, char *dir, char *
 	char scale[128];
 	int fd, ret = -1;
 	char path[PATH_MAX];
-	char *lc;
+	const char *lc;
 
 	snprintf(path, PATH_MAX, "%s/%s.scale", dir, name);
 
@@ -609,7 +609,7 @@ static struct perf_pmu_alias *pmu_find_alias(struct perf_pmu *pmu,
 
 
 static int check_unit_scale(struct perf_pmu_alias *alias,
-			    char **unit, double *scale)
+			    const char **unit, double *scale)
 {
 	/*
 	 * Only one term in event definition can
@@ -634,14 +634,18 @@ static int check_unit_scale(struct perf_pmu_alias *alias,
  * defined for the alias
  */
 int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
-			  char **unit, double *scale)
+			  const char **unit, double *scale)
 {
 	struct parse_events_term *term, *h;
 	struct perf_pmu_alias *alias;
 	int ret;
 
+	/*
+	 * Mark unit and scale as not set
+	 * (different from default values, see below)
+	 */
 	*unit   = NULL;
-	*scale  = 0;
+	*scale  = 0.0;
 
 	list_for_each_entry_safe(term, h, head_terms, list) {
 		alias = pmu_find_alias(pmu, term);
@@ -658,6 +662,18 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 		list_del(&term->list);
 		free(term);
 	}
+
+	/*
+	 * if no unit or scale foundin aliases, then
+	 * set defaults as for evsel
+	 * unit cannot left to NULL
+	 */
+	if (*unit == NULL)
+		*unit   = "";
+
+	if (*scale == 0.0)
+		*scale  = 1.0;
+
 	return 0;
 }
 
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 9183380..8b64125 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -29,7 +29,7 @@ int perf_pmu__config_terms(struct list_head *formats,
 			   struct perf_event_attr *attr,
 			   struct list_head *head_terms);
 int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
-			  char **unit, double *scale);
+			  const char **unit, double *scale);
 struct list_head *perf_pmu__alias(struct perf_pmu *pmu,
 				  struct list_head *head_terms);
 int perf_pmu_wrap(void);
