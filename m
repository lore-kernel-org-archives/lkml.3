Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab3BSEOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 23:14:17 -0500
Received: from mout.gmx.net ([212.227.17.20]:52354 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab3BSEOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 23:14:16 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+eGIM7bYuezGw47nJRyWEfxDVs4ZcaRNKfAj00EQ
	EafyDosrzBi7B9
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Devendra Naga <devendra.aaru@gmail.com>, Peter Huewe <peterhuewe@gmx.de>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Cruz Julian Bishop <cruzjbishop@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] staging/slicoss: Remove always true if statement
Date: Tue, 19 Feb 2013 05:18:49 +0100
Message-Id: <1361247532-1874-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1361247234-1754-1-git-send-email-peterhuewe@gmx.de>
References: <1361247234-1754-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

skbtype is assigned once to NORMAL_ETHFRAME and then checked if it is
NORMAL_ETHFRAME -> remove the checks.

This also gets rid of the (false positive) smatch warning:
slicoss.c:2829 slic_xmit_start() error: potential NULL dereference
'hcmd'.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/slicoss/slicoss.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 753993c..048a341 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -2786,7 +2786,6 @@ static netdev_tx_t slic_xmit_start(struct sk_buff *skb, struct net_device *dev)
 	struct adapter *adapter = netdev_priv(dev);
 	struct slic_hostcmd *hcmd = NULL;
 	u32 status = 0;
-	u32 skbtype = NORMAL_ETHFRAME;
 	void *offloadcmd = NULL;
 
 	card = adapter->card;
@@ -2800,19 +2799,16 @@ static netdev_tx_t slic_xmit_start(struct sk_buff *skb, struct net_device *dev)
 		goto xmit_fail;
 	}
 
-	if (skbtype == NORMAL_ETHFRAME) {
-		hcmd = slic_cmdq_getfree(adapter);
-		if (!hcmd) {
-			adapter->xmitq_full = 1;
-			status = XMIT_FAIL_HOSTCMD_FAIL;
-			goto xmit_fail;
-		}
-		hcmd->skb = skb;
-		hcmd->busy = 1;
-		hcmd->type = SLIC_CMD_DUMB;
-		if (skbtype == NORMAL_ETHFRAME)
-			slic_xmit_build_request(adapter, hcmd, skb);
+	hcmd = slic_cmdq_getfree(adapter);
+	if (!hcmd) {
+		adapter->xmitq_full = 1;
+		status = XMIT_FAIL_HOSTCMD_FAIL;
+		goto xmit_fail;
 	}
+	hcmd->skb = skb;
+	hcmd->busy = 1;
+	hcmd->type = SLIC_CMD_DUMB;
+	slic_xmit_build_request(adapter, hcmd, skb);
 	dev->stats.tx_packets++;
 	dev->stats.tx_bytes += skb->len;
 
@@ -2838,7 +2834,7 @@ static netdev_tx_t slic_xmit_start(struct sk_buff *skb, struct net_device *dev)
 xmit_done:
 	return NETDEV_TX_OK;
 xmit_fail:
-	slic_xmit_fail(adapter, skb, offloadcmd, skbtype, status);
+	slic_xmit_fail(adapter, skb, offloadcmd, NORMAL_ETHFRAME, status);
 	goto xmit_done;
 }
 
-- 
1.7.8.6

