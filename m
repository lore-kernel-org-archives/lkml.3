Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab3J1P3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:29:52 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:60895 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab3J1P3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:29:51 -0400
From: "Du, Changbin" <changbin.du@gmail.com>
To: jbaron@akamai.com
Cc: joe@perches.com, linux-kernel@vger.kernel.org,
        "Du, Changbin" <changbin.du@gmail.com>
Subject: [PATCH v2] dynamic_debug: add wildcard support to filter files/functions/modules
Date: Mon, 28 Oct 2013 23:29:10 +0800
Message-Id: <1382974150-7392-1-git-send-email-changbin.du@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <51F73A17.2090208@akamai.com>
References: <51F73A17.2090208@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Du, Changbin" <changbin.du@gmail.com>

This patch add wildcard '*'(matches zero or more characters) and '?'
(matches one character) support when qurying debug flags.

Now we can open debug messages using keywords. eg:
1. open debug logs in all usb drivers
    echo "file drivers/usb/* +p" > <debugfs>/dynamic_debug/control
2.  open debug logs for usb xhci code
    echo "file *xhci* +p" > <debugfs>/dynamic_debug/control

Signed-off-by: Du, Changbin <changbin.du@gmail.com>
---
changes since v1:
	rewrite match_pattern using non-recursion method.
---
 lib/dynamic_debug.c | 47 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index c37aeac..d239207 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -127,6 +127,41 @@ static void vpr_info_dq(const struct ddebug_query *query, const char *msg)
 		 query->first_lineno, query->last_lineno);
 }
 
+/* check if the string matches given pattern which includes wildcards */
+static int match_pattern(const char *pattern, const char *string)
+{
+	const char *s, *p;
+	int star = 0;
+
+loop:
+	for (s = string, p = pattern; *s; ++s, ++p) {
+		switch (*p) {
+		case '?':
+			break;
+		case '*':
+			star = 1;
+			string = s;
+			pattern = p;
+			if (!*++pattern)
+				return 1;
+			goto loop;
+		default:
+			if (*s != *p)
+				goto star_check;
+			break;
+		}
+	}
+	if (*p == '*')
+		++p;
+	return (!*p);
+
+star_check:
+	if (!star)
+		return 0;
+	string++;
+	goto loop;
+}
+
 /*
  * Search the tables for _ddebug's which match the given `query' and
  * apply the `flags' and `mask' to them.  Returns number of matching
@@ -147,7 +182,7 @@ static int ddebug_change(const struct ddebug_query *query,
 	list_for_each_entry(dt, &ddebug_tables, link) {
 
 		/* match against the module name */
-		if (query->module && strcmp(query->module, dt->mod_name))
+		if (query->module && !match_pattern(query->module, dt->mod_name))
 			continue;
 
 		for (i = 0; i < dt->num_ddebugs; i++) {
@@ -155,14 +190,16 @@ static int ddebug_change(const struct ddebug_query *query,
 
 			/* match against the source filename */
 			if (query->filename &&
-			    strcmp(query->filename, dp->filename) &&
-			    strcmp(query->filename, kbasename(dp->filename)) &&
-			    strcmp(query->filename, trim_prefix(dp->filename)))
+			    !match_pattern(query->filename, dp->filename) &&
+			    !match_pattern(query->filename,
+					   kbasename(dp->filename)) &&
+			    !match_pattern(query->filename,
+					   trim_prefix(dp->filename)))
 				continue;
 
 			/* match against the function */
 			if (query->function &&
-			    strcmp(query->function, dp->function))
+			    !match_pattern(query->function, dp->function))
 				continue;
 
 			/* match against the format */
-- 
1.8.1.2

