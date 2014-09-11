Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbaIKMax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:30:53 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:43939 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbaIKMaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:30:10 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 3.17-rc4 1/3] kdb: Fix a prompt management bug when using | grep
Date: Thu, 11 Sep 2014 13:29:37 +0100
Message-Id: <1410438579-7839-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410438579-7839-1-git-send-email-daniel.thompson@linaro.org>
References: <1410438579-7839-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when the "| grep" feature is used to filter the output of a
command then the prompt is not displayed for the subsequent command.
Likewise any characters typed by the user are also not echoed to the
display. This rather disconcerting problem eventually corrects itself
when the user presses Enter the kdb_grepping_flag is cleared when
kdb_parse() tries to make sense of whatever they typed.

This patch resolves the problem by moving the clearing of this flag
from the middle of command processing to the beginning.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 kernel/debug/kdb/kdb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 379650b..9d10cb2 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -872,13 +872,12 @@ int kdb_parse(const char *cmdstr)
 	char *cp;
 	char *cpp, quoted;
 	kdbtab_t *tp;
-	int i, escaped, ignore_errors = 0, check_grep;
+	int i, escaped, ignore_errors = 0, check_grep = 0;
 
 	/*
 	 * First tokenize the command string.
 	 */
 	cp = (char *)cmdstr;
-	kdb_grepping_flag = check_grep = 0;
 
 	if (KDB_FLAG(CMD_INTERRUPT)) {
 		/* Previous command was interrupted, newline must not
@@ -1241,6 +1240,7 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 		 */
 		kdb_nextline = 1;
 		KDB_STATE_CLEAR(SUPPRESS);
+		kdb_grepping_flag = 0;
 
 		cmdbuf = cmd_cur;
 		*cmdbuf = '\0';
-- 
1.9.3

