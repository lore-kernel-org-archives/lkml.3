Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaDRJaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:30:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:46015 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752370AbaDRJWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 58/72] usbnet: include wait queue head in device structure
Date: Fri, 18 Apr 2014 11:22:31 +0200
Message-Id: <0631987d442761501dc65c8ecb9a1267e0b2050d.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oneukum@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 14a0d635d18d0fb552dcc979d6d25106e6541f2e ]

This fixes a race which happens by freeing an object on the stack.
Quoting Julius:
> The issue is
> that it calls usbnet_terminate_urbs() before that, which temporarily
> installs a waitqueue in dev->wait in order to be able to wait on the
> tasklet to run and finish up some queues. The waiting itself looks
> okay, but the access to 'dev->wait' is totally unprotected and can
> race arbitrarily. I think in this case usbnet_bh() managed to succeed
> it's dev->wait check just before usbnet_terminate_urbs() sets it back
> to NULL. The latter then finishes and the waitqueue_t structure on its
> stack gets overwritten by other functions halfway through the
> wake_up() call in usbnet_bh().

The fix is to just not allocate the data structure on the stack.
As dev->wait is abused as a flag it also takes a runtime PM change
to fix this bug.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Reported-by: Grant Grundler <grundler@google.com>
Tested-by: Grant Grundler <grundler@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/usb/usbnet.c   | 33 +++++++++++++++++++--------------
 include/linux/usb/usbnet.h |  2 +-
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index a91fa49b81c3..1d4da74595f9 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -753,14 +753,12 @@ EXPORT_SYMBOL_GPL(usbnet_unlink_rx_urbs);
 // precondition: never called in_interrupt
 static void usbnet_terminate_urbs(struct usbnet *dev)
 {
-	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(unlink_wakeup);
 	DECLARE_WAITQUEUE(wait, current);
 	int temp;
 
 	/* ensure there are no more active urbs */
-	add_wait_queue(&unlink_wakeup, &wait);
+	add_wait_queue(&dev->wait, &wait);
 	set_current_state(TASK_UNINTERRUPTIBLE);
-	dev->wait = &unlink_wakeup;
 	temp = unlink_urbs(dev, &dev->txq) +
 		unlink_urbs(dev, &dev->rxq);
 
@@ -774,15 +772,14 @@ static void usbnet_terminate_urbs(struct usbnet *dev)
 				  "waited for %d urb completions\n", temp);
 	}
 	set_current_state(TASK_RUNNING);
-	dev->wait = NULL;
-	remove_wait_queue(&unlink_wakeup, &wait);
+	remove_wait_queue(&dev->wait, &wait);
 }
 
 int usbnet_stop (struct net_device *net)
 {
 	struct usbnet		*dev = netdev_priv(net);
 	struct driver_info	*info = dev->driver_info;
-	int			retval;
+	int			retval, pm;
 
 	clear_bit(EVENT_DEV_OPEN, &dev->flags);
 	netif_stop_queue (net);
@@ -792,6 +789,8 @@ int usbnet_stop (struct net_device *net)
 		   net->stats.rx_packets, net->stats.tx_packets,
 		   net->stats.rx_errors, net->stats.tx_errors);
 
+	/* to not race resume */
+	pm = usb_autopm_get_interface(dev->intf);
 	/* allow minidriver to stop correctly (wireless devices to turn off
 	 * radio etc) */
 	if (info->stop) {
@@ -818,6 +817,9 @@ int usbnet_stop (struct net_device *net)
 	dev->flags = 0;
 	del_timer_sync (&dev->delay);
 	tasklet_kill (&dev->bh);
+	if (!pm)
+		usb_autopm_put_interface(dev->intf);
+
 	if (info->manage_power &&
 	    !test_and_clear_bit(EVENT_NO_RUNTIME_PM, &dev->flags))
 		info->manage_power(dev, 0);
@@ -1438,11 +1440,12 @@ static void usbnet_bh (unsigned long param)
 	/* restart RX again after disabling due to high error rate */
 	clear_bit(EVENT_RX_KILL, &dev->flags);
 
-	// waiting for all pending urbs to complete?
-	if (dev->wait) {
-		if ((dev->txq.qlen + dev->rxq.qlen + dev->done.qlen) == 0) {
-			wake_up (dev->wait);
-		}
+	/* waiting for all pending urbs to complete?
+	 * only then can we forgo submitting anew
+	 */
+	if (waitqueue_active(&dev->wait)) {
+		if (dev->txq.qlen + dev->rxq.qlen + dev->done.qlen == 0)
+			wake_up_all(&dev->wait);
 
 	// or are we maybe short a few urbs?
 	} else if (netif_running (dev->net) &&
@@ -1581,6 +1584,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	dev->driver_name = name;
 	dev->msg_enable = netif_msg_init (msg_level, NETIF_MSG_DRV
 				| NETIF_MSG_PROBE | NETIF_MSG_LINK);
+	init_waitqueue_head(&dev->wait);
 	skb_queue_head_init (&dev->rxq);
 	skb_queue_head_init (&dev->txq);
 	skb_queue_head_init (&dev->done);
@@ -1792,9 +1796,10 @@ int usbnet_resume (struct usb_interface *intf)
 		spin_unlock_irq(&dev->txq.lock);
 
 		if (test_bit(EVENT_DEV_OPEN, &dev->flags)) {
-			/* handle remote wakeup ASAP */
-			if (!dev->wait &&
-				netif_device_present(dev->net) &&
+			/* handle remote wakeup ASAP
+			 * we cannot race against stop
+			 */
+			if (netif_device_present(dev->net) &&
 				!timer_pending(&dev->delay) &&
 				!test_bit(EVENT_RX_HALT, &dev->flags))
 					rx_alloc_submit(dev, GFP_NOIO);
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index e303eef94dd5..0662e98fef72 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -30,7 +30,7 @@ struct usbnet {
 	struct driver_info	*driver_info;
 	const char		*driver_name;
 	void			*driver_priv;
-	wait_queue_head_t	*wait;
+	wait_queue_head_t	wait;
 	struct mutex		phy_mutex;
 	unsigned char		suspend_count;
 	unsigned char		pkt_cnt, pkt_err;
-- 
1.9.2

