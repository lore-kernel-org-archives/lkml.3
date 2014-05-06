Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaEFNEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:04:45 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:61206 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaEFNEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:04:43 -0400
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
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH v4 3/9] kdb: Rename kdb_repeat_t to kdb_cmdflags_t, cmd_repeat to cmd_flags
Date: Tue,  6 May 2014 14:03:43 +0100
Message-Id: <1399381429-16194-4-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399381429-16194-1-git-send-email-daniel.thompson@linaro.org>
References: <1398443370-12668-1-git-send-email-daniel.thompson@linaro.org>
 <1399381429-16194-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <anton.vorontsov@linaro.org>

We're about to add more options for command behaviour, so let's expand
the meaning of kdb_repeat_t.

So far we just do various renames, there should be no functional changes.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 include/linux/kdb.h            | 6 +++---
 kernel/debug/kdb/kdb_main.c    | 6 +++---
 kernel/debug/kdb/kdb_private.h | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 290db12..e650f79 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -17,7 +17,7 @@ typedef enum {
 	KDB_REPEAT_NONE = 0,	/* Do not repeat this command */
 	KDB_REPEAT_NO_ARGS,	/* Repeat the command without arguments */
 	KDB_REPEAT_WITH_ARGS,	/* Repeat the command including its arguments */
-} kdb_repeat_t;
+} kdb_cmdflags_t;
 
 typedef int (*kdb_func_t)(int, const char **);
 
@@ -147,7 +147,7 @@ static inline const char *kdb_walk_kallsyms(loff_t *pos)
 /* Dynamic kdb shell command registration */
 extern int kdb_register(char *, kdb_func_t, char *, char *, short);
 extern int kdb_register_repeat(char *, kdb_func_t, char *, char *,
-			       short, kdb_repeat_t);
+			       short, kdb_cmdflags_t);
 extern int kdb_unregister(char *);
 #else /* ! CONFIG_KGDB_KDB */
 static inline __printf(1, 2) int kdb_printf(const char *fmt, ...) { return 0; }
@@ -156,7 +156,7 @@ static inline int kdb_register(char *cmd, kdb_func_t func, char *usage,
 			       char *help, short minlen) { return 0; }
 static inline int kdb_register_repeat(char *cmd, kdb_func_t func, char *usage,
 				      char *help, short minlen,
-				      kdb_repeat_t repeat) { return 0; }
+				      kdb_cmdflags_t flags) { return 0; }
 static inline int kdb_unregister(char *cmd) { return 0; }
 #endif	/* CONFIG_KGDB_KDB */
 enum {
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index f0a4e69..5b7b13a 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1008,7 +1008,7 @@ int kdb_parse(const char *cmdstr)
 		if (result && ignore_errors && result > KDB_CMD_GO)
 			result = 0;
 		KDB_STATE_CLEAR(CMD);
-		switch (tp->cmd_repeat) {
+		switch (tp->cmd_flags) {
 		case KDB_REPEAT_NONE:
 			argc = 0;
 			if (argv[0])
@@ -2653,7 +2653,7 @@ int kdb_register_repeat(char *cmd,
 			char *usage,
 			char *help,
 			short minlen,
-			kdb_repeat_t repeat)
+			kdb_cmdflags_t flags)
 {
 	int i;
 	kdbtab_t *kp;
@@ -2702,7 +2702,7 @@ int kdb_register_repeat(char *cmd,
 	kp->cmd_usage  = usage;
 	kp->cmd_help   = help;
 	kp->cmd_minlen = minlen;
-	kp->cmd_repeat = repeat;
+	kp->cmd_flags  = flags;
 
 	return 0;
 }
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index c4c46c7..eaacd16 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -174,7 +174,7 @@ typedef struct _kdbtab {
 	char    *cmd_help;		/* Help message for this command */
 	short    cmd_minlen;		/* Minimum legal # command
 					 * chars required */
-	kdb_repeat_t cmd_repeat;	/* Does command auto repeat on enter? */
+	kdb_cmdflags_t cmd_flags;	/* Command behaviour flags */
 } kdbtab_t;
 
 extern int kdb_bt(int, const char **);	/* KDB display back trace */
-- 
1.9.0

