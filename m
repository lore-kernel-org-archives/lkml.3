Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab3KNCVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 21:21:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:29142 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab3KNCVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 21:21:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,696,1378882800"; 
   d="scan'208";a="433125040"
Subject: [PATCH V3] usbnet: fix race condition caused spinlock bad magic
 issue
From: wangbiao <biao.wang@intel.com>
To: oneukum@suse.de, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo.kernel.org@gmail.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        rusty@rustcorp.com.au, william.douglas@intel.com, di.zhang@intel.com,
        biao.wang@intel.com
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 14 Nov 2013 10:03:15 +0800
Message-ID: <1384394595.4229.24.camel@wangbiao>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wang, biao <biao.wang@intel.com>
Date: Mon, 11 Nov 2013 10:23:40 +0800
Subject: [PATCH] usbnet: fix race condition caused spinlock bad magic issue

there is race between usbnet_terminate_urbs and usbnet_bh.
for example:
    cpu 0                                     cpu 1
                                          usbnet_suspend
usbnet_bh {                               ->usbnet_terminate_urbs {
                                              dev->wait = &unlink_wakeup;
                                              while(....){..}//break
    if(dev->wait) is true
                       		              dev->wait=NULL
                                          }//unlink_wakeup is invalid
    __wake_up(dev->wait)//garbage value
}

the race is due to unprotection of dev->wait, so this patch involves a
spinlock to avoid it.

Signed-off-by: wang, biao <biao.wang@intel.com>
Signed-off-by: Zhang, Di <di.zhang@intel.com>
---
 drivers/net/usb/usbnet.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 90a429b..f7df1af 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -86,6 +86,7 @@ static const char driver_name [] = "usbnet";
 
 /* use ethtool to change the level for any given device */
 static int msg_level = -1;
+static spinlock_t dev_wait_lock = __SPIN_LOCK_UNLOCKED(dev_wait_lock);
 module_param (msg_level, int, 0);
 MODULE_PARM_DESC (msg_level, "Override default message level");
 
@@ -764,11 +765,14 @@ static void usbnet_terminate_urbs(struct usbnet *dev)
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(unlink_wakeup);
 	DECLARE_WAITQUEUE(wait, current);
 	int temp;
+	unsigned long flags;
 
 	/* ensure there are no more active urbs */
 	add_wait_queue(&unlink_wakeup, &wait);
 	set_current_state(TASK_UNINTERRUPTIBLE);
+	spin_lock_irqsave(&dev_wait_lock, flags);
 	dev->wait = &unlink_wakeup;
+	spin_unlock_irqrestore(&dev_wait_lock, flags);
 	temp = unlink_urbs(dev, &dev->txq) +
 		unlink_urbs(dev, &dev->rxq);
 
@@ -782,7 +786,9 @@ static void usbnet_terminate_urbs(struct usbnet *dev)
 				  "waited for %d urb completions\n", temp);
 	}
 	set_current_state(TASK_RUNNING);
+	spin_lock_irqsave(&dev_wait_lock, flags);
 	dev->wait = NULL;
+	spin_unlock_irqrestore(&dev_wait_lock, flags);
 	remove_wait_queue(&unlink_wakeup, &wait);
 }
 
@@ -1424,6 +1430,7 @@ static void usbnet_bh (unsigned long param)
 	struct usbnet		*dev = (struct usbnet *) param;
 	struct sk_buff		*skb;
 	struct skb_data		*entry;
+	unsigned long           flags;
 
 	while ((skb = skb_dequeue (&dev->done))) {
 		entry = (struct skb_data *) skb->cb;
@@ -1447,13 +1454,18 @@ static void usbnet_bh (unsigned long param)
 	clear_bit(EVENT_RX_KILL, &dev->flags);
 
 	// waiting for all pending urbs to complete?
+	spin_lock_irqsave(&dev_wait_lock, flags);
 	if (dev->wait) {
 		if ((dev->txq.qlen + dev->rxq.qlen + dev->done.qlen) == 0) {
-			wake_up (dev->wait);
+			wake_up(dev->wait);
 		}
+		spin_unlock_irqrestore(&dev_wait_lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&dev_wait_lock, flags);
 
 	// or are we maybe short a few urbs?
-	} else if (netif_running (dev->net) &&
+	if (netif_running(dev->net) &&
 		   netif_device_present (dev->net) &&
 		   netif_carrier_ok(dev->net) &&
 		   !timer_pending (&dev->delay) &&
-- 
1.7.0.4



