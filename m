Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaCBLgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 06:36:18 -0500
Received: from leviathan.tchmachines.com ([208.76.85.180]:59145 "EHLO
	leviathan.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaCBLgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 06:36:17 -0500
X-Greylist: delayed 958 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Mar 2014 06:36:17 EST
From: Eli Billauer <eli.billauer@gmail.com>
To: chris@printf.net
Cc: michal.simek@xilinx.com, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH v2] mmc: sdhci: add quirk for broken write protect detection
Date: Sun,  2 Mar 2014 13:20:00 +0200
Message-Id: <1393759200-22819-1-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - leviathan.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - billauer.co.il
X-Get-Message-Sender-Via: leviathan.tchmachines.com: authenticated_id: billaue/sender_address_domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The write protection signal is absent on a board based upon Xilinx' Zynq
processor ("ZyBo"). This leads the kernel to think that the MicroSD card is
write protected, and causes a kernel panic during boot, as root fails to
mount RW.

This patch adds a quirk and an optional OF property, sdhci,broken-wp to
work around this issue.

Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 Documentation/devicetree/bindings/mmc/mmc.txt |    2 ++
 drivers/mmc/host/sdhci-pltfm.c                |    4 +++-
 drivers/mmc/host/sdhci.c                      |    2 ++
 include/linux/mmc/sdhci.h                     |    2 ++
 4 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/mmc/mmc.txt b/Documentation/devicetree/bindings/mmc/mmc.txt
index 458b57f..83a39c1 100644
--- a/Documentation/devicetree/bindings/mmc/mmc.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc.txt
@@ -21,6 +21,8 @@ Optional properties:
   below for the case, when a GPIO is used for the CD line
 - wp-inverted: when present, polarity on the WP line is inverted. See the note
   below for the case, when a GPIO is used for the WP line
+- broken-wp: when present, no indication of write protection is available,
+  and write protection is assumed always off.
 - max-frequency: maximum operating clock frequency
 - no-1-8-v: when present, denotes that 1.8v card voltage is not supported on
   this system, even if the controller claims it is.
diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index bef250e..dac20af 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -80,7 +80,9 @@ void sdhci_get_of_property(struct platform_device *pdev)
 		    bus_width == 1))
 			host->quirks |= SDHCI_QUIRK_FORCE_1_BIT_DATA;
 
-		if (sdhci_of_wp_inverted(np))
+		if (of_get_property(np, "sdhci,broken-wp", NULL))
+			host->quirks2 |= SDHCI_QUIRK2_BROKEN_WRITE_PROTECT;
+		else if (sdhci_of_wp_inverted(np))
 			host->quirks |= SDHCI_QUIRK_INVERTED_WRITE_PROTECT;
 
 		if (of_get_property(np, "broken-cd", NULL))
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 9ddef47..6c77f2e 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1657,6 +1657,8 @@ static int sdhci_check_ro(struct sdhci_host *host)
 		is_readonly = 0;
 	else if (host->ops->get_ro)
 		is_readonly = host->ops->get_ro(host);
+	else if (host->quirks2 & SDHCI_QUIRK2_BROKEN_WRITE_PROTECT)
+		is_readonly = 0;
 	else
 		is_readonly = !(sdhci_readl(host, SDHCI_PRESENT_STATE)
 				& SDHCI_WRITE_PROTECT);
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 362927c4..0f6ef9d 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -100,6 +100,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK2_BROKEN_HOST_CONTROL		(1<<5)
 /* Controller does not support HS200 */
 #define SDHCI_QUIRK2_BROKEN_HS200			(1<<6)
+/* There is no indication for write protection at all, assume RW */
+#define SDHCI_QUIRK2_BROKEN_WRITE_PROTECT		(1<<7)
 
 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */
-- 
1.7.2.3

