Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaHIFkj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 01:40:39 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:42351 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaHIFkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 01:40:36 -0400
Date: Sat, 9 Aug 2014 14:39:05 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] staging: dgap: Simplify to set a module type
Message-ID: <20140809053905.GA14675@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is same manner with setting a board type.
After allocating a type of "MNODE", get a token value
set to "module.type".

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   26 +++++++-------------------
 drivers/staging/dgap/dgap.h |    1 -
 2 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 1d27976..a54b8d4 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -6388,6 +6388,7 @@ static int dgap_parsefile(char **in)
 	for (; ;) {
 		int board_type = 0;
 		int conc_type = 0;
+		int module_type = 0;
 
 		rc = dgap_gettok(in);
 		if (rc == 0) {
@@ -6762,24 +6763,15 @@ static int dgap_parsefile(char **in)
 			else
 				brd->u.board.module1++;
 
-			break;
-
-		case PORTS:	/* ports type EBI module */
-			if (p->type != MNODE) {
-				dgap_err("ports only valid for EBI modules");
+			module_type = dgap_gettok(in);
+			if (module_type == 0 || module_type != PORTS ||
+			    module_type != MODEM) {
+				dgap_err("failed to set a type of module");
 				return -1;
 			}
-			p->u.module.type = PORTS;
-			p->u.module.v_type = 1;
-			break;
 
-		case MODEM:	/* ports type EBI module */
-			if (p->type != MNODE) {
-				dgap_err("modem only valid for modem modules");
-				return -1;
-			}
-			p->u.module.type = MODEM;
-			p->u.module.v_type = 1;
+			p->u.module.type = module_type;
+
 			break;
 
 		case CABLE:
@@ -7207,10 +7199,6 @@ static int dgap_checknode(struct cnode *p)
 		return 0;
 
 	case MNODE:
-		if (p->u.module.v_type == 0) {
-			dgap_err("EBI module type not specified");
-			return 1;
-		}
 		if (p->u.module.v_nport == 0) {
 			dgap_err("number of ports on EBI module not specified");
 			return 1;
diff --git a/drivers/staging/dgap/dgap.h b/drivers/staging/dgap/dgap.h
index 800f407..52e1d64 100644
--- a/drivers/staging/dgap/dgap.h
+++ b/drivers/staging/dgap/dgap.h
@@ -1219,7 +1219,6 @@ struct cnode {
 			char *id;
 			char *idstr;
 			long start;
-			char v_type;
 			char v_nport;
 			char v_id;
 			char v_start;
-- 
1.7.1

