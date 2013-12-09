Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761838Ab3LIV6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:58:16 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:49569 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761697Ab3LIV6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:58:10 -0500
Date: Mon, 9 Dec 2013 16:58:35 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Namhyung Kim <namhyung@kernel.org>
cc: linux-kernel@vger.kernel.org, Chad Paradis <chad.paradis@umit.maine.edu>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [patch] perf tools: perf list broken on ARM
Message-ID: <alpine.DEB.2.10.1312091646100.2337@vincent-weaver-1.um.maine.edu>
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

If we drop the "exclude_kernel" attribute events are properly reported.

Reported-by: Chad Paradis <chad.paradis@umit.maine.edu>
Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 6de6f89..360ecab 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1087,7 +1087,6 @@ static bool is_event_supported(u8 type, unsigned config)
 		.type = type,
 		.config = config,
 		.disabled = 1,
-		.exclude_kernel = 1,
 	};
 	struct {
 		struct thread_map map;
