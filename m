Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaLPAoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:44:15 -0500
Received: from c-82-192-226-27.customer.ggaweb.ch ([82.192.226.27]:33668 "EHLO
	dizzy-6.o2s.ch" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752664AbaLPAoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:44:09 -0500
Subject: [PATCH 3/4] mmc: sunxi: Reset behavior fix
From: David =?utf-8?q?Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>
To: Ulf Hansson <ulf.hansson@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        Peter Griffin <peter.griffin@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>, Chen-Yu Tsai <wens@csie.org>,
        David =?utf-8?q?Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>,
        =?utf-8?b?5p2O5oOz?= <lixiang@allwinnertech.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 16 Dec 2014 01:37:56 +0100
Message-ID: <20141216003756.15488.34861.stgit@dizzy-6.o2s.ch>
In-Reply-To: <20141216003412.15488.54812.stgit@dizzy-6.o2s.ch>
References: <20141216003412.15488.54812.stgit@dizzy-6.o2s.ch>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there is only one DES available the DMA performs a FIFO reset and waits until the reinitialization has been completed.
Disabling the SDXC_IDMAC_DES0_DIC bit prevents the DMA from sending an interrupt after it has finished this reinitialization.

The flags SDXC_IDMAC_DES0_FD and SDXC_IDMAC_DES0_LD are both required in order to use the controller with more than one DES.

Signed-off-by: David Lanzendörfer <david.lanzendoerfer@o2s.ch>
Reported-by: 李想 <lixiang@allwinnertech.com>
---
 drivers/mmc/host/sunxi-mmc.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sunxi-mmc.c b/drivers/mmc/host/sunxi-mmc.c
index 50bd3d2..5331c88 100644
--- a/drivers/mmc/host/sunxi-mmc.c
+++ b/drivers/mmc/host/sunxi-mmc.c
@@ -310,7 +310,17 @@ static void sunxi_mmc_init_idma_des(struct sunxi_mmc_host *host,
 	}
 
 	pdes[0].config |= SDXC_IDMAC_DES0_FD;
-	pdes[i - 1].config = SDXC_IDMAC_DES0_OWN | SDXC_IDMAC_DES0_LD;
+
+	/*
+	 * When there is only one DES available the DMA performs a FIFO reset and waits
+	 * until the reinitialization has been completed.
+	 * Disabling the SDXC_IDMAC_DES0_DIC bit prevents the DMA from sending an interrupt
+	 * after it has finished this reinitialization.
+	 */
+	pdes[i - 1].config = SDXC_IDMAC_DES0_OWN;
+	pdes[i - 1].config |= SDXC_IDMAC_DES0_FD;
+	pdes[i - 1].config |= SDXC_IDMAC_DES0_LD;
+	pdes[i - 1].config &= ~SDXC_IDMAC_DES0_DIC;
 
 	/*
 	 * Avoid the io-store starting the idmac hitting io-mem before the

