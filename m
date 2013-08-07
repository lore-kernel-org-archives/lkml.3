Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab3HGVNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:13:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47112 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422Ab3HGVLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/47] perf kvm: Split out tracepoints from record args
Date: Wed,  7 Aug 2013 18:10:46 -0300
Message-Id: <1375909874-22073-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Needed by kvm live command. Make record_args a local while we are
messing with the args.

Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1375473947-64285-5-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 24b78ae..7d14a3a 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -801,16 +801,11 @@ exit:
 	return ret;
 }
 
-static const char * const record_args[] = {
-	"record",
-	"-R",
-	"-f",
-	"-m", "1024",
-	"-c", "1",
-	"-e", "kvm:kvm_entry",
-	"-e", "kvm:kvm_exit",
-	"-e", "kvm:kvm_mmio",
-	"-e", "kvm:kvm_pio",
+static const char * const kvm_events_tp[] = {
+	"kvm:kvm_entry",
+	"kvm:kvm_exit",
+	"kvm:kvm_mmio",
+	"kvm:kvm_pio",
 };
 
 #define STRDUP_FAIL_EXIT(s)		\
@@ -826,8 +821,16 @@ kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
+	const char * const record_args[] = {
+		"record",
+		"-R",
+		"-f",
+		"-m", "1024",
+		"-c", "1",
+	};
 
-	rec_argc = ARRAY_SIZE(record_args) + argc + 2;
+	rec_argc = ARRAY_SIZE(record_args) + argc + 2 +
+		   2 * ARRAY_SIZE(kvm_events_tp);
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
 	if (rec_argv == NULL)
@@ -836,6 +839,11 @@ kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
 		rec_argv[i] = STRDUP_FAIL_EXIT(record_args[i]);
 
+	for (j = 0; j < ARRAY_SIZE(kvm_events_tp); j++) {
+		rec_argv[i++] = "-e";
+		rec_argv[i++] = STRDUP_FAIL_EXIT(kvm_events_tp[j]);
+	}
+
 	rec_argv[i++] = STRDUP_FAIL_EXIT("-o");
 	rec_argv[i++] = STRDUP_FAIL_EXIT(kvm->file_name);
 
-- 
1.8.1.4

