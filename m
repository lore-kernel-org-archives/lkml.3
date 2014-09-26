Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbaIZXhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 19:37:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:3602 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756336AbaIZXh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 19:37:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,606,1406617200"; 
   d="scan'208";a="579753264"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 7/8] tools, perf: Make srcline output address with -v
Date: Fri, 26 Sep 2014 16:37:15 -0700
Message-Id: <1411774636-6870-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When -v is specified always print the hex address for the srcline.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/srcline.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 36a7aff..a22be7c 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -258,6 +258,12 @@ char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
 	unsigned line = 0;
 	char *srcline;
 	const char *dso_name;
+	char astr[50];
+
+	if (verbose)
+		snprintf(astr, sizeof astr, " %#lx", addr);
+	else
+		astr[0] = 0;
 
 	if (!dso->has_srcline)
 		goto out;
@@ -276,7 +282,12 @@ char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
 	if (!addr2line(dso_name, addr, &file, &line, dso))
 		goto out;
 
-	if (asprintf(&srcline, "%s:%u", basename(file), line) < 0) {
+	if (line == 0) {
+		free(file);
+		goto fallback;
+	}
+
+	if (asprintf(&srcline, "%s:%u%s", basename(file), line, astr) < 0) {
 		free(file);
 		goto out;
 	}
@@ -291,9 +302,10 @@ out:
 		dso->has_srcline = 0;
 		dso__free_a2l(dso);
 	}
+fallback:
 	if (sym) {
-		if (asprintf(&srcline, "%s+%ld", show_sym ? sym->name : "",
-					addr - sym->start) < 0)
+		if (asprintf(&srcline, "%s+%ld%s", show_sym ? sym->name : "",
+					addr - sym->start, astr) < 0)
 			return SRCLINE_UNKNOWN;
 	} else if (asprintf(&srcline, "%s[%lx]", dso->short_name, addr) < 0)
 		return SRCLINE_UNKNOWN;
-- 
1.9.3

