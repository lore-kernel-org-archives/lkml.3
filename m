Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbbAUPCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:02:17 -0500
Received: from mail.kernel.org ([198.145.29.136]:43390 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbbAUPBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:01:30 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/9] perf annotate: Handle ins parsing failures
Date: Wed, 21 Jan 2015 12:01:04 -0300
Message-Id: <1421852470-20153-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421852470-20153-1-git-send-email-acme@kernel.org>
References: <1421852470-20153-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin@rab.in>

Don't use the ins's ->sncprintf() if the parsing failed.

For example, this fixes the display of "imul %edx".  Without this patch:

       |      imul   (null),(null)

After this patch:

       |      imul   %edx

Signed-off-by: Rabin Vincent <rabin@rab.in>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1421607621-15005-1-git-send-email-rabin@rab.in
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 79999ceaf2be..d5da1b85541b 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -183,8 +183,9 @@ static int lock__parse(struct ins_operands *ops)
 	if (!ops->locked.ins->ops)
 		return 0;
 
-	if (ops->locked.ins->ops->parse)
-		ops->locked.ins->ops->parse(ops->locked.ops);
+	if (ops->locked.ins->ops->parse &&
+	    ops->locked.ins->ops->parse(ops->locked.ops) < 0)
+		goto out_free_ops;
 
 	return 0;
 
@@ -531,8 +532,8 @@ static void disasm_line__init_ins(struct disasm_line *dl)
 	if (!dl->ins->ops)
 		return;
 
-	if (dl->ins->ops->parse)
-		dl->ins->ops->parse(&dl->ops);
+	if (dl->ins->ops->parse && dl->ins->ops->parse(&dl->ops) < 0)
+		dl->ins = NULL;
 }
 
 static int disasm_line__parse(char *line, char **namep, char **rawp)
-- 
1.9.3

