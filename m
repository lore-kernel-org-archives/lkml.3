Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab3KSUmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:42:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48609 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3KSUmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:42:04 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/5] perf tools: Tag thread comm as overriden
Date: Tue, 19 Nov 2013 17:41:54 -0300
Message-Id: <1384893718-18762-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384893718-18762-1-git-send-email-acme@infradead.org>
References: <1384893718-18762-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

The problem is that when a thread overrides its default ":%pid" comm, we
forget to tag the thread comm as overriden. Hence, this overriden comm
is not inherited on future forks. Fix it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131116010207.GA18855@localhost.localdomain
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index cd8e2f592719..49eaf1d7d89d 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -70,14 +70,13 @@ int thread__set_comm(struct thread *thread, const char *str, u64 timestamp)
 	/* Override latest entry if it had no specific time coverage */
 	if (!curr->start) {
 		comm__override(curr, str, timestamp);
-		return 0;
+	} else {
+		new = comm__new(str, timestamp);
+		if (!new)
+			return -ENOMEM;
+		list_add(&new->list, &thread->comm_list);
 	}
 
-	new = comm__new(str, timestamp);
-	if (!new)
-		return -ENOMEM;
-
-	list_add(&new->list, &thread->comm_list);
 	thread->comm_set = true;
 
 	return 0;
-- 
1.8.1.4

