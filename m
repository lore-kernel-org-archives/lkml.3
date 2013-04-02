Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761206Ab3DBOAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:00:34 -0400
Received: from ams-iport-4.cisco.com ([144.254.224.147]:44868 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761158Ab3DBOAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:00:32 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Apr 2013 10:00:32 EDT
X-IronPort-AV: E=Sophos;i="4.87,393,1363132800"; 
   d="scan'208";a="13037141"
From: Hans Verkuil <hansverk@cisco.com>
Organization: Cisco Systems Norway
To: Prabhakar lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v3] davinci: vpif: add pm_runtime support
Date: Tue, 2 Apr 2013 15:50:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.7-7.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, Sekhar Nori <nsekhar@ti.com>
References: <1364910090-5501-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1364910090-5501-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304021550.21018.hansverk@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2 April 2013 15:41:30 Prabhakar lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> Add pm_runtime support to the TI Davinci VPIF driver.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Sekhar Nori <nsekhar@ti.com>
> ---
>  Changes for v3:
>  1: Removed pm_runtime_resume() from probe as pm_runtime_get()
>     calls it as pointed by Hans.
> 
>  Changes for v2:
>  1: Removed use of clk API as pointed by Laurent and Sekhar.
> 
>  drivers/media/platform/davinci/vpif.c |   24 ++++++------------------
>  1 files changed, 6 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
> index 3bc4db8..ea82a8b 100644
> --- a/drivers/media/platform/davinci/vpif.c
> +++ b/drivers/media/platform/davinci/vpif.c
> @@ -23,8 +23,8 @@
>  #include <linux/spinlock.h>
>  #include <linux/kernel.h>
>  #include <linux/io.h>
> -#include <linux/clk.h>
>  #include <linux/err.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/v4l2-dv-timings.h>
>  
>  #include <mach/hardware.h>
> @@ -46,8 +46,6 @@ spinlock_t vpif_lock;
>  void __iomem *vpif_base;
>  EXPORT_SYMBOL_GPL(vpif_base);
>  
> -struct clk *vpif_clk;
> -
>  /**
>   * vpif_ch_params: video standard configuration parameters for vpif
>   * The table must include all presets from supported subdevices.
> @@ -443,19 +441,13 @@ static int vpif_probe(struct platform_device *pdev)
>  		goto fail;
>  	}
>  
> -	vpif_clk = clk_get(&pdev->dev, "vpif");
> -	if (IS_ERR(vpif_clk)) {
> -		status = PTR_ERR(vpif_clk);
> -		goto clk_fail;
> -	}
> -	clk_prepare_enable(vpif_clk);
> +	pm_runtime_enable(&pdev->dev);
> +	pm_runtime_get(&pdev->dev);
>  
>  	spin_lock_init(&vpif_lock);
>  	dev_info(&pdev->dev, "vpif probe success\n");
>  	return 0;
>  
> -clk_fail:
> -	iounmap(vpif_base);
>  fail:
>  	release_mem_region(res->start, res_len);
>  	return status;
> @@ -463,11 +455,7 @@ fail:
>  
>  static int vpif_remove(struct platform_device *pdev)
>  {
> -	if (vpif_clk) {
> -		clk_disable_unprepare(vpif_clk);
> -		clk_put(vpif_clk);
> -	}
> -
> +	pm_runtime_disable(&pdev->dev);
>  	iounmap(vpif_base);
>  	release_mem_region(res->start, res_len);
>  	return 0;
> @@ -476,13 +464,13 @@ static int vpif_remove(struct platform_device *pdev)
>  #ifdef CONFIG_PM
>  static int vpif_suspend(struct device *dev)
>  {
> -	clk_disable_unprepare(vpif_clk);
> +	pm_runtime_put(dev);
>  	return 0;
>  }
>  
>  static int vpif_resume(struct device *dev)
>  {
> -	clk_prepare_enable(vpif_clk);
> +	pm_runtime_get(dev);
>  	return 0;
>  }
>  
> 
