Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbbAUPD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:03:59 -0500
Received: from mail.kernel.org ([198.145.29.136]:43404 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbbAUPBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:01:33 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/9] perf annotate: Fix memory leaks in LOCK handling
Date: Wed, 21 Jan 2015 12:01:05 -0300
Message-Id: <1421852470-20153-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421852470-20153-1-git-send-email-acme@kernel.org>
References: <1421852470-20153-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin@rab.in>

The lock prefix handling fails to free the strdup()'d name as well as
the fields allocated by the instruction parsing.

Signed-off-by: Rabin Vincent <rabin@rab.in>
Cc: Paul Mackerras <paulus@samba.org>
Link: http://lkml.kernel.org/r/1421607621-15005-2-git-send-email-rabin@rab.in
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index d5da1b85541b..01bc4e23a2cf 100644
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
1.9.3

