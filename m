Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab3EVRsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 13:48:11 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:47976 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab3EVRsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 13:48:07 -0400
From: "Felipe F. Tonello" <eu@felipetonello.com>
To: linux-mmc@vger.kernel.org
Cc: ben-linux@fluff.org, cjb@laptop.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org,
        "Felipe F. Tonello" <eu@felipetonello.com>
Subject: [PATCH 1/2] mmc: sdhci: Added set_power sdhci_ops handler.
Date: Wed, 22 May 2013 10:47:11 -0700
Message-Id: <1369244832-23868-2-git-send-email-eu@felipetonello.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369244832-23868-1-git-send-email-eu@felipetonello.com>
References: <1369244832-23868-1-git-send-email-eu@felipetonello.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Felipe F. Tonello" <eu@felipetonello.com>

This is useful for power managment purposes if a sdhci child host wants to
turn off some other peripheral also.

Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
---
 drivers/mmc/host/sdhci.c | 8 ++++++++
 drivers/mmc/host/sdhci.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 2ea429c..0a026c6 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1244,6 +1244,10 @@ static int sdhci_set_power(struct sdhci_host *host, unsigned short power)
 	u8 pwr = 0;
 
 	if (power != (unsigned short)-1) {
+
+		if (host->ops->set_power)
+			host->ops->set_power(host, true);
+
 		switch (1 << power) {
 		case MMC_VDD_165_195:
 			pwr = SDHCI_POWER_180;
@@ -1259,6 +1263,10 @@ static int sdhci_set_power(struct sdhci_host *host, unsigned short power)
 		default:
 			BUG();
 		}
+	} else {
+
+		if (host->ops->set_power)
+			host->ops->set_power(host, false);
 	}
 
 	if (host->pwr == pwr)
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 379e09d..293d56d 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -294,6 +294,7 @@ struct sdhci_ops {
 	void	(*platform_resume)(struct sdhci_host *host);
 	void    (*adma_workaround)(struct sdhci_host *host, u32 intmask);
 	void	(*platform_init)(struct sdhci_host *host);
+	void	(*set_power)(struct sdhci_host *host, bool power);
 };
 
 #ifdef CONFIG_MMC_SDHCI_IO_ACCESSORS
-- 
1.8.1.4

