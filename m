Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab3EZA0q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 20:26:46 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62876 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479Ab3EZA0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 20:26:43 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@kernel.org, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 07/16] perf kvm: split out tracepoints from record args
Date: Sat, 25 May 2013 18:24:47 -0600
Message-Id: <1369527896-3650-8-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
References: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed by kvm live command. Make record_args a local while we are
messing with the args.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
---
 tools/perf/builtin-kvm.c |   30 +++++++++++++++++++-----------
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
1.7.10.1

