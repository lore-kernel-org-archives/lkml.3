Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018Ab3BMNXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:23:36 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:12413 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756892Ab3BMNXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:23:35 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH] of: spi: Return error from of_spi_register_master on bad "cs-gpios" property
Date: Wed, 13 Feb 2013 14:23:24 +0100
Message-Id: <1360761804-16044-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure that an error is returned on an incorrectly formed
"cs-gpios" property, but reports success when the "cs-gpios" property is
well formed or missing.

When holes in the cs-gpios property phandle list is used to indicate
that some other form of chipselect is to be used it is important that
failure to read a broken "cs-gpios" property does not silently fail
leading to the spi controller to use an unintended chipselect.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---

Can only be applied to devicetree/next as it builds upon the
"of: Add helper for counting phandle refernces" patch series.

 drivers/spi/spi.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 21c4748..9b5f024 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1068,8 +1068,11 @@ static int of_spi_register_master(struct spi_master *master)
 	nb = of_gpio_named_count(np, "cs-gpios");
 	master->num_chipselect = max(nb, (int)master->num_chipselect);
 
-	if (nb < 1)
+	/* Return error only for an incorrectly formed cs-gpios property */
+	if (nb == 0 || nb == -ENOENT)
 		return 0;
+	else if (nb < 0)
+		return nb;
 
 	cs = devm_kzalloc(&master->dev,
 			  sizeof(int) * master->num_chipselect,
-- 
1.7.0.4

