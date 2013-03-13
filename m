Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab3CMFHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 01:07:48 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:53961 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab3CMFHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 01:07:44 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 4/4] perf: move machine__remove_thread and make static
Date: Tue, 12 Mar 2013 23:07:28 -0600
Message-Id: <1363151248-16674-5-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1363151248-16674-1-git-send-email-dsahern@gmail.com>
References: <1363151248-16674-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/machine.c |   22 +++++++++++-----------
 tools/perf/util/machine.h |    1 -
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index efdb38e..c5e3b12 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1003,6 +1003,17 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
 	return 0;
 }
 
+static void machine__remove_thread(struct machine *machine, struct thread *th)
+{
+	machine->last_match = NULL;
+	rb_erase(&th->rb_node, &machine->threads);
+	/*
+	 * We may have references to this thread, for instance in some hist_entry
+	 * instances, so just move them to a separate list.
+	 */
+	list_add_tail(&th->node, &machine->dead_threads);
+}
+
 int machine__process_exit_event(struct machine *machine, union perf_event *event)
 {
 	struct thread *thread = machine__find_thread(machine, event->fork.tid);
@@ -1039,17 +1050,6 @@ int machine__process_event(struct machine *machine, union perf_event *event)
 	return ret;
 }
 
-void machine__remove_thread(struct machine *machine, struct thread *th)
-{
-	machine->last_match = NULL;
-	rb_erase(&th->rb_node, &machine->threads);
-	/*
-	 * We may have references to this thread, for instance in some hist_entry
-	 * instances, so just move them to a separate list.
-	 */
-	list_add_tail(&th->node, &machine->dead_threads);
-}
-
 static bool symbol__match_parent_regex(struct symbol *sym)
 {
 	if (sym->name && !regexec(&parent_regex, sym->name, 0, NULL, 0))
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 5ac5892..e0b2c00 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -97,7 +97,6 @@ static inline bool machine__is_host(struct machine *machine)
 }
 
 struct thread *machine__findnew_thread(struct machine *machine, pid_t pid);
-void machine__remove_thread(struct machine *machine, struct thread *th);
 
 size_t machine__fprintf(struct machine *machine, FILE *fp);
 
-- 
1.7.10.1

