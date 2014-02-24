Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaBXHAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:00:42 -0500
Received: from atl4mhfb03.myregisteredsite.com ([209.17.115.61]:48467 "EHLO
	atl4mhfb03.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbaBXHAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:00:41 -0500
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: linux-mmc@vger.kernel.org, anton@enomsg.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, cjb@laptop.org,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH] sdhci: Add a quirk to disable write-protect
Date: Mon, 24 Feb 2014 07:59:48 +0100
Message-Id: <1393225188-18000-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a board does not have the WP line wired at all, the card
may be detected as read-only. Add a quirk and a device property
to disable WP detection.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---
 drivers/mmc/host/sdhci-pltfm.c |    3 +++
 drivers/mmc/host/sdhci.c       |    3 ++-
 include/linux/mmc/sdhci.h      |    2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index e2065a4..9e83ada 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -83,6 +83,9 @@ void sdhci_get_of_property(struct platform_device *pdev)
 		if (sdhci_of_wp_inverted(np))
 			host->quirks |= SDHCI_QUIRK_INVERTED_WRITE_PROTECT;
 
+		if (of_get_property(np, "disable-wp", NULL))
+			host->quirks2 |= SDHCI_QUIRK2_DISABLE_WP;
+
 		if (of_get_property(np, "broken-cd", NULL))
 			host->quirks |= SDHCI_QUIRK_BROKEN_CARD_DETECTION;
 
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 7a7fb4f..68f47fc 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1635,7 +1635,8 @@ static int sdhci_check_ro(struct sdhci_host *host)
 
 	spin_lock_irqsave(&host->lock, flags);
 
-	if (host->flags & SDHCI_DEVICE_DEAD)
+	if ((host->flags & SDHCI_DEVICE_DEAD) ||
+		(host->quirks2 & SDHCI_QUIRK2_DISABLE_WP))
 		is_readonly = 0;
 	else if (host->ops->get_ro)
 		is_readonly = host->ops->get_ro(host);
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 3e781b8..967dba0 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -98,6 +98,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK2_CARD_ON_NEEDS_BUS_ON		(1<<4)
 /* Controller has a non-standard host control register */
 #define SDHCI_QUIRK2_BROKEN_HOST_CONTROL		(1<<5)
+/* Controller lacks write protect detection */
+#define SDHCI_QUIRK2_DISABLE_WP			(1<<6)
 
 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */
-- 
1.7.9.5

