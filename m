Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaAOBpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:45:51 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43403 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaAOBpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:45:47 -0500
X-AuditID: 9c930197-b7b7cae000000e34-5f-52d5e846b70b
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 09/17] tools lib traceevent: Unregister handler when hrtimer plugin unloaded
Date: Wed, 15 Jan 2014 10:45:32 +0900
Message-Id: <1389750340-15965-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timer handlers should be unregistered when the plugin unloaded
otherwise they'll try to access invalid memory.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/plugin_hrtimer.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/lib/traceevent/plugin_hrtimer.c b/tools/lib/traceevent/plugin_hrtimer.c
index 0b0ebf30aa44..12bf14cc1152 100644
--- a/tools/lib/traceevent/plugin_hrtimer.c
+++ b/tools/lib/traceevent/plugin_hrtimer.c
@@ -76,3 +76,13 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 				      timer_start_handler, NULL);
 	return 0;
 }
+
+void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+{
+	pevent_unregister_event_handler(pevent, -1,
+					"timer", "hrtimer_expire_entry",
+					timer_expire_handler, NULL);
+
+	pevent_unregister_event_handler(pevent, -1, "timer", "hrtimer_start",
+					timer_start_handler, NULL);
+}
-- 
1.7.11.7

