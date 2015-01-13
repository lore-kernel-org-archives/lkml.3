Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbbAMWAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:00:19 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:53127 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbbAMWAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:00:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: gregkh@linuxfoundation.org
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] tty/isicom: fix big-endian compile warning
Date: Tue, 13 Jan 2015 22:59:47 +0100
Message-ID: <2188320.G0IBCG4UeO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:mVujfDbwWWWRS7ne4lsHaAeFhPBlR3THUeZ/7qoXa6h0I3jryIl
 PFcPX+uCaVFm+NCxOwTnL053Awqrqo14J2tYSZhOTbyw74w8lvUOeMF6tnWZxgFyrdipZPZ
 KhbLDaDoCFFQTYMyZiie0PiUaZod2xR7noaUiBruit4Zvi556sPVF8B1qheLRvjkWGcTJQn
 YzrHu5NmVdlIIs0Zg1faA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building an arm allmodconfig kernel triggers a lengthy but harmless
warning in the isicom driver:

drvers/tty/isicom.c: In function 'isicom_send_break':
uapi/linux/swab.h:13:15: warning: integer overflow in expression [-Woverflow]
  (((__u16)(x) & (__u16)0x00ffU) << 8) |   \
               ^
uapi/linux/swab.h:107:2: note: in expansion of macro '___constant_swab16'
  ___constant_swab16(x) :   \
  ^
uapi/linux/byteorder/big_endian.h:34:43: note: in expansion of macro '__swab16'
 #define __cpu_to_le16(x) ((__force __le16)__swab16((x)))
                                           ^
linux/byteorder/generic.h:89:21: note: in expansion of macro '__cpu_to_le16'
 #define cpu_to_le16 __cpu_to_le16
                     ^
include/asm/io.h:270:6: note: in expansion of macro 'cpu_to_le16'
      cpu_to_le16(v),__io(p)); })
      ^
drivers/tty/isicom.c:1058:2: note: in expansion of macro 'outw'
  outw((length & 0xff00), base);
  ^

Apparently, the problem is related to the fact that the value 0xff00,
when used as a 16-bit number, is negative and passed into bitwise
operands of the generic byte swapping code.

Marking the input argument as unsigned in both technically correct
and avoids the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/tty/isicom.c b/drivers/tty/isicom.c
index 59ed783c4bcd..2054427992e0 100644
--- a/drivers/tty/isicom.c
+++ b/drivers/tty/isicom.c
@@ -1055,7 +1055,7 @@ static int isicom_send_break(struct tty_struct *tty, int length)
 
 	outw(0x8000 | ((port->channel) << (card->shift_count)) | 0x3, base);
 	outw((length & 0xff) << 8 | 0x00, base);
-	outw((length & 0xff00), base);
+	outw((length & 0xff00u), base);
 	InterruptTheCard(base);
 
 	unlock_card(card);

