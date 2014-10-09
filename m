Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaJIJtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:49:22 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:45339 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaJIJtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:49:13 -0400
X-Originating-IP: 88.159.34.112
From: Maarten ter Huurne <maarten@treewalker.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: [PATCH] fbcon: Fix option parsing control flow in fb_console_setup
Date: Thu,  9 Oct 2014 11:48:30 +0200
Message-Id: <1412848110-12734-1-git-send-email-maarten@treewalker.org>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since strsep is used to tokenize the options string, after each option
match the code should use "continue" to get the next token from strsep.
This patch applies this pattern consistently.

Previously, for "scrollback:" and "map:" the parse code would return
(unconditionally: strsep ensures *options != ','), causing any
following option to be ignored, while for "vc:" the parse code would
go on to parse further options within the same token, which could lead
to invalid input being accepted.

Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
Acked-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/video/console/fbcon.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 57b1d44..eb976ee 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -448,8 +448,10 @@ static int __init fb_console_setup(char *this_opt)
 		return 1;
 
 	while ((options = strsep(&this_opt, ",")) != NULL) {
-		if (!strncmp(options, "font:", 5))
+		if (!strncmp(options, "font:", 5)) {
 			strlcpy(fontname, options + 5, sizeof(fontname));
+			continue;
+		}
 		
 		if (!strncmp(options, "scrollback:", 11)) {
 			options += 11;
@@ -457,13 +459,9 @@ static int __init fb_console_setup(char *this_opt)
 				fbcon_softback_size = simple_strtoul(options, &options, 0);
 				if (*options == 'k' || *options == 'K') {
 					fbcon_softback_size *= 1024;
-					options++;
 				}
-				if (*options != ',')
-					return 1;
-				options++;
-			} else
-				return 1;
+			}
+			continue;
 		}
 		
 		if (!strncmp(options, "map:", 4)) {
@@ -478,8 +476,7 @@ static int __init fb_console_setup(char *this_opt)
 
 				fbcon_map_override();
 			}
-
-			return 1;
+			continue;
 		}
 
 		if (!strncmp(options, "vc:", 3)) {
@@ -491,7 +488,8 @@ static int __init fb_console_setup(char *this_opt)
 			if (*options++ == '-')
 				last_fb_vc = simple_strtoul(options, &options, 10) - 1;
 			fbcon_is_default = 0; 
-		}	
+			continue;
+		}
 
 		if (!strncmp(options, "rotate:", 7)) {
 			options += 7;
@@ -499,6 +497,7 @@ static int __init fb_console_setup(char *this_opt)
 				initial_rotation = simple_strtoul(options, &options, 0);
 			if (initial_rotation > 3)
 				initial_rotation = 0;
+			continue;
 		}
 	}
 	return 1;
-- 
1.8.4.5

