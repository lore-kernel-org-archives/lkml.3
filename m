Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbaGODDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:03:24 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63256 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540AbaGODDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:03:21 -0400
Date: Tue, 15 Jul 2014 12:02:05 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] staging: dgap: remove dgap_newnode()
Message-ID: <20140715030205.GA14401@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dgap_newnode() is useless for creating new node.
So just use kzalloc and set a type in case statement.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |  104 ++++++++++++++++++++++++++++++------------
 1 files changed, 74 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 1e52092..06c55cb 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -152,7 +152,6 @@ static void dgap_firmware_reset_port(struct channel_t *ch);
  */
 static int dgap_gettok(char **in);
 static char *dgap_getword(char **in);
-static struct cnode *dgap_newnode(int t);
 static int dgap_checknode(struct cnode *p);
 static void dgap_err(char *s);
 
@@ -6367,13 +6366,15 @@ static int dgap_parsefile(char **in)
 		case BOARD:	/* board info */
 			if (dgap_checknode(p))
 				return -1;
-			p->next = dgap_newnode(BNODE);
+
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
 				dgap_err("out of memory");
 				return -1;
 			}
 			p = p->next;
 
+			p->type = BNODE;
 			p->u.board.status = kstrdup("No", GFP_KERNEL);
 			line = conc = NULL;
 			brd = p;
@@ -6658,12 +6659,16 @@ static int dgap_parsefile(char **in)
 		case TTYN:	/* tty name prefix */
 			if (dgap_checknode(p))
 				return -1;
-			p->next = dgap_newnode(TNODE);
+
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
 				dgap_err("out of memory");
 				return -1;
 			}
+
 			p = p->next;
+			p->type = TNODE;
+
 			s = dgap_getword(in);
 			if (!s) {
 				dgap_err("unexpeced end of file");
@@ -6679,12 +6684,16 @@ static int dgap_parsefile(char **in)
 		case CU:	/* cu name prefix */
 			if (dgap_checknode(p))
 				return -1;
-			p->next = dgap_newnode(CUNODE);
+
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
 				dgap_err("out of memory");
 				return -1;
 			}
+
 			p = p->next;
+			p->type = CUNODE;
+
 			s = dgap_getword(in);
 			if (!s) {
 				dgap_err("unexpeced end of file");
@@ -6709,12 +6718,15 @@ static int dgap_parsefile(char **in)
 				dgap_err("line not vaild for PC/em");
 				return -1;
 			}
-			p->next = dgap_newnode(LNODE);
+
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
 				dgap_err("out of memory");
 				return -1;
 			}
+
 			p = p->next;
+			p->type = LNODE;
 			conc = NULL;
 			line = p;
 			linecnt++;
@@ -6727,13 +6739,17 @@ static int dgap_parsefile(char **in)
 				dgap_err("must specify line info before concentrator");
 				return -1;
 			}
-			p->next = dgap_newnode(CNODE);
+
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
 				dgap_err("out of memory");
 				return -1;
 			}
+
 			p = p->next;
+			p->type = CNODE;
 			conc = p;
+
 			if (linecnt)
 				brd->u.board.conc2++;
 			else
@@ -6776,12 +6792,15 @@ static int dgap_parsefile(char **in)
 					return -1;
 				}
 			}
-			p->next = dgap_newnode(MNODE);
+
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
 				dgap_err("out of memory");
 				return -1;
 			}
 			p = p->next;
+			p->type = MNODE;
+
 			if (linecnt)
 				brd->u.board.module2++;
 			else
@@ -6862,12 +6881,16 @@ static int dgap_parsefile(char **in)
 		case PRINT:	/* transparent print name prefix */
 			if (dgap_checknode(p))
 				return -1;
-			p->next = dgap_newnode(PNODE);
+
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
 				dgap_err("out of memory");
 				return -1;
 			}
+
 			p = p->next;
+			p->type = PNODE;
+
 			s = dgap_getword(in);
 			if (!s) {
 				dgap_err("unexpeced end of file");
@@ -6883,12 +6906,16 @@ static int dgap_parsefile(char **in)
 		case CMAJOR:	/* major number */
 			if (dgap_checknode(p))
 				return -1;
-			p->next = dgap_newnode(JNODE);
+
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
 				dgap_err("out of memory");
 				return -1;
 			}
+
 			p = p->next;
+			p->type = JNODE;
+
 			s = dgap_getword(in);
 			if (!s) {
 				dgap_err("unexpected end of file");
@@ -6903,12 +6930,16 @@ static int dgap_parsefile(char **in)
 		case ALTPIN:	/* altpin setting */
 			if (dgap_checknode(p))
 				return -1;
-			p->next = dgap_newnode(ANODE);
+
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
 				dgap_err("out of memory");
 				return -1;
 			}
+
 			p = p->next;
+			p->type = ANODE;
+
 			s = dgap_getword(in);
 			if (!s) {
 				dgap_err("unexpected end of file");
@@ -6923,12 +6954,14 @@ static int dgap_parsefile(char **in)
 		case USEINTR:		/* enable interrupt setting */
 			if (dgap_checknode(p))
 				return -1;
-			p->next = dgap_newnode(INTRNODE);
+
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
 				dgap_err("out of memory");
 				return -1;
 			}
 			p = p->next;
+			p->type = INTRNODE;
 			s = dgap_getword(in);
 			if (!s) {
 				dgap_err("unexpected end of file");
@@ -6943,12 +6976,16 @@ static int dgap_parsefile(char **in)
 		case TTSIZ:	/* size of tty structure */
 			if (dgap_checknode(p))
 				return -1;
-			p->next = dgap_newnode(TSNODE);
+
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
 				dgap_err("out of memory");
 				return -1;
 			}
+
 			p = p->next;
+			p->type = TSNODE;
+
 			s = dgap_getword(in);
 			if (!s) {
 				dgap_err("unexpected end of file");
@@ -6963,12 +7000,16 @@ static int dgap_parsefile(char **in)
 		case CHSIZ:	/* channel structure size */
 			if (dgap_checknode(p))
 				return -1;
-			p->next = dgap_newnode(CSNODE);
+
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
 				dgap_err("out of memory");
 				return -1;
 			}
+
 			p = p->next;
+			p->type = CSNODE;
+
 			s = dgap_getword(in);
 			if (!s) {
 				dgap_err("unexpected end of file");
@@ -6983,12 +7024,16 @@ static int dgap_parsefile(char **in)
 		case BSSIZ:	/* board structure size */
 			if (dgap_checknode(p))
 				return -1;
-			p->next = dgap_newnode(BSNODE);
+
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
 				dgap_err("out of memory");
 				return -1;
 			}
+
 			p = p->next;
+			p->type = BSNODE;
+
 			s = dgap_getword(in);
 			if (!s) {
 				dgap_err("unexpected end of file");
@@ -7003,12 +7048,16 @@ static int dgap_parsefile(char **in)
 		case UNTSIZ:	/* sched structure size */
 			if (dgap_checknode(p))
 				return -1;
-			p->next = dgap_newnode(USNODE);
+
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
 				dgap_err("out of memory");
 				return -1;
 			}
+
 			p = p->next;
+			p->type = USNODE;
+
 			s = dgap_getword(in);
 			if (!s) {
 				dgap_err("unexpected end of file");
@@ -7023,12 +7072,16 @@ static int dgap_parsefile(char **in)
 		case F2SIZ:	/* f2200 structure size */
 			if (dgap_checknode(p))
 				return -1;
-			p->next = dgap_newnode(FSNODE);
+
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
 				dgap_err("out of memory");
 				return -1;
 			}
+
 			p = p->next;
+			p->type = FSNODE;
+
 			s = dgap_getword(in);
 			if (!s) {
 				dgap_err("unexpected end of file");
@@ -7043,12 +7096,16 @@ static int dgap_parsefile(char **in)
 		case VPSIZ:	/* vpix structure size */
 			if (dgap_checknode(p))
 				return -1;
-			p->next = dgap_newnode(VSNODE);
+
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
 				dgap_err("out of memory");
 				return -1;
 			}
+
 			p = p->next;
+			p->type = VSNODE;
+
 			s = dgap_getword(in);
 			if (!s) {
 				dgap_err("unexpected end of file");
@@ -7165,19 +7222,6 @@ static void dgap_err(char *s)
 }
 
 /*
- * allocate a new configuration node of type t
- */
-static struct cnode *dgap_newnode(int t)
-{
-	struct cnode *n;
-
-	n = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-	if (n)
-		n->type = t;
-	return n;
-}
-
-/*
  * dgap_checknode: see if all the necessary info has been supplied for a node
  * before creating the next node.
  */
-- 
1.7.1

