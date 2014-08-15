Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaHOQu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:50:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:44630 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbaHOQuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:50:25 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alex Converse <aconverse@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/18] perf annotate: Don't truncate Intel style addresses
Date: Fri, 15 Aug 2014 13:49:47 -0300
Message-Id: <1408121403-11919-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121403-11919-1-git-send-email-acme@kernel.org>
References: <1408121403-11919-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Converse <aconverse@google.com>

Instructions like "mov r9,QWORD PTR [rdx+0x8]" were being truncated to
"mov r9,QWORD" by code that assuemd operands cannot have spaces.

Signed-off-by: Alex Converse <aconverse@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1408050180-14088-1-git-send-email-aconverse@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 7745fec01a6b..36437527dbb3 100644
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
1.9.3

