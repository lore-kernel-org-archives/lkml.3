Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbbAGDkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 22:40:53 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:51308 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbbAGDku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 22:40:50 -0500
From: Chunyan Zhang <zhang.chunyan@linaro.org>
To: samuel@sortiz.org
Cc: arnd@linaro.org, zhang.lyra@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] driver/net/irda: Removed all unused timeval variables
Date: Wed,  7 Jan 2015 11:39:33 +0800
Message-Id: <1420601978-15866-2-git-send-email-zhang.chunyan@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420601978-15866-1-git-send-email-zhang.chunyan@linaro.org>
References: <driver-irda>
 <1420601978-15866-1-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the file au1k_ir.c & via-ircc.h, there were two unused
definitions of the timeval type members, so I removed them
entirely in this patch.

In other three files, the same problem is the rx_time
member is only ever written, never read, so removed it
entirely.

Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
---
 drivers/net/irda/au1k_ir.c     |    3 ---
 drivers/net/irda/kingsun-sir.c |    3 ---
 drivers/net/irda/ks959-sir.c   |    3 ---
 drivers/net/irda/mcs7780.c     |    2 --
 drivers/net/irda/mcs7780.h     |    1 -
 drivers/net/irda/via-ircc.h    |    4 ----
 6 files changed, 16 deletions(-)

diff --git a/drivers/net/irda/au1k_ir.c b/drivers/net/irda/au1k_ir.c
index e151205..44e4f38 100644
--- a/drivers/net/irda/au1k_ir.c
+++ b/drivers/net/irda/au1k_ir.c
@@ -24,7 +24,6 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
-#include <linux/time.h>
 #include <linux/types.h>
 #include <linux/ioport.h>
 
@@ -163,8 +162,6 @@ struct au1k_private {
 	iobuff_t rx_buff;
 
 	struct net_device *netdev;
-	struct timeval stamp;
-	struct timeval now;
 	struct qos_info qos;
 	struct irlap_cb *irlap;
 
diff --git a/drivers/net/irda/kingsun-sir.c b/drivers/net/irda/kingsun-sir.c
index e638893..fb5d162 100644
--- a/drivers/net/irda/kingsun-sir.c
+++ b/drivers/net/irda/kingsun-sir.c
@@ -114,7 +114,6 @@ struct kingsun_cb {
 					   (usually 8) */
 
 	iobuff_t  	  rx_buff;	/* receive unwrap state machine */
-	struct timeval	  rx_time;
 	spinlock_t lock;
 	int receiving;
 
@@ -235,7 +234,6 @@ static void kingsun_rcv_irq(struct urb *urb)
 						  &kingsun->netdev->stats,
 						  &kingsun->rx_buff, bytes[i]);
 			}
-			do_gettimeofday(&kingsun->rx_time);
 			kingsun->receiving =
 				(kingsun->rx_buff.state != OUTSIDE_FRAME)
 				? 1 : 0;
@@ -273,7 +271,6 @@ static int kingsun_net_open(struct net_device *netdev)
 
 	skb_reserve(kingsun->rx_buff.skb, 1);
 	kingsun->rx_buff.head = kingsun->rx_buff.skb->data;
-	do_gettimeofday(&kingsun->rx_time);
 
 	kingsun->rx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!kingsun->rx_urb)
diff --git a/drivers/net/irda/ks959-sir.c b/drivers/net/irda/ks959-sir.c
index e6b3804..8e6e0ed 100644
--- a/drivers/net/irda/ks959-sir.c
+++ b/drivers/net/irda/ks959-sir.c
@@ -187,7 +187,6 @@ struct ks959_cb {
 	__u8 *rx_buf;
 	__u8 rx_variable_xormask;
 	iobuff_t rx_unwrap_buff;
-	struct timeval rx_time;
 
 	struct usb_ctrlrequest *speed_setuprequest;
 	struct urb *speed_urb;
@@ -476,7 +475,6 @@ static void ks959_rcv_irq(struct urb *urb)
 						  bytes[i]);
 			}
 		}
-		do_gettimeofday(&kingsun->rx_time);
 		kingsun->receiving =
 		    (kingsun->rx_unwrap_buff.state != OUTSIDE_FRAME) ? 1 : 0;
 	}
@@ -514,7 +512,6 @@ static int ks959_net_open(struct net_device *netdev)
 
 	skb_reserve(kingsun->rx_unwrap_buff.skb, 1);
 	kingsun->rx_unwrap_buff.head = kingsun->rx_unwrap_buff.skb->data;
-	do_gettimeofday(&kingsun->rx_time);
 
 	kingsun->rx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!kingsun->rx_urb)
diff --git a/drivers/net/irda/mcs7780.c b/drivers/net/irda/mcs7780.c
index e4d678f..bca6a1e 100644
--- a/drivers/net/irda/mcs7780.c
+++ b/drivers/net/irda/mcs7780.c
@@ -722,7 +722,6 @@ static int mcs_net_open(struct net_device *netdev)
 
 	skb_reserve(mcs->rx_buff.skb, 1);
 	mcs->rx_buff.head = mcs->rx_buff.skb->data;
-	do_gettimeofday(&mcs->rx_time);
 
 	/*
 	 * Now that everything should be initialized properly,
@@ -799,7 +798,6 @@ static void mcs_receive_irq(struct urb *urb)
 			mcs_unwrap_fir(mcs, urb->transfer_buffer,
 				urb->actual_length);
 		}
-		do_gettimeofday(&mcs->rx_time);
 	}
 
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
diff --git a/drivers/net/irda/mcs7780.h b/drivers/net/irda/mcs7780.h
index b10689b..a6e8f7d 100644
--- a/drivers/net/irda/mcs7780.h
+++ b/drivers/net/irda/mcs7780.h
@@ -116,7 +116,6 @@ struct mcs_cb {
 	__u8 *fifo_status;
 
 	iobuff_t rx_buff;	/* receive unwrap state machine */
-	struct timeval rx_time;
 	spinlock_t lock;
 	int receiving;
 
diff --git a/drivers/net/irda/via-ircc.h b/drivers/net/irda/via-ircc.h
index 7ce820e..ac15255 100644
--- a/drivers/net/irda/via-ircc.h
+++ b/drivers/net/irda/via-ircc.h
@@ -29,7 +29,6 @@ this program; if not, see <http://www.gnu.org/licenses/>.
  ********************************************************************/
 #ifndef via_IRCC_H
 #define via_IRCC_H
-#include <linux/time.h>
 #include <linux/spinlock.h>
 #include <linux/pm.h>
 #include <linux/types.h>
@@ -106,9 +105,6 @@ struct via_ircc_cb {
 
 	__u8 ier;		/* Interrupt enable register */
 
-	struct timeval stamp;
-	struct timeval now;
-
 	spinlock_t lock;	/* For serializing operations */
 
 	__u32 flags;		/* Interface flags */
-- 
1.7.9.5

