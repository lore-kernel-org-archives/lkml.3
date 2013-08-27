Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab3H0Or4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:47:56 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27176 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3H0Orn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:47:43 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-5f-521cbc0db92c
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org
Cc: dmitry.kasatkin@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCHv2 2/2] xhci:prevent "callbacks suppressed" when debug is not
 enabled
Date: Tue, 27 Aug 2013 17:47:35 +0300
Message-id: <7a445b01abe657f0771a9c488e9afcf71d0a5d55.1377614854.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <7f53397d0aa93e644124037d44188da5067336fc.1377614854.git.d.kasatkin@samsung.com>
References: <7f53397d0aa93e644124037d44188da5067336fc.1377614854.git.d.kasatkin@samsung.com>
In-reply-to: <7f53397d0aa93e644124037d44188da5067336fc.1377614854.git.d.kasatkin@samsung.com>
References: <7f53397d0aa93e644124037d44188da5067336fc.1377614854.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xq7q8e2SCDI4t1bH4srTOonnxejaL
	y7vmsFk0nzjF7MDisXPWXXaPeScDPfbPXcPu8XmTXABLFJdNSmpOZllqkb5dAlfGnnONjAVb
	BCsOTJjG0sD4lreLkZNDQsBEYv3dLkYIW0ziwr31bF2MXBxCAksZJaa2LWCEcDqZJJbeaGIH
	qWIT0JPY0PwDzBYRsJX4eu8gM4jNLGAtsajxNwuILSwQJnFj5nKwOIuAqsTvQ1/BbF6BOIll
	++4xQ2xTkPh5+QQbiM0pEC9xa9ICsCuEgGomvNzMjEt8AiP/AkaGVYyiqaXJBcVJ6bmGesWJ
	ucWleel6yfm5mxghofVlB+PiY1aHGAU4GJV4eC02ywQJsSaWFVfmHmKU4GBWEuHdvQIoxJuS
	WFmVWpQfX1Sak1p8iJGJg1OqgTGc1YSZYcE//YfNoRlnN63iO3ujXyD7pr3+hp1ZVx8Zd00q
	ebLp3VzpAi8NHV+W+pk1H2es4ZyR1Vjx8WPxsv7T/OwWt/WmxHgmrWApfLhwXTrzpZg0j2ka
	rcmdXQFe3j8Xiv0PPtp+5bz1n47zhSmcdlmu8qqZl0V1y3dvEKw9YnKO9cxhASWW4oxEQy3m
	ouJEAB/XI8ALAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When debug is not enabled and dev_dbg() will expand to nothing,
log might be flooded with "callbacks suppressed". If it was not
done on purpose, better to use dev_dbg_ratelimited() instead.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 drivers/usb/host/xhci-ring.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 5b08cd8..3cbf1c0 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3060,14 +3060,10 @@ int xhci_queue_intr_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 	 * to set the polling interval (once the API is added).
 	 */
 	if (xhci_interval != ep_interval) {
-		if (printk_ratelimit())
-			dev_dbg(&urb->dev->dev, "Driver uses different interval"
-					" (%d microframe%s) than xHCI "
-					"(%d microframe%s)\n",
-					ep_interval,
-					ep_interval == 1 ? "" : "s",
-					xhci_interval,
-					xhci_interval == 1 ? "" : "s");
+		dev_dbg_ratelimited(&urb->dev->dev,
+				"Driver uses different interval (%d microframe%s) than xHCI (%d microframe%s)\n",
+				ep_interval, ep_interval == 1 ? "" : "s",
+				xhci_interval, xhci_interval == 1 ? "" : "s");
 		urb->interval = xhci_interval;
 		/* Convert back to frames for LS/FS devices */
 		if (urb->dev->speed == USB_SPEED_LOW ||
@@ -3849,14 +3845,10 @@ int xhci_queue_isoc_tx_prepare(struct xhci_hcd *xhci, gfp_t mem_flags,
 	 * to set the polling interval (once the API is added).
 	 */
 	if (xhci_interval != ep_interval) {
-		if (printk_ratelimit())
-			dev_dbg(&urb->dev->dev, "Driver uses different interval"
-					" (%d microframe%s) than xHCI "
-					"(%d microframe%s)\n",
-					ep_interval,
-					ep_interval == 1 ? "" : "s",
-					xhci_interval,
-					xhci_interval == 1 ? "" : "s");
+		dev_dbg_ratelimited(&urb->dev->dev,
+				"Driver uses different interval (%d microframe%s) than xHCI (%d microframe%s)\n",
+				ep_interval, ep_interval == 1 ? "" : "s",
+				xhci_interval, xhci_interval == 1 ? "" : "s");
 		urb->interval = xhci_interval;
 		/* Convert back to frames for LS/FS devices */
 		if (urb->dev->speed == USB_SPEED_LOW ||
-- 
1.8.1.2

