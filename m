Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab3LECmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:42:49 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:35493 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab3LECl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:41:56 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/4] perf trace: Fix summary percentage when processing files
Date: Wed,  4 Dec 2013 19:41:41 -0700
Message-Id: <1386211302-31303-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1386211302-31303-1-git-send-email-dsahern@gmail.com>
References: <1386211302-31303-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/builtin-trace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8f47eaae2f34..0203324fe585 100644
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
1.8.3.4 (Apple Git-47)

