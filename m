Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaIVCLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 22:11:11 -0400
Received: from mail-bl2on0101.outbound.protection.outlook.com ([65.55.169.101]:29472
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751194AbaIVCLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 22:11:09 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: nick <yocto6@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "julia.lawall@lip6.fr" <julia.lawall@lip6.fr>,
        "oneukum@suse.de" <oneukum@suse.de>,
        "himangi774@gmail.com" <himangi774@gmail.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: FIX ME in  oxu210p-hcd.c
Thread-Topic: FIX ME in  oxu210p-hcd.c
Thread-Index: AQHP1PgEnm/39G8KQ0aBJF+T0X3g1pwMRAsAgAAk0QCAAAHMcA==
Date: Mon, 22 Sep 2014 02:11:05 +0000
Message-ID: <684d0564efd840b7a45164546425f849@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <541DB6BF.7090909@gmail.com> <541DB8C1.2000101@gmail.com>
 <2d062bb368d94327b89cba3d547bff9d@BN1PR0301MB0772.namprd03.prod.outlook.com>
 <541F8370.4040705@gmail.com>
In-Reply-To: <541F8370.4040705@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 034215E98F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(101416001)(50986999)(93886004)(85306004)(90102001)(95666004)(54356999)(77982003)(99396002)(76482002)(74502003)(20776003)(33646002)(66066001)(64706001)(4396001)(106356001)(108616004)(120916001)(77096002)(106116001)(83322001)(74662003)(105586002)(76176999)(81542003)(74316001)(2656002)(92566001)(83072002)(107046002)(85852003)(87936001)(86362001)(31966008)(99286002)(80022003)(79102003)(575784001)(76576001)(21056001)(46102003)(97736003)(2501002)(81342003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0770;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8M2BUAq025544


 
> >> Subject: Re: FIX ME in oxu210p-hcd.c
> >>
> >>
> >> I found a unfixed FIX ME in the file stated in my above message. I am
> >> wondering what to set hcd->self.comtroller->dma_mask to as it's now
> >> been defined to NULL and clearly even as a newbie this seem incorrect.
> >> Regards Nick
> >
> > Usually, it is set at its controller driver or pass through through
> > device tree or platform data.
> >
> > Peter
> >
> Sorry Peter,
> I apologize for asking for more help here but I will paste the function below and
> with my changes.
> Please let me known if I am wrong and how to fix it as I new here.
> Sorry for Wasting Your Time,

You are welcome

> Nick
> static int oxu_reset(struct usb_hcd *hcd) {
>  	struct oxu_hcd *oxu = hcd_to_oxu(hcd);
>  	int ret;
> 
>  	spin_lock_init(&oxu->mem_lock);
>  	INIT_LIST_HEAD(&oxu->urb_list);
> 	oxu->urb_len = 0;
> 
> -	/* FIMXE */
> + 	hcd->self.controller->dma_mask = hcd->regs;
> 

It is the dma mask, not the register.

Try below patch to see if it works for you:

diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index da5fb0e..5549851 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -37,6 +37,7 @@
 #include <linux/moduleparam.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/irq.h>
 #include <asm/unaligned.h>
@@ -3841,6 +3842,12 @@ static int oxu_drv_probe(struct platform_device *pdev)
                goto error;
        }
 
+       ret = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+       if (ret) {
+               dev_err(&pdev->dev, "set dma mask error\n");
+               goto error;
+       }
+
        /* Allocate a driver data struct to hold useful info for both
         * SPH & OTG devices
         */

Peter


>  	if (oxu->is_otg) {
> 		oxu->caps = hcd->regs + OXU_OTG_CAP_OFFSET;
> 		oxu->regs = hcd->regs + OXU_OTG_CAP_OFFSET + \
> 			HC_LENGTH(readl(&oxu->caps->hc_capbase));
> 
> 		oxu->mem = hcd->regs + OXU_SPH_MEM;
> 	} else {
> 		oxu->caps = hcd->regs + OXU_SPH_CAP_OFFSET;
>  		oxu->regs = hcd->regs + OXU_SPH_CAP_OFFSET + \
>  			HC_LENGTH(readl(&oxu->caps->hc_capbase));
> 
>  		oxu->mem = hcd->regs + OXU_OTG_MEM;
> 	}
> 
>  	oxu->hcs_params = readl(&oxu->caps->hcs_params);
>  	oxu->sbrn = 0x20;
> 
> 	ret = oxu_hcd_init(hcd);
> 	if (ret)
>  		return ret;
> 
>  	return 0;
> }
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
