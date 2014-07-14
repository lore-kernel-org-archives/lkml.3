Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbaGNKP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:15:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:41894 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbaGNKFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:05:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434344"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 18/41] perf tools: Record whether a dso has data
Date: Mon, 14 Jul 2014 13:02:42 +0300
Message-Id: <1405332185-4050-19-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
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
 tools/perf/util/dso.c | 5 ++++-
 tools/perf/util/dso.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index fc006fe..91a4eb4 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -556,8 +556,11 @@ static ssize_t data_read_offset(struct dso *dso, u64 offset,
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
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index c239e86..c5257aa 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -104,6 +104,7 @@ struct dso {
 	struct {
 		struct rb_root	 cache;
 		int		 fd;
+		int		 data_status;
 		size_t		 file_size;
 		struct list_head open_entry;
 	} data;
-- 
1.8.3.2

