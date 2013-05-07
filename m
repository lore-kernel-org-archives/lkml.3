Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343Ab3EGDBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 23:01:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6675 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757867Ab3EGDBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:01:35 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7202271"
Message-ID: <51886E12.8070701@cn.fujitsu.com>
Date: Tue, 07 May 2013 10:59:30 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: wsa@the-dreams.de, uclinux-dist-devel@blackfin.uclinux.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 2/2] i2c: pxa: no need release_mem_region before request_mem_region
 successful
References: <5187ABF9.4000903@huawei.com>
In-Reply-To: <5187ABF9.4000903@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 11:00:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 11:00:38,
	Serialize complete at 2013/05/07 11:00:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi libo,

On 05/06/2013 09:11 PM, Libo Chen wrote:

> 
> move release_mem_region above kfree(i2c) && below clk_put(i2c->clk)
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/i2c/busses/i2c-pxa.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> index ea6d45d..3188cd0 100644
> --- a/drivers/i2c/busses/i2c-pxa.c
> +++ b/drivers/i2c/busses/i2c-pxa.c
> @@ -1129,7 +1129,7 @@ static int i2c_pxa_probe(struct platform_device *dev)
>  	i2c->clk = clk_get(&dev->dev, NULL);
>  	if (IS_ERR(i2c->clk)) {
>  		ret = PTR_ERR(i2c->clk);
> -		goto eclk;
> +		goto emm;

The new tag 'emm' seems not suitable here, keep the original 'eclk' here, modify the upper 'eclk' tags instead:
...
	ret = i2c_pxa_probe_dt(dev, i2c, &i2c_type);
	if (ret > 0)
		ret = i2c_pxa_probe_pdata(dev, i2c, &i2c_type);
	if (ret < 0)
-		goto eclk;
+		goto etype;

	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
	irq = platform_get_irq(dev, 0);
	if (res == NULL || irq < 0) {
		ret = -ENODEV;
-		goto eclk;
+		goto edev;
	}

	if (!request_mem_region(res->start, resource_size(res), res->name)) {
		ret = -ENOMEM;
-		goto eclk;
+		goto emem;
	}
...

>  	}
> 
>  	i2c->reg_base = ioremap(res->start, resource_size(res));
> @@ -1206,10 +1206,11 @@ ereqirq:
>  	iounmap(i2c->reg_base);
>  eremap:
>  	clk_put(i2c->clk);
> +emm:
> +	release_mem_region(res->start, resource_size(res));
>  eclk:
>  	kfree(i2c);

   eclk:
	release_mem_region(res->start, resource_size(res));
   etype:
   edev:
   emem:
  	kfree(i2c);

>  emalloc:
> -	release_mem_region(res->start, resource_size(res));
>  	return ret;
>  }
> 

Thanks,
Gu

