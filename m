Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaIIVtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:49:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41161 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaIIVtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:49:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] trace/trace_stat: fix a race condition in register_stat_tracer
Date: Tue,  9 Sep 2014 22:49:35 +0100
Message-Id: <1410299375-20068-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A race condition exits (at least theoretically) if a tracer_stat
registration is interrupted after verifying it hasn't been registered yet
but before being added to the all_stat_sessions list.

This patch fixes this race by making both operations atomic (protected by
the all_stat_sessions_mutex mutex).

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace_stat.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 7af67360b330..cb70ac12cfe4 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -310,16 +310,6 @@ int register_stat_tracer(struct tracer_stat *trace)
 	if (!trace->stat_start || !trace->stat_next || !trace->stat_show)
 		return -EINVAL;
 
-	/* Already registered? */
-	mutex_lock(&all_stat_sessions_mutex);
-	list_for_each_entry(node, &all_stat_sessions, session_list) {
-		if (node->ts == trace) {
-			mutex_unlock(&all_stat_sessions_mutex);
-			return -EINVAL;
-		}
-	}
-	mutex_unlock(&all_stat_sessions_mutex);
-
 	/* Init the session */
 	session = kzalloc(sizeof(*session), GFP_KERNEL);
 	if (!session)
@@ -337,10 +327,21 @@ int register_stat_tracer(struct tracer_stat *trace)
 
 	/* Register */
 	mutex_lock(&all_stat_sessions_mutex);
+	/* Already registered? */
+	list_for_each_entry(node, &all_stat_sessions, session_list) {
+		if (node->ts == trace) {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
 	list_add_tail(&session->session_list, &all_stat_sessions);
+
+out:
 	mutex_unlock(&all_stat_sessions_mutex);
+	if (ret)
+		destroy_session(session);
 
-	return 0;
+	return ret;
 }
 
 void unregister_stat_tracer(struct tracer_stat *trace)
-- 
1.9.1

