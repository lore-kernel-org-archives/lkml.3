Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbaHUM0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:26:32 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:52338 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbaHUMXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:23:40 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCHv3 4/9] modpost: provide better diagnostics for __init / __exit strings
Date: Thu, 21 Aug 2014 14:23:07 +0200
Message-Id: <1408623792-7973-5-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
References: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modpost will detect wrong usage of the pe_*() / pi_*() macros or the
__init_str() / __exit_str() annotations in general. But it'll print
cryptic diagnoses in this case that don't really help fixing the issue
in the code. Detect __init / __exit string section mismatches by there
unique symbol name pattern and provide better help texts in this case.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 This patch generates quite a few checkpatch warnings related to strings
 split across lines. But I choose to do so anyway to not make the code
 differ from other fprintf()s in this file.

 scripts/mod/modpost.c |   94 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 75 insertions(+), 19 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 091d90573b..7b462d5d01 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1150,6 +1150,16 @@ static inline int is_arm_mapping_symbol(const char *str)
 	       && (str[2] == '\0' || str[2] == '.');
 }
 
+static inline int is_init_str(const char *str)
+{
+	return !strncmp(str, "__UNIQUE_ID__init_str_", 22);
+}
+
+static inline int is_exit_str(const char *str)
+{
+	return !strncmp(str, "__UNIQUE_ID__exit_str_", 22);
+}
+
 /*
  * If there's no name there, ignore it; likewise, ignore it if it's
  * one of the magic symbols emitted used by current ARM tools.
@@ -1305,12 +1315,24 @@ static void report_sec_mismatch(const char *modname,
 		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The function %s%s() references\n"
-		"the %s %s%s%s.\n"
-		"This is often because %s lacks a %s\n"
-		"annotation or the annotation of %s is wrong.\n",
+		"the %s %s%s%s.\n",
 		prl_from, fromsym,
-		to, prl_to, tosym, to_p,
-		fromsym, prl_to, tosym);
+		to, prl_to, tosym, to_p);
+		if (!to_is_func && is_init_str(tosym)) {
+			fprintf(stderr,
+			"This is probably due to a wrong use of the "
+			"pi_<level>() macro\n"
+			"or a wrongly __init_str() annotated string literal.\n"
+			"The fix is to either change the pi_<level>() to its "
+			"pr_<level>()\n"
+			"counterpart or to remove the __init_str() annotation "
+			"of the string literal\n");
+		} else {
+			fprintf(stderr,
+			"This is often because %s lacks a %s\n"
+			"annotation or the annotation of %s is wrong.\n",
+			fromsym, prl_to, tosym);
+		}
 		free(prl_from);
 		free(prl_to);
 		break;
@@ -1330,10 +1352,24 @@ static void report_sec_mismatch(const char *modname,
 	case TEXT_TO_ANY_EXIT:
 		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
-		"The function %s() references a %s in an exit section.\n"
-		"Often the %s %s%s has valid usage outside the exit section\n"
-		"and the fix is to remove the %sannotation of %s.\n",
-		fromsym, to, to, tosym, to_p, prl_to, tosym);
+		"The function %s() references a %s in an exit section.\n",
+		fromsym, to);
+		if (!to_is_func && is_exit_str(tosym)) {
+			fprintf(stderr,
+			"This is probably due to a wrong use of the "
+			"pe_<level>() macro\n"
+			"or a wrongly __exit_str() annotated string literal.\n"
+			"The fix is to either change the pe_<level>() to its "
+			"pr_<level>()\n"
+			"counterpart or to remove the __exit_str() annotation "
+			"of the string literal\n");
+		} else {
+			fprintf(stderr,
+			"Often the %s %s%s has valid usage outside the exit "
+			"section\n"
+			"and the fix is to remove the %sannotation of %s.\n",
+			to, tosym, to_p, prl_to, tosym);
+		}
 		free(prl_to);
 		break;
 	case DATA_TO_ANY_EXIT: {
@@ -1372,12 +1408,22 @@ static void report_sec_mismatch(const char *modname,
 		"a %s %s%s%s.\n"
 		"This is often seen when error handling "
 		"in the init function\n"
-		"uses functionality in the exit path.\n"
-		"The fix is often to remove the %sannotation of\n"
-		"%s%s so it may be used outside an exit section.\n",
+		"uses functionality of the exit path.\n",
 		from, prl_from, fromsym, from_p,
-		to, prl_to, tosym, to_p,
-		prl_to, tosym, to_p);
+		to, prl_to, tosym, to_p);
+		if (!to_is_func && is_exit_str(tosym)) {
+			fprintf(stderr,
+			"The fix is often to either change the pe_<level>() to "
+			"its pr_<level>()\n"
+			"counterpart or to remove the __exit_str() annotation "
+			"of the string literal\n"
+			"so it may be used outside an exit section.\n");
+		} else {
+			fprintf(stderr,
+			"The fix is often to remove the %sannotation of\n"
+			"%s%s so it may be used outside an exit section.\n",
+			prl_to, tosym, to_p);
+		}
 		free(prl_from);
 		free(prl_to);
 		break;
@@ -1389,12 +1435,22 @@ static void report_sec_mismatch(const char *modname,
 		"a %s %s%s%s.\n"
 		"This is often seen when error handling "
 		"in the exit function\n"
-		"uses functionality in the init path.\n"
-		"The fix is often to remove the %sannotation of\n"
-		"%s%s so it may be used outside an init section.\n",
+		"uses functionality of the init path.\n",
 		from, prl_from, fromsym, from_p,
-		to, prl_to, tosym, to_p,
-		prl_to, tosym, to_p);
+		to, prl_to, tosym, to_p);
+		if (!to_is_func && is_init_str(tosym)) {
+			fprintf(stderr,
+			"The fix is often to either change the pi_<level>() to "
+			"its pr_<level>()\n"
+			"counterpart or to remove the __init_str() annotation "
+			"of the string literal\n"
+			"so it may be used outside an init section.\n");
+		} else {
+			fprintf(stderr,
+			"The fix is often to remove the %sannotation of\n"
+			"%s%s so it may be used outside an init section.\n",
+			prl_to, tosym, to_p);
+		}
 		free(prl_from);
 		free(prl_to);
 		break;
-- 
1.7.10.4

