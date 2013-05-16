Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab3EPGqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 02:46:24 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:37817 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3EPGqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 02:46:21 -0400
Message-ID: <519480A1.6030909@ahsoftware.de>
Date: Thu, 16 May 2013 08:45:53 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: BUG: tty: memory corruption through tty_release/tty_ldisc_release
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

after some pain because the "big step" (ecbbfd4) happened while the 
support for my AMD CPU was broken and thus git bisect hit a series of 
kernels which didn't boot, I've finally found the cause for a memory 
corruption: tty_ldisc_release().

What happens is the following:

tty_port is self-destructing, that means it destroys itself in 
tty_port.c:tty_port_destructor() when the last reference is gone. E.g. 
in case of rfcomm this happens with the call to tty->ops->close() in 
tty_io.c:tty_release().

The problem here is that tty_io.c:tty_release() calls 
tty_ldisc.c:tty_ldisc_release() which uses the tty_port to flush the 
ldisc work queues.

In the best case this hits a BUG() in cancel_work_sync() but often it 
just causes a memory corruption without a BUG() got hit before.

My quick fix (the diff below) is to remove the call to 
tty_ldisc_release() but I'm very doubtful that this is the correct 
approach, as I'm not very familiar with the tty subsystem and therefor 
I'm not sure if it is necessary to flush the ldisc queues. Another 
solution could be to move the call to tty_ldisc_release() to 
tty_port.c:tty_port_destructor().

If the patch finds friends, it could be enhanced to remove
tty_ldisc.c:tty_ldisc_release() too, tty_release() is the only user of 
that function.

I've added the bluetooth people to cc, because rfcomm is one user of 
tty_release() which gets hit by this bug whenever a connected (rfcomm) 
remote device disappears.

Regards,

Alexander Holler


(The format of the patch below is likely broken, but I don't care, as it 
is just a RFC.)

 From 4a1d24e5334668f6cd82937d574cd75b5e372a75 Mon Sep 17 00:00:00 2001
From: Alexander Holler <holler@ahsoftware.de>
Date: Thu, 16 May 2013 08:21:22 +0200
Subject: [PATCH] tty: don't call tty_ldisc_release() because tty_port likely
  disappeared before

tty_port destroys itself when the last reference is gone, therefor
tty_ldisc_release() can't be called afterwards.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
  drivers/tty/tty_io.c | 4 ----
  1 file changed, 4 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 6464029..9c9ad04 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1850,10 +1850,6 @@ int tty_release(struct inode *inode, struct file 
*filp)
  #ifdef TTY_DEBUG_HANGUP
  	printk(KERN_DEBUG "%s: %s: final close\n", __func__, tty_name(tty, buf));
  #endif
-	/*
-	 * Ask the line discipline code to release its structures
-	 */
-	tty_ldisc_release(tty, o_tty);

  	/* Wait for pending work before tty destruction commmences */
  	tty_flush_works(tty);
-- 
1.8.1.4

