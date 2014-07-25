Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908AbaGYPhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:37:47 -0400
Received: from mail.kernel.org ([198.145.19.201]:34941 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaGYPhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:37:45 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/27] perf tools: Add dso__data_status_seen()
Date: Fri, 25 Jul 2014 12:36:48 -0300
Message-Id: <1406302629-11790-7-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a function to track whether a caller has seen the data status of a
dso.  This is needed to enable callers to report the error exactly once
only per dso.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-11-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c | 12 ++++++++++++
 tools/perf/util/dso.h |  6 ++++++
 2 files changed, 18 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 8827db3d2cba..84e4a0546a31 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -359,6 +359,18 @@ out:
 	return dso->data.fd;
 }
 
+bool dso__data_status_seen(struct dso *dso, enum dso_data_status_seen by)
+{
+	u32 flag = 1 << by;
+
+	if (dso->data.status_seen & flag)
+		return true;
+
+	dso->data.status_seen |= flag;
+
+	return false;
+}
+
 static void
 dso_cache__free(struct rb_root *root)
 {
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index aeb7bcbf0239..c805f604da1f 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -46,6 +46,10 @@ enum dso_data_status {
 	DSO_DATA_STATUS_OK	= 1,
 };
 
+enum dso_data_status_seen {
+	DSO_DATA_STATUS_SEEN_ITRACE,
+};
+
 #define DSO__SWAP(dso, type, val)			\
 ({							\
 	type ____r = val;				\
@@ -111,6 +115,7 @@ struct dso {
 		struct rb_root	 cache;
 		int		 fd;
 		int		 status;
+		u32		 status_seen;
 		size_t		 file_size;
 		struct list_head open_entry;
 	} data;
@@ -203,6 +208,7 @@ ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
 			    struct machine *machine, u64 addr,
 			    u8 *data, ssize_t size);
+bool dso__data_status_seen(struct dso *dso, enum dso_data_status_seen by);
 
 struct map *dso__new_map(const char *name);
 struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
-- 
1.9.3

