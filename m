Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934870AbaGRE2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:28:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33376 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933537AbaGRE2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:28:03 -0400
Date: Thu, 17 Jul 2014 21:27:08 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-9608b84e4dd95341b88cad646b114811f5bccbba@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1405495184-20441-2-git-send-email-adrian.hunter@intel.com>
References: <1405495184-20441-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf thread:
  Allow deletion of a thread with no map groups
Git-Commit-ID: 9608b84e4dd95341b88cad646b114811f5bccbba
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

Commit-ID:  9608b84e4dd95341b88cad646b114811f5bccbba
Gitweb:     http://git.kernel.org/tip/9608b84e4dd95341b88cad646b114811f5bccbba
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 16 Jul 2014 10:19:43 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Jul 2014 10:32:35 -0300

perf thread: Allow deletion of a thread with no map groups

It needs to be possible to call thread__delete() on a thread with no map
groups.

This is needed for a subsequent patch which deletes a thread on the
error path before map groups have been attached.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405495184-20441-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 7a32f44..b9c36ef 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -60,8 +60,10 @@ void thread__delete(struct thread *thread)
 {
 	struct comm *comm, *tmp;
 
-	map_groups__put(thread->mg);
-	thread->mg = NULL;
+	if (thread->mg) {
+		map_groups__put(thread->mg);
+		thread->mg = NULL;
+	}
 	list_for_each_entry_safe(comm, tmp, &thread->comm_list, list) {
 		list_del(&comm->list);
 		comm__free(comm);
