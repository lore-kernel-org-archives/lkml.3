Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbaFBQhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:37:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:35854 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbaFBQhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:37:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,957,1392192000"; 
   d="scan'208";a="439908444"
Subject: Re: [PATCH] misc: mic: Introduce the managed version of ioremap
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: sudeep.dutt@intel.com, Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
In-Reply-To: <20140601185452.GA21438@himangi-Dell>
References: <20140601185452.GA21438@himangi-Dell>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jun 2014 09:30:05 -0700
Message-ID: <1401726605.1619.20.camel@rbtaylor-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 00:24 +0530, Himangi Saraogi wrote:
> This patch moves data allocated using ioremap to managed data allocated
> using devm_ioremap and cleans now unnecessary iounmaps in probe and remove
> functions. Also the unnecessary label iounmap is done away with.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> ---
> I wonder if mic_card_map and mic_card_unmap can be used on the same data
> as the devm_ioremap in the probe function. If yes, can I devmify them as well,
> in which case mic_card_unmap will not be required.
> 

Hi Himangi,

Thanks for the patch which I have tested on MIC and it works fine.
mic_card_map(..) and mic_card_unmap(..) can be called multiple times
while the driver is loaded so it would be best to leave those APIs
unchanged or modify them to use devm_ioremap(..) and devm_iounmap(..)
instead.

This patch does create conflicts with a MIC DMA patch series under
review @ https://lkml.org/lkml/2014/5/29/981 I will send your patch to
Greg K-H for inclusion in char-misc-next once the larger patch is
accepted so that there are no conflicts.

Thanks,
Sudeep Dutt

>  drivers/misc/mic/card/mic_x100.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/misc/mic/card/mic_x100.c b/drivers/misc/mic/card/mic_x100.c
> index 2868945..5f26b17 100644
> --- a/drivers/misc/mic/card/mic_x100.c
> +++ b/drivers/misc/mic/card/mic_x100.c
> @@ -159,7 +159,8 @@ static int __init mic_probe(struct platform_device *pdev)
>  
>  	mdev->mmio.pa = MIC_X100_MMIO_BASE;
>  	mdev->mmio.len = MIC_X100_MMIO_LEN;
> -	mdev->mmio.va = ioremap(MIC_X100_MMIO_BASE, MIC_X100_MMIO_LEN);
> +	mdev->mmio.va = devm_ioremap(&pdev->dev, MIC_X100_MMIO_BASE,
> +				     MIC_X100_MMIO_LEN);
>  	if (!mdev->mmio.va) {
>  		dev_err(&pdev->dev, "Cannot remap MMIO BAR\n");
>  		rc = -EIO;
> @@ -169,22 +170,17 @@ static int __init mic_probe(struct platform_device *pdev)
>  	rc = mic_driver_init(mdrv);
>  	if (rc) {
>  		dev_err(&pdev->dev, "mic_driver_init failed rc %d\n", rc);
> -		goto iounmap;
> +		goto done;
>  	}
>  done:
>  	return rc;
> -iounmap:
> -	iounmap(mdev->mmio.va);
> -	return rc;
>  }
>  
>  static int mic_remove(struct platform_device *pdev)
>  {
>  	struct mic_driver *mdrv = &g_drv;
> -	struct mic_device *mdev = &mdrv->mdev;
>  
>  	mic_driver_uninit(mdrv);
> -	iounmap(mdev->mmio.va);
>  	return 0;
>  }
>  


