Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161072AbaCNVdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:33:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:16787 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756644AbaCNVcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:32:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,657,1389772800"; 
   d="scan'208";a="472797955"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 03/10] fixup! perf, tools: Add support for text descriptions of events and alias add
Date: Fri, 14 Mar 2014 14:31:31 -0700
Message-Id: <1394832698-322-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394832698-322-1-git-send-email-andi@firstfloor.org>
References: <1394832698-322-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

---
 tools/perf/util/pmu.c | 48 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index cc888d9..26311d9 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -737,11 +737,51 @@ static char *format_alias_or(char *buf, int len, struct perf_pmu *pmu,
 	return buf;
 }
 
-static int cmp_string(const void *a, const void *b)
+struct pair {
+	char *name;
+	char *desc;
+};
+
+static int cmp_pair(const void *a, const void *b)
+{
+	const struct pair *as = a;
+	const struct pair *bs = b;
+
+	/* Put downloaded event list last */
+	if (!!as->desc != !!bs->desc)
+		return !!as->desc - !!bs->desc;
+	return strcmp(as->name, bs->name);
+}
+
+static void wordwrap(char *s, int start, int max, int corr)
+{
+	int column = start;
+	int n;
+
+	while (*s) {
+		int wlen = strcspn(s, " \t");
+
+		if (column + wlen >= max && column > start) {
+			printf("\n%*s", start, "");
+			column = start + corr;
+		}
+		n = printf("%s%.*s", column > start ? " " : "", wlen, s);
+		if (n <= 0)
+			break;
+		s += wlen;
+		column += n;
+		while (isspace(*s))
+			s++;
+	}
+}
+
+static int get_columns(void)
 {
-	const char * const *as = a;
-	const char * const *bs = b;
-	return strcmp(*as, *bs);
+	/*
+	 * Should ask the terminal with TIOCGWINSZ here, but we
+	 * need the original fd before the pager.
+	 */
+	return 79;
 }
 
 void print_pmu_events(const char *event_glob, bool name_only)
-- 
1.8.5.3

