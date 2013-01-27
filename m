Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3A0Tlh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 14:41:37 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34173 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab3A0Tle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 14:41:34 -0500
Date: Sun, 27 Jan 2013 22:40:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] TTY: synclink, small cleanup in dtr_rts()
Message-ID: <20130127194039.GA18787@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a kind of precedence problem here, but it doesn't affect how
the code works because ->serial_signals is unsigned char.  We want to
clear two flags here.

#define SerialSignal_RTS            0x20     /* Request to Send */
#define SerialSignal_DTR            0x80     /* Data Terminal Ready */

Without the parenthesis then it does:

	info->serial_signals &= 0x5f;

With the parenthesis it does:

	info->serial_signals &= 0xffffff5f;

info->serial_signals is an unsigned char so the two statements are
equivalent, but it's cleaner to add the parenthesis.  In other dtr_rts()
functions the parenthesis are there so this makes it more consistent.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 34e52ed..749fc05 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2466,7 +2466,7 @@ static void dtr_rts(struct tty_port *port, int onoff)
 	if (onoff)
 		info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
 	else
-		info->serial_signals &= ~SerialSignal_RTS + SerialSignal_DTR;
+		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
 	set_signals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 }
