Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab3CYBYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:24:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34061 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756061Ab3CYBQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:12 -0400
Message-Id: <20130325010529.043746724@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:12 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 048/104] sfc: Disable soft interrupt handling during  efx_device_detach_sync()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit 35205b211c8d17a8a0b5e8926cb7c73e9a7ef1ad ]

efx_device_detach_sync() locks all TX queues before marking the device
detached and thus disabling further TX scheduling.  But it can still
be interrupted by TX completions which then result in TX scheduling in
soft interrupt context.  This will deadlock when it tries to acquire
a TX queue lock that efx_device_detach_sync() already acquired.

To avoid deadlock, we must use netif_tx_{,un}lock_bh().

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/sfc/efx.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 55e72af..9668d29 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -157,9 +157,9 @@ static inline void efx_device_detach_sync(struct efx_nic *efx)
 	 * TX scheduler is stopped when we're done and before
 	 * netif_device_present() becomes false.
 	 */
-	netif_tx_lock(dev);
+	netif_tx_lock_bh(dev);
 	netif_device_detach(dev);
-	netif_tx_unlock(dev);
+	netif_tx_unlock_bh(dev);
 }
 
 #endif /* EFX_EFX_H */


