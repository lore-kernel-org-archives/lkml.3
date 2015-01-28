Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbbA1VQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:16:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbbA1Uug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:36 -0500
Date: Wed, 28 Jan 2015 07:04:22 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-j6ideab7lkakavfvfguw858z@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, namhyung@kernel.org,
        dsahern@gmail.com, dzickus@redhat.com, fweisbec@gmail.com,
        efault@gmx.de, jolsa@redhat.com, tglx@linutronix.de, mingo@kernel.org,
        adrian.hunter@intel.com, hpa@zytor.com, peterz@infradead.org,
        bp@suse.de, linux-kernel@vger.kernel.org
Reply-To: mingo@kernel.org, adrian.hunter@intel.com, tglx@linutronix.de,
        jolsa@redhat.com, efault@gmx.de, fweisbec@gmail.com,
        namhyung@kernel.org, dzickus@redhat.com, dsahern@gmail.com,
        eranian@google.com, acme@redhat.com, linux-kernel@vger.kernel.org,
        bp@suse.de, peterz@infradead.org, hpa@zytor.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Introduce function for deleting/
 removing hist_entry
Git-Commit-ID: 956b65e1a7a6f10e630ee7f2f2f9de3aab001527
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

Commit-ID:  956b65e1a7a6f10e630ee7f2f2f9de3aab001527
Gitweb:     http://git.kernel.org/tip/956b65e1a7a6f10e630ee7f2f2f9de3aab001527
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 19 Dec 2014 12:41:28 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 13:24:32 -0300

perf hists: Introduce function for deleting/removing hist_entry

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
index b4492de..038483a 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -241,6 +241,20 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
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
@@ -258,16 +272,7 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
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
@@ -281,16 +286,7 @@ void hists__delete_entries(struct hists *hists)
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
 
