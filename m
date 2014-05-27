Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbaE0VOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:14:12 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:40747 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaE0VOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:14:10 -0400
Date: Tue, 27 May 2014 18:13:57 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, julia.lawall@lip6.fr,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] ehea: Introduce the use of the managed version of
 kzalloc
Message-ID: <20140527211357.GA4700@oc0268524204.ibm.com>
References: <20140525185037.GA3041@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140525185037.GA3041@himangi-Dell>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052721-1798-0000-0000-000002B55476
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 12:20:38AM +0530, Himangi Saraogi wrote:
> This patch moves data allocated using kzalloc to managed data allocated
> using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> functions. Also, linux/device.h is added to make sure the devm_*()
> routine declarations are unambiguously available.
> 
> The following Coccinelle semantic patch was used for making the change:
> 
> @platform@
> identifier p, probefn, removefn;
> @@
> struct platform_driver p = {
>   .probe = probefn,
>   .remove = removefn,
> };
> 
> @prb@
> identifier platform.probefn, pdev;
> expression e, e1, e2;
> @@
> probefn(struct platform_device *pdev, ...) {
>   <+...
> - e = kzalloc(e1, e2)
> + e = devm_kzalloc(&pdev->dev, e1, e2)
>   ...
> ?-kfree(e);
>   ...+>
> }
> 
> @rem depends on prb@
> identifier platform.removefn;
> expression e;
> @@
> removefn(...) {
>   <...
> - kfree(e);
>   ...>
> }
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> ---
> Not compiled due to incompatible architecture

For now, compile-tested.

Cascardo.

> 
> v2: add linux/device.h include
>  drivers/net/ethernet/ibm/ehea/ehea_main.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
> index 538903b..a25f3c6 100644
> --- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
> +++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
> @@ -29,6 +29,7 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
>  #include <linux/in.h>
> +#include<linux/device.h>
>  #include <linux/ip.h>
>  #include <linux/tcp.h>
>  #include <linux/udp.h>
> @@ -3273,7 +3274,7 @@ static int ehea_probe_adapter(struct platform_device *dev)
>  		return -EINVAL;
>  	}
> 
> -	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
> +	adapter = devm_kzalloc(&dev->dev, sizeof(*adapter), GFP_KERNEL);
>  	if (!adapter) {
>  		ret = -ENOMEM;
>  		dev_err(&dev->dev, "no mem for ehea_adapter\n");
> @@ -3359,7 +3360,6 @@ out_kill_eq:
> 
>  out_free_ad:
>  	list_del(&adapter->list);
> -	kfree(adapter);
> 
>  out:
>  	ehea_update_firmware_handles();
> @@ -3386,7 +3386,6 @@ static int ehea_remove(struct platform_device *dev)
>  	ehea_destroy_eq(adapter->neq);
>  	ehea_remove_adapter_mr(adapter);
>  	list_del(&adapter->list);
> -	kfree(adapter);
> 
>  	ehea_update_firmware_handles();
> 
> -- 
> 1.9.1
> 

