Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaFMGZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:25:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44121 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaFMGZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:25:46 -0400
Date: Thu, 12 Jun 2014 23:25:29 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-eba5102d2f0b4117edd089f2d882d9386025c829@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1401892622-30848-5-git-send-email-jolsa@kernel.org>
References: <1401892622-30848-5-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add global list of opened dso objects
Git-Commit-ID: eba5102d2f0b4117edd089f2d882d9386025c829
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

Commit-ID:  eba5102d2f0b4117edd089f2d882d9386025c829
Gitweb:     http://git.kernel.org/tip/eba5102d2f0b4117edd089f2d882d9386025c829
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 30 Apr 2014 15:00:59 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 12 Jun 2014 16:53:20 +0200

perf tools: Add global list of opened dso objects

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
