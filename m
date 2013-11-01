Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab3KAWQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:16:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab3KAWIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mariusz Ceier <mceier+kernel@gmail.com>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 47/66] davinci_emac.c: Fix IFF_ALLMULTI setup
Date: Fri,  1 Nov 2013 15:07:23 -0700
Message-Id: <20131101220647.738445603@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mariusz Ceier <mceier+kernel@gmail.com>

[ Upstream commit d69e0f7ea95fef8059251325a79c004bac01f018 ]

When IFF_ALLMULTI flag is set on interface and IFF_PROMISC isn't,
emac_dev_mcast_set should only enable RX of multicasts and reset
MACHASH registers.

It does this, but afterwards it either sets up multicast MACs
filtering or disables RX of multicasts and resets MACHASH registers
again, rendering IFF_ALLMULTI flag useless.

This patch fixes emac_dev_mcast_set, so that multicast MACs filtering and
disabling of RX of multicasts are skipped when IFF_ALLMULTI flag is set.

Tested with kernel 2.6.37.

Signed-off-by: Mariusz Ceier <mceier+kernel@gmail.com>
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/davinci_emac.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -876,8 +876,7 @@ static void emac_dev_mcast_set(struct ne
 		    netdev_mc_count(ndev) > EMAC_DEF_MAX_MULTICAST_ADDRESSES) {
 			mbp_enable = (mbp_enable | EMAC_MBP_RXMCAST);
 			emac_add_mcast(priv, EMAC_ALL_MULTI_SET, NULL);
-		}
-		if (!netdev_mc_empty(ndev)) {
+		} else if (!netdev_mc_empty(ndev)) {
 			struct netdev_hw_addr *ha;
 
 			mbp_enable = (mbp_enable | EMAC_MBP_RXMCAST);


