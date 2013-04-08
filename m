Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936145Ab3DHKCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:02:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42985 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935870Ab3DHJwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 080/102] pch_gbe: fix ip_summed checksum reporting on rx
Date: Mon,  8 Apr 2013 10:50:35 +0100
Message-Id: <1365414657-29191-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

commit 76a0e68129d7d24eb995a6871ab47081bbfa0acc upstream.

skb->ip_summed should be CHECKSUM_UNNECESSARY when the driver reports that
checksums were correct and CHECKSUM_NONE in any other case. They're
currently placed vice versa, which breaks the forwarding scenario. Fix it
by placing them as described above.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 3787c64..9400ce8 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -1747,9 +1747,9 @@ pch_gbe_clean_rx(struct pch_gbe_adapter *adapter,
 
 			skb->protocol = eth_type_trans(skb, netdev);
 			if (tcp_ip_status & PCH_GBE_RXD_ACC_STAT_TCPIPOK)
-				skb->ip_summed = CHECKSUM_NONE;
-			else
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
+			else
+				skb->ip_summed = CHECKSUM_NONE;
 
 			napi_gro_receive(&adapter->napi, skb);
 			(*work_done)++;
-- 
1.8.1.2

