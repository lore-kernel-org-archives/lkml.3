Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3KPIZC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 03:25:02 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:36967 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab3KPIYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 03:24:49 -0500
From: "Du, Changbin" <changbin.du@gmail.com>
To: jbaron@akamai.com, joe@perches.com
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org,
        akpm@linux-foundation.org, "Du, Changbin" <changbin.du@gmail.com>
Subject: [PATCH v5 2/3] dynamic_debug: add wildcard support to filter files/functions/modules
Date: Sat, 16 Nov 2013 16:24:08 +0800
Message-Id: <1384590249-16672-3-git-send-email-changbin.du@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1384590249-16672-1-git-send-email-changbin.du@gmail.com>
References: <1384590249-16672-1-git-send-email-changbin.du@gmail.com>
In-Reply-To: <CABgQ-Th3arUm=rLcv4FGRamAN00kGnDsO_VsHkRp4ZfFGOjaZQ@mail.gmail.com>
References: <CABgQ-Th3arUm=rLcv4FGRamAN00kGnDsO_VsHkRp4ZfFGOjaZQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Du, Changbin" <changbin.du@gmail.com>

Add wildcard '*'(matches zero or more characters) and '?'
(matches one character) support when qurying debug flags.

Now we can open debug messages using keywords. eg:
1. open debug logs in all usb drivers
    echo "file drivers/usb/* +p" > <debugfs>/dynamic_debug/control
2.  open debug logs for usb xhci code
    echo "file *xhci* +p" > <debugfs>/dynamic_debug/control

Signed-off-by: Du, Changbin <changbin.du@gmail.com>
---
 lib/dynamic_debug.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index c37aeac..600ac57 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -8,6 +8,7 @@
  * By Greg Banks <gnb@melbourne.sgi.com>
  * Copyright (c) 2008 Silicon Graphics Inc.  All Rights Reserved.
  * Copyright (C) 2011 Bart Van Assche.  All Rights Reserved.
+ * Copyright (C) 2013 Du, Changbin <changbin.du@gmail.com>
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
@@ -24,6 +25,7 @@
 #include <linux/sysctl.h>
 #include <linux/ctype.h>
 #include <linux/string.h>
+#include <linux/parser.h>
 #include <linux/string_helpers.h>
 #include <linux/uaccess.h>
 #include <linux/dynamic_debug.h>
@@ -147,7 +149,8 @@ static int ddebug_change(const struct ddebug_query *query,
 	list_for_each_entry(dt, &ddebug_tables, link) {
 
 		/* match against the module name */
-		if (query->module && strcmp(query->module, dt->mod_name))
+		if (query->module &&
+		    !match_wildcard(query->module, dt->mod_name))
 			continue;
 
 		for (i = 0; i < dt->num_ddebugs; i++) {
@@ -155,14 +158,16 @@ static int ddebug_change(const struct ddebug_query *query,
 
 			/* match against the source filename */
 			if (query->filename &&
-			    strcmp(query->filename, dp->filename) &&
-			    strcmp(query->filename, kbasename(dp->filename)) &&
-			    strcmp(query->filename, trim_prefix(dp->filename)))
+			    !match_wildcard(query->filename, dp->filename) &&
+			    !match_wildcard(query->filename,
+					   kbasename(dp->filename)) &&
+			    !match_wildcard(query->filename,
+					   trim_prefix(dp->filename)))
 				continue;
 
 			/* match against the function */
 			if (query->function &&
-			    strcmp(query->function, dp->function))
+			    !match_wildcard(query->function, dp->function))
 				continue;
 
 			/* match against the format */
-- 
1.8.3.2

