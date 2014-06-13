Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaFMGZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:25:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44083 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaFMGZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:25:19 -0400
Date: Thu, 12 Jun 2014 23:24:39 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-17314e2385c6627fcab4b8f97bd6668bb63495c0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, andi@firstfloor.org, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, jolsa@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de
In-Reply-To: <1402292617-26278-1-git-send-email-namhyung@kernel.org>
References: <1402292617-26278-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Fix to honor user freq/
 interval properly
Git-Commit-ID: 17314e2385c6627fcab4b8f97bd6668bb63495c0
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

Commit-ID:  17314e2385c6627fcab4b8f97bd6668bb63495c0
Gitweb:     http://git.kernel.org/tip/17314e2385c6627fcab4b8f97bd6668bb63495c0
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 9 Jun 2014 14:43:37 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 12 Jun 2014 16:53:18 +0200

perf record: Fix to honor user freq/interval properly

When configuring event perf checked a wrong condition that user
specified both of freq (-F) and period (-c) or the event has no
default value.  This worked because most of events don't have default
value and only tracepoint events have default of 1 (and it's not
desirable to change it for those events).

However, Andi's downloadable event patch changes the situation so it
cannot change the value for those events.  Fix it by allowing override
the default value if user gives one of the options.

  $ perf record -a -e uops_retired.all -F 4000 sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.325 MB perf.data (~14185 samples) ]

  $ perf evlist -F
  cpu/uops_retired.all/: sample_freq=4000

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1402292617-26278-1-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/evsel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 21154da..8606175 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -589,10 +589,10 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	}
 
 	/*
-	 * We default some events to a 1 default interval. But keep
+	 * We default some events to have a default interval. But keep
 	 * it a weak assumption overridable by the user.
 	 */
-	if (!attr->sample_period || (opts->user_freq != UINT_MAX &&
+	if (!attr->sample_period || (opts->user_freq != UINT_MAX ||
 				     opts->user_interval != ULLONG_MAX)) {
 		if (opts->freq) {
 			perf_evsel__set_sample_bit(evsel, PERIOD);
