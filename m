Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbaLAUkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:40:53 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:41368 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbaLAUkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:40:52 -0500
MIME-Version: 1.0
In-Reply-To: <547CCFF7.2000205@metafoo.de>
References: <1417402251-6596-1-git-send-email-jiada_wang@mentor.com>
	<2547588.Qc4F2IfZke@wuerfel>
	<547CC89F.1030205@tabi.org>
	<3401240.VsRpsiV8WN@wuerfel>
	<547CCB78.5090007@tabi.org>
	<547CCFF7.2000205@metafoo.de>
Date: Mon, 1 Dec 2014 18:40:51 -0200
Message-ID: <CAOMZO5B7MxLSaETUW0QyajdHMMX2nLg=t=5dVCNRePb6UzizRQ@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: fsl_ssi: free irq before irq_dispose_mapping()
From: Fabio Estevam <festevam@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Timur Tabi <timur@tabi.org>, Arnd Bergmann <arnd@arndb.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Jiada Wang <jiada_wang@mentor.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>, Markus Pargmann <mpa@pengutronix.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 6:30 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 12/01/2014 09:11 PM, Timur Tabi wrote:
>>
>> On 12/01/2014 02:01 PM, Arnd Bergmann wrote:
>>>>
>>>> >Does this mean that fsl_ssi.c should not be calling
>>>> >irq_of_parse_and_map?  How else should it get the IRQ?
>>>
>>> platform_get_irq()
>>
>>
>> Ok, but that function also calls irq_create_of_mapping().  So it still
>> appears that the only way to get the IRQ is to map it, but then we can't
>> use
>> devm_request_irq().
>>
>
> Hm... that's new. But it's not really a driver issue anymore if it is done
> in the core. So I guess for now just use platform_get_irq() and ignore the
> other issue.

With the suggested changes below, the removal of the driver works fine on a mx6:

root@freescale /$ modprobe   snd-soc-fsl-ssi
root@freescale /$ modprobe snd-soc-imx-wm8962
[  319.517679] input: WM8962 Beep Generator as
/devices/soc0/soc/2100000.aips-bus/21a0000.i2c/i2c-0/0-001a/input/input7
[  319.543225] imx-wm8962 sound: wm8962 <-> 202c000.ssi mapping ok
root@freescale /$ rmmod  snd-soc-imx-wm8962
root@freescale /$ rmmod   snd-soc-fsl-ssi

 sound/soc/fsl/fsl_ssi.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index 32a31d9..c528f16 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -1361,7 +1361,7 @@ static int fsl_ssi_probe(struct platform_device *pdev)
         return PTR_ERR(ssi_private->regs);
     }

-    ssi_private->irq = irq_of_parse_and_map(np, 0);
+    ssi_private->irq = platform_get_irq(pdev, 0);
     if (!ssi_private->irq) {
         dev_err(&pdev->dev, "no irq for node %s\n", np->full_name);
         return -ENXIO;
@@ -1387,7 +1387,7 @@ static int fsl_ssi_probe(struct platform_device *pdev)
     if (ssi_private->soc->imx) {
         ret = fsl_ssi_imx_probe(pdev, ssi_private, iomem);
         if (ret)
-            goto error_irqmap;
+            return ret;
     }

     ret = snd_soc_register_component(&pdev->dev, &fsl_ssi_component,
@@ -1458,10 +1458,6 @@ error_asoc_register:
     if (ssi_private->soc->imx)
         fsl_ssi_imx_clean(pdev, ssi_private);

-error_irqmap:
-    if (ssi_private->use_dma)
-        irq_dispose_mapping(ssi_private->irq);
-
     return ret;
 }

@@ -1478,9 +1474,6 @@ static int fsl_ssi_remove(struct platform_device *pdev)
     if (ssi_private->soc->imx)
         fsl_ssi_imx_clean(pdev, ssi_private);

-    if (ssi_private->use_dma)
-        irq_dispose_mapping(ssi_private->irq);
-
     return 0;
 }

-- 
1.9.1
