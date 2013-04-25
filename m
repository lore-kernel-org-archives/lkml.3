Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab3DYITH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:19:07 -0400
Received: from sestofw01.enea.se ([192.36.1.252]:22180 "HELO mx-3.enea.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756601Ab3DYITF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:19:05 -0400
From: <maxin.john@enea.com>
To: <cjb@laptop.org>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <maxin.john@gmail.com>, "Maxin B. John" <maxin.john@enea.com>
Subject: [PATCH] mmc: host: sdhci: Fix console flooding when there is no proper card detection
Date: Thu, 25 Apr 2013 10:18:57 +0200
Message-ID: <1366877937-36517-1-git-send-email-maxin.john@enea.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Maxin B. John" <maxin.john@enea.com>

With 3.9.0-rc8 kernel in p2020rdb powerpc target, the console gets
flooded with this message without any SD-Cards present:
"mmc0: Timeout waiting for hardware interrupt"

Since the driver doesn't implement proper card detection, it assumes that
card is always present. This quick-n-dirty patch removes this console
flooding.

In an ideal world, the driver should have "cd-gpio" support.

Signed-off-by: Maxin B. John <maxin.john@enea.com>
---
 drivers/mmc/host/sdhci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 51bbba4..3347864 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2131,10 +2131,18 @@ static void sdhci_timeout_timer(unsigned long data)
 	spin_lock_irqsave(&host->lock, flags);
 
 	if (host->mrq) {
+		/*
+		 * If the driver doesn't implement proper card detection,
+		 * we shouldn't flood the console with Timeout error messages.
+		 */
+		if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
+			goto data_check;
+
 		pr_err("%s: Timeout waiting for hardware "
 			"interrupt.\n", mmc_hostname(host->mmc));
 		sdhci_dumpregs(host);
 
+data_check:
 		if (host->data) {
 			host->data->error = -ETIMEDOUT;
 			sdhci_finish_data(host);
-- 
1.7.10.4

