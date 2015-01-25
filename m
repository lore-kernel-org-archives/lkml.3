Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbbAYSjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:39:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbbAYSKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tim Kryger <tim.kryger@gmail.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 3.18 116/183] mmc: sdhci: Set SDHCI_POWER_ON with external vmmc
Date: Sun, 25 Jan 2015 10:07:18 -0800
Message-Id: <20150125180815.236559138@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Kryger <tim.kryger@gmail.com>

commit 3cbc6123a93dc91b99b58f7ea37d267fe93e1cad upstream.

Host controllers lacking the required internal vmmc regulator may still
follow the spec with regard to the LSB of SDHCI_POWER_CONTROL.  Set the
SDHCI_POWER_ON bit when vmmc is enabled to encourage the controller to
to drive CMD, DAT, SDCLK.

This fixes a regression observed on some Qualcomm and Nvidia boards
caused by 5222161 mmc: sdhci: Improve external VDD regulator support.

Fixes: 52221610dd84 (mmc: sdhci: Improve external VDD regulator support)
Signed-off-by: Tim Kryger <tim.kryger@gmail.com>
Tested-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1239,6 +1239,12 @@ static void sdhci_set_power(struct sdhci
 		spin_unlock_irq(&host->lock);
 		mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
 		spin_lock_irq(&host->lock);
+
+		if (mode != MMC_POWER_OFF)
+			sdhci_writeb(host, SDHCI_POWER_ON, SDHCI_POWER_CONTROL);
+		else
+			sdhci_writeb(host, 0, SDHCI_POWER_CONTROL);
+
 		return;
 	}
 


