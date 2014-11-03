Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbaKCH2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 02:28:15 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59111 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaKCH2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 02:28:02 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/8] perf tools: Get rid of unused dsos__hit_all()
Date: Mon,  3 Nov 2014 16:27:53 +0900
Message-Id: <1414999678-31377-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414999678-31377-1-git-send-email-namhyung@kernel.org>
References: <1414999678-31377-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dsos__hit_all() and its friends are not used anywhere.  Let's get
rid of them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c | 41 -----------------------------------------
 tools/perf/util/header.h |  2 --
 2 files changed, 43 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 0ecf4a304cbc..e7c762f54bee 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -200,47 +200,6 @@ static int write_buildid(const char *name, size_t name_len, u8 *build_id,
 	return write_padded(fd, name, name_len + 1, len);
 }
 
-static int __dsos__hit_all(struct list_head *head)
-{
-	struct dso *pos;
-
-	list_for_each_entry(pos, head, node)
-		pos->hit = true;
-
-	return 0;
-}
-
-static int machine__hit_all_dsos(struct machine *machine)
-{
-	int err;
-
-	err = __dsos__hit_all(&machine->kernel_dsos.head);
-	if (err)
-		return err;
-
-	return __dsos__hit_all(&machine->user_dsos.head);
-}
-
-int dsos__hit_all(struct perf_session *session)
-{
-	struct rb_node *nd;
-	int err;
-
-	err = machine__hit_all_dsos(&session->machines.host);
-	if (err)
-		return err;
-
-	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-
-		err = machine__hit_all_dsos(pos);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
 static int __dsos__write_buildid_table(struct list_head *head,
 				       struct machine *machine,
 				       pid_t pid, u16 misc, int fd)
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 8f5cbaea64a5..d08cfe499404 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -151,8 +151,6 @@ int perf_event__process_build_id(struct perf_tool *tool,
 				 struct perf_session *session);
 bool is_perf_magic(u64 magic);
 
-int dsos__hit_all(struct perf_session *session);
-
 /*
  * arch specific callback
  */
-- 
2.1.2

