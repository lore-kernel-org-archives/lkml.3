Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaHIFkT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 01:40:19 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:43842 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaHIFkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 01:40:12 -0400
Date: Sat, 9 Aug 2014 14:38:41 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] staging: dgap: Simplify to set a concentrator type
Message-ID: <20140809053841.GA14669@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is same manner with setting a board type.
For example of config file for concentrator,
    "conc ccon" or
    "conc epcon"

After allocating a type of "CNODE" then set a type of concentrator.
So remove cases in swith statement, just get a token from string
and set to "conc.type". And also it doesn't need to "conc.v_type".

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   26 +++++++-------------------
 drivers/staging/dgap/dgap.h |    1 -
 2 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 7fb54d1..1d27976 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -6387,6 +6387,7 @@ static int dgap_parsefile(char **in)
 
 	for (; ;) {
 		int board_type = 0;
+		int conc_type = 0;
 
 		rc = dgap_gettok(in);
 		if (rc == 0) {
@@ -6719,24 +6720,15 @@ static int dgap_parsefile(char **in)
 			else
 				brd->u.board.conc1++;
 
-			break;
-
-		case CX:	/* c/x type concentrator */
-			if (p->type != CNODE) {
-				dgap_err("cx only valid for concentrators");
+			conc_type = dgap_gettok(in);
+			if (conc_type == 0 || conc_type != CX ||
+			    conc_type != EPC) {
+				dgap_err("failed to set a type of concentratros");
 				return -1;
 			}
-			p->u.conc.type = CX;
-			p->u.conc.v_type = 1;
-			break;
 
-		case EPC:	/* epc type concentrator */
-			if (p->type != CNODE) {
-				dgap_err("cx only valid for concentrators");
-				return -1;
-			}
-			p->u.conc.type = EPC;
-			p->u.conc.v_type = 1;
+			p->u.conc.type = conc_type;
+
 			break;
 
 		case MOD:	/* EBI module */
@@ -7200,10 +7192,6 @@ static int dgap_checknode(struct cnode *p)
 		return 0;
 
 	case CNODE:
-		if (p->u.conc.v_type == 0) {
-			dgap_err("concentrator type not specified");
-			return 1;
-		}
 		if (p->u.conc.v_speed == 0) {
 			dgap_err("concentrator line speed not specified");
 			return 1;
diff --git a/drivers/staging/dgap/dgap.h b/drivers/staging/dgap/dgap.h
index c01aa28..800f407 100644
--- a/drivers/staging/dgap/dgap.h
+++ b/drivers/staging/dgap/dgap.h
@@ -1206,7 +1206,6 @@ struct cnode {
 			char  *id;
 			char  *idstr;
 			long  start;
-			char  v_type;
 			char  v_connect;
 			char  v_speed;
 			char  v_nport;
-- 
1.7.1

