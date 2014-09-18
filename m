Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbaIRHav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 03:30:51 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:55475 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173AbaIRHau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 03:30:50 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: broonie@kernel.org
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH] spi: pl022:  Add missing error check for devm_kzalloc
Date: Thu, 18 Sep 2014 12:57:47 +0530
Message-Id: <1411025267-773-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently this driver is missing a check on the return value of devm_kzalloc,
which would cause a NULL pointer dereference in a OOM situation.

This patch adds a missing check.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/spi/spi-pl022.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 1189cfd..7f13f3f 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -2100,6 +2100,10 @@ static int pl022_probe(struct amba_device *adev, const struct amba_id *id)
 	pl022->vendor = id->data;
 	pl022->chipselects = devm_kzalloc(dev, num_cs * sizeof(int),
 					  GFP_KERNEL);
+	if (!pl022->chipselects) {
+		status = -ENOMEM;
+		goto err_no_mem;
+	}
 
 	/*
 	 * Bus Number Which has been Assigned to this SSP controller
@@ -2241,6 +2245,7 @@ static int pl022_probe(struct amba_device *adev, const struct amba_id *id)
 	amba_release_regions(adev);
  err_no_ioregion:
  err_no_gpio:
+ err_no_mem:
 	spi_master_put(master);
 	return status;
 }
-- 
1.7.9.5

