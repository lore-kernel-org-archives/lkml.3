Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbaBJUB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:01:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34939 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbaBJTqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:15 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 115/124] net,via-rhine: Fix tx_timeout handling
Date: Mon, 10 Feb 2014 11:40:55 -0800
Message-Id: <1392061264-28124-116-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

[ Upstream commit a926592f5e4e900f3fa903298c4619a131e60963 ]

rhine_reset_task() misses to disable the tx scheduler upon reset,
this can lead to a crash if work is still scheduled while we're resetting
the tx queue.

Fixes:
[   93.591707] BUG: unable to handle kernel NULL pointer dereference at 0000004c
[   93.595514] IP: [<c119d10d>] rhine_napipoll+0x491/0x6

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/via/via-rhine.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 3b96bfa..7eb1963 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -1600,6 +1600,7 @@ static void rhine_reset_task(struct work_struct *work)
 		goto out_unlock;
 
 	napi_disable(&rp->napi);
+	netif_tx_disable(dev);
 	spin_lock_bh(&rp->lock);
 
 	/* clear all descriptors */
-- 
1.8.3.2

