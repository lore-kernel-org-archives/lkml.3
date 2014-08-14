Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaHNVDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:03:35 -0400
Received: from mail-pd0-f201.google.com ([209.85.192.201]:54362 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaHNVD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:03:29 -0400
From: Alex Converse <aconverse@google.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Alex Converse <aconverse@google.com>
Subject: [PATCH] perf annotate: Don't truncate Intel style addresses
Date: Thu, 14 Aug 2014 14:03:00 -0700
Message-Id: <1408050180-14088-1-git-send-email-aconverse@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instructions like "mov r9,QWORD PTR [rdx+0x8]" were being truncated to
"mov r9,QWORD" by code that assuemd operands cannot have spaces.

Signed-off-by: Alex Converse <aconverse@google.com>
---
 tools/perf/util/annotate.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 809b4c5..cc6f72c 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -232,9 +232,16 @@ static int mov__parse(struct ins_operands *ops)
 		return -1;
 
 	target = ++s;
+	comment = strchr(s, '#');
 
-	while (s[0] != '\0' && !isspace(s[0]))
-		++s;
+	if (comment != NULL)
+		s = comment - 1;
+	else
+		s = strchr(s, '\0') - 1;
+
+	while (s > target && isspace(s[0]))
+		--s;
+	s++;
 	prev = *s;
 	*s = '\0';
 
@@ -244,7 +251,6 @@ static int mov__parse(struct ins_operands *ops)
 	if (ops->target.raw == NULL)
 		goto out_free_source;
 
-	comment = strchr(s, '#');
 	if (comment == NULL)
 		return 0;
 
-- 
2.1.0.rc2.206.gedb03e5

