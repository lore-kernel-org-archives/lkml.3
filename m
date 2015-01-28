Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059AbbA1Utk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:49:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759371AbbA1Uth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:49:37 -0500
Date: Wed, 28 Jan 2015 07:01:09 -0800
From: tip-bot for Rabin Vincent <tipbot@zytor.com>
Message-ID: <tip-0fb9f2aab738eec9dd9b929ed7d37bf744d2ac77@git.kernel.org>
Cc: tglx@linutronix.de, acme@redhat.com, hpa@zytor.com, paulus@samba.org,
        rabin@rab.in, linux-kernel@vger.kernel.org, mingo@kernel.org
Reply-To: rabin@rab.in, mingo@kernel.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com, hpa@zytor.com, tglx@linutronix.de
In-Reply-To: <1421607621-15005-2-git-send-email-rabin@rab.in>
References: <1421607621-15005-2-git-send-email-rabin@rab.in>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Fix memory leaks in LOCK handling
Git-Commit-ID: 0fb9f2aab738eec9dd9b929ed7d37bf744d2ac77
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

Commit-ID:  0fb9f2aab738eec9dd9b929ed7d37bf744d2ac77
Gitweb:     http://git.kernel.org/tip/0fb9f2aab738eec9dd9b929ed7d37bf744d2ac77
Author:     Rabin Vincent <rabin@rab.in>
AuthorDate: Sun, 18 Jan 2015 20:00:21 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 10:05:32 -0300

perf annotate: Fix memory leaks in LOCK handling

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
index d5da1b8..01bc4e2 100644
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
