Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbaGQIo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:44:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:30635 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746AbaGQIoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:44:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,676,1400050800"; 
   d="scan'208";a="544670587"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH V2 2/2] perf tools: Record whether a dso has data
Date: Thu, 17 Jul 2014 11:43:10 +0300
Message-Id: <1405586590-13657-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405586590-13657-1-git-send-email-adrian.hunter@intel.com>
References: <20140716142031.GD9441@krava.redhat.com>
 <1405586590-13657-1-git-send-email-adrian.hunter@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'data_status' to record whether a dso has data
(i.e. an object file) as follows:

	dso->data_status	meaning
	----------------------------------
	0			don't know
	-1			no data
	1			has data

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/dso.c | 25 ++++++++++++++++---------
 tools/perf/util/dso.h |  7 +++++++
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 28cf747..af274f0 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -332,25 +332,28 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
 	int i = 0;
 
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
+		dso->data.data_status = DSO_DATA_STATUS_OK;
+	else
+		dso->data.data_status = DSO_DATA_STATUS_ERROR;
 
-	return -EINVAL;
+	return dso->data.fd;
 }
 
 static void
@@ -556,8 +559,11 @@ static ssize_t data_read_offset(struct dso *dso, u64 offset,
 ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 			      u64 offset, u8 *data, ssize_t size)
 {
-	if (dso__data_fd(dso, machine) < 0)
+	if (dso__data_fd(dso, machine) < 0) {
+		dso->data.data_status = -1;
 		return -1;
+	}
+	dso->data.data_status = 1;
 
 	return data_read_offset(dso, offset, data, size);
 }
@@ -701,6 +707,7 @@ struct dso *dso__new(const char *name)
 			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
 		dso->data.cache = RB_ROOT;
 		dso->data.fd = -1;
+		dso->data.data_status = DSO_DATA_STATUS_UNKNOWN;
 		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->binary_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->is_64_bit = (sizeof(void *) == 8);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index c239e86..07d0a58 100644
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
+		int		 data_status;
 		size_t		 file_size;
 		struct list_head open_entry;
 	} data;
-- 
1.8.3.2

