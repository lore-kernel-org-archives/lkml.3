Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaETPvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:51:54 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:37471 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaETPvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:51:53 -0400
Date: Tue, 20 May 2014 08:51:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Jean Delvare <jdelvare@suse.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] hwmon: Introduce the use of the managed version of
 kzalloc
Message-ID: <20140520155138.GA23434@roeck-us.net>
References: <20140518063256.GA7599@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140518063256.GA7599@himangi-Dell>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 12:02:56PM +0530, Himangi Saraogi wrote:
> This patch moves data allocated using kzalloc to managed data allocated
> using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> functions. Also, the unnecessary label out_free is removed.
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
> Not compile tested.
> 
> To send to: Jean Delvare <jdelvare@suse.de>,Guenter Roeck <linux@roeck-us.net>,
> lm-sensors@lm-sensors.org,linux-kernel@vger.kernel.org
> 
>  drivers/hwmon/ultra45_env.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/hwmon/ultra45_env.c b/drivers/hwmon/ultra45_env.c
> index fb3e693..92564b8 100644
> --- a/drivers/hwmon/ultra45_env.c
> +++ b/drivers/hwmon/ultra45_env.c
> @@ -252,7 +252,7 @@ static const struct attribute_group env_group = {
>  
>  static int env_probe(struct platform_device *op)
>  {
> -	struct env *p = kzalloc(sizeof(*p), GFP_KERNEL);
> +	struct env *p = devm_kzalloc(&op->dev, sizeof(*p), GFP_KERNEL);
>  	int err = -ENOMEM;
>  
>  	if (!p)
> @@ -262,7 +262,7 @@ static int env_probe(struct platform_device *op)
>  
>  	p->regs = of_ioremap(&op->resource[0], 0, REG_SIZE, "pic16f747");
>  	if (!p->regs)
> -		goto out_free;
> +		goto out;
>  
>  	err = sysfs_create_group(&op->dev.kobj, &env_group);
>  	if (err)
> @@ -285,9 +285,7 @@ out_sysfs_remove_group:
>  
>  out_iounmap:
>  	of_iounmap(&op->resource[0], p->regs, REG_SIZE);
> -
> -out_free:
> -	kfree(p);
> +	
>  	goto out;
>  }

This introduces a whitespace error, and results in really ugly code.

        err = 0;

out:
        return err;

out_sysfs_remove_group:
        sysfs_remove_group(&op->dev.kobj, &env_group);

out_iounmap:
	of_iounmap(&op->resource[0], p->regs, REG_SIZE);

	goto out;
}

Ok, the code is already ugly, but it doesn't make sense to me
to spend time on it without cleaning it up.

Guenter
