Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab3ILSOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:14:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab3ILR7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sathya Perla <sathya.perla@emulex.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 27/46] be2net: fix disabling TX in be_close()
Date: Thu, 12 Sep 2013 10:58:38 -0700
Message-Id: <20130912175723.958427727@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sathya Perla <sathya.perla@emulex.com>

[ Upstream commit 6e1f99757a2b24b7255263b2240a0eb04215174d ]

commit fba875591 ("disable TX in be_close()") disabled TX in be_close()
to protect be_xmit() from touching freed up queues in the AER recovery
flow.  But, TX must be disabled *before* cleaning up TX completions in
the close() path, not after. This allows be_tx_compl_clean() to free up
all TX-req skbs that were notified to the HW.

Signed-off-by: Sathya Perla <sathya.perla@emulex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/emulex/benet/be_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2561,8 +2561,8 @@ static int be_close(struct net_device *n
 	/* Wait for all pending tx completions to arrive so that
 	 * all tx skbs are freed.
 	 */
-	be_tx_compl_clean(adapter);
 	netif_tx_disable(netdev);
+	be_tx_compl_clean(adapter);
 
 	be_rx_qs_destroy(adapter);
 


