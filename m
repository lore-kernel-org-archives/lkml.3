Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbbARTAo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 14:00:44 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:40746 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbARTAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 14:00:43 -0500
From: Rabin Vincent <rabin@rab.in>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 1/2] perf annotate: handle ins parsing failures
Date: Sun, 18 Jan 2015 20:00:20 +0100
Message-Id: <1421607621-15005-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use the ins's ->sncprintf() if the parsing failed.

For example, this fixes the display of "imul %edx".  Without this patch:

       |      imul   (null),(null)

After this patch:

       |      imul   %edx

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 tools/perf/util/annotate.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 79999ce..5ae428b 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -183,8 +183,9 @@ static int lock__parse(struct ins_operands *ops)
 	if (!ops->locked.ins->ops)
 		return 0;
 
-	if (ops->locked.ins->ops->parse)
-		ops->locked.ins->ops->parse(ops->locked.ops);
+	if (ops->locked.ins->ops->parse
+	    && ops->locked.ins->ops->parse(ops->locked.ops) < 0)
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
2.1.4

