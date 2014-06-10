Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502AbaFJB6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:58:35 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:33593 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933821AbaFJB6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:58:33 -0400
Message-ID: <53966624.5060206@huawei.com>
Date: Tue, 10 Jun 2014 09:57:56 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Doug Thompson <dougthompson@xmission.com>
CC: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpc925_eadc: Use devm_ioremap_resource()
References: <1402324818-12300-1-git-send-email-wangkefeng.wang@huawei.com>
In-Reply-To: <1402324818-12300-1-git-send-email-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.21.224]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to devm_ioremap_resource() to simplify code.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/edac/cpc925_edac.c |   30 ++++++------------------------
 1 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index df6575f..b335c14 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -950,28 +950,12 @@ static int cpc925_probe(struct platform_device *pdev)
        }

        r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-       if (!r) {
-               cpc925_printk(KERN_ERR, "Unable to get resource\n");
-               res = -ENOENT;
+       vbase = devm_ioremap_resource(&pdev->dev, r);
+       if (IS_ERR(vbase)) {
+               res = PTR_ERR(vbase);
                goto err1;
        }

-       if (!devm_request_mem_region(&pdev->dev,
-                                    r->start,
-                                    resource_size(r),
-                                    pdev->name)) {
-               cpc925_printk(KERN_ERR, "Unable to request mem region\n");
-               res = -EBUSY;
-               goto err1;
-       }
-
-       vbase = devm_ioremap(&pdev->dev, r->start, resource_size(r));
-       if (!vbase) {
-               cpc925_printk(KERN_ERR, "Unable to ioremap device\n");
-               res = -ENOMEM;
-               goto err2;
-       }
-
        nr_channels = cpc925_mc_get_channels(vbase) + 1;

        layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
@@ -985,7 +969,7 @@ static int cpc925_probe(struct platform_device *pdev)
        if (!mci) {
                cpc925_printk(KERN_ERR, "No memory for mem_ctl_info\n");
                res = -ENOMEM;
-               goto err2;
+               goto err1;
        }

        pdata = mci->pvt_info;
@@ -1018,7 +1002,7 @@ static int cpc925_probe(struct platform_device *pdev)

        if (edac_mc_add_mc(mci) > 0) {
                cpc925_mc_printk(mci, KERN_ERR, "Failed edac_mc_add_mc()\n");
-               goto err3;
+               goto err2;
        }

        cpc925_add_edac_devices(vbase);
@@ -1029,11 +1013,9 @@ static int cpc925_probe(struct platform_device *pdev)
        res = 0;
        goto out;

-err3:
+err2:
        cpc925_mc_exit(mci);
        edac_mc_free(mci);
-err2:
-       devm_release_mem_region(&pdev->dev, r->start, resource_size(r));
 err1:
        devres_release_group(&pdev->dev, cpc925_probe);
 out:
-- 
1.7.1

