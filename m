Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934608Ab3DGW5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 18:57:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46328 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934503Ab3DGWzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 18:55:53 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Veaceslav Falico" <vfalico@redhat.com>
Date: Sun, 07 Apr 2013 23:45:43 +0100
Message-ID: <lsq.1365374743.335953811@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [71/74] pch_gbe: fix ip_summed checksum reporting on rx
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit 76a0e68129d7d24eb995a6871ab47081bbfa0acc ]

skb->ip_summed should be CHECKSUM_UNNECESSARY when the driver reports that
checksums were correct and CHECKSUM_NONE in any other case. They're
currently placed vice versa, which breaks the forwarding scenario. Fix it
by placing them as described above.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 43c7b25..495d65c 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -1545,9 +1545,9 @@ pch_gbe_clean_rx(struct pch_gbe_adapter *adapter,
 			skb_put(skb, length);
 			skb->protocol = eth_type_trans(skb, netdev);
 			if (tcp_ip_status & PCH_GBE_RXD_ACC_STAT_TCPIPOK)
-				skb->ip_summed = CHECKSUM_NONE;
-			else
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
+			else
+				skb->ip_summed = CHECKSUM_NONE;
 
 			napi_gro_receive(&adapter->napi, skb);
 			(*work_done)++;

