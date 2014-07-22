Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbaGVNdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:33:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:40572 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbaGVNUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:20:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576985481"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/52] perf tools: Record whether a dso has data
Date: Tue, 22 Jul 2014 16:17:18 +0300
Message-Id: <1406035081-14301-10-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'data.status' to record whether a dso has data
(i.e. an object file).  This is used to avoid
repeatedly creating the file name and attempting
to open a file that is not present.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/dso.c | 23 +++++++++++++++--------
 tools/perf/util/dso.h |  7 +++++++
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 28cf747..8827db3 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -331,26 +331,32 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
 	};
 	int i = 0;
 
+	if (dso->data.status == DSO_DATA_STATUS_ERROR)
+		return -1;
+
 	if (dso->data.fd >= 0)
-		return dso->data.fd;
+		goto out;
 
 	if (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND) {
 		dso->data.fd = open_dso(dso, machine);
-		return dso->data.fd;
+		goto out;
 	}
 
 	do {
-		int fd;
-
 		dso->binary_type = binary_type_data[i++];
 
-		fd = open_dso(dso, machine);
-		if (fd >= 0)
-			return dso->data.fd = fd;
+		dso->data.fd = open_dso(dso, machine);
+		if (dso->data.fd >= 0)
+			goto out;
 
 	} while (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND);
+out:
+	if (dso->data.fd >= 0)
+		dso->data.status = DSO_DATA_STATUS_OK;
+	else
+		dso->data.status = DSO_DATA_STATUS_ERROR;
 
-	return -EINVAL;
+	return dso->data.fd;
 }
 
 static void
@@ -701,6 +707,7 @@ struct dso *dso__new(const char *name)
 			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
 		dso->data.cache = RB_ROOT;
 		dso->data.fd = -1;
+		dso->data.status = DSO_DATA_STATUS_UNKNOWN;
 		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->binary_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->is_64_bit = (sizeof(void *) == 8);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index c239e86..aeb7bcb 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -40,6 +40,12 @@ enum dso_swap_type {
 	DSO_SWAP__YES,
 };
 
+enum dso_data_status {
+	DSO_DATA_STATUS_ERROR	= -1,
+	DSO_DATA_STATUS_UNKNOWN	= 0,
+	DSO_DATA_STATUS_OK	= 1,
+};
+
 #define DSO__SWAP(dso, type, val)			\
 ({							\
 	type ____r = val;				\
@@ -104,6 +110,7 @@ struct dso {
 	struct {
 		struct rb_root	 cache;
 		int		 fd;
+		int		 status;
 		size_t		 file_size;
 		struct list_head open_entry;
 	} data;
-- 
1.8.3.2

