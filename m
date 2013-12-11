Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3LKMit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:38:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:32257 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab3LKMim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:38:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442368201"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 12/71] perf tools: Add dsos__hit_all()
Date: Wed, 11 Dec 2013 14:36:24 +0200
Message-Id: <1386765443-26966-13-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add ability to mark all dsos as hit.

This is needed in the case of Instruction
Tracing.  It takes so long to decode an
Instruction Trace that it is not worth
doing just to determine which dsos are
hit.  A later patch takes this into use.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/header.c | 41 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h |  2 ++
 2 files changed, 43 insertions(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 125cdc9..49c4896 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -200,6 +200,47 @@ static int write_buildid(char *name, size_t name_len, u8 *build_id,
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
index 307c9ae..e8c45fa 100644
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
1.8.5.1

