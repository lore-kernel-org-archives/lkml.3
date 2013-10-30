Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab3J3OXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:23:11 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40415 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab3J3OXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:23:09 -0400
From: "Du, Changbin" <changbin.du@gmail.com>
To: jbaron@akamai.com, joe@perches.com
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org,
        "Du, Changbin" <changbin.du@gmail.com>
Subject: [PATCH v4 1/2] dynamic_debug: add wildcard support to filter files/functions/modules
Date: Wed, 30 Oct 2013 22:21:40 +0800
Message-Id: <1383142901-6186-1-git-send-email-changbin.du@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <CABgQ-TjqiALfieAz8+6nt6TVxy93dJRv1UzkGMRMVO1CgfwXNg@mail.gmail.com>
References: <CABgQ-TjqiALfieAz8+6nt6TVxy93dJRv1UzkGMRMVO1CgfwXNg@mail.gmail.com>
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
 lib/dynamic_debug.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 5 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index c37aeac..b953780 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -8,6 +8,7 @@
  * By Greg Banks <gnb@melbourne.sgi.com>
  * Copyright (c) 2008 Silicon Graphics Inc.  All Rights Reserved.
  * Copyright (C) 2011 Bart Van Assche.  All Rights Reserved.
+ * Copyright (C) 2013 Du, Changbin <changbin.du@gmail.com>
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
@@ -127,6 +128,46 @@ static void vpr_info_dq(const struct ddebug_query *query, const char *msg)
 		 query->first_lineno, query->last_lineno);
 }
 
+/* check if the string matches given pattern which includes wildcards */
+static bool match_pattern(const char *pattern, const char *string)
+{
+	const char *s = string;
+	const char *p = pattern;
+	bool star = false;
+
+	while (*s) {
+		switch (*p) {
+		case '?':
+			s++;
+			p++;
+			break;
+		case '*':
+			star = true;
+			string = s;
+			if (!*++p)
+				return true;
+			pattern = p;
+			break;
+		default:
+			if (*s == *p) {
+				s++;
+				p++;
+			} else {
+				if (!star)
+					return false;
+				string++;
+				s = string;
+				p = pattern;
+			}
+			break;
+		}
+	}
+
+	if (*p == '*')
+		++p;
+	return !*p;
+}
+
 /*
  * Search the tables for _ddebug's which match the given `query' and
  * apply the `flags' and `mask' to them.  Returns number of matching
@@ -147,7 +188,8 @@ static int ddebug_change(const struct ddebug_query *query,
 	list_for_each_entry(dt, &ddebug_tables, link) {
 
 		/* match against the module name */
-		if (query->module && strcmp(query->module, dt->mod_name))
+		if (query->module &&
+		    !match_pattern(query->module, dt->mod_name))
 			continue;
 
 		for (i = 0; i < dt->num_ddebugs; i++) {
@@ -155,14 +197,16 @@ static int ddebug_change(const struct ddebug_query *query,
 
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

