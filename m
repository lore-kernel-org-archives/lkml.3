Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbbARTAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 14:00:51 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:53129 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbARTAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 14:00:47 -0500
From: Rabin Vincent <rabin@rab.in>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 2/2] perf annotate: fix memory leaks in LOCK handling
Date: Sun, 18 Jan 2015 20:00:21 +0100
Message-Id: <1421607621-15005-2-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421607621-15005-1-git-send-email-rabin@rab.in>
References: <1421607621-15005-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lock prefix handling fails to free the strdup()'d name as well as
the fields allocated by the instruction parsing.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 tools/perf/util/annotate.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 5ae428b..53d11c1 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -177,6 +177,8 @@ static int lock__parse(struct ins_operands *ops)
 		goto out_free_ops;
 
 	ops->locked.ins = ins__find(name);
+	free(name);
+
 	if (ops->locked.ins == NULL)
 		goto out_free_ops;
 
@@ -209,6 +211,13 @@ static int lock__scnprintf(struct ins *ins, char *bf, size_t size,
 
 static void lock__delete(struct ins_operands *ops)
 {
+	struct ins *ins = ops->locked.ins;
+
+	if (ins && ins->ops->free)
+		ins->ops->free(ops->locked.ops);
+	else
+		ins__delete(ops->locked.ops);
+
 	zfree(&ops->locked.ops);
 	zfree(&ops->target.raw);
 	zfree(&ops->target.name);
-- 
2.1.4

