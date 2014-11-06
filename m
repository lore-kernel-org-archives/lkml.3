Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaKFQC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:02:57 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:61279 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaKFQCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:02:52 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RESEND PATCH 3.18-rc3 2/3] kdb: Provide forward search at more prompt
Date: Thu,  6 Nov 2014 16:02:25 +0000
Message-Id: <1415289746-30917-3-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415289746-30917-1-git-send-email-daniel.thompson@linaro.org>
References: <1410438579-7839-1-git-send-email-daniel.thompson@linaro.org>
 <1415289746-30917-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kdb allows the output of comamnds to be filtered using the
| grep feature. This is useful but does not permit the output emitted
shortly after a string match to be examined without wading through the
entire unfiltered output of the command. Such a feature is particularly
useful to navigate function traces because these traces often have a
useful trigger string *before* the point of interest.

This patch reuses the existing filtering logic to introduce a simple
forward search to kdb that can be triggered from the more prompt.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 kernel/debug/kdb/kdb_io.c      | 22 ++++++++++++++++++++--
 kernel/debug/kdb/kdb_main.c    |  7 ++++---
 kernel/debug/kdb/kdb_private.h |  2 ++
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 7c70812..70e0f49 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -680,6 +680,12 @@ int vkdb_printf(const char *fmt, va_list ap)
 			size_avail = sizeof(kdb_buffer) - len;
 			goto kdb_print_out;
 		}
+		if (kdb_grepping_flag >= KDB_GREPPING_FLAG_SEARCH)
+			/*
+			 * This was a interactive search (using '/' at more
+			 * prompt) and it has completed. Clear the flag.
+			 */
+			kdb_grepping_flag = 0;
 		/*
 		 * at this point the string is a full line and
 		 * should be printed, up to the null.
@@ -794,11 +800,23 @@ kdb_printit:
 			kdb_nextline = linecount - 1;
 			kdb_printf("\r");
 			suspend_grep = 1; /* for this recursion */
+		} else if (buf1[0] == '/' && !kdb_grepping_flag) {
+			kdb_printf("\r");
+			kdb_getstr(kdb_grep_string, KDB_GREP_STRLEN,
+				   kdbgetenv("SEARCHPROMPT") ?: "search> ");
+			*strchrnul(kdb_grep_string, '\n') = '\0';
+			kdb_grepping_flag += KDB_GREPPING_FLAG_SEARCH;
+			suspend_grep = 1; /* for this recursion */
 		} else if (buf1[0] && buf1[0] != '\n') {
 			/* user hit something other than enter */
 			suspend_grep = 1; /* for this recursion */
-			kdb_printf("\nOnly 'q' or 'Q' are processed at more "
-				   "prompt, input ignored\n");
+			if (buf1[0] != '/')
+				kdb_printf(
+				    "\nOnly 'q', 'Q' or '/' are processed at "
+				    "more prompt, input ignored\n");
+			else
+				kdb_printf("\n'/' cannot be used during | "
+					   "grep filtering, input ignored\n");
 		} else if (kdb_grepping_flag) {
 			/* user hit enter */
 			suspend_grep = 1; /* for this recursion */
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 9d10cb2..c36f6f6 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -42,8 +42,7 @@
 #include <linux/slab.h>
 #include "kdb_private.h"
 
-#define GREP_LEN 256
-char kdb_grep_string[GREP_LEN];
+char kdb_grep_string[KDB_GREP_STRLEN];
 int kdb_grepping_flag;
 EXPORT_SYMBOL(kdb_grepping_flag);
 int kdb_grep_leading;
@@ -827,7 +826,7 @@ static void parse_grep(const char *str)
 	len = strlen(cp);
 	if (!len)
 		return;
-	if (len >= GREP_LEN) {
+	if (len >= KDB_GREP_STRLEN) {
 		kdb_printf("search string too long\n");
 		return;
 	}
@@ -1241,6 +1240,8 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 		kdb_nextline = 1;
 		KDB_STATE_CLEAR(SUPPRESS);
 		kdb_grepping_flag = 0;
+		/* ensure the old search does not leak into '/' commands */
+		kdb_grep_string[0] = '\0';
 
 		cmdbuf = cmd_cur;
 		*cmdbuf = '\0';
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index 7afd3c8..30ed4f3 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -197,7 +197,9 @@ extern int kdb_main_loop(kdb_reason_t, kdb_reason_t,
 
 /* Miscellaneous functions and data areas */
 extern int kdb_grepping_flag;
+#define KDB_GREPPING_FLAG_SEARCH 0x8000
 extern char kdb_grep_string[];
+#define KDB_GREP_STRLEN 256
 extern int kdb_grep_leading;
 extern int kdb_grep_trailing;
 extern char *kdb_cmds[];
-- 
1.9.3

