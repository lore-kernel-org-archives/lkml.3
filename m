Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbaAJPVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:21:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:10368 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751738AbaAJPVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:21:03 -0500
Message-Id: <20140110152100.485765227@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 Jan 2014 10:20:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [for-next][PATCH 3/5] tracing: Fix counter for traceon/off event triggers
References: <20140110152004.200225053@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Fix-counter-for-traceon-off-event-triggers.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The counters for the traceon and traceoff are only suppose to decrement
when the trigger enables or disables tracing. It is not suppose to decrement
every time the event is hit.

Only decrement the counter if the trigger actually did something.

Link: http://lkml.kernel.org/r/20140106223124.0e5fd0b4@gandalf.local.home

Acked-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_trigger.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index f6dd115..a53e0da 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -742,13 +742,16 @@ traceon_trigger(struct event_trigger_data *data)
 static void
 traceon_count_trigger(struct event_trigger_data *data)
 {
+	if (tracing_is_on())
+		return;
+
 	if (!data->count)
 		return;
 
 	if (data->count != -1)
 		(data->count)--;
 
-	traceon_trigger(data);
+	tracing_on();
 }
 
 static void
@@ -763,13 +766,16 @@ traceoff_trigger(struct event_trigger_data *data)
 static void
 traceoff_count_trigger(struct event_trigger_data *data)
 {
+	if (!tracing_is_on())
+		return;
+
 	if (!data->count)
 		return;
 
 	if (data->count != -1)
 		(data->count)--;
 
-	traceoff_trigger(data);
+	tracing_off();
 }
 
 static int
-- 
1.8.4.3


