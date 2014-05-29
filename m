Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892AbaE2FGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:06:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755AbaE2Ef4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zenghui Shi <zshi@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        linux-net-drivers@solarflare.com, Shradha Shah <sshah@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@redhat.com>
Subject: [PATCH 3.14 117/140] sfc: fix calling of free_irq with already free vector
Date: Wed, 28 May 2014 21:34:16 -0700
Message-Id: <20140529043104.640750409@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/nic.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/sfc/nic.c
+++ b/drivers/net/ethernet/sfc/nic.c
@@ -156,13 +156,15 @@ void efx_nic_fini_interrupt(struct efx_n
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


