Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaGVNUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:20:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:45360 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbaGVNUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:20:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576985486"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/52] perf tools: Add dso__data_status_seen()
Date: Tue, 22 Jul 2014 16:17:19 +0300
Message-Id: <1406035081-14301-11-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to track whether a caller has seen
the data status of a dso.  This is needed to
enable callers to report the error exactly once
only per dso.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/dso.c | 12 ++++++++++++
 tools/perf/util/dso.h |  6 ++++++
 2 files changed, 18 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 8827db3..84e4a05 100644
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
index aeb7bcb..c805f60 100644
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
1.8.3.2

