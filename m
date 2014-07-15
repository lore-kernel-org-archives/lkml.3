Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbaGODGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:06:34 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35593 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbaGODGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:06:32 -0400
Date: Tue, 15 Jul 2014 12:05:14 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] staging: dgap: fix memory leak in dgap_parsefile()
Message-ID: <20140715030456.GA14420@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The p->u.board.status is allocated and set a string as
"No" once within allocating a node of BNODE type.
But it also set again with kstrdup() in case of "STATUS"
or "ID". If it is not allocated yet, use kstrdup().
If not, use just memcpy().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index a207bd7..cedf4b3 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -6598,7 +6598,11 @@ static int dgap_parsefile(char **in)
 				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
-			p->u.board.status = kstrdup(s, GFP_KERNEL);
+
+			if (p->u.board.status)
+				memcpy(p->u.board.status, s, strlen(s) + 1);
+			else
+				p->u.board.status = kstrdup(s, GFP_KERNEL);
 			break;
 
 		case NPORTS:	/* number of ports */
@@ -6648,7 +6652,10 @@ static int dgap_parsefile(char **in)
 				return -1;
 			}
 
-			p->u.board.status = kstrdup(s, GFP_KERNEL);
+			if (p->u.board.status)
+				memcpy(p->u.board.status, s, strlen(s) + 1);
+			else
+				p->u.board.status = kstrdup(s, GFP_KERNEL);
 
 			if (p->type == CNODE) {
 				p->u.conc.id = kstrdup(s, GFP_KERNEL);
-- 
1.7.1

