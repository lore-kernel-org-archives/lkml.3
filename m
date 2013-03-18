Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3CRQZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:25:57 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49321
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395Ab3CRQZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 36/54] perf machine: Move machine__remove_thread and make static
Date: Mon, 18 Mar 2013 13:25:21 -0300
Message-Id: <1363623939-10748-37-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

As the now only user, machine__process_exit_event, that is what tools
use to process PERF_RECORD_EXIT events, is on the same object file.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1363151248-16674-5-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.7.1

