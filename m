Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab3KKUXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:23:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43947 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3KKUWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:22:50 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/10] perf tests: Check return of perf_evlist__open sw clock event period test
Date: Mon, 11 Nov 2013 17:22:32 -0300
Message-Id: <1384201353-23863-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384201353-23863-1-git-send-email-acme@infradead.org>
References: <1384201353-23863-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We were not checking if we successfully opened the counters, i.e. if
sys_perf_event_open worked, when it doesn't in this test, we were
continuing anyway and then segfaulting when trying to access the file
descriptor array, that at that point had been freed in perf_evlist__open
error path:

[root@ssdandy ~]# perf test -v 19
19: Test software clock events have valid period values    :
--- start ---
Segmentation fault (core dumped)
[root@ssdandy ~]#

Do the check and bail out instead.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6qy8ljkn0e9hm7bh7keo5z68@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/sw-clock.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
index 73c5c37cb27b..ed777728dfe7 100644
--- a/tools/perf/tests/sw-clock.c
+++ b/tools/perf/tests/sw-clock.c
@@ -57,7 +57,11 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 		goto out_delete_maps;
 	}
 
-	perf_evlist__open(evlist);
+	if (perf_evlist__open(evlist)) {
+		err = -errno;
+		pr_debug("Couldn't open evlist: %s\n", strerror(errno));
+		goto out_delete_maps;
+	}
 
 	err = perf_evlist__mmap(evlist, 128, true);
 	if (err < 0) {
-- 
1.8.1.4

