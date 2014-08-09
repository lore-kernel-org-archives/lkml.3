Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaHIFjt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 01:39:49 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37782 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaHIFjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 01:39:46 -0400
Date: Sat, 9 Aug 2014 14:38:14 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] staging: dgap: Simplify set a board type from
 configration file
Message-ID: <20140809053814.GA14655@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Board types need to separate normal command like IO, MEM and so on.
And the board type will come after "board" string in config file normally.
(If it is not, dgap_gettok returns an error with zero)
After that, set a variable of a number which is matched with specific
a board number to "board.type". The dgap_gettok() returns that number so
just set to "board.type" and also "v_type" can be removed.

In case of boards of PCI type are set variables to zero. These can
be removed because "p" as cnode get memory from kzalloc so already
set to zero.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |  109 ++++++------------------------------------
 drivers/staging/dgap/dgap.h |    1 -
 2 files changed, 16 insertions(+), 94 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 51f9ebc..7fb54d1 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -399,10 +399,7 @@ struct toklist {
 	char *string;
 };
 
-static struct toklist dgap_tlist[] = {
-	{ BEGIN,	"config_begin" },
-	{ END,		"config_end" },
-	{ BOARD,	"board"	},
+static struct toklist dgap_brdtype[] = {
 	{ PCX,		"Digi_AccelePort_C/X_PCI" },
 	{ PEPC,		"Digi_AccelePort_EPC/X_PCI" },
 	{ PPCM,		"Digi_AccelePort_Xem_PCI" },
@@ -411,6 +408,13 @@ static struct toklist dgap_tlist[] = {
 	{ APORT8_920P,	"Digi_AccelePort_8r_920_PCI" },
 	{ PAPORT4,	"Digi_AccelePort_4r_PCI(EIA-232/RS-422)" },
 	{ PAPORT8,	"Digi_AccelePort_8r_PCI(EIA-232/RS-422)" },
+	{ 0, NULL }
+};
+
+static struct toklist dgap_tlist[] = {
+	{ BEGIN,	"config_begin" },
+	{ END,		"config_end" },
+	{ BOARD,	"board"	},
 	{ IO,		"io" },
 	{ PCIINFO,	"pciinfo" },
 	{ LINE,		"line" },
@@ -6382,6 +6386,8 @@ static int dgap_parsefile(char **in)
 	}
 
 	for (; ;) {
+		int board_type = 0;
+
 		rc = dgap_gettok(in);
 		if (rc == 0) {
 			dgap_err("unexpected EOF");
@@ -6412,88 +6418,13 @@ static int dgap_parsefile(char **in)
 			line = conc = NULL;
 			brd = p;
 			linecnt = -1;
-			break;
-
-		case APORT2_920P:	/* AccelePort_4 */
-			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_2r_920 string");
-				return -1;
-			}
-			p->u.board.type = APORT2_920P;
-			p->u.board.v_type = 1;
-			break;
 
-		case APORT4_920P:	/* AccelePort_4 */
-			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_4r_920 string");
+			board_type = dgap_gettok(in);
+			if (board_type == 0)
 				return -1;
-			}
-			p->u.board.type = APORT4_920P;
-			p->u.board.v_type = 1;
-			break;
 
-		case APORT8_920P:	/* AccelePort_8 */
-			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_8r_920 string");
-				return -1;
-			}
-			p->u.board.type = APORT8_920P;
-			p->u.board.v_type = 1;
-			break;
+			p->u.board.type = board_type;
 
-		case PAPORT4:	/* AccelePort_4 PCI */
-			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_4r(PCI) string");
-				return -1;
-			}
-			p->u.board.type = PAPORT4;
-			p->u.board.v_type = 1;
-			break;
-
-		case PAPORT8:	/* AccelePort_8 PCI */
-			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_8r string");
-				return -1;
-			}
-			p->u.board.type = PAPORT8;
-			p->u.board.v_type = 1;
-			break;
-
-		case PCX:	/* PCI C/X */
-			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_C/X_(PCI) string");
-				return -1;
-			}
-			p->u.board.type = PCX;
-			p->u.board.v_type = 1;
-			p->u.board.conc1 = 0;
-			p->u.board.conc2 = 0;
-			p->u.board.module1 = 0;
-			p->u.board.module2 = 0;
-			break;
-
-		case PEPC:	/* PCI EPC/X */
-			if (p->type != BNODE) {
-				dgap_err("unexpected \"Digi_EPC/X_(PCI)\" string");
-				return -1;
-			}
-			p->u.board.type = PEPC;
-			p->u.board.v_type = 1;
-			p->u.board.conc1 = 0;
-			p->u.board.conc2 = 0;
-			p->u.board.module1 = 0;
-			p->u.board.module2 = 0;
-			break;
-
-		case PPCM:	/* PCI/Xem */
-			if (p->type != BNODE) {
-				dgap_err("unexpected PCI/Xem string");
-				return -1;
-			}
-			p->u.board.type = PPCM;
-			p->u.board.v_type = 1;
-			p->u.board.conc1 = 0;
-			p->u.board.conc2 = 0;
 			break;
 
 		case IO:	/* i/o port */
@@ -7198,12 +7129,11 @@ static int dgap_gettok(char **in)
 	if (strstr(dgap_cword, "board")) {
 		w = dgap_getword(in);
 		snprintf(dgap_cword, MAXCWORD, "%s", w);
-		for (t = dgap_tlist; t->token != 0; t++) {
+		for (t = dgap_brdtype; t->token != 0; t++) {
 			if (!strcmp(w, t->string))
 				return t->token;
 		}
 		dgap_err("board !!type not specified");
-		return 1;
 	} else {
 		while ((w = dgap_getword(in))) {
 			snprintf(dgap_cword, MAXCWORD, "%s", w);
@@ -7212,8 +7142,9 @@ static int dgap_gettok(char **in)
 					return t->token;
 			}
 		}
-		return 0;
 	}
+
+	return 0;
 }
 
 /*
@@ -7261,14 +7192,6 @@ static void dgap_err(char *s)
 static int dgap_checknode(struct cnode *p)
 {
 	switch (p->type) {
-	case BNODE:
-		if (p->u.board.v_type == 0) {
-			dgap_err("board type !not specified");
-			return 1;
-		}
-
-		return 0;
-
 	case LNODE:
 		if (p->u.line.v_speed == 0) {
 			dgap_err("line speed not specified");
diff --git a/drivers/staging/dgap/dgap.h b/drivers/staging/dgap/dgap.h
index 0482a4c..c01aa28 100644
--- a/drivers/staging/dgap/dgap.h
+++ b/drivers/staging/dgap/dgap.h
@@ -1172,7 +1172,6 @@ struct cnode {
 			char  *id;	/* tty id		*/
 			long  start;	/* start of tty counting */
 			char  *method;  /* Install method       */
-			char  v_type;
 			char  v_port;
 			char  v_addr;
 			char  v_pcibus;
-- 
1.7.1

