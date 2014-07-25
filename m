Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891AbaGYPho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:37:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:34929 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaGYPhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:37:42 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/27] perf tools: Record whether a dso has data
Date: Fri, 25 Jul 2014 12:36:47 -0300
Message-Id: <1406302629-11790-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add 'data.status' to record whether a dso has data (i.e. an object
file).  This is used to avoid repeatedly creating the file name and
attempting to open a file that is not present.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-10-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c | 23 +++++++++++++++--------
 tools/perf/util/dso.h |  7 +++++++
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 28cf7476b68c..8827db3d2cba 100644
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
index c239e86541a3..aeb7bcbf0239 100644
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
1.9.3

