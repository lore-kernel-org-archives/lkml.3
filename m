Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaBMVQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:16:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55908 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaBMVQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:16:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Vince Weaver <vincent.weaver@maine.edu>,
        Chad Paradis <chad.paradis@umit.maine.edu>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/5] perf list: Fix checking for supported events on older kernels
Date: Thu, 13 Feb 2014 18:15:59 -0300
Message-Id: <1392326161-30579-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392326161-30579-1-git-send-email-acme@infradead.org>
References: <1392326161-30579-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vince Weaver <vincent.weaver@maine.edu>

"perf list" listing of hardware events doesn't work on older ARM devices.
The change enabling event detection:

 commit b41f1cec91c37eeea6fdb15effbfa24ea0a5536b
 Author: Namhyung Kim <namhyung.kim@lge.com>
 Date:   Tue Aug 27 11:41:53 2013 +0900

     perf list: Skip unsupported events

uses the following code in tools/perf/util/parse-events.c:

        struct perf_event_attr attr = {
                .type = type,
                .config = config,
                .disabled = 1,
                .exclude_kernel = 1,
        };

On ARM machines pre-dating the Cortex-A15 this doesn't work, as these
machines don't support .exclude_kernel.  So starting with 3.12 "perf
list" does not report any hardware events at all on older machines (seen
on Rasp-Pi, Pandaboard, Beagleboard, etc).

This version of the patch makes changes suggested by Namhyung Kim to
check for EACCESS and retry (instead of just dropping the
exclude_kernel) so we can properly handle machines where
/proc/sys/kernel/perf_event_paranoid is set to 2.

Reported-by: Chad Paradis <chad.paradis@umit.maine.edu>
Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Chad Paradis <chad.paradis@umit.maine.edu>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1312301536150.28814@vincent-weaver-1.um.maine.edu
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d248fca6d7ed..1e15df10a88c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1091,12 +1091,12 @@ int is_valid_tracepoint(const char *event_string)
 static bool is_event_supported(u8 type, unsigned config)
 {
 	bool ret = true;
+	int open_return;
 	struct perf_evsel *evsel;
 	struct perf_event_attr attr = {
 		.type = type,
 		.config = config,
 		.disabled = 1,
-		.exclude_kernel = 1,
 	};
 	struct {
 		struct thread_map map;
@@ -1108,7 +1108,20 @@ static bool is_event_supported(u8 type, unsigned config)
 
 	evsel = perf_evsel__new(&attr);
 	if (evsel) {
-		ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
+		open_return = perf_evsel__open(evsel, NULL, &tmap.map);
+		ret = open_return >= 0;
+
+		if (open_return == -EACCES) {
+			/*
+			 * This happens if the paranoid value
+			 * /proc/sys/kernel/perf_event_paranoid is set to 2
+			 * Re-run with exclude_kernel set; we don't do that
+			 * by default as some ARM machines do not support it.
+			 *
+			 */
+			evsel->attr.exclude_kernel = 1;
+			ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
+		}
 		perf_evsel__delete(evsel);
 	}
 
-- 
1.8.1.4

