Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbbA1Utq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:49:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762036AbbA1Utm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:49:42 -0500
Date: Wed, 28 Jan 2015 07:00:48 -0800
From: tip-bot for Rabin Vincent <tipbot@zytor.com>
Message-ID: <tip-be81908c2289f405df75d2511ccf5da785945400@git.kernel.org>
Cc: peterz@infradead.org, tglx@linutronix.de, paulus@samba.org, rabin@rab.in,
        linux-kernel@vger.kernel.org, mingo@kernel.org, acme@redhat.com,
        hpa@zytor.com
Reply-To: acme@redhat.com, hpa@zytor.com, peterz@infradead.org,
        tglx@linutronix.de, rabin@rab.in, paulus@samba.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org
In-Reply-To: <1421607621-15005-1-git-send-email-rabin@rab.in>
References: <1421607621-15005-1-git-send-email-rabin@rab.in>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Handle ins parsing failures
Git-Commit-ID: be81908c2289f405df75d2511ccf5da785945400
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

Commit-ID:  be81908c2289f405df75d2511ccf5da785945400
Gitweb:     http://git.kernel.org/tip/be81908c2289f405df75d2511ccf5da785945400
Author:     Rabin Vincent <rabin@rab.in>
AuthorDate: Sun, 18 Jan 2015 20:00:20 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 10:05:17 -0300

perf annotate: Handle ins parsing failures

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
index 79999ce..d5da1b8 100644
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
