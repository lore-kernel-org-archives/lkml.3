Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3EaLrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:47:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56917 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3EaLrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:47:15 -0400
Date: Fri, 31 May 2013 04:44:46 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-367c53c08f84bb554a3aae18b65e5419fe4b164a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1355404152-16523-2-git-send-email-jolsa@redhat.com>
References: <1355404152-16523-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff:
  Use internal rb tree for hists__precompute
Git-Commit-ID: 367c53c08f84bb554a3aae18b65e5419fe4b164a
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

Commit-ID:  367c53c08f84bb554a3aae18b65e5419fe4b164a
Gitweb:     http://git.kernel.org/tip/367c53c08f84bb554a3aae18b65e5419fe4b164a
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 13 Dec 2012 14:08:59 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:24:02 +0300

perf diff: Use internal rb tree for hists__precompute

There's missing change for hists__precompute to iterate either
entries_collapsed or entries_in tree. The change was initiated
for hists_compute_resort function in commit:

  66f97ed perf diff: Use internal rb tree for compute resort

but was missing for hists__precompute function changes.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1355404152-16523-2-git-send-email-jolsa@redhat.com
[ committer note: Reduce patch size, no functional change ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index a9d63c1..da8f8eb 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -323,13 +323,20 @@ static void hists__baseline_only(struct hists *hists)
 
 static void hists__precompute(struct hists *hists)
 {
-	struct rb_node *next = rb_first(&hists->entries);
+	struct rb_root *root;
+	struct rb_node *next;
+
+	if (sort__need_collapse)
+		root = &hists->entries_collapsed;
+	else
+		root = hists->entries_in;
 
+	next = rb_first(root);
 	while (next != NULL) {
-		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
+		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node_in);
 		struct hist_entry *pair = hist_entry__next_pair(he);
 
-		next = rb_next(&he->rb_node);
+		next = rb_next(&he->rb_node_in);
 		if (!pair)
 			continue;
 
