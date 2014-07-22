Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbaGVN3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:29:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:45434 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240AbaGVNUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:20:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576985865"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 26/52] perf tools: Add dso__data_size()
Date: Tue, 22 Jul 2014 16:17:35 +0300
Message-Id: <1406035081-14301-27-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to return the dso data size, for use
in estimating the size an instruction cache.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/dso.c | 22 ++++++++++++++++++++++
 tools/perf/util/dso.h |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 84e4a05..e657d86 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -544,6 +544,28 @@ static int data_file_size(struct dso *dso)
 	return 0;
 }
 
+/**
+ * dso__data_size - Return dso data size
+ * @dso: dso object
+ * @machine: machine object
+ *
+ * Return: dso data size
+ */
+off_t dso__data_size(struct dso *dso, struct machine *machine)
+{
+	int fd;
+
+	fd = dso__data_fd(dso, machine);
+	if (fd < 0)
+		return fd;
+
+	if (data_file_size(dso))
+		return -1;
+
+	/* For now just estimate dso data size is close to file size */
+	return dso->data.file_size;
+}
+
 static ssize_t data_read_offset(struct dso *dso, u64 offset,
 				u8 *data, ssize_t size)
 {
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index c805f60..af1c256 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -166,6 +166,7 @@ int dso__read_binary_type_filename(const struct dso *dso, enum dso_binary_type t
  * The dso__data_* external interface provides following functions:
  *   dso__data_fd
  *   dso__data_close
+ *   dso__data_size
  *   dso__data_read_offset
  *   dso__data_read_addr
  *
@@ -203,6 +204,7 @@ int dso__read_binary_type_filename(const struct dso *dso, enum dso_binary_type t
 int dso__data_fd(struct dso *dso, struct machine *machine);
 void dso__data_close(struct dso *dso);
 
+off_t dso__data_size(struct dso *dso, struct machine *machine);
 ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 			      u64 offset, u8 *data, ssize_t size);
 ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
-- 
1.8.3.2

