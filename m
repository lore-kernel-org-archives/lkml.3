Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab3BRDmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 22:42:21 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49815 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483Ab3BRDmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 22:42:20 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
CC: "wim@iguana.be" <wim@iguana.be>, "Nori, Sekhar" <nsekhar@ti.com>,
        "Kumar, Anil" <anilkumar.v@ti.com>
Subject: RE: [PATCH V2] watchdog: davinci_wdt: update to devm_* API
Thread-Topic: [PATCH V2] watchdog: davinci_wdt: update to devm_* API
Thread-Index: AQHOBc870MtGYfE0SEW3iqNb9smjO5h/Axwg
Date: Mon, 18 Feb 2013 03:42:09 +0000
Message-ID: <F3DBB1B3EF102E4994C89758CFCA32412C9258@DBDE01.ent.ti.com>
References: <1360309170-9672-1-git-send-email-anilkumar.v@ti.com>
In-Reply-To: <1360309170-9672-1-git-send-email-anilkumar.v@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 08, 2013 at 13:09:30, Kumar, Anil wrote:
> Update the code to use devm_* API so that driver
> core will manage resources.
> 
> Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
> ---
> This patch applies on top of v3.8-rc6.
> 
> Tested on da850 EVM.
> 
> Changes for V2:
>  - Use return -EADDRNOTAVAIL in case of devm_request_and_ioremap() fail.
>  - Use devm_clk_get() instead of clk_get().
>  - Revert back the change for *dev.
>  - Removes static type for "wdt_mem" structure as it is used only
>    inside the function now. 
>

Gentle Ping. As there are no review comments on this patch,
Could you please pull this patch ?    


> :100644 100644 e8e8724... 7df1fdc... M	drivers/watchdog/davinci_wdt.c
>  drivers/watchdog/davinci_wdt.c |   29 ++++++-----------------------
>  1 files changed, 6 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
> index e8e8724..7df1fdc 100644
> --- a/drivers/watchdog/davinci_wdt.c
> +++ b/drivers/watchdog/davinci_wdt.c
> @@ -69,7 +69,6 @@ static unsigned long wdt_status;
>  #define WDT_REGION_INITED 2
>  #define WDT_DEVICE_INITED 3
>  
> -static struct resource	*wdt_mem;
>  static void __iomem	*wdt_base;
>  struct clk		*wdt_clk;
>  
> @@ -201,10 +200,11 @@ static struct miscdevice davinci_wdt_miscdev = {
>  
>  static int davinci_wdt_probe(struct platform_device *pdev)
>  {
> -	int ret = 0, size;
> +	int ret = 0;
>  	struct device *dev = &pdev->dev;
> +	struct resource  *wdt_mem;
>  
> -	wdt_clk = clk_get(dev, NULL);
> +	wdt_clk = devm_clk_get(dev, NULL);
>  	if (WARN_ON(IS_ERR(wdt_clk)))
>  		return PTR_ERR(wdt_clk);
>  
> @@ -221,43 +221,26 @@ static int davinci_wdt_probe(struct platform_device *pdev)
>  		return -ENOENT;
>  	}
>  
> -	size = resource_size(wdt_mem);
> -	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
> -		dev_err(dev, "failed to get memory region\n");
> -		return -ENOENT;
> -	}
> -
> -	wdt_base = ioremap(wdt_mem->start, size);
> +	wdt_base = devm_request_and_ioremap(dev, wdt_mem);
>  	if (!wdt_base) {
> -		dev_err(dev, "failed to map memory region\n");
> -		release_mem_region(wdt_mem->start, size);
> -		wdt_mem = NULL;
> -		return -ENOMEM;
> +		dev_err(dev, "ioremap failed\n");
> +		return -EADDRNOTAVAIL;
>  	}
>  
>  	ret = misc_register(&davinci_wdt_miscdev);
>  	if (ret < 0) {
>  		dev_err(dev, "cannot register misc device\n");
> -		release_mem_region(wdt_mem->start, size);
> -		wdt_mem = NULL;
>  	} else {
>  		set_bit(WDT_DEVICE_INITED, &wdt_status);
>  	}
>  
> -	iounmap(wdt_base);
>  	return ret;
>  }
>  
>  static int davinci_wdt_remove(struct platform_device *pdev)
>  {
>  	misc_deregister(&davinci_wdt_miscdev);
> -	if (wdt_mem) {
> -		release_mem_region(wdt_mem->start, resource_size(wdt_mem));
> -		wdt_mem = NULL;
> -	}
> -
>  	clk_disable_unprepare(wdt_clk);
> -	clk_put(wdt_clk);
>  
>  	return 0;
>  }
> -- 
> 1.7.4.1
> 
> 

Thanks,
Anil
