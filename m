Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab3KMB36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 20:29:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:15513 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab3KMB3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 20:29:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,689,1378882800"; 
   d="scan'208";a="426554509"
Subject: [PATCH V2] usbnet: fix race condition caused spinlock bad magic
 issue
From: wangbiao <biao.wang@intel.com>
To: oneukum@suse.de, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo.kernel.org@gmail.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        rusty@rustcorp.com.au, william.douglas@intel.com, di.zhang@intel.com,
        biao.wang@intel.com
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 13 Nov 2013 09:11:25 +0800
Message-ID: <1384305085.19509.5.camel@wangbiao>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wang, biao <biao.wang@intel.com>
Date: Mon, 11 Nov 2013 10:23:40 +0800
Subject: [PATCH] usbnet: fix race condition caused spinlock bad magic issue

1, there is race between usbnet_terminate_urbs and usbnet_bh, when
unlink_wakeup used in usbnet_bh, it may be already freed and used by
other function as unlink_wakeup was a local var on stack.
for example:
    cpu 0:                              cpu 1:
                                    usb_suspend_both
                                    ->usbnet_suspend
usbnet_bh                           ->usbnet_terminate_urbs
->__wake_up
->_raw_spin_unlock_irqrestore
->do_raw_spin_unlock
->spin_bug
when usbnet_terminate_urbs complete execution and memory of unlink_wakeup was
used by other function, then usbnet_bh may still use it.

2, for the same reason,dev->wait should be judged again before use it,
as between the judge point(if(dev->wait)) and use point(wakeup(dev->wait)),
the dev->wait may be set NULL by another cpu.

for issue 1, declare  unlink_wakeup in global section instead of on stack.
for issue 2, use a temporary local var to keep the value of dev->wait
in stack and judge it before using.

Signed-off-by: wang, biao <biao.wang@intel.com>
Acked-by: Ingo Molnar <mingo.kernel.org@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.de>
Acked-by: Zhang, Di <di.zhang@intel.com>
---
 drivers/net/usb/usbnet.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 90a429b..0603ef6 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -86,6 +86,7 @@ static const char driver_name [] = "usbnet";
 
 /* use ethtool to change the level for any given device */
 static int msg_level = -1;
+static DECLARE_WAIT_QUEUE_HEAD(unlink_wakeup);
 module_param (msg_level, int, 0);
 MODULE_PARM_DESC (msg_level, "Override default message level");
 
@@ -761,7 +762,6 @@ EXPORT_SYMBOL_GPL(usbnet_unlink_rx_urbs);
 // precondition: never called in_interrupt
 static void usbnet_terminate_urbs(struct usbnet *dev)
 {
-	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(unlink_wakeup);
 	DECLARE_WAITQUEUE(wait, current);
 	int temp;
 
@@ -1449,7 +1449,9 @@ static void usbnet_bh (unsigned long param)
 	// waiting for all pending urbs to complete?
 	if (dev->wait) {
 		if ((dev->txq.qlen + dev->rxq.qlen + dev->done.qlen) == 0) {
-			wake_up (dev->wait);
+			wait_queue_head_t *wait_d = dev->wait;
+			if (wait_d)
+				wake_up(wait_d);
 		}
 
 	// or are we maybe short a few urbs?
-- 
1.7.0.4



