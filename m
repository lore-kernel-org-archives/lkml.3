Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaCJVfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:35:20 -0400
Received: from xes-mad.com ([216.165.139.218]:4957 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406AbaCJVfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:35:17 -0400
From: Peter Tyser <ptyser@xes-inc.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Tyser <ptyser@xes-inc.com>, Guenter Roeck <linux@roeck-us.net>,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/8] mfd: lpc_ich: Only configure watchdog or GPIO when present
Date: Mon, 10 Mar 2014 16:34:52 -0500
Message-Id: <1394487298-14459-2-git-send-email-ptyser@xes-inc.com>
X-Mailer: git-send-email 1.7.7.GIT
In-Reply-To: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some chipsets don't currently have GPIO support enabled.  For these
chipsets don't go through the process of initializing the GPIO region.

Make the same change for the watchdog initialization for chipsets which
may not enable the WDT in the future.

Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Tested-by: Rajat Jain <rajatjain@juniper.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: James Ralston <james.d.ralston@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/lpc_ich.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index be10ad4..e247e7e 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -967,13 +967,17 @@ static int lpc_ich_probe(struct pci_dev *dev,
 
 	pci_set_drvdata(dev, priv);
 
-	ret = lpc_ich_init_wdt(dev);
-	if (!ret)
-		cell_added = true;
+	if (lpc_chipset_info[priv->chipset].iTCO_version) {
+		ret = lpc_ich_init_wdt(dev);
+		if (!ret)
+			cell_added = true;
+	}
 
-	ret = lpc_ich_init_gpio(dev);
-	if (!ret)
-		cell_added = true;
+	if (lpc_chipset_info[priv->chipset].gpio_version) {
+		ret = lpc_ich_init_gpio(dev);
+		if (!ret)
+			cell_added = true;
+	}
 
 	/*
 	 * We only care if at least one or none of the cells registered
-- 
1.7.7.GIT

