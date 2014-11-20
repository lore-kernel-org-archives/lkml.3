Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbaKTHlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:41:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43922 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049AbaKTHk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:40:59 -0500
Date: Wed, 19 Nov 2014 23:40:31 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-a84808083688d82d7f1e5786ccf5df0ff7d448cb@git.kernel.org>
Cc: mingo@kernel.org, acme@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, jolsa@redhat.com, tglx@linutronix.de,
        eranian@google.com, paulus@samba.org, hpa@zytor.com,
        namhyung@gmail.com
Reply-To: hpa@zytor.com, namhyung@gmail.com, tglx@linutronix.de,
        jolsa@redhat.com, paulus@samba.org, eranian@google.com,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, mingo@kernel.org, acme@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com
In-Reply-To: <1415715423-15563-4-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-4-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Only override the default :
 tid comm entry
Git-Commit-ID: a84808083688d82d7f1e5786ccf5df0ff7d448cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a84808083688d82d7f1e5786ccf5df0ff7d448cb
Gitweb:     http://git.kernel.org/tip/a84808083688d82d7f1e5786ccf5df0ff7d448cb
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 11 Nov 2014 16:16:41 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 19 Nov 2014 12:37:26 -0300

perf tools: Only override the default :tid comm entry

Events may still be ordered even if there are no timestamps e.g. if the
data is recorded per-thread.

Also synthesized COMM events have a timestamp of zero.

Consequently it is better to keep comm entries even if they have a
timestamp of zero.

However, when a struct thread is created the command string is not known
and a comm entry with a string of the form ":<tid>" is used.

In that case thread->comm_set is false and the comm entry should be
overridden.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1415715423-15563-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index a2157f0..9ebc8b1 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -103,15 +103,14 @@ struct comm *thread__exec_comm(const struct thread *thread)
 	return last;
 }
 
-/* CHECKME: time should always be 0 if event aren't ordered */
 int __thread__set_comm(struct thread *thread, const char *str, u64 timestamp,
 		       bool exec)
 {
 	struct comm *new, *curr = thread__comm(thread);
 	int err;
 
-	/* Override latest entry if it had no specific time coverage */
-	if (!curr->start && !curr->exec) {
+	/* Override the default :tid entry */
+	if (!thread->comm_set) {
 		err = comm__override(curr, str, timestamp, exec);
 		if (err)
 			return err;
