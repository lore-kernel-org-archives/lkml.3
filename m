Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab3EPL0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:26:43 -0400
Received: from intranet.asianux.com ([58.214.24.6]:8639 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab3EPL0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:26:42 -0400
X-Spam-Score: -100.8
Message-ID: <5194C23A.3090405@asianux.com>
Date: Thu, 16 May 2013 19:25:46 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: jason.wessel@windriver.com, anton.vorontsov@linaro.org,
        sasha.levin@oracle.com, vincent.stehle@laposte.net,
        john.blackwood@ccur.com
CC: kgdb-bugreport@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/debug/kdb: code enhancement for 3 areas.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Delete waste '{' for 'case' statement.

For the return variable 'long res' in function kdb_task_state_string(),
neither it matches the function return type 'unsigned long', nor is
suitable as a flag variable to make 'or' operation. So use 'unsigned
long' instead of 'long'.

If "case 'A'" happen in function kdb_task_state_string(), can return
~0UL directly to save the useless looping.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/debug/kdb/kdb_main.c    |    3 ---
 kernel/debug/kdb/kdb_support.c |    5 ++---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 00eb8f7..62a0d4a 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1151,7 +1151,6 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 
 	switch (reason) {
 	case KDB_REASON_DEBUG:
-	{
 		/*
 		 * If re-entering kdb after a single step
 		 * command, don't print the message.
@@ -1176,8 +1175,6 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 				   db_result);
 			break;
 		}
-
-	}
 		break;
 	case KDB_REASON_ENTER:
 		if (KDB_STATE(KEYBOARD))
diff --git a/kernel/debug/kdb/kdb_support.c b/kernel/debug/kdb/kdb_support.c
index d35cc2d..75377d1 100644
--- a/kernel/debug/kdb/kdb_support.c
+++ b/kernel/debug/kdb/kdb_support.c
@@ -560,7 +560,7 @@ int kdb_putword(unsigned long addr, unsigned long word, size_t size)
 
 unsigned long kdb_task_state_string(const char *s)
 {
-	long res = 0;
+	unsigned long res = 0;
 	if (!s) {
 		s = kdbgetenv("PS");
 		if (!s)
@@ -599,8 +599,7 @@ unsigned long kdb_task_state_string(const char *s)
 			res |= DAEMON;
 			break;
 		case 'A':
-			res = ~0UL;
-			break;
+			return ~0UL;
 		default:
 			  kdb_printf("%s: unknown flag '%c' ignored\n",
 				     __func__, *s);
-- 
1.7.7.6
