Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609AbaGYPon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:44:43 -0400
Received: from mail.kernel.org ([198.145.19.201]:35021 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760495AbaGYPiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:38:04 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/27] perf tools: Add dso__data_size()
Date: Fri, 25 Jul 2014 12:36:53 -0300
Message-Id: <1406302629-11790-12-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a function to return the dso data size, for use in estimating the
size an instruction cache.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-27-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c | 22 ++++++++++++++++++++++
 tools/perf/util/dso.h |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 84e4a0546a31..e657d86e82b9 100644
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
index c805f604da1f..af1c256aad4f 100644
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
1.9.3

