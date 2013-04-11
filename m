Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934661Ab3DKXRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:17:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19842 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934085Ab3DKXQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:16:23 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=IasI6AIsBCwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=iCZGgNzww8cA:10 a=zRKbQ67AAAAA:8 a=3gsjiaR7UxkkINrlJtAA:9 a=1Dwx9gnmAe4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411231619.979911521@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 19:11:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 1/9 ] sfc: Disable soft interrupt handling during efx_device_detach_sync()
References: <20130411231149.302144972@goodmis.org>
Content-Disposition: inline; filename=0001-sfc-Disable-soft-interrupt-handling-during-efx_devic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit 35205b211c8d17a8a0b5e8926cb7c73e9a7ef1ad ]

efx_device_detach_sync() locks all TX queues before marking the device
detached and thus disabling further TX scheduling.  But it can still
be interrupted by TX completions which then result in TX scheduling in
soft interrupt context.  This will deadlock when it tries to acquire
a TX queue lock that efx_device_detach_sync() already acquired.

To avoid deadlock, we must use netif_tx_{,un}lock_bh().

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/sfc/efx.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 320cf7b..7db0e5b 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -170,9 +170,9 @@ static inline void efx_device_detach_sync(struct efx_nic *efx)
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
-- 
1.7.10.4


