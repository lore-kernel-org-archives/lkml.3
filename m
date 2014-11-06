Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaKFQCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:02:52 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:64917 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaKFQCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:02:49 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RESEND PATCH 3.18-rc3 1/3] kdb: Fix a prompt management bug when using | grep
Date: Thu,  6 Nov 2014 16:02:24 +0000
Message-Id: <1415289746-30917-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415289746-30917-1-git-send-email-daniel.thompson@linaro.org>
References: <1410438579-7839-1-git-send-email-daniel.thompson@linaro.org>
 <1415289746-30917-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when the "| grep" feature is used to filter the output of a
command then the prompt is not displayed for the subsequent command.
Likewise any characters typed by the user are also not echoed to the
display. This rather disconcerting problem eventually corrects itself
when the user presses Enter and the kdb_grepping_flag is cleared as
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

