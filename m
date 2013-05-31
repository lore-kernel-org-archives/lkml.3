Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab3EaLd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:33:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56690 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab3EaLdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:33:50 -0400
Date: Fri, 31 May 2013 04:33:11 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-804f7ac78803ed095bb0402d540f859ecb1be9f1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org, efault@gmx.de,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1367864663-1309-1-git-send-email-dsahern@gmail.com>
References: <1367864663-1309-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: handle death by SIGTERM
Git-Commit-ID: 804f7ac78803ed095bb0402d540f859ecb1be9f1
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

Commit-ID:  804f7ac78803ed095bb0402d540f859ecb1be9f1
Gitweb:     http://git.kernel.org/tip/804f7ac78803ed095bb0402d540f859ecb1be9f1
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 6 May 2013 12:24:23 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:58 +0300

perf record: handle death by SIGTERM

Perf data files cannot be processed until the header is updated which is
done via an on_exit handler.

If perf is killed due to a SIGTERM it does not run the on_exit hooks
leaving the perf.data file in a random state which perf-report will
happily spin on trying to read.

As noted by Mike an easy reproducer is:

perf record -a -g & sleep 1; killall perf

Fix by catching SIGTERM like it does SIGINT.

Also need to remove the kill which was added via commit f7b7c26e.

Acked-by: Stephane Eranian <eranian@google.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1367864663-1309-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index cdf58ec..fff985c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -198,7 +198,6 @@ static void perf_record__sig_exit(int exit_status __maybe_unused, void *arg)
 		return;
 
 	signal(signr, SIG_DFL);
-	kill(getpid(), signr);
 }
 
 static bool perf_evlist__equal(struct perf_evlist *evlist,
@@ -404,6 +403,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
+	signal(SIGTERM, sig_handler);
 
 	if (!output_name) {
 		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
