Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab3EUK13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:27:29 -0400
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:54074 "EHLO lnfm1.sai.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab3EUK11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:27:27 -0400
X-Greylist: delayed 1778 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2013 06:27:27 EDT
Date: Tue, 21 May 2013 13:57:37 +0400 (MSK)
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: jirislaby@gmail.com
cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty: mxser: fix usage of opmode_ioaddr
Message-ID: <alpine.LRH.2.00.1305211349360.20113@lnfm1.sai.msu.ru>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matwey V. Kornilov <matwey@sai.msu.ru>

mxser_port->opmode_ioaddr is initialized only for MOXA_MUST_MU860_HWID 
chips, but no precautions have been undertaken to prevent reading and 
writing to undefined port number.

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 71d6eb2..f97b196 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -1618,8 +1618,12 @@ static int mxser_ioctl_special(unsigned int cmd, void __user *argp)
  				if (ip->type == PORT_16550A)
  					me->fifo[p] = 1;

-				opmode = inb(ip->opmode_ioaddr)>>((p % 4) * 2);
-				opmode &= OP_MODE_MASK;
+				if (ip->board->chip_flag == MOXA_MUST_MU860_HWID) {
+					opmode = inb(ip->opmode_ioaddr)>>((p % 4) * 2);
+					opmode &= OP_MODE_MASK;
+				} else {
+					opmode = RS232_MODE;
+				}
  				me->iftype[p] = opmode;
  				mutex_unlock(&port->mutex);
  			}
@@ -1670,6 +1674,9 @@ static int mxser_ioctl(struct tty_struct *tty,
  		return mxser_ioctl_special(cmd, argp);

  	if (cmd == MOXA_SET_OP_MODE || cmd == MOXA_GET_OP_MODE) {
+		if (info->board->chip_flag != MOXA_MUST_MU860_HWID)
+			return -EFAULT;
+
  		int p;
  		unsigned long opmode;
  		static unsigned char ModeMask[] = { 0xfc, 0xf3, 0xcf, 0x3f };
