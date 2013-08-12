Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab3HLCft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 22:35:49 -0400
Received: from [207.46.163.24] ([207.46.163.24]:42825 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755524Ab3HLCfr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 22:35:47 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1155h)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Shuah Khan <shuah.kh@samsung.com>, "cjb@laptop.org" <cjb@laptop.org>
CC: "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: RE: [PATCH] mmc:bfin_sdh change driver to use dev_pm_ops
 infrastructure
Thread-Topic: [PATCH] mmc:bfin_sdh change driver to use dev_pm_ops
 infrastructure
Thread-Index: AQHOld2oGDWoZtd2REGHkienmI9Pf5mQ3PAw
Date: Mon, 12 Aug 2013 02:33:59 +0000
Message-ID: <B168F8A49F4BCF4C84FD23DA5F6363EE31BC1B03@NWD2MBX7.ad.analog.com>
References: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
 <1376148055-2539-3-git-send-email-shuah.kh@samsung.com>
In-Reply-To: <1376148055-2539-3-git-send-email-shuah.kh@samsung.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.24.94]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Sonic Zhang<sonic.zhang@analog.com>

>-----Original Message-----
>From: Shuah Khan [mailto:shuah.kh@samsung.com]
>Sent: Saturday, August 10, 2013 11:21 PM
>To: Zhang, Sonic; cjb@laptop.org
>Cc: Shuah Khan; uclinux-dist-devel@blackfin.uclinux.org; linux-mmc@vger.kernel.org;
>linux-kernel@vger.kernel.org; shuahkhan@gmail.com
>Subject: [PATCH] mmc:bfin_sdh change driver to use dev_pm_ops infrastructure
>
>Change bfin sdh platform driver to register pm ops using dev_pm_ops instead of
>legacy pm_ops infrastructure.
>
>Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>---
> drivers/mmc/host/bfin_sdh.c |   21 ++++++++++++---------
> 1 file changed, 12 insertions(+), 9 deletions(-)
>
>diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c index
>94fae2f..7b3e12f 100644
>--- a/drivers/mmc/host/bfin_sdh.c
>+++ b/drivers/mmc/host/bfin_sdh.c
>@@ -638,10 +638,11 @@ static int sdh_remove(struct platform_device *pdev)  }
>
> #ifdef CONFIG_PM
>-static int sdh_suspend(struct platform_device *dev, pm_message_t state)
>+static int sdh_suspend(struct device *dev)
> {
>-      struct mmc_host *mmc = platform_get_drvdata(dev);
>-      struct bfin_sd_host *drv_data = get_sdh_data(dev);
>+      struct platform_device *pdev = to_platform_device(dev);
>+      struct mmc_host *mmc = platform_get_drvdata(pdev);
>+      struct bfin_sd_host *drv_data = get_sdh_data(pdev);
>       int ret = 0;
>
>       if (mmc)
>@@ -652,15 +653,16 @@ static int sdh_suspend(struct platform_device *dev,
>pm_message_t state)
>       return ret;
> }
>
>-static int sdh_resume(struct platform_device *dev)
>+static int sdh_resume(struct device *dev)
> {
>-      struct mmc_host *mmc = platform_get_drvdata(dev);
>-      struct bfin_sd_host *drv_data = get_sdh_data(dev);
>+      struct platform_device *pdev = to_platform_device(dev);
>+      struct mmc_host *mmc = platform_get_drvdata(pdev);
>+      struct bfin_sd_host *drv_data = get_sdh_data(pdev);
>       int ret = 0;
>
>       ret = peripheral_request_list(drv_data->pin_req, DRIVER_NAME);
>       if (ret) {
>-              dev_err(&dev->dev, "unable to request peripheral pins\n");
>+              dev_err(dev, "unable to request peripheral pins\n");
>               return ret;
>       }
>
>@@ -676,13 +678,14 @@ static int sdh_resume(struct platform_device *dev)  #
>define sdh_resume  NULL  #endif
>
>+static SIMPLE_DEV_PM_OPS(sdh_dev_pm_ops, sdh_suspend, sdh_resume);
>+
> static struct platform_driver sdh_driver = {
>       .probe   = sdh_probe,
>       .remove  = sdh_remove,
>-      .suspend = sdh_suspend,
>-      .resume  = sdh_resume,
>       .driver  = {
>               .name = DRIVER_NAME,
>+              .pm = &sdh_dev_pm_ops,
>       },
> };
>
>--
>1.7.10.4
>


