Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab3EXEdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 00:33:46 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:49631
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998Ab3EXEdo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 00:33:44 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z551biz9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1155h)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Libo Chen <libo.chen@huawei.com>, "wsa@the-dreams.de" <wsa@the-dreams.de>
CC: "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lizefan@huawei.com" <lizefan@huawei.com>
Subject: RE: [PATCH RFC v3 1/3] i2c: i2c-bfin-twi: convert to devm_* API
Thread-Topic: [PATCH RFC v3 1/3] i2c: i2c-bfin-twi: convert to devm_* API
Thread-Index: AQHOV61VKrVzWXmFgUal2R2gwcOch5kTujSA
Date: Fri, 24 May 2013 04:32:15 +0000
Message-ID: <B168F8A49F4BCF4C84FD23DA5F6363EE010780@NWD2MBX7.ad.analog.com>
References: <1369310405-21112-1-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1369310405-21112-1-git-send-email-libo.chen@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.64.72.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Sonic Zhang <sonic.zhang@analog.com>


>-----Original Message-----
>From: Libo Chen [mailto:libo.chen@huawei.com]
>Sent: Thursday, May 23, 2013 8:00 PM
>To: wsa@the-dreams.de
>Cc: guz.fnst@cn.fujitsu.com; Zhang, Sonic; uclinux-dist-
>devel@blackfin.uclinux.org; linux-i2c@vger.kernel.org; linux-
>kernel@vger.kernel.org; lizefan@huawei.com; libo.chen@huawei.com
>Subject: [PATCH RFC v3 1/3] i2c: i2c-bfin-twi: convert to devm_* API
>
>peripheral_request_list has got free if any one faild, so no need to free again in err
>case.
>aovid this, convert them to devm_* API
>
>Signed-off-by: Libo Chen <libo.chen@huawei.com>
>---
> drivers/i2c/busses/i2c-bfin-twi.c |   38 +++++++++---------------------------
> 1 files changed, 10 insertions(+), 28 deletions(-)
>
>diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
>index 05080c4..2b99c48 100644
>--- a/drivers/i2c/busses/i2c-bfin-twi.c
>+++ b/drivers/i2c/busses/i2c-bfin-twi.c
>@@ -621,35 +621,27 @@ static int i2c_bfin_twi_probe(struct platform_device
>*pdev)
>       int rc;
>       unsigned int clkhilow;
>
>-      iface = kzalloc(sizeof(struct bfin_twi_iface), GFP_KERNEL);
>+      iface = devm_kzalloc(&pdev->dev, sizeof(struct bfin_twi_iface),
>+                      GFP_KERNEL);
>       if (!iface) {
>               dev_err(&pdev->dev, "Cannot allocate memory\n");
>-              rc = -ENOMEM;
>-              goto out_error_nomem;
>+              return -ENOMEM;
>       }
>
>       spin_lock_init(&(iface->lock));
>
>       /* Find and map our resources */
>       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>-      if (res == NULL) {
>-              dev_err(&pdev->dev, "Cannot get IORESOURCE_MEM\n");
>-              rc = -ENOENT;
>-              goto out_error_get_res;
>-      }
>-
>-      iface->regs_base = ioremap(res->start, resource_size(res));
>-      if (iface->regs_base == NULL) {
>+      iface->regs_base = devm_ioremap_resource(&pdev->dev, res);
>+      if (IS_ERR(iface->regs_base)) {
>               dev_err(&pdev->dev, "Cannot map IO\n");
>-              rc = -ENXIO;
>-              goto out_error_ioremap;
>+              return -ENXIO;
>       }
>
>       iface->irq = platform_get_irq(pdev, 0);
>       if (iface->irq < 0) {
>               dev_err(&pdev->dev, "No IRQ specified\n");
>-              rc = -ENOENT;
>-              goto out_error_no_irq;
>+              return -ENOENT;
>       }
>
>       p_adap = &iface->adap;
>@@ -666,10 +658,10 @@ static int i2c_bfin_twi_probe(struct platform_device
>*pdev)
>                                       "i2c-bfin-twi");
>       if (rc) {
>               dev_err(&pdev->dev, "Can't setup pin mux!\n");
>-              goto out_error_pin_mux;
>+              return rc;
>       }
>
>-      rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
>+      rc = devm_request_irq(&pdev->dev, iface->irq,
>+bfin_twi_interrupt_entry,
>               0, pdev->name, iface);
>       if (rc) {
>               dev_err(&pdev->dev, "Can't get IRQ %d !\n", iface->irq); @@ -
>707,16 +699,9 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
>       return 0;
>
> out_error_add_adapter:
>-      free_irq(iface->irq, iface);
> out_error_req_irq:
>-out_error_no_irq:
>       peripheral_free_list((unsigned short *)pdev->dev.platform_data);
>-out_error_pin_mux:
>-      iounmap(iface->regs_base);
>-out_error_ioremap:
>-out_error_get_res:
>-      kfree(iface);
>-out_error_nomem:
>+
>       return rc;
> }
>
>@@ -725,10 +710,7 @@ static int i2c_bfin_twi_remove(struct platform_device
>*pdev)
>       struct bfin_twi_iface *iface = platform_get_drvdata(pdev);
>
>       i2c_del_adapter(&(iface->adap));
>-      free_irq(iface->irq, iface);
>       peripheral_free_list((unsigned short *)pdev->dev.platform_data);
>-      iounmap(iface->regs_base);
>-      kfree(iface);
>
>       return 0;
> }
>--
>1.7.1
>
>


