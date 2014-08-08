Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308AbaHHVAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:00:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41446 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbaHHUyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:54:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Fitzsimmons <fitzsim@fitzsim.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 124/259] net: mvneta: Fix big endian issue in mvneta_txq_desc_csum()
Date: Fri,  8 Aug 2014 13:39:07 -0700
Message-Id: <1407530482-4483-125-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fitzsimmons <fitzsim@fitzsim.org>

commit 0a1985879437d14bda8c90d0dae3455c467d7642 upstream.

This commit fixes the command value generated for CSUM calculation
when running in big endian mode.  The Ethernet protocol ID for IP was
being unconditionally byte-swapped in the layer 3 protocol check (with
swab16), which caused the mvneta driver to not function correctly in
big endian mode.  This patch byte-swaps the ID conditionally with
htons.

Signed-off-by: Thomas Fitzsimmons <fitzsim@fitzsim.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 1c8dd19..89c85b7 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1212,7 +1212,7 @@ static u32 mvneta_txq_desc_csum(int l3_offs, int l3_proto,
 	command =  l3_offs    << MVNETA_TX_L3_OFF_SHIFT;
 	command |= ip_hdr_len << MVNETA_TX_IP_HLEN_SHIFT;
 
-	if (l3_proto == swab16(ETH_P_IP))
+	if (l3_proto == htons(ETH_P_IP))
 		command |= MVNETA_TXD_IP_CSUM;
 	else
 		command |= MVNETA_TX_L3_IP6;
-- 
1.9.1

