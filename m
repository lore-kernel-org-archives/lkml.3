Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaLHGtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:49:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34614 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbaLHGtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:49:18 -0500
Date: Sun, 7 Dec 2014 22:48:59 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-23f0981bbd89fcc1496d0490ec39ca7c91599e32@git.kernel.org>
Cc: hpa@zytor.com, namhyung@kernel.org, jolsa@redhat.com, acme@redhat.com,
        tglx@linutronix.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org
Reply-To: linux-kernel@vger.kernel.org, ak@linux.intel.com, acme@redhat.com,
        tglx@linutronix.de, mingo@kernel.org, jolsa@redhat.com, hpa@zytor.com,
        namhyung@kernel.org
In-Reply-To: <1415844328-4884-7-git-send-email-andi@firstfloor.org>
References: <1415844328-4884-7-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain:
  Enable printing the srcline in the history
Git-Commit-ID: 23f0981bbd89fcc1496d0490ec39ca7c91599e32
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

Commit-ID:  23f0981bbd89fcc1496d0490ec39ca7c91599e32
Gitweb:     http://git.kernel.org/tip/23f0981bbd89fcc1496d0490ec39ca7c91599e32
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed, 12 Nov 2014 18:05:24 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Nov 2014 18:03:46 -0300

perf callchain: Enable printing the srcline in the history

For lbr-as-callgraph we need to see the line number in the history,
because many LBR entries can be in a single function, and just
showing the same function name many times is not useful.

When the history code is configured to sort by address, also try to
resolve the address to a file:srcline and display this in the browser.
If that doesn't work still display the address.

This can be also useful without LBRs for understanding which call in a large
function (or in which inlined function) called something else.

Contains fixes from Namhyung Kim

v2: Refactor code into common function
v3: Fix GTK build
v4: Rebase

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1415844328-4884-7-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/callchain.c | 11 ++++++++++-
 tools/perf/util/callchain.h |  1 +
 tools/perf/util/srcline.c   |  6 ++++--
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 38da69c..b6624ae 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -815,7 +815,16 @@ char *callchain_list__sym_name(struct callchain_list *cl,
 	int printed;
 
 	if (cl->ms.sym) {
-		printed = scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
+		if (callchain_param.key == CCKEY_ADDRESS &&
+		    cl->ms.map && !cl->srcline)
+			cl->srcline = get_srcline(cl->ms.map->dso,
+						  map__rip_2objdump(cl->ms.map,
+								    cl->ip));
+		if (cl->srcline)
+			printed = scnprintf(bf, bfsize, "%s %s",
+					cl->ms.sym->name, cl->srcline);
+		else
+			printed = scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
 	} else
 		printed = scnprintf(bf, bfsize, "%#" PRIx64, cl->ip);
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 3e1ed15..3f15847 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -70,6 +70,7 @@ extern struct callchain_param callchain_param;
 struct callchain_list {
 	u64			ip;
 	struct map_symbol	ms;
+	char		       *srcline;
 	struct list_head	list;
 };
 
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 77c1806..ac877f9 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -258,7 +258,7 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	const char *dso_name;
 
 	if (!dso->has_srcline)
-		return SRCLINE_UNKNOWN;
+		goto out;
 
 	if (dso->symsrc_filename)
 		dso_name = dso->symsrc_filename;
@@ -289,7 +289,9 @@ out:
 		dso->has_srcline = 0;
 		dso__free_a2l(dso);
 	}
-	return SRCLINE_UNKNOWN;
+	if (asprintf(&srcline, "%s[%lx]", dso->short_name, addr) < 0)
+		return SRCLINE_UNKNOWN;
+	return srcline;
 }
 
 void free_srcline(char *srcline)
