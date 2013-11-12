Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab3KLV5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:57:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40185 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab3KLV4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:56:33 -0500
Date: Tue, 12 Nov 2013 13:55:55 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-548rhj1uo6xbwnxa95kw3hqe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tests:
  Use lower sample_freq in sw clock event period test
Git-Commit-ID: 67c1e4a53b17894e6a24f95057cc374c4be051cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:56:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67c1e4a53b17894e6a24f95057cc374c4be051cb
Gitweb:     http://git.kernel.org/tip/67c1e4a53b17894e6a24f95057cc374c4be051cb
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 11 Nov 2013 16:33:18 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 11 Nov 2013 16:43:34 -0300

perf tests: Use lower sample_freq in sw clock event period test

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
index ed77772..93a7139 100644
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
 
