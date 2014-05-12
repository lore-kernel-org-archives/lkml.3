Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaELBmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:42:45 -0400
Received: from 1wt.eu ([62.212.114.60]:34601 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbaELBml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:41 -0400
Message-Id: <20140512003205.169961121@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:49 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 109/143] isdnloop: several buffer overflows
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 7563487cbf865284dcd35e9ef5a95380da046737 ]

There are three buffer overflows addressed in this patch.

1) In isdnloop_fake_err() we add an 'E' to a 60 character string and
then copy it into a 60 character buffer.  I have made the destination
buffer 64 characters and I'm changed the sprintf() to a snprintf().

2) In isdnloop_parse_cmd(), p points to a 6 characters into a 60
character buffer so we have 54 characters.  The ->eazlist[] is 11
characters long.  I have modified the code to return if the source
buffer is too long.

3) In isdnloop_command() the cbuf[] array was 60 characters long but the
max length of the string then can be up to 79 characters.  I made the
cbuf array 80 characters long and changed the sprintf() to snprintf().
I also removed the temporary "dial" buffer and changed it to use "p"
directly.

Unfortunately, we pass the "cbuf" string from isdnloop_command() to
isdnloop_writecmd() which truncates anything over 60 characters to make
it fit in card->omsg[].  (It can accept values up to 255 characters so
long as there is a '\n' character every 60 characters).  For now I have
just fixed the memory corruption bug and left the other problems in this
driver alone.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/isdn/isdnloop/isdnloop.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index 92d895f..bf4168b 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -517,9 +517,9 @@ static isdnloop_stat isdnloop_cmd_table[] =
 static void
 isdnloop_fake_err(isdnloop_card * card)
 {
-	char buf[60];
+	char buf[64];
 
-	sprintf(buf, "E%s", card->omsg);
+	snprintf(buf, sizeof(buf), "E%s", card->omsg);
 	isdnloop_fake(card, buf, -1);
 	isdnloop_fake(card, "NAK", -1);
 }
@@ -902,6 +902,8 @@ isdnloop_parse_cmd(isdnloop_card * card)
 		case 7:
 			/* 0x;EAZ */
 			p += 3;
+			if (strlen(p) >= sizeof(card->eazlist[0]))
+				break;
 			strcpy(card->eazlist[ch - 1], p);
 			break;
 		case 8:
@@ -1126,7 +1128,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop_card * card)
 {
 	ulong a;
 	int i;
-	char cbuf[60];
+	char cbuf[80];
 	isdn_ctrl cmd;
 	isdnloop_cdef cdef;
 
@@ -1191,7 +1193,6 @@ isdnloop_command(isdn_ctrl * c, isdnloop_card * card)
 				break;
 			if ((c->arg & 255) < ISDNLOOP_BCH) {
 				char *p;
-				char dial[50];
 				char dcode[4];
 
 				a = c->arg;
@@ -1203,10 +1204,10 @@ isdnloop_command(isdn_ctrl * c, isdnloop_card * card)
 				} else
 					/* Normal Dial */
 					strcpy(dcode, "CAL");
-				strcpy(dial, p);
-				sprintf(cbuf, "%02d;D%s_R%s,%02d,%02d,%s\n", (int) (a + 1),
-					dcode, dial, c->parm.setup.si1,
-				c->parm.setup.si2, c->parm.setup.eazmsn);
+				snprintf(cbuf, sizeof(cbuf),
+					 "%02d;D%s_R%s,%02d,%02d,%s\n", (int) (a + 1),
+					 dcode, p, c->parm.setup.si1,
+					 c->parm.setup.si2, c->parm.setup.eazmsn);
 				i = isdnloop_writecmd(cbuf, strlen(cbuf), 0, card);
 			}
 			break;
-- 
1.7.12.2.21.g234cd45.dirty



