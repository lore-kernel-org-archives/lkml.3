Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbbAEQwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:52:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:55866 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbbAEQwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:52:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,700,1413270000"; 
   d="scan'208";a="657030039"
From: "Jiang, Dave" <dave.jiang@intel.com>
To: "der.herr@hofr.at" <der.herr@hofr.at>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rashika.kheria@gmail.com" <rashika.kheria@gmail.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: Re: [PATCH] ioat: fail self-test if wait_for_completion times out
Thread-Topic: [PATCH] ioat: fail self-test if wait_for_completion times out
Thread-Index: AQHQIorOSaVKzf9bt063KEMfjRC+jpyyUNSA
Date: Mon, 5 Jan 2015 16:51:51 +0000
Message-ID: <1420476711.7745.2.camel@djiang5-desk2.amr.corp.intel.com>
References: <1419763047-15414-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1419763047-15414-1-git-send-email-der.herr@hofr.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.2.105.66]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0ACB727D99CCF048BA25CF65084AF73A@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t05GqBeb007176




On Sun, 2014-12-28 at 10:37 +0000, Nicholas Mc Guire wrote:
> wait_for_completion_timeout reaching timeout was being ignored,
> fail the self-test if timeout condition occurs.
> 
> Not sure about the indentations used (CodingStyle:Chapter 2)
> 
> this was only compile tested with
> x86_64_defconfig + CONFIG_DMA_ENGINE=y + CONFIG_INTEL_IOATDMA=y
> 
> patch is against linux-next 3.19.0-rc1 -next-20141226
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
>  drivers/dma/ioat/dma_v3.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> index be307182..0659215 100644
> --- a/drivers/dma/ioat/dma_v3.c
> +++ b/drivers/dma/ioat/dma_v3.c
> @@ -1311,7 +1311,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
> 
>  	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
> 
> -	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> +	if (tmo == 0 || dma->device_tx_status(dma_chan, cookie, NULL)
> +			!= DMA_COMPLETE) {
>  		dev_err(dev, "Self-test xor timed out\n");
>  		err = -ENODEV;
>  		goto dma_unmap;
> @@ -1377,7 +1378,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
> 
>  	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
> 
> -	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> +	if (tmo == 0 || dma->device_tx_status(dma_chan, cookie, NULL)
> +			!= DMA_COMPLETE) {

Can you please do: 
+	if (tmo == 0 ||
+	    dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {

Otherwise it looks good. Although I've never hit that error condition either. 

>  		dev_err(dev, "Self-test validate timed out\n");
>  		err = -ENODEV;
>  		goto dma_unmap;
> @@ -1429,7 +1431,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
> 
>  	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
> 
> -	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> +	if (tmo == 0 || dma->device_tx_status(dma_chan, cookie, NULL)
> +			!= DMA_COMPLETE) {
>  		dev_err(dev, "Self-test 2nd validate timed out\n");
>  		err = -ENODEV;
>  		goto dma_unmap;
> --
> 1.7.10.4
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
