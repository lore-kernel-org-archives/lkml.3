Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab3APOoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:44:16 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:39731 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3APOoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:44:12 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: mporter@ti.com, =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Suman Anna <s-anna@ti.com>, Mark Grosen <mgrosen@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv3 01/11] remoteproc: Move enable_iommu to rproc_boot
Date: Wed, 16 Jan 2013 15:43:40 +0100
Message-Id: <1358347430-9243-2-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358347430-9243-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1358347430-9243-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Call enable_iommu from rproc_boot and disable_iommu from rproc_shutdown.
This make it simpler to keep enable/disable in balance.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index dd3bfaf..ceca76c 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -141,6 +141,7 @@ static void rproc_disable_iommu(struct rproc *rproc)
 
 	iommu_detach_device(domain, dev);
 	iommu_domain_free(domain);
+	rproc->domain = NULL;
 
 	return;
 }
@@ -816,16 +817,6 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 
 	dev_info(dev, "Booting fw image %s, size %zd\n", name, fw->size);
 
-	/*
-	 * if enabling an IOMMU isn't relevant for this rproc, this is
-	 * just a nop
-	 */
-	ret = rproc_enable_iommu(rproc);
-	if (ret) {
-		dev_err(dev, "can't enable iommu: %d\n", ret);
-		return ret;
-	}
-
 	rproc->bootaddr = rproc_get_boot_addr(rproc, fw);
 
 	/* look for the resource table */
@@ -1045,12 +1036,23 @@ int rproc_boot(struct rproc *rproc)
 		goto downref_rproc;
 	}
 
+	/*
+	 * if enabling an IOMMU isn't relevant for this rproc, this is
+	 * just a nop
+	 */
+	ret = rproc_enable_iommu(rproc);
+	if (ret) {
+		dev_err(dev, "can't enable iommu: %d\n", ret);
+		goto downref_rproc;
+	}
+
 	ret = rproc_fw_boot(rproc, firmware_p);
 
 	release_firmware(firmware_p);
 
 downref_rproc:
 	if (ret) {
+		rproc_disable_iommu(rproc);
 		module_put(dev->parent->driver->owner);
 		atomic_dec(&rproc->power);
 	}
-- 
1.7.5.4

