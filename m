Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbaJNVGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:06:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:45038 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbaJNVGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:06:31 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Don Zickus <dzickus@redhat.com>, Douglas Hatch <doug.hatch@hp.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH 20/24] perf machine: Add missing dsos->root rbtree root initialization
Date: Tue, 14 Oct 2014 18:04:29 -0300
Message-Id: <1413320673-5784-21-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413320673-5784-1-git-send-email-acme@kernel.org>
References: <1413320673-5784-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

A segfault happens on 'perf test hists_link' because we end up using a
struct machines on the stack, and then machines__init() was not
initializing the newly introduced rb_root, just the existing list_head.

When we introduced struct dsos, to group the two ways to store dsos,
i.e. the linked list and the rbtree, we didn't turned the initialization
done in:

	machines__init(machines->host) ->
		machine__init() ->
			INIT_LIST_HEAD

into a dsos__init() to keep on initializing the list_head but _as well_
initializing the rb_root, oops.

All worked because outside perf-test we probably zalloc the whole thing
which ends up initializing it in to NULL.

So the problem looks contained to 'perf test' that uses it on stack,
etc.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Waiman Long <Waiman.Long@hp.com>,
Cc: Adrian Hunter <adrian.hunter@intel.com>,
Cc: Don Zickus <dzickus@redhat.com>
Cc: Douglas Hatch <doug.hatch@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Scott J Norton <scott.norton@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>,
Link: http://lkml.kernel.org/r/20141014180353.GF3198@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b7d477fbda02..34fc7c8672e4 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -13,12 +13,18 @@
 #include <symbol/kallsyms.h>
 #include "unwind.h"
 
+static void dsos__init(struct dsos *dsos)
+{
+	INIT_LIST_HEAD(&dsos->head);
+	dsos->root = RB_ROOT;
+}
+
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 {
 	map_groups__init(&machine->kmaps);
 	RB_CLEAR_NODE(&machine->rb_node);
-	INIT_LIST_HEAD(&machine->user_dsos.head);
-	INIT_LIST_HEAD(&machine->kernel_dsos.head);
+	dsos__init(&machine->user_dsos);
+	dsos__init(&machine->kernel_dsos);
 
 	machine->threads = RB_ROOT;
 	INIT_LIST_HEAD(&machine->dead_threads);
-- 
1.9.3

