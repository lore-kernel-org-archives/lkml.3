Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaAHSMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:12:33 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.147]:46582 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbaAHSMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:12:30 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-12.tower-179.messagelabs.com!1389204747!27271340!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [PATCH V1] input: fix memory leak in da9052 touchscreen driver
Thread-Topic: [PATCH V1] input: fix memory leak in da9052 touchscreen driver
Thread-Index: AQHPDJRzicdMdU03pUyV/DfQNMsjc5p7FE8AgAAKzMA=
Date: Wed, 8 Jan 2014 18:12:27 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51847B1D99@NB-EX-MBX02.diasemi.com>
References: <201401081709.s08H9nMr038265@swsrvapps-02.lan>
 <7aad8e91-f5d9-4527-8a94-bc038a9ccd85@email.android.com>
In-Reply-To: <7aad8e91-f5d9-4527-8a94-bc038a9ccd85@email.android.com>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.24.126]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s08ICf3a028407

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: 08 January 2014 17:26
> To: Opensource [Anthony Olech]
> Cc: linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; Huqiu Liu;
> David Dajun Chen
> Subject: Re: [PATCH V1] input: fix memory leak in da9052 touchscreen driver
> Anthony Olech <anthony.olech.opensource@diasemi.com> wrote:
> >The touchscreen component driver for the da9052/3 Dialog PMICs leaks
> >memory by not freeing the input device in the remove call.
> >This patch matches the existing call to input_alloc_device() in
> >da9052_ts_probe() to a new call to input_free_device() in
> >da9052_ts_remove()
> >Suggested-by: Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>
> >Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> >---
> >This patch is relative to linux-next repository tag next-20140108
> >Many thanks to Huqiu Liu who found the bug.
> No, this is not a bug. Please refer to input API spec in input.h
> Thanks.

Hi Dmitry,
the spec *seems* to say that if the allocation is done via devm_input_allocate_device(dev)
then no explicit freeing must be done.

However that is not the case here, so the bug exists.

It does seem that there is an alternative way of resolving the issue, namely to:
1) change from allocate_device() to devm_input_allocate_device(dev) and
2) remove the exiosting input_free_device() from the error path in the probe() function

I will update the patch submission to the alternative tomorrow

Tony Olech (Dialog Semiconductor)

> > drivers/input/touchscreen/da9052_tsi.c |    2 ++
> > 1 file changed, 2 insertions(+)
> >diff --git a/drivers/input/touchscreen/da9052_tsi.c
> >b/drivers/input/touchscreen/da9052_tsi.c
> >index ab64d58..43a69d1 100644
> >--- a/drivers/input/touchscreen/da9052_tsi.c
> >+++ b/drivers/input/touchscreen/da9052_tsi.c
> >@@ -320,6 +320,7 @@ err_free_mem:
> > static int  da9052_ts_remove(struct platform_device *pdev)  {
> > 	struct da9052_tsi *tsi = platform_get_drvdata(pdev);
> >+	struct input_dev *input_dev = tsi->dev;
> > 	da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x19);
> >@@ -328,6 +329,7 @@ static int  da9052_ts_remove(struct
> platform_device
> >*pdev)
> > 	input_unregister_device(tsi->dev);
> > 	kfree(tsi);
> >+	input_free_device(input_dev);
> > 	return 0;
> > }
> --
> Dmitry
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
