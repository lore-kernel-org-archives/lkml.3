Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbaG1IYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:24:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42444 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaG1IYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:24:09 -0400
Date: Mon, 28 Jul 2014 01:23:12 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-1f625b0b3dd641b74ba21640a1fea19a3dd893a2@git.kernel.org>
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
In-Reply-To: <1406035081-14301-15-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-15-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add dsos__hit_all()
Git-Commit-ID: 1f625b0b3dd641b74ba21640a1fea19a3dd893a2
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

Commit-ID:  1f625b0b3dd641b74ba21640a1fea19a3dd893a2
Gitweb:     http://git.kernel.org/tip/1f625b0b3dd641b74ba21640a1fea19a3dd893a2
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Jul 2014 16:17:23 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 11:25:40 -0300

perf tools: Add dsos__hit_all()

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
index 893f8e2..a588a3e 100644
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
index d08cfe4..8f5cbae 100644
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
