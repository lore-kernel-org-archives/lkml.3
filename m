Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab3BLKIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:08:53 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:61695 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab3BLKIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:08:51 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <mailinglists@erwinrol.com>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] net/macb: fix race with RX interrupt while doing NAPI
Date: Tue, 12 Feb 2013 11:08:48 +0100
Message-ID: <1360663728-10296-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <50D2D7BD.3030801@erwinrol.com>
References: <50D2D7BD.3030801@erwinrol.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When interrupts are disabled, an RX condition can occur but
it is not reported when enabling interrupts again. We need to check
RSR and use napi_reschedule() if condition is met.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/net/ethernet/cadence/macb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index a9b0830..b9d4bb9 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -693,6 +693,11 @@ static int macb_poll(struct napi_struct *napi, int budget)
 		 * get notified when new packets arrive.
 		 */
 		macb_writel(bp, IER, MACB_RX_INT_FLAGS);
+
+		/* Packets received while interrupts were disabled */
+		status = macb_readl(bp, RSR);
+		if (unlikely(status))
+			napi_reschedule(napi);
 	}
 
 	/* TODO: Handle errors */
-- 
1.8.0

