Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030299Ab3HICDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:03:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030230Ab3HIB7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 089/102] sfc: Enable RX scatter for flows steered by RFS
Date: Thu,  8 Aug 2013 18:58:05 -0700
Message-Id: <20130809015031.311990254@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit 7aa0076c497d6f0d5d957b431d0d80e1e9780274 ]

Received packets are only scattered if this is enabled in both the
matching filter and the receiving queue.  This was not being done for
filters inserted for RFS, so any packet requiring more than a single
descriptor was dropped.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/filter.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/sfc/filter.c
+++ b/drivers/net/ethernet/sfc/filter.c
@@ -1196,7 +1196,9 @@ int efx_filter_rfs(struct net_device *ne
 	EFX_BUG_ON_PARANOID(skb_headlen(skb) < nhoff + 4 * ip->ihl + 4);
 	ports = (const __be16 *)(skb->data + nhoff + 4 * ip->ihl);
 
-	efx_filter_init_rx(&spec, EFX_FILTER_PRI_HINT, 0, rxq_index);
+	efx_filter_init_rx(&spec, EFX_FILTER_PRI_HINT,
+			   efx->rx_scatter ? EFX_FILTER_FLAG_RX_SCATTER : 0,
+			   rxq_index);
 	rc = efx_filter_set_ipv4_full(&spec, ip->protocol,
 				      ip->daddr, ports[1], ip->saddr, ports[0]);
 	if (rc)


