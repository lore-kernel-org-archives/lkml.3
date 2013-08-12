Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab3HLKU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:20:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47877 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272Ab3HLKUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:20:15 -0400
Date: Mon, 12 Aug 2013 03:19:37 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-8fdd84c44fd09d783caa4fb81d2d680b0cf07eeb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        runzhen@linux.vnet.ibm.com, jolsa@redhat.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, runzhen@linux.vnet.ibm.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1375473947-64285-5-git-send-email-dsahern@gmail.com>
References: <1375473947-64285-5-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Split out tracepoints from record args
Git-Commit-ID: 8fdd84c44fd09d783caa4fb81d2d680b0cf07eeb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:19:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8fdd84c44fd09d783caa4fb81d2d680b0cf07eeb
Gitweb:     http://git.kernel.org/tip/8fdd84c44fd09d783caa4fb81d2d680b0cf07eeb
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Fri, 2 Aug 2013 14:05:42 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:27 -0300

perf kvm: Split out tracepoints from record args

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
 
