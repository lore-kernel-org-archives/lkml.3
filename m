Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028Ab3LJTob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:44:31 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:35723 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab3LJToa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:44:30 -0500
Date: Tue, 10 Dec 2013 14:44:52 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Namhyung Kim <namhyung@kernel.org>
cc: linux-kernel@vger.kernel.org, Chad Paradis <chad.paradis@umit.maine.edu>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [patch v2] perf tools: perf list broken on ARM
Message-ID: <alpine.DEB.2.10.1312101439590.7745@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

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

On ARM machines pre-dating the Cortex-A15 this doesn't work, as
these machines don't support .exclude_kernel.  So starting with 3.12
"perf list" does not report any hardware events at all on older
machines (seen on Rasp-Pi, Pandaboard, Beagleboard, etc).

This version of the patch makes changes suggested by Namhyung Kim 
to check for EACCESS and retry (instead of just dropping
the exclude_kernel) so we can properly handle machines where 
/proc/sys/kernel/perf_event_paranoid is set to 2.


Reported-by: Chad Paradis <chad.paradis@umit.maine.edu>
Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 6de6f89..07b6e2d 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1082,12 +1082,12 @@ int is_valid_tracepoint(const char *event_string)
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
@@ -1099,8 +1099,24 @@ static bool is_event_supported(u8 type, unsigned config)
 
 	evsel = perf_evsel__new(&attr);
 	if (evsel) {
-		ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
+		open_return = perf_evsel__open(evsel, NULL, &tmap.map);
+		ret = open_return >= 0;
 		perf_evsel__delete(evsel);
+
+		if (open_return == -EACCES) {
+			/*
+			 * This happens if the paranoid value
+			 * /proc/sys/kernel/perf_event_paranoid is set to 2
+			 * Re-run with exclude_kernel set; we don't do that
+			 * by default as some ARM machines do not support it.
+			 *
+			 */
+			attr.exclude_kernel = 1;
+			evsel = perf_evsel__new(&attr);
+
+			ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
+			perf_evsel__delete(evsel);
+		}
 	}
 
 	return ret;
