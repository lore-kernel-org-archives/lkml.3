Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3EGOVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:21:33 -0400
Received: from ip4-83-240-18-99.cust.nbox.cz ([83.240.18.99]:59356 "EHLO
	anemoi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752720Ab3EGOSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:18:03 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, "salina@us.ibm.com" <salina@us.ibm.com>,
        okir@suse.de, Jiri Slaby <jslaby@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 01/15] Char: lp, protect LPGETSTATUS with port_mutex
Date: Tue,  7 May 2013 16:18:09 +0200
Message-Id: <1367936303-13386-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "salina@us.ibm.com" <salina@us.ibm.com>

The patch fixes a problem in the lp driver that can cause oopses as
follows:
process A:	calls lp_write, which in turn calls
		parport_ieee1284_write_compat, and that invokes
		parport_wait_peripheral
process B:	meanwhile does an ioctl(LPGETSTATUS), which call
		lp_release_parport when done. This function will set
		physport->cad = NULL.
process A:	parport_wait_peripheral tries to dereference
		physport->cad and dies

So, protect that code with the port_mutex in order to protect against
simultaneous calls to lp_read/lp_write.

Similar protection is probably required for ioctl(LPRESET)...

This patch was done by IBM a while back and we (at suse) have that
since at least 2004 in our repos. Let's make it upstream.

Signed-off-by: okir@suse.de
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/lp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index dafd9ac..0913d79 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -622,9 +622,12 @@ static int lp_do_ioctl(unsigned int minor, unsigned int cmd,
 				return -EFAULT;
 			break;
 		case LPGETSTATUS:
+			if (mutex_lock_interruptible(&lp_table[minor].port_mutex))
+				return -EINTR;
 			lp_claim_parport_or_block (&lp_table[minor]);
 			status = r_str(minor);
 			lp_release_parport (&lp_table[minor]);
+			mutex_unlock(&lp_table[minor].port_mutex);
 
 			if (copy_to_user(argp, &status, sizeof(int)))
 				return -EFAULT;
-- 
1.8.2.1

