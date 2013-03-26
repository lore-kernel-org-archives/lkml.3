Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3CZWwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:52:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab3CZWwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 29/72] sfc: Disable soft interrupt handling during efx_device_detach_sync()
Date: Tue, 26 Mar 2013 15:51:12 -0700
Message-Id: <20130326224922.704109328@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/efx.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -170,9 +170,9 @@ static inline void efx_device_detach_syn
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


