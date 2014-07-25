Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbaGYPhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:37:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:34953 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaGYPhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:37:48 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/27] perf tools: Add dsos__hit_all()
Date: Fri, 25 Jul 2014 12:36:49 -0300
Message-Id: <1406302629-11790-8-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add ability to mark all dsos as hit.

This is needed in the case of Instruction Tracing.  It takes so long to
decode an Instruction Trace that it is not worth doing just to determine
which dsos are hit.  A later patch takes this into use.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-15-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 41 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h |  2 ++
 2 files changed, 43 insertions(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 893f8e2df928..a588a3eb5753 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -200,6 +200,47 @@ static int write_buildid(const char *name, size_t name_len, u8 *build_id,
 	return write_padded(fd, name, name_len + 1, len);
 }
 
+static int __dsos__hit_all(struct list_head *head)
+{
+	struct dso *pos;
+
+	list_for_each_entry(pos, head, node)
+		pos->hit = true;
+
+	return 0;
+}
+
+static int machine__hit_all_dsos(struct machine *machine)
+{
+	int err;
+
+	err = __dsos__hit_all(&machine->kernel_dsos);
+	if (err)
+		return err;
+
+	return __dsos__hit_all(&machine->user_dsos);
+}
+
+int dsos__hit_all(struct perf_session *session)
+{
+	struct rb_node *nd;
+	int err;
+
+	err = machine__hit_all_dsos(&session->machines.host);
+	if (err)
+		return err;
+
+	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+
+		err = machine__hit_all_dsos(pos);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int __dsos__write_buildid_table(struct list_head *head,
 				       struct machine *machine,
 				       pid_t pid, u16 misc, int fd)
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index d08cfe499404..8f5cbaea64a5 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -151,6 +151,8 @@ int perf_event__process_build_id(struct perf_tool *tool,
 				 struct perf_session *session);
 bool is_perf_magic(u64 magic);
 
+int dsos__hit_all(struct perf_session *session);
+
 /*
  * arch specific callback
  */
-- 
1.9.3

