Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaAPCdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:33:38 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:46634 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaAPCbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:31:23 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-d4-52d7447818b0
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 07/12] tools lib traceevent: Unregister handler when sched_switch plugin unloaded
Date: Thu, 16 Jan 2014 11:31:13 +0900
Message-Id: <1389839478-5887-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389839478-5887-1-git-send-email-namhyung@kernel.org>
References: <1389839478-5887-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The event handlers should be unregistered when the plugin unloaded
otherwise they'll try to access invalid memory.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/plugin_sched_switch.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/lib/traceevent/plugin_sched_switch.c b/tools/lib/traceevent/plugin_sched_switch.c
index fea3724aa24f..f1ce60065258 100644
--- a/tools/lib/traceevent/plugin_sched_switch.c
+++ b/tools/lib/traceevent/plugin_sched_switch.c
@@ -146,3 +146,15 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 				      sched_wakeup_handler, NULL);
 	return 0;
 }
+
+void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+{
+	pevent_unregister_event_handler(pevent, -1, "sched", "sched_switch",
+					sched_switch_handler, NULL);
+
+	pevent_unregister_event_handler(pevent, -1, "sched", "sched_wakeup",
+					sched_wakeup_handler, NULL);
+
+	pevent_unregister_event_handler(pevent, -1, "sched", "sched_wakeup_new",
+					sched_wakeup_handler, NULL);
+}
-- 
1.7.11.7

