Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaLVPam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:30:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:53990 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253AbaLVPaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:30:39 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/10] perf hists: Introduce function for deleting/removing hist_entry
Date: Mon, 22 Dec 2014 12:30:04 -0300
Message-Id: <1419262209-9464-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1419262209-9464-1-git-send-email-acme@kernel.org>
References: <1419262209-9464-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The code being used when decaying and deleting entries from a hists
instance was the same, provide a function to avoid code dup.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-j6ideab7lkakavfvfguw858z@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9090b5fc07e0..f03854b5fb5f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -240,6 +240,20 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 	return he->stat.period == 0;
 }
 
+static void hists__delete_entry(struct hists *hists, struct hist_entry *he)
+{
+	rb_erase(&he->rb_node, &hists->entries);
+
+	if (sort__need_collapse)
+		rb_erase(&he->rb_node_in, &hists->entries_collapsed);
+
+	--hists->nr_entries;
+	if (!he->filtered)
+		--hists->nr_non_filtered_entries;
+
+	hist_entry__delete(he);
+}
+
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
 {
 	struct rb_node *next = rb_first(&hists->entries);
@@ -257,16 +271,7 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
 		     (zap_kernel && n->level != '.') ||
 		     hists__decay_entry(hists, n)) &&
 		    !n->used) {
-			rb_erase(&n->rb_node, &hists->entries);
-
-			if (sort__need_collapse)
-				rb_erase(&n->rb_node_in, &hists->entries_collapsed);
-
-			--hists->nr_entries;
-			if (!n->filtered)
-				--hists->nr_non_filtered_entries;
-
-			hist_entry__delete(n);
+			hists__delete_entry(hists, n);
 		}
 	}
 }
@@ -280,16 +285,7 @@ void hists__delete_entries(struct hists *hists)
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
-		rb_erase(&n->rb_node, &hists->entries);
-
-		if (sort__need_collapse)
-			rb_erase(&n->rb_node_in, &hists->entries_collapsed);
-
-		--hists->nr_entries;
-		if (!n->filtered)
-			--hists->nr_non_filtered_entries;
-
-		hist_entry__delete(n);
+		hists__delete_entry(hists, n);
 	}
 }
 
-- 
1.9.3

