Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaJOKG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:06:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54517 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaJOKGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:06:24 -0400
Date: Wed, 15 Oct 2014 03:05:33 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-e167f995e26249aa93708589c5eea539652351fa@git.kernel.org>
Cc: mingo@redhat.com, dzickus@redhat.com, paulus@samba.org, jolsa@kernel.org,
        tglx@linutronix.de, hpa@zytor.com, acme@redhat.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org, doug.hatch@hp.com,
        peterz@infradead.org, jolsa@redhat.com, scott.norton@hp.com,
        mingo@kernel.org
Reply-To: mingo@kernel.org, scott.norton@hp.com, jolsa@redhat.com,
        peterz@infradead.org, doug.hatch@hp.com, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, acme@redhat.com, hpa@zytor.com,
        dzickus@redhat.com, paulus@samba.org, tglx@linutronix.de,
        jolsa@kernel.org, mingo@redhat.com
In-Reply-To: <20141014180353.GF3198@kernel.org>
References: <20141014180353.GF3198@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf machine: Add missing dsos->
 root rbtree root initialization
Git-Commit-ID: e167f995e26249aa93708589c5eea539652351fa
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

Commit-ID:  e167f995e26249aa93708589c5eea539652351fa
Gitweb:     http://git.kernel.org/tip/e167f995e26249aa93708589c5eea539652351fa
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 14 Oct 2014 15:07:48 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Oct 2014 17:50:44 -0300

perf machine: Add missing dsos->root rbtree root initialization

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
index b7d477f..34fc7c8 100644
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
