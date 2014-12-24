Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaLXKQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 05:16:28 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6106 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaLXKQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 05:16:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 24 Dec 2014 02:11:07 -0800
From: Vince Hsu <vinceh@nvidia.com>
To: stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com
CC: linux-usb@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vince Hsu <vinceh@nvidia.com>
Subject: [PATCH] usb: host: ehci-tegra: request deferred probe when failing to get phy
Date: Wed, 24 Dec 2014 18:16:30 +0800
Message-ID: <1419416190-4321-1-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.9.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 1290a958d48e ("usb: phy: propagate __of_usb_find_phy()'s error on
failure") changed the condition to return -EPROBE_DEFER to host driver.
Originally the Tegra host driver depended on the returned -EPROBE_DEFER to
get the phy device later when booting. Now we have to do that explicitly.

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
---
Hi,

This fixes a regression found on 3.19-rc1. The USB host can't be probed and
the USB failed on Jetson TK1.

Thanks,
Vince


 drivers/usb/host/ehci-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 19a9af1b4d74..ff9af29b4e9f 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -451,7 +451,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 
 	u_phy = devm_usb_get_phy_by_phandle(&pdev->dev, "nvidia,phy", 0);
 	if (IS_ERR(u_phy)) {
-		err = PTR_ERR(u_phy);
+		err = -EPROBE_DEFER;
 		goto cleanup_clk_en;
 	}
 	hcd->usb_phy = u_phy;
-- 
1.9.1

