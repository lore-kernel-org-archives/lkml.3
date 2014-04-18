Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaDRJ01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:26:27 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:46052 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbaDRJWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:50 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 68/72] isdnloop: several buffer overflows
Date: Fri, 18 Apr 2014 11:22:41 +0200
Message-Id: <f11c98eec721c6c00d1c56289ebf35971037b967.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/isdn/isdnloop/isdnloop.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index e1f8748ff25d..5a4da94aefb0 100644
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
1.9.2

