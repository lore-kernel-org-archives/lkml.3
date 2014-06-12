Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbaFLPba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:31:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140AbaFLPbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:31:24 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/14] perf tools: Add global list of opened dso objects
Date: Thu, 12 Jun 2014 17:30:36 +0200
Message-Id: <1402587045-5461-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402587045-5461-1-git-send-email-jolsa@kernel.org>
References: <1402587045-5461-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding global list of opened dso objects, so we can
track them and use the list for caching dso data file
descriptors.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1401892622-30848-5-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/dso.c | 41 +++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/dso.h |  1 +
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 5acb4b8..5d7c7bc 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -136,7 +136,22 @@ int dso__read_binary_type_filename(const struct dso *dso,
 	return ret;
 }
 
-static int open_dso(struct dso *dso, struct machine *machine)
+/*
+ * Global list of open DSOs.
+ */
+static LIST_HEAD(dso__data_open);
+
+static void dso__list_add(struct dso *dso)
+{
+	list_add_tail(&dso->data.open_entry, &dso__data_open);
+}
+
+static void dso__list_del(struct dso *dso)
+{
+	list_del(&dso->data.open_entry);
+}
+
+static int __open_dso(struct dso *dso, struct machine *machine)
 {
 	int fd;
 	char *root_dir = (char *)"";
@@ -159,14 +174,35 @@ static int open_dso(struct dso *dso, struct machine *machine)
 	return fd;
 }
 
-void dso__data_close(struct dso *dso)
+static int open_dso(struct dso *dso, struct machine *machine)
+{
+	int fd = __open_dso(dso, machine);
+
+	if (fd > 0)
+		dso__list_add(dso);
+
+	return fd;
+}
+
+static void close_data_fd(struct dso *dso)
 {
 	if (dso->data.fd >= 0) {
 		close(dso->data.fd);
 		dso->data.fd = -1;
+		dso__list_del(dso);
 	}
 }
 
+static void close_dso(struct dso *dso)
+{
+	close_data_fd(dso);
+}
+
+void dso__data_close(struct dso *dso)
+{
+	close_dso(dso);
+}
+
 int dso__data_fd(struct dso *dso, struct machine *machine)
 {
 	enum dso_binary_type binary_type_data[] = {
@@ -499,6 +535,7 @@ struct dso *dso__new(const char *name)
 		dso->kernel = DSO_TYPE_USER;
 		dso->needs_swap = DSO_SWAP__UNSET;
 		INIT_LIST_HEAD(&dso->node);
+		INIT_LIST_HEAD(&dso->data.open_entry);
 	}
 
 	return dso;
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index e48dcf5..90988bf 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -103,6 +103,7 @@ struct dso {
 	struct {
 		struct rb_root	 cache;
 		int		 fd;
+		struct list_head open_entry;
 	} data;
 
 	char		 name[0];
-- 
1.8.3.1

