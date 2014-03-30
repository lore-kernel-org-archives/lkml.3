Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbaC3XgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:36:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36472 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753087AbaC3XZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Emil Goode" <emilgoode@gmail.com>,
        "Igor Gnatenko" <i.gnatenko.brain@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.711981166@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 189/200] usbnet: remove generic hard_header_len check
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Goode <emilgoode@gmail.com>

[ Upstream commit eb85569fe2d06c2fbf4de7b66c263ca095b397aa ]

This patch removes a generic hard_header_len check from the usbnet
module that is causing dropped packages under certain circumstances
for devices that send rx packets that cross urb boundaries.

One example is the AX88772B which occasionally send rx packets that
cross urb boundaries where the remaining partial packet is sent with
no hardware header. When the buffer with a partial packet is of less
number of octets than the value of hard_header_len the buffer is
discarded by the usbnet module.

With AX88772B this can be reproduced by using ping with a packet
size between 1965-1976.

The bug has been reported here:

https://bugzilla.kernel.org/show_bug.cgi?id=29082

This patch introduces the following changes:
- Removes the generic hard_header_len check in the rx_complete
  function in the usbnet module.
- Introduces a ETH_HLEN check for skbs that are not cloned from
  within a rx_fixup callback.
- For safety a hard_header_len check is added to each rx_fixup
  callback function that could be affected by this change.
  These extra checks could possibly be removed by someone
  who has the hardware to test.
- Removes a call to dev_kfree_skb_any() and instead utilizes the
  dev->done list to queue skbs for cleanup.

The changes place full responsibility on the rx_fixup callback
functions that clone skbs to only pass valid skbs to the
usbnet_skb_return function.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
Reported-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/usb/gl620a.c     |  4 ++++
 drivers/net/usb/mcs7830.c    |  5 +++--
 drivers/net/usb/net1080.c    |  4 ++++
 drivers/net/usb/rndis_host.c |  4 ++++
 drivers/net/usb/smsc75xx.c   |  4 ++++
 drivers/net/usb/smsc95xx.c   |  4 ++++
 drivers/net/usb/usbnet.c     | 25 ++++++++++---------------
 7 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/net/usb/gl620a.c b/drivers/net/usb/gl620a.c
index c4cfd1d..75d9040 100644
--- a/drivers/net/usb/gl620a.c
+++ b/drivers/net/usb/gl620a.c
@@ -86,6 +86,10 @@ static int genelink_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	u32			size;
 	u32			count;
 
+	/* This check is no longer done by usbnet */
+	if (skb->len < dev->net->hard_header_len)
+		return 0;
+
 	header = (struct gl_header *) skb->data;
 
 	// get the packet count of the received skb
diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index db2cb74..a2f7579 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -601,8 +601,9 @@ static int mcs7830_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
 	u8 status;
 
-	if (skb->len == 0) {
-		dev_err(&dev->udev->dev, "unexpected empty rx frame\n");
+	/* This check is no longer done by usbnet */
+	if (skb->len < dev->net->hard_header_len) {
+		dev_err(&dev->udev->dev, "unexpected tiny rx frame\n");
 		return 0;
 	}
 
diff --git a/drivers/net/usb/net1080.c b/drivers/net/usb/net1080.c
index 01db460..c9e3278 100644
--- a/drivers/net/usb/net1080.c
+++ b/drivers/net/usb/net1080.c
@@ -419,6 +419,10 @@ static int net1080_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	struct nc_trailer	*trailer;
 	u16			hdr_len, packet_len;
 
+	/* This check is no longer done by usbnet */
+	if (skb->len < dev->net->hard_header_len)
+		return 0;
+
 	if (!(skb->len & 0x01)) {
 #ifdef DEBUG
 		struct net_device	*net = dev->net;
diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 255d6a4..13b40e3 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -490,6 +490,10 @@ EXPORT_SYMBOL_GPL(rndis_unbind);
  */
 int rndis_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
+	/* This check is no longer done by usbnet */
+	if (skb->len < dev->net->hard_header_len)
+		return 0;
+
 	/* peripheral may have batched packets to us... */
 	while (likely(skb->len)) {
 		struct rndis_data_hdr	*hdr = (void *)skb->data;
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index a8e4640..c41b42b 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1079,6 +1079,10 @@ static void smsc75xx_rx_csum_offload(struct usbnet *dev, struct sk_buff *skb,
 
 static int smsc75xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
+	/* This check is no longer done by usbnet */
+	if (skb->len < dev->net->hard_header_len)
+		return 0;
+
 	while (skb->len > 0) {
 		u32 rx_cmd_a, rx_cmd_b, align_count, size;
 		struct sk_buff *ax_skb;
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 55b3218..6617325 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1039,6 +1039,10 @@ static void smsc95xx_rx_csum_offload(struct sk_buff *skb)
 
 static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
+	/* This check is no longer done by usbnet */
+	if (skb->len < dev->net->hard_header_len)
+		return 0;
+
 	while (skb->len > 0) {
 		u32 header, align_count;
 		struct sk_buff *ax_skb;
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index dc53a8f..3d21742 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -414,17 +414,19 @@ static inline void rx_process (struct usbnet *dev, struct sk_buff *skb)
 	}
 	// else network stack removes extra byte if we forced a short packet
 
-	if (skb->len) {
-		/* all data was already cloned from skb inside the driver */
-		if (dev->driver_info->flags & FLAG_MULTI_PACKET)
-			dev_kfree_skb_any(skb);
-		else
-			usbnet_skb_return(dev, skb);
+	/* all data was already cloned from skb inside the driver */
+	if (dev->driver_info->flags & FLAG_MULTI_PACKET)
+		goto done;
+
+	if (skb->len < ETH_HLEN) {
+		dev->net->stats.rx_errors++;
+		dev->net->stats.rx_length_errors++;
+		netif_dbg(dev, rx_err, dev->net, "rx length %d\n", skb->len);
+	} else {
+		usbnet_skb_return(dev, skb);
 		return;
 	}
 
-	netif_dbg(dev, rx_err, dev->net, "drop\n");
-	dev->net->stats.rx_errors++;
 done:
 	skb_queue_tail(&dev->done, skb);
 }
@@ -446,13 +448,6 @@ static void rx_complete (struct urb *urb)
 	switch (urb_status) {
 	/* success */
 	case 0:
-		if (skb->len < dev->net->hard_header_len) {
-			state = rx_cleanup;
-			dev->net->stats.rx_errors++;
-			dev->net->stats.rx_length_errors++;
-			netif_dbg(dev, rx_err, dev->net,
-				  "rx length %d\n", skb->len);
-		}
 		break;
 
 	/* stalls need manual reset. this is rare ... except that

