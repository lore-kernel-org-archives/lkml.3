Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521AbaCUAD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:03:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760479AbaCUADv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3.13 065/149] Revert "USBNET: ax88179_178a: enable tso if usb host supports sg dma"
Date: Thu, 20 Mar 2014 17:03:48 -0700
Message-Id: <20140321000439.216740065@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 469d417b68958a064c09e7875646c97c6e783dfc upstream.

This reverts commit 3804fad45411b48233b48003e33a78f290d227c8.

This commit, together with commit 247bf557273dd775505fb9240d2d152f4f20d304
"xhci 1.0: Limit arbitrarily-aligned scatter gather." were
origially added to get xHCI 1.0 hosts and usb ethernet ax88179_178a devices
working together with scatter gather. xHCI 1.0 hosts pose some requirement on how transfer
buffers are aligned, setting this requirement for 1.0 hosts caused USB 3.0 mass
storage devices to fail more frequently.

USB 3.0 mass storage devices used to work before 3.14-rc1.  Theoretically,
the TD fragment rules could have caused an occasional disk glitch.
Now the devices *will* fail, instead of theoretically failing.
>From a user perspective, this looks like a regression; the USB device obviously
fails on 3.14-rc1, and may sometimes silently fail on prior kernels.

The proper soluition is to implement the TD fragment rules for xHCI 1.0 hosts,
but for now, revert this patch until scatter gather can be properly supported.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/ax88179_178a.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1030,20 +1030,12 @@ static int ax88179_bind(struct usbnet *d
 	dev->mii.phy_id = 0x03;
 	dev->mii.supports_gmii = 1;
 
-	if (usb_device_no_sg_constraint(dev->udev))
-		dev->can_dma_sg = 1;
-
 	dev->net->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			      NETIF_F_RXCSUM;
 
 	dev->net->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				 NETIF_F_RXCSUM;
 
-	if (dev->can_dma_sg) {
-		dev->net->features |= NETIF_F_SG | NETIF_F_TSO;
-		dev->net->hw_features |= NETIF_F_SG | NETIF_F_TSO;
-	}
-
 	/* Enable checksum offload */
 	*tmp = AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
 	       AX_RXCOE_TCPV6 | AX_RXCOE_UDPV6;


