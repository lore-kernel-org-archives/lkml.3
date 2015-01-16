Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbbAPVZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 16:25:05 -0500
Received: from mail.kernel.org ([198.145.29.136]:54163 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756443AbbAPVXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 16:23:02 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/10] perf machine: Fix __machine__findnew_thread() error path
Date: Fri, 16 Jan 2015 18:22:35 -0300
Message-Id: <1421443362-10709-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421443362-10709-1-git-send-email-acme@kernel.org>
References: <1421443362-10709-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When thread__init_map_groups() fails, a new thread should be removed
from the rbtree since it's gonna be freed.  Also update last match cache
only if the function succeeded.

Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1420763892-15535-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 94de3e48b490..1bca3a9f2b16 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -389,7 +389,6 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 	if (th != NULL) {
 		rb_link_node(&th->rb_node, parent, p);
 		rb_insert_color(&th->rb_node, &machine->threads);
-		machine->last_match = th;
 
 		/*
 		 * We have to initialize map_groups separately
@@ -400,9 +399,12 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 		 * leader and that would screwed the rb tree.
 		 */
 		if (thread__init_map_groups(th, machine)) {
+			rb_erase(&th->rb_node, &machine->threads);
 			thread__delete(th);
 			return NULL;
 		}
+
+		machine->last_match = th;
 	}
 
 	return th;
-- 
1.9.3

