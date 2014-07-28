Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaG1IZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:25:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42517 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaG1IZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:25:08 -0400
Date: Mon, 28 Jul 2014 01:24:10 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-6d363459d7e6e05f0afeb8e36e6de262a4964694@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406035081-14301-27-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-27-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add dso__data_size()
Git-Commit-ID: 6d363459d7e6e05f0afeb8e36e6de262a4964694
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

Commit-ID:  6d363459d7e6e05f0afeb8e36e6de262a4964694
Gitweb:     http://git.kernel.org/tip/6d363459d7e6e05f0afeb8e36e6de262a4964694
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Jul 2014 16:17:35 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 11:57:27 -0300

perf tools: Add dso__data_size()

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
