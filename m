Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964951AbaLKPNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:13:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964876AbaLKPNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:13:46 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 8/8] perf data: Add support for setting ordered_events queue size
Date: Thu, 11 Dec 2014 16:12:29 +0100
Message-Id: <1418310749-22267-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1418310749-22267-1-git-send-email-jolsa@kernel.org>
References: <1418310749-22267-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to limit the size of ordered_events queue,
so we could control allocation size of perf data files
without proper finished round events.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeremie Galarneau <jgalar@efficios.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/data-convert-bt.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
index 3d73e51ee10d..ddecce88bf6d 100644
--- a/tools/perf/util/data-convert-bt.c
+++ b/tools/perf/util/data-convert-bt.c
@@ -74,6 +74,9 @@ struct convert {
 
 	u64			events_size;
 	u64			events_count;
+
+	/* Ordered events configured queue size. */
+	u64			queue_size;
 };
 
 static int value_set(struct bt_ctf_field_type *type,
@@ -966,6 +969,18 @@ static void ctf_writer__flush_streams(struct ctf_writer *cw)
 		ctf_stream__flush(cw->stream[cpu]);
 }
 
+static int convert__config(const char *var, const char *value, void *cb)
+{
+	struct convert *c = cb;
+
+	if (!strcmp(var, "convert.queue-size")) {
+		c->queue_size = perf_config_u64(var, value);
+		return 0;
+	}
+
+	return perf_default_config(var, value, cb);
+}
+
 int bt_convert__perf2ctf(const char *input, const char *path)
 {
 	struct perf_session *session;
@@ -991,6 +1006,8 @@ int bt_convert__perf2ctf(const char *input, const char *path)
 	struct ctf_writer *cw = &c.writer;
 	int err = -1;
 
+	perf_config(convert__config, &c);
+
 	/* CTF writer */
 	if (ctf_writer__init(cw, path))
 		return -1;
@@ -1000,6 +1017,11 @@ int bt_convert__perf2ctf(const char *input, const char *path)
 	if (!session)
 		goto free_writer;
 
+	if (c.queue_size) {
+		ordered_events__set_alloc_size(&session->ordered_events,
+					       c.queue_size);
+	}
+
 	/* CTF writer env/clock setup  */
 	if (ctf_writer__setup_env(cw, session))
 		goto free_session;
-- 
1.9.3

