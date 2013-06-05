Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab3FEVaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:30:06 -0400
Received: from mail.ispras.ru ([83.149.199.45]:48379 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab3FEVaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:30:04 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Barry Song <baohua.song@csr.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] spi/sirf: fix error propagation in spi_sirfsoc_probe()
Date: Thu,  6 Jun 2013 01:29:56 +0400
Message-Id: <1370467796-4641-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pinctrl_get_select_default() fails, spi_sirfsoc_probe()
returns IS_ERR(sspi->p) instead of PTR_ERR(sspi->p).

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/spi/spi-sirf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-sirf.c b/drivers/spi/spi-sirf.c
index 0808cd5..94c3920 100644
--- a/drivers/spi/spi-sirf.c
+++ b/drivers/spi/spi-sirf.c
@@ -559,9 +559,10 @@ static int spi_sirfsoc_probe(struct platform_device *pdev)
 	sspi->bitbang.master->dev.of_node = pdev->dev.of_node;
 
 	sspi->p = pinctrl_get_select_default(&pdev->dev);
-	ret = IS_ERR(sspi->p);
-	if (ret)
+	if (IS_ERR(sspi->p)) {
+		ret = PTR_ERR(sspi->p);
 		goto free_master;
+	}
 
 	sspi->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(sspi->clk)) {
-- 
1.8.1.2

