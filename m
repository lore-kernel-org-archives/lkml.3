Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3DZOac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:30:32 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:42898 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab3DZOab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:30:31 -0400
Date: Fri, 26 Apr 2013 09:28:15 -0500
From: Kent Yoder <shpedoikal@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: key@linux.vnet.ibm.com, mail@srajiv.net, tpmdd@selhorst.net,
        tpmdd@sirrix.com, yongjun_wei@trendmicro.com.cn,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH] tpm_tis: missing
 platform_driver_unregister() on error in init_tis()
Message-ID: <20130426142814.GA19153@gmail.com>
References: <CAPgLHd9-Ji3TaH9iFGt7d0R3rtQMkbmMvYQnSwwcehEn1=qP5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd9-Ji3TaH9iFGt7d0R3rtQMkbmMvYQnSwwcehEn1=qP5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 03:07:47PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing platform_driver_unregister() before return
> from init_tis() in the device register error handling case.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

  Applied and staged here, thanks!

  git://github.com/shpedoikal/linux.git tpmdd-04-26-13

Kent

> ---
>  drivers/char/tpm/tpm_tis.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 8a41b6b..2f777a4 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -884,13 +884,20 @@ static int __init init_tis(void)
>  	rc = platform_driver_register(&tis_drv);
>  	if (rc < 0)
>  		return rc;
> -	if (IS_ERR(pdev=platform_device_register_simple("tpm_tis", -1, NULL, 0)))
> -		return PTR_ERR(pdev);
> -	if((rc=tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0)) != 0) {
> -		platform_device_unregister(pdev);
> -		platform_driver_unregister(&tis_drv);
> +	pdev = platform_device_register_simple("tpm_tis", -1, NULL, 0);
> +	if (IS_ERR(pdev)) {
> +		rc = PTR_ERR(pdev);
> +		goto err_dev;
>  	}
> -	return rc;
> +	rc = tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0);
> +	if (rc)
> +		goto err_init;
> +	return 0;
> +err_init:
> +	platform_device_unregister(pdev);
> +err_dev:
> +	platform_driver_unregister(&tis_drv);
> +	return rc;
>  }
>  
>  static void __exit cleanup_tis(void)
> 
> 
> ------------------------------------------------------------------------------
> Try New Relic Now & We'll Send You this Cool Shirt
> New Relic is the only SaaS-based application performance monitoring service 
> that delivers powerful full stack analytics. Optimize and monitor your
> browser, app, & servers with just a few lines of code. Try New Relic
> and get this awesome Nerd Life shirt! http://p.sf.net/sfu/newrelic_d2d_apr
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
