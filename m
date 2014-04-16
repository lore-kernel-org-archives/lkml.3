Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaDPKin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:38:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51788 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbaDPKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 36/46] isdnloop: several buffer overflows
Date: Wed, 16 Apr 2014 11:31:52 +0100
Message-Id: <1397644322-13905-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 7563487cbf865284dcd35e9ef5a95380da046737 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/isdn/isdnloop/isdnloop.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index e1f8748..5a4da94 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -518,9 +518,9 @@ static isdnloop_stat isdnloop_cmd_table[] =
 static void
 isdnloop_fake_err(isdnloop_card *card)
 {
-	char buf[60];
+	char buf[64];
 
-	sprintf(buf, "E%s", card->omsg);
+	snprintf(buf, sizeof(buf), "E%s", card->omsg);
 	isdnloop_fake(card, buf, -1);
 	isdnloop_fake(card, "NAK", -1);
 }
@@ -903,6 +903,8 @@ isdnloop_parse_cmd(isdnloop_card *card)
 	case 7:
 		/* 0x;EAZ */
 		p += 3;
+		if (strlen(p) >= sizeof(card->eazlist[0]))
+			break;
 		strcpy(card->eazlist[ch - 1], p);
 		break;
 	case 8:
@@ -1133,7 +1135,7 @@ isdnloop_command(isdn_ctrl *c, isdnloop_card *card)
 {
 	ulong a;
 	int i;
-	char cbuf[60];
+	char cbuf[80];
 	isdn_ctrl cmd;
 	isdnloop_cdef cdef;
 
@@ -1198,7 +1200,6 @@ isdnloop_command(isdn_ctrl *c, isdnloop_card *card)
 			break;
 		if ((c->arg & 255) < ISDNLOOP_BCH) {
 			char *p;
-			char dial[50];
 			char dcode[4];
 
 			a = c->arg;
@@ -1210,10 +1211,10 @@ isdnloop_command(isdn_ctrl *c, isdnloop_card *card)
 			} else
 				/* Normal Dial */
 				strcpy(dcode, "CAL");
-			strcpy(dial, p);
-			sprintf(cbuf, "%02d;D%s_R%s,%02d,%02d,%s\n", (int) (a + 1),
-				dcode, dial, c->parm.setup.si1,
-				c->parm.setup.si2, c->parm.setup.eazmsn);
+			snprintf(cbuf, sizeof(cbuf),
+				 "%02d;D%s_R%s,%02d,%02d,%s\n", (int) (a + 1),
+				 dcode, p, c->parm.setup.si1,
+				 c->parm.setup.si2, c->parm.setup.eazmsn);
 			i = isdnloop_writecmd(cbuf, strlen(cbuf), 0, card);
 		}
 		break;
-- 
1.9.1

