Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaDALhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:37:07 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:57329 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753092AbaDALhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:37:03 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/1] serial: 8250, disable "too much work" messages
Date: Tue,  1 Apr 2014 13:37:00 +0200
Message-Id: <1396352220-5031-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 8250 driver now reports many of these:
  serial8250: too much work for irq4
These messages turned out to be common these days with a use of
virtualization. I tried to increase the limit of processed characters
in commit e7328ae1848966181a7ac47e8ae6cddbd2cf55f3 (serial: 8250,
increase PASS_LIMIT) in 2011. It was raised from 256 to 512, but it is
still not enough, apparently.

So disable the warning unless somebody turns on DEBUG (or
DYNAMIC_DEBUG _and_ the message).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Martin Pluskal <mpluskal@suse.com>
Reported-by: Takashi Iwai <tiwai@suse.com>
References: https://bugzilla.novell.com/show_bug.cgi?id=868394
---
 drivers/tty/serial/8250/8250_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 81f909c2101f..139ab1997e06 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1601,8 +1601,7 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 		l = l->next;
 
 		if (l == i->head && pass_counter++ > PASS_LIMIT) {
-			/* If we hit this, we're dead. */
-			printk_ratelimited(KERN_ERR
+			pr_debug_ratelimited(
 				"serial8250: too much work for irq%d\n", irq);
 			break;
 		}
-- 
1.9.1

