Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab3GWHr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:47:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56203 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3GWHrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:47:23 -0400
Date: Tue, 23 Jul 2013 00:46:50 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-2b821cce1c950cead081d779db0dda680192c4bd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1374190079-28507-1-git-send-email-dsahern@gmail.com>
References: <1374190079-28507-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Handle ENODEV on default cycles event
Git-Commit-ID: 2b821cce1c950cead081d779db0dda680192c4bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 00:46:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b821cce1c950cead081d779db0dda680192c4bd
Gitweb:     http://git.kernel.org/tip/2b821cce1c950cead081d779db0dda680192c4bd
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Thu, 18 Jul 2013 17:27:59 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 22 Jul 2013 12:03:57 -0300

perf evsel: Handle ENODEV on default cycles event

Some systems (e.g., VMs on qemu-0.13 with the default vcpu model) report
an unsupported CPU model:

Performance Events: unsupported p6 CPU model 2 no PMU driver, software events only.

Subsequent invocations of perf fail with:

The sys_perf_event_open() syscall returned with 19 (No such device) for event (cycles).
/bin/dmesg may provide additional information.
No CONFIG_PERF_EVENTS=y kernel support configured?

Add ENODEV to the list of errno's to fallback to cpu-clock.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1374190079-28507-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a635461..8bed0c1 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1482,7 +1482,7 @@ out:
 bool perf_evsel__fallback(struct perf_evsel *evsel, int err,
 			  char *msg, size_t msgsize)
 {
-	if ((err == ENOENT || err == ENXIO) &&
+	if ((err == ENOENT || err == ENXIO || err == ENODEV) &&
 	    evsel->attr.type   == PERF_TYPE_HARDWARE &&
 	    evsel->attr.config == PERF_COUNT_HW_CPU_CYCLES) {
 		/*
