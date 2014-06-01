Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbaFALdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 07:33:00 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:55534 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbaFALc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 07:32:58 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] thermal: ti-soc-thermal: ti-bandgap.c:  Cleaning up memory leak
Date: Sun,  1 Jun 2014 13:33:51 +0200
Message-Id: <1401622431-13554-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk for memory leak in when something unexpected happens
and the function returns.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/thermal/ti-soc-thermal/ti-bandgap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index 3ab12ee..8401d2e 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -1155,8 +1155,9 @@ static struct ti_bandgap *ti_bandgap_build(struct platform_device *pdev)
 	/* register shadow for context save and restore */
 	bgp->regval = devm_kzalloc(&pdev->dev, sizeof(*bgp->regval) *
 				   bgp->conf->sensor_count, GFP_KERNEL);
-	if (!bgp) {
+	if (!bgp->regval) {
 		dev_err(&pdev->dev, "Unable to allocate mem for driver ref\n");
+		devm_kfree(&pdev->dev, bgp);
 		return ERR_PTR(-ENOMEM);
 	}
 
-- 
1.7.10.4

