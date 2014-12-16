Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbaLPOLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:11:06 -0500
Received: from c-82-192-226-27.customer.ggaweb.ch ([82.192.226.27]:35233 "EHLO
	dizzy-6.o2s.ch" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751055AbaLPOLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:11:01 -0500
Subject: [PATCH 1/4] mmc: sunxi: Fix setup of last descriptor of dma transfer
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
Date: Tue, 16 Dec 2014 15:10:59 +0100
Message-ID: <20141216141059.3036.53205.stgit@dizzy-6.o2s.ch>
In-Reply-To: <20141216140921.3036.14668.stgit@dizzy-6.o2s.ch>
References: <20141216140921.3036.14668.stgit@dizzy-6.o2s.ch>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

The last descriptor might be the first descriptor as well, so use masking to
add the LD (last descriptor) bit and drop the DIC (disable interrupt on
completion) bit rather then hard assignment as hard assigment will override
the FD (first descriptor) bit if there is only 1 descriptor.

Also set the ER (end of ring) bit and clear buf_addr_ptr2 on the last
descriptor, like the android kernel code does.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: David Lanzendörfer <david.lanzendoerfer@o2s.ch>
Reported-by: 李想 <lixiang@allwinnertech.com>
---
 drivers/mmc/host/sunxi-mmc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sunxi-mmc.c b/drivers/mmc/host/sunxi-mmc.c
index 15cb8b7..1fe54a8 100644
--- a/drivers/mmc/host/sunxi-mmc.c
+++ b/drivers/mmc/host/sunxi-mmc.c
@@ -310,7 +310,9 @@ static void sunxi_mmc_init_idma_des(struct sunxi_mmc_host *host,
 	}
 
 	pdes[0].config |= SDXC_IDMAC_DES0_FD;
-	pdes[i - 1].config = SDXC_IDMAC_DES0_OWN | SDXC_IDMAC_DES0_LD;
+	pdes[i - 1].config |= SDXC_IDMAC_DES0_LD | SDXC_IDMAC_DES0_ER;
+	pdes[i - 1].config &= ~SDXC_IDMAC_DES0_DIC;
+	pdes[i - 1].buf_addr_ptr2 = 0;
 
 	/*
 	 * Avoid the io-store starting the idmac hitting io-mem before the

