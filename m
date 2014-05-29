Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209AbaE2FRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:17:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593AbaE2Efd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 100/140] slip: fix spinlock variant
Date: Wed, 28 May 2014 21:33:59 -0700
Message-Id: <20140529043102.420859131@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit ddcde142bed44490e338ed1124cb149976d355bb ]

With commit cc9fa74e2a ("slip/slcan: added locking in wakeup function") a
formerly missing locking was added to slip.c and slcan.c by Andre Naujoks.

Alexander Stein contributed the fix 367525c8c2 ("can: slcan: Fix spinlock
variant") as the kernel lock debugging advised to use spin_lock_bh() instead
of just using spin_lock().

This fix has to be applied to the same code section in slip.c for the same
reason too.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/slip/slip.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -429,13 +429,13 @@ static void slip_write_wakeup(struct tty
 	if (!sl || sl->magic != SLIP_MAGIC || !netif_running(sl->dev))
 		return;
 
-	spin_lock(&sl->lock);
+	spin_lock_bh(&sl->lock);
 	if (sl->xleft <= 0)  {
 		/* Now serial buffer is almost free & we can start
 		 * transmission of another packet */
 		sl->dev->stats.tx_packets++;
 		clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-		spin_unlock(&sl->lock);
+		spin_unlock_bh(&sl->lock);
 		sl_unlock(sl);
 		return;
 	}
@@ -443,7 +443,7 @@ static void slip_write_wakeup(struct tty
 	actual = tty->ops->write(tty, sl->xhead, sl->xleft);
 	sl->xleft -= actual;
 	sl->xhead += actual;
-	spin_unlock(&sl->lock);
+	spin_unlock_bh(&sl->lock);
 }
 
 static void sl_tx_timeout(struct net_device *dev)


