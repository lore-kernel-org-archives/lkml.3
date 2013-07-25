Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3GYNCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:02:32 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:57328 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab3GYNCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:02:30 -0400
From: "Du, Changbin" <changbin.du@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, changbin.du@gmail.com
Subject: [PATCH] dynamic_debug: add wildcard support to filter files/functions/modules
Date: Thu, 25 Jul 2013 21:02:01 +0800
Message-Id: <1374757321-5988-1-git-send-email-changbin.du@gmail.com>
X-Mailer: git-send-email 1.8.1.2
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
 lib/dynamic_debug.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 99fec3a..cdcce58 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -127,6 +127,21 @@ static void vpr_info_dq(const struct ddebug_query *query, const char *msg)
 		 query->first_lineno, query->last_lineno);
 }
 
+static int match_pattern(char *pat, char *str)
+{
+	switch (*pat) {
+	case '\0':
+		return !*str;
+	case '*':
+		return  match_pattern(pat+1, str) || 
+			(*str && match_pattern(pat, str+1));
+	case '?':
+		return *str && match_pattern(pat+1, str+1);
+	default:
+		return *pat == *str && match_pattern(pat+1, str+1);
+	}
+}
+
 /*
  * Search the tables for _ddebug's which match the given `query' and
  * apply the `flags' and `mask' to them.  Returns number of matching
@@ -147,7 +162,7 @@ static int ddebug_change(const struct ddebug_query *query,
 	list_for_each_entry(dt, &ddebug_tables, link) {
 
 		/* match against the module name */
-		if (query->module && strcmp(query->module, dt->mod_name))
+		if (query->module && !match_pattern(query->module, dt->mod_name))
 			continue;
 
 		for (i = 0; i < dt->num_ddebugs; i++) {
@@ -155,14 +170,16 @@ static int ddebug_change(const struct ddebug_query *query,
 
 			/* match against the source filename */
 			if (query->filename &&
-			    strcmp(query->filename, dp->filename) &&
-			    strcmp(query->filename, kbasename(dp->filename)) &&
-			    strcmp(query->filename, trim_prefix(dp->filename)))
+			    !match_pattern(query->filename, dp->filename) &&
+			    !match_pattern(query->filename, 
+			    		   kbasename(dp->filename)) &&
+			    !match_pattern(query->filename, 
+			    		   trim_prefix(dp->filename)))
 				continue;
 
 			/* match against the function */
 			if (query->function &&
-			    strcmp(query->function, dp->function))
+			    !match_pattern(query->function, dp->function))
 				continue;
 
 			/* match against the format */
-- 
1.8.1.2

