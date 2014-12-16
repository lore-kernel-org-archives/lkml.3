Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaLPQ6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:58:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:46810 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbaLPQ55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:57:57 -0500
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
Subject: [PATCH 05/18] perf evlist: Do not use hard coded value for a mmap_pages default
Date: Tue, 16 Dec 2014 13:57:07 -0300
Message-Id: <1418749040-31807-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418749040-31807-1-git-send-email-acme@kernel.org>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So far what is in there by default is what we were using: 512KB + the
control page, but the admin may change that, and if it does to a smaller
value, all calls to tooling for non root users start failing, requiring
that the user manually set --mmap_pages/-m.

Use instead what is in /proc/sys/kernel/perf_event_mlock_kb.

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
Link: http://lkml.kernel.org/n/tip-2f6mtm8xu3wo5lhkql6jdblh@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7847f3885081..ac808680e61c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -893,10 +893,22 @@ out_unmap:
 
 static size_t perf_evlist__mmap_size(unsigned long pages)
 {
-	/* 512 kiB: default amount of unprivileged mlocked memory */
-	if (pages == UINT_MAX)
-		pages = (512 * 1024) / page_size;
-	else if (!is_power_of_2(pages))
+	if (pages == UINT_MAX) {
+		int max;
+
+		if (sysctl__read_int("kernel/perf_event_mlock_kb", &max) < 0) {
+			/*
+			 * Pick a once upon a time good value, i.e. things look
+			 * strange since we can't read a sysctl value, but lets not
+			 * die yet...
+			 */
+			max = 512;
+		} else {
+			max -= (page_size / 1024);
+		}
+
+		pages = (max * 1024) / page_size;
+	} else if (!is_power_of_2(pages))
 		return 0;
 
 	return (pages + 1) * page_size;
-- 
1.9.3

