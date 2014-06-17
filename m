Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965763AbaFQVql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:46:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53787 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965720AbaFQVqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:46:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zenghui Shi <zshi@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        <linux-net-drivers@solarflare.com>,
        Shradha Shah <sshah@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 050/212] sfc: fix calling of free_irq with already free vector
Date: Tue, 17 Jun 2014 14:42:24 -0700
Message-Id: <1403041506-13646-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <nikolay@redhat.com>

[ Upstream commit 1c3639005f48492e5f2d965779efd814e80f8b15 ]

If the sfc driver is in legacy interrupt mode (either explicitly by
using interrupt_mode module param or by falling back to it) it will
hit a warning at kernel/irq/manage.c because it will try to free an irq
which wasn't allocated by it in the first place because the MSI(X) irqs are
zero and it'll try to free them unconditionally. So fix it by checking if
we're in legacy mode and freeing the appropriate irqs.

CC: Zenghui Shi <zshi@redhat.com>
CC: Ben Hutchings <ben@decadent.org.uk>
CC: <linux-net-drivers@solarflare.com>
CC: Shradha Shah <sshah@solarflare.com>
CC: David S. Miller <davem@davemloft.net>

Fixes: 1899c111a535 ("sfc: Fix IRQ cleanup in case of a probe failure")
Reported-by: Zenghui Shi <zshi@redhat.com>
Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Acked-by: Shradha Shah <sshah@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/sfc/nic.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/nic.c b/drivers/net/ethernet/sfc/nic.c
index 9c90bf5..a4a1348 100644
--- a/drivers/net/ethernet/sfc/nic.c
+++ b/drivers/net/ethernet/sfc/nic.c
@@ -156,13 +156,15 @@ void efx_nic_fini_interrupt(struct efx_nic *efx)
 	efx->net_dev->rx_cpu_rmap = NULL;
 #endif
 
-	/* Disable MSI/MSI-X interrupts */
-	efx_for_each_channel(channel, efx)
-		free_irq(channel->irq, &efx->msi_context[channel->channel]);
-
-	/* Disable legacy interrupt */
-	if (efx->legacy_irq)
+	if (EFX_INT_MODE_USE_MSI(efx)) {
+		/* Disable MSI/MSI-X interrupts */
+		efx_for_each_channel(channel, efx)
+			free_irq(channel->irq,
+				 &efx->msi_context[channel->channel]);
+	} else {
+		/* Disable legacy interrupt */
 		free_irq(efx->legacy_irq, efx);
+	}
 }
 
 /* Register dump */
-- 
1.9.1

