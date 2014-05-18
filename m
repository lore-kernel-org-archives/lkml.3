Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaERKqE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 06:46:04 -0400
Received: from mout.gmx.net ([212.227.17.22]:58252 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaERKqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 06:46:01 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: davem@davemloft.net
Cc: tedheadster@gmail.com, joe@perches.com, paul.gortmaker@windriver.com,
        jg1.han@samsung.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] net: 8390: use time_after() for time comparison
Date: Sun, 18 May 2014 12:45:48 +0200
Message-Id: <1400409948-29399-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:y5xbfzkJ4i814MTxpAkksgHvA6DY0v+XskAygWqMA/7fPNfta44
 I0nuzHsAKNGq6c0UN8eu16VU1FxwhOwPfMmBJhUGuKy7747uHMtV1mODa95exAKN8t4ufFi
 6L3Ee8qmnlRalBwGXDrdqwvvnvqzZALfJjynyawQfdbVME5T+gKX56e9hC4PpmHfeKBW5qd
 1VdLVLpt5s8/JT/QtUHJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are modified
to use time_after() instead of raw math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/net/ethernet/8390/ax88796.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/8390/ax88796.c b/drivers/net/ethernet/8390/ax88796.c
index 455d4c3..1d162cc 100644
--- a/drivers/net/ethernet/8390/ax88796.c
+++ b/drivers/net/ethernet/8390/ax88796.c
@@ -157,7 +157,7 @@ static void ax_reset_8390(struct net_device *dev)
 
 	/* This check _should_not_ be necessary, omit eventually. */
 	while ((ei_inb(addr + EN0_ISR) & ENISR_RESET) == 0) {
-		if (jiffies - reset_start_time > 2 * HZ / 100) {
+		if (time_after(jiffies, reset_start_time + 2 * HZ / 100)) {
 			netdev_warn(dev, "%s: did not complete.\n", __func__);
 			break;
 		}
@@ -293,7 +293,7 @@ static void ax_block_output(struct net_device *dev, int count,
 	dma_start = jiffies;
 
 	while ((ei_inb(nic_base + EN0_ISR) & ENISR_RDC) == 0) {
-		if (jiffies - dma_start > 2 * HZ / 100) {		/* 20ms */
+		if (time_after(jiffies, dma_start + 2 * HZ / 100)) { /* 20ms */
 			netdev_warn(dev, "timeout waiting for Tx RDC.\n");
 			ax_reset_8390(dev);
 			ax_NS8390_init(dev, 1);
-- 
1.7.10.4

