Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab3EZA1G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 20:27:06 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44359 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758748Ab3EZA1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 20:27:03 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@kernel.org, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        Runzhen Wang <icycoder@gmail.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 14/16] perf kvm: reuse some code of perf_kvm__timerfd_create()
Date: Sat, 25 May 2013 18:24:54 -0600
Message-Id: <1369527896-3650-15-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
References: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Runzhen Wang <icycoder@gmail.com>

Create a new function perf_kvm__timerfd_set() to reuse some code
in perf_kvm__timerfd_create()

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
 tools/perf/builtin-kvm.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 76cfe59..7392538 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -940,16 +940,9 @@ static void sig_handler(int sig __maybe_unused)
 	done = 1;
 }
 
-static int perf_kvm__timerfd_create(struct perf_kvm_stat *kvm)
+static int perf_kvm__timerfd_set(struct perf_kvm_stat *kvm)
 {
 	struct itimerspec new_value;
-	int rc = -1;
-
-	kvm->timerfd = timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK);
-	if (kvm->timerfd < 0) {
-		pr_err("timerfd_create failed\n");
-		goto out;
-	}
 
 	new_value.it_value.tv_sec = kvm->display_time;
 	new_value.it_value.tv_nsec = 0;
@@ -959,12 +952,20 @@ static int perf_kvm__timerfd_create(struct perf_kvm_stat *kvm)
 	if (timerfd_settime(kvm->timerfd, 0, &new_value, NULL) != 0) {
 		pr_err("timerfd_settime failed: %d\n", errno);
 		close(kvm->timerfd);
-		goto out;
+		return -1;
 	}
 
-	rc = 0;
-out:
-	return rc;
+	return 0;
+}
+
+static int perf_kvm__timerfd_create(struct perf_kvm_stat *kvm)
+{
+	kvm->timerfd = timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK);
+	if (kvm->timerfd < 0) {
+		pr_err("timerfd_create failed\n");
+		return -1;
+	}
+	return perf_kvm__timerfd_set(kvm);
 }
 
 static int perf_kvm__handle_timerfd(struct perf_kvm_stat *kvm)
-- 
1.7.10.1

