Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaG1Ibv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:31:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42431 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaG1IXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:23:55 -0400
Date: Mon, 28 Jul 2014 01:23:00 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-288be943b5024729cd6809b61b62f727960178f3@git.kernel.org>
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
In-Reply-To: <1406035081-14301-11-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-11-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add dso__data_status_seen()
Git-Commit-ID: 288be943b5024729cd6809b61b62f727960178f3
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

Commit-ID:  288be943b5024729cd6809b61b62f727960178f3
Gitweb:     http://git.kernel.org/tip/288be943b5024729cd6809b61b62f727960178f3
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Jul 2014 16:17:19 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 11:23:44 -0300

perf tools: Add dso__data_status_seen()

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
