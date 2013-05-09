Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab3EIGIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 02:08:05 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:43085 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3EIGGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 02:06:33 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <stern@rowland.harvard.edu>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <lizefan@huawei.com>,
        Libo Chen <libo.chen@huawei.com>
Subject: [PATCH RESEND 4/4] usb: tilegx: fix memleak when create hcd fail
Date: Thu, 9 May 2013 14:05:37 +0800
Message-ID: <1368079537-15328-5-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1368079537-15328-1-git-send-email-libo.chen@huawei.com>
References: <1368079537-15328-1-git-send-email-libo.chen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When usb_create_hcd fail, we should call gxio_usb_host_destroy

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/usb/host/ohci-tilegx.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ohci-tilegx.c b/drivers/usb/host/ohci-tilegx.c
index 1ae7b28..5888fc4 100644
--- a/drivers/usb/host/ohci-tilegx.c
+++ b/drivers/usb/host/ohci-tilegx.c
@@ -112,8 +112,10 @@ static int ohci_hcd_tilegx_drv_probe(struct platform_device *pdev)
 
 	hcd = usb_create_hcd(&ohci_tilegx_hc_driver, &pdev->dev,
 			     dev_name(&pdev->dev));
-	if (!hcd)
-		return -ENOMEM;
+	if (!hcd){
+		ret = -ENOMEM;
+		goto err_hcd;
+	}
 
 	/*
 	 * We don't use rsrc_start to map in our registers, but seems like
@@ -165,6 +167,7 @@ err_have_irq:
 err_no_irq:
 	tilegx_stop_ohc();
 	usb_put_hcd(hcd);
+err_hcd:
 	gxio_usb_host_destroy(&pdata->usb_ctx);
 	return ret;
 }
-- 
1.7.1


