Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3KKUXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:23:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43959 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3KKUWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:22:53 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/10] perf tests: Use lower sample_freq in sw clock event period test
Date: Mon, 11 Nov 2013 17:22:33 -0300
Message-Id: <1384201353-23863-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384201353-23863-1-git-send-email-acme@infradead.org>
References: <1384201353-23863-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We were using it at 10 kHz, which doesn't work in machines where somehow
the max freq was auto reduced by the kernel:

[root@ssdandy ~]# perf test 19
19: Test software clock events have valid period values    : FAILED!
[root@ssdandy ~]# perf test -v 19
19: Test software clock events have valid period values    :
--- start ---
Couldn't open evlist: Invalid argument
---- end ----
Test software clock events have valid period values: FAILED!
[root@ssdandy ~]#

[root@ssdandy ~]# cat /proc/sys/kernel/perf_event_max_sample_rate
7000

Reducing it to 500 Hz should be good enough for this test and also
shouldn't affect what it is testing.

But warn the user if it fails, informing the knob and the freq tried.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-548rhj1uo6xbwnxa95kw3hqe@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/sw-clock.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
index ed777728dfe7..93a7139ff5f7 100644
--- a/tools/perf/tests/sw-clock.c
+++ b/tools/perf/tests/sw-clock.c
@@ -34,7 +34,7 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 		.freq = 1,
 	};
 
-	attr.sample_freq = 10000;
+	attr.sample_freq = 500;
 
 	evlist = perf_evlist__new();
 	if (evlist == NULL) {
@@ -58,8 +58,11 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 	}
 
 	if (perf_evlist__open(evlist)) {
+		const char *knob = "/proc/sys/kernel/perf_event_max_sample_rate";
+
 		err = -errno;
-		pr_debug("Couldn't open evlist: %s\n", strerror(errno));
+		pr_debug("Couldn't open evlist: %s\nHint: check %s, using %" PRIu64 " in this test.\n",
+			 strerror(errno), knob, (u64)attr.sample_freq);
 		goto out_delete_maps;
 	}
 
-- 
1.8.1.4

