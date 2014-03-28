Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaC1Hag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 03:30:36 -0400
Received: from atl4mhob14.myregisteredsite.com ([209.17.115.52]:35265 "EHLO
	atl4mhob14.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbaC1Hae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:30:34 -0400
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: cjb@laptop.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gdjakov@mm-sol.com,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH] sdhci: Forward EPROBE_DEFER on vmmc and vqmmc regulators
Date: Fri, 28 Mar 2014 08:30:16 +0100
Message-Id: <1395991817-3503-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394201923-27345-1-git-send-email-mike.looijmans@topic.nl>
References: <1394201923-27345-1-git-send-email-mike.looijmans@topic.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If vmmc or vqmmc regulators are controlled by an I2C device, the
request for the regulator is likely to fail because the I2C bus has
not been probed yet. The sdhci then incorrectly assumes that the user
never wanted to use a regulator anyway and continues without ever
enabling or configuring the required regulator.

To solve this, when a required voltage regulator returns
EPROBE_DEFER, signalling that the regulator exists but is not
available yet, forward this error to the probe method instead
of simply assuming that the user never wanted to use a regulator
anyway.

Tested on a custom board that has an I2C regulator for one of the sdhcis
and no regulators at all for the other. This patch enables such a system
to work correctly.

v2: Changed "%d" into "%ld" for PTR_ERR value.
---
 drivers/mmc/host/sdhci.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 34aef81..de601f5 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2972,6 +2972,8 @@ int sdhci_add_host(struct sdhci_host *host)
 	host->vqmmc = regulator_get_optional(mmc_dev(mmc), "vqmmc");
 	if (IS_ERR_OR_NULL(host->vqmmc)) {
 		if (PTR_ERR(host->vqmmc) < 0) {
+			if (PTR_ERR(host->vqmmc) == -EPROBE_DEFER)
+				return -EPROBE_DEFER;
 			pr_info("%s: no vqmmc regulator found\n",
 				mmc_hostname(mmc));
 			host->vqmmc = NULL;
@@ -3048,8 +3050,10 @@ int sdhci_add_host(struct sdhci_host *host)
 	host->vmmc = regulator_get_optional(mmc_dev(mmc), "vmmc");
 	if (IS_ERR_OR_NULL(host->vmmc)) {
 		if (PTR_ERR(host->vmmc) < 0) {
-			pr_info("%s: no vmmc regulator found\n",
-				mmc_hostname(mmc));
+			if (PTR_ERR(host->vmmc) == -EPROBE_DEFER)
+				return -EPROBE_DEFER;
+			pr_info("%s: no vmmc regulator found (%ld)\n",
+				mmc_hostname(mmc), PTR_ERR(host->vmmc));
 			host->vmmc = NULL;
 		}
 	}
-- 
1.7.9.5

