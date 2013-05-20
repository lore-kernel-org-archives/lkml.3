Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab3ETPzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:55:07 -0400
Received: from smtp-out-223.synserver.de ([212.40.185.223]:1043 "EHLO
	smtp-out-219.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755340Ab3ETPzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:55:04 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11574
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] spi: topcliff-pch: Pass correct pointer to free_irq()
Date: Mon, 20 May 2013 17:54:35 +0200
Message-Id: <1369065275-32323-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_irq() expects the same pointer that was passed to request_irq(), otherwise
the IRQ is not freed.

The issue was found using the following coccinelle script:

<smpl>
@r1@
type T;
T devid;
@@
request_irq(..., devid)

@r2@
type r1.T;
T devid;
position p;
@@
free_irq@p(..., devid)

@@
position p != r2.p;
@@
*free_irq@p(...)
</smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/spi/spi-topcliff-pch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 35f60bd..963e0f3 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1487,7 +1487,7 @@ static int pch_spi_pd_probe(struct platform_device *plat_dev)
 	return 0;
 
 err_spi_register_master:
-	free_irq(board_dat->pdev->irq, board_dat);
+	free_irq(board_dat->pdev->irq, data);
 err_request_irq:
 	pch_spi_free_resources(board_dat, data);
 err_spi_get_resources:
-- 
1.8.0

