Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab3CULbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:31:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56643 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3CULbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:31:19 -0400
Date: Thu, 21 Mar 2013 04:30:06 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-ed8996a6d59b9eb00a50d7d30887ba9f28eb4bb0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1363151248-16674-5-git-send-email-dsahern@gmail.com>
References: <1363151248-16674-5-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine:
  Move machine__remove_thread and make static
Git-Commit-ID: ed8996a6d59b9eb00a50d7d30887ba9f28eb4bb0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:30:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed8996a6d59b9eb00a50d7d30887ba9f28eb4bb0
Gitweb:     http://git.kernel.org/tip/ed8996a6d59b9eb00a50d7d30887ba9f28eb4bb0
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 12 Mar 2013 23:07:28 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:08 -0300

perf machine: Move machine__remove_thread and make static

As the now only user, machine__process_exit_event, that is what tools
use to process PERF_RECORD_EXIT events, is on the same object file.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1363151248-16674-5-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 22 +++++++++++-----------
 tools/perf/util/machine.h |  1 -
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
 
