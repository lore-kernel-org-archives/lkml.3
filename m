Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125Ab3LIThS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:37:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54886 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3LIThQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:37:16 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/21] perf trace: Fix summary percentage when processing files
Date: Mon,  9 Dec 2013 16:36:51 -0300
Message-Id: <1386617830-18926-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Getting a divide by 0 when events are processed from a file:

   perf trace -i perf.data -s
   ...
   dnsmasq (1684), 10 events, inf%, 0.000 msec

The problem is that the event count is not incremented as events are
processed. With this patch:

   perf trace -i perf.data -s
   ...
   dnsmasq (1684), 10 events, 8.9%, 0.000 msec

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1386211302-31303-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index a7aa771a98e6..56bbca5bc2dc 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1770,8 +1770,10 @@ static int trace__process_sample(struct perf_tool *tool,
 	if (!trace->full_time && trace->base_time == 0)
 		trace->base_time = sample->time;
 
-	if (handler)
+	if (handler) {
+		++trace->nr_events;
 		handler(trace, evsel, sample);
+	}
 
 	return err;
 }
-- 
1.8.1.4

