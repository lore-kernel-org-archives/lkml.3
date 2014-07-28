Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaG1Iby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:31:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42429 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaG1IXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:23:54 -0400
Date: Mon, 28 Jul 2014 01:22:46 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-c27697d6dee02ef2389b6701c792a075bc9873dc@git.kernel.org>
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
In-Reply-To: <1406035081-14301-10-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-10-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Record whether a dso has data
Git-Commit-ID: c27697d6dee02ef2389b6701c792a075bc9873dc
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

Commit-ID:  c27697d6dee02ef2389b6701c792a075bc9873dc
Gitweb:     http://git.kernel.org/tip/c27697d6dee02ef2389b6701c792a075bc9873dc
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Jul 2014 16:17:18 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 11:22:35 -0300

perf tools: Record whether a dso has data

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
