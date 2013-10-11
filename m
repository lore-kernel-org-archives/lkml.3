Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab3JKVJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 17:09:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab3JKTfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:35:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 16/39] ll_temac: Reset dma descriptors indexes on ndo_open
Date: Fri, 11 Oct 2013 12:35:00 -0700
Message-Id: <20131011193212.646072174@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193210.843963685@linuxfoundation.org>
References: <20131011193210.843963685@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ricardo.ribalda@gmail.com>

[ Upstream commit 7167cf0e8cd10287b7912b9ffcccd9616f382922 ]

The dma descriptors indexes are only initialized on the probe function.

If a packet is on the buffer when temac_stop is called, the dma
descriptors indexes can be left on a incorrect state where no other
package can be sent.

So an interface could be left in an usable state after ifdow/ifup.

This patch makes sure that the descriptors indexes are in a proper
status when the device is open.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ll_temac_main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ll_temac_main.c
+++ b/drivers/net/ll_temac_main.c
@@ -302,6 +302,12 @@ static int temac_dma_bd_init(struct net_
 		       lp->rx_bd_p + (sizeof(*lp->rx_bd_v) * (RX_BD_NUM - 1)));
 	lp->dma_out(lp, TX_CURDESC_PTR, lp->tx_bd_p);
 
+	/* Init descriptor indexes */
+	lp->tx_bd_ci = 0;
+	lp->tx_bd_next = 0;
+	lp->tx_bd_tail = 0;
+	lp->rx_bd_ci = 0;
+
 	return 0;
 
 out:


