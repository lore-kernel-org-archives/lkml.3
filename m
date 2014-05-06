Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbaEFNEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:04:49 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53673 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbaEFNEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:04:46 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com
Subject: [PATCH v4 5/9] kdb: Use KDB_REPEAT_* values as flags
Date: Tue,  6 May 2014 14:03:45 +0100
Message-Id: <1399381429-16194-6-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399381429-16194-1-git-send-email-daniel.thompson@linaro.org>
References: <1398443370-12668-1-git-send-email-daniel.thompson@linaro.org>
 <1399381429-16194-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <anton.vorontsov@linaro.org>

The actual values of KDB_REPEAT_* enum values and overall logic stayed
the same, but we now treat the values as flags.

This makes it possible to add other flags and combine them, plus makes
the code a lot simpler and shorter. But functionality-wise, there should
be no changes.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/kdb.h         |  4 ++--
 kernel/debug/kdb/kdb_main.c | 21 +++++++--------------
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 32d2f40..90aed7c 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -15,8 +15,8 @@
 
 typedef enum {
 	KDB_REPEAT_NONE = 0,	/* Do not repeat this command */
-	KDB_REPEAT_NO_ARGS,	/* Repeat the command without arguments */
-	KDB_REPEAT_WITH_ARGS,	/* Repeat the command including its arguments */
+	KDB_REPEAT_NO_ARGS	= 0x1, /* Repeat the command w/o arguments */
+	KDB_REPEAT_WITH_ARGS	= 0x2, /* Repeat the command w/ its arguments */
 } kdb_cmdflags_t;
 
 typedef int (*kdb_func_t)(int, const char **);
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 626c6d2..2f54353 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1008,20 +1008,13 @@ int kdb_parse(const char *cmdstr)
 		if (result && ignore_errors && result > KDB_CMD_GO)
 			result = 0;
 		KDB_STATE_CLEAR(CMD);
-		switch (tp->cmd_flags) {
-		case KDB_REPEAT_NONE:
-			argc = 0;
-			if (argv[0])
-				*(argv[0]) = '\0';
-			break;
-		case KDB_REPEAT_NO_ARGS:
-			argc = 1;
-			if (argv[1])
-				*(argv[1]) = '\0';
-			break;
-		case KDB_REPEAT_WITH_ARGS:
-			break;
-		}
+
+		if (tp->cmd_flags & KDB_REPEAT_WITH_ARGS)
+			return result;
+
+		argc = tp->cmd_flags & KDB_REPEAT_NO_ARGS ? 1 : 0;
+		if (argv[argc])
+			*(argv[argc]) = '\0';
 		return result;
 	}
 
-- 
1.9.0

