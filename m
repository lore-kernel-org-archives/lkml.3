Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab3EZA1f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 20:27:35 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38385 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758474Ab3EZA1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 20:27:04 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@kernel.org, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 15/16] perf kvm: move the prompt_integer() to /util/top.c
Date: Sat, 25 May 2013 18:24:55 -0600
Message-Id: <1369527896-3650-16-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
References: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As David suggested, this patch has no functional changes
just a code move.

move prompt_integer() from tools/perf/builtin-top.c  into
tools/perf/util/top.c

Signed-off-by: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 tools/perf/builtin-top.c |   26 --------------------------
 tools/perf/util/top.c    |   26 ++++++++++++++++++++++++++
 tools/perf/util/top.h    |    1 +
 3 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 495171a..cb7c308 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -298,32 +298,6 @@ static void perf_top__print_sym_table(struct perf_top *top)
 		       top->min_percent, stdout);
 }
 
-static void prompt_integer(int *target, const char *msg)
-{
-	char *buf = malloc(0), *p;
-	size_t dummy = 0;
-	int tmp;
-
-	fprintf(stdout, "\n%s: ", msg);
-	if (getline(&buf, &dummy, stdin) < 0)
-		return;
-
-	p = strchr(buf, '\n');
-	if (p)
-		*p = 0;
-
-	p = buf;
-	while(*p) {
-		if (!isdigit(*p))
-			goto out_free;
-		p++;
-	}
-	tmp = strtoul(buf, NULL, 10);
-	*target = tmp;
-out_free:
-	free(buf);
-}
-
 static void prompt_percent(int *target, const char *msg)
 {
 	int tmp = 0;
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index f857b51..1a2eaec 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -115,3 +115,29 @@ void perf_top__reset_sample_counters(struct perf_top *top)
 	top->exact_samples = top->guest_kernel_samples =
 	top->guest_us_samples = 0;
 }
+
+void prompt_integer(int *target, const char *msg)
+{
+	char *buf = malloc(0), *p;
+	size_t dummy = 0;
+	int tmp;
+
+	fprintf(stdout, "\n%s: ", msg);
+	if (getline(&buf, &dummy, stdin) < 0)
+		return;
+
+	p = strchr(buf, '\n');
+	if (p)
+		*p = 0;
+
+	p = buf;
+	while (*p) {
+		if (!isdigit(*p))
+			goto out_free;
+		p++;
+	}
+	tmp = strtoul(buf, NULL, 10);
+	*target = tmp;
+out_free:
+	free(buf);
+}
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index b554ffc..1538dab 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -43,4 +43,5 @@ struct perf_top {
 
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size);
 void perf_top__reset_sample_counters(struct perf_top *top);
+void prompt_integer(int *target, const char *msg);
 #endif /* __PERF_TOP_H */
-- 
1.7.10.1

