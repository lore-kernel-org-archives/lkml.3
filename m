Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab3D2SH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:07:56 -0400
Received: from nm17.access.bullet.mail.sp2.yahoo.com ([98.139.44.144]:23148
	"EHLO nm17.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754931Ab3D2SHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:07:55 -0400
X-Yahoo-Newman-Id: 914322.76609.bm@smtp118.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: VvQezucVM1kQOSbMkSw9lMSwCpeg50sMiC_EAYOLDoGqdCP
 SeqSFs3arLg15k6POuWQYc.opDvB_HPU613dSqCiYURDbtd2ahcBhKZaJt5f
 pTeATxmnEB8Fvg8dWpJZHZ3HkhvQeRwnwWkxMoZuJl18dz7PnnrA7qgzsSkU
 Li.55K7U.EKO3i8tTZ4E3R0MWm0coKDk75PYFrLU_qPYjvpYY8M1Q8SvDlb0
 9DrlJ1WyfpkHcgXaGYXVBPfr8o1r1HE0F2fRtogWAEX0pgo7FYegAUrFtje8
 n6XZ9w2MxcqACR.8tgoXSYOG6gTqh2A_KUSLgZImB8OPnl3oVmri7xljc1zA
 9kgBNGkSYISnuzuxXITfFDnbFD7GqQ58vAAN_gDyzTnMu4Kw9SiPmROjVJqR
 4b8p7Fk5wNudFGGrxQzlkpxN7B.0rb.6H1GqrxnEfPEtOqniCanzQe6TAvlL
 z.oT8imrCMqN1SqFRtCCcoOIciQJJR3RP
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp118.sbc.mail.ne1.yahoo.com with SMTP; 29 Apr 2013 18:07:54 +0000 UTC
Date: Mon, 29 Apr 2013 11:07:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH RESEND 6/7] watchdog: riowd: use devm_kzalloc()
Message-ID: <20130429180755.GF5183@roeck-us.net>
References: <001001ce44bc$faf2ce40$f0d86ac0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001001ce44bc$faf2ce40$f0d86ac0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 06:36:09PM +0900, Jingoo Han wrote:
> Use devm_kzalloc() to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/watchdog/riowd.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
> index 0040451..13363ad 100644
> --- a/drivers/watchdog/riowd.c
> +++ b/drivers/watchdog/riowd.c
> @@ -183,7 +183,7 @@ static int riowd_probe(struct platform_device *op)
>  		goto out;
>  
>  	err = -ENOMEM;
> -	p = kzalloc(sizeof(*p), GFP_KERNEL);
> +	p = devm_kzalloc(&op->dev, sizeof(*p), GFP_KERNEL);
>  	if (!p)
>  		goto out;
>  
That goto is really unnecessary. Just return -ENOMEM and drop the label.
Though that is really another logical change and should be done separately,
so

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> @@ -192,7 +192,7 @@ static int riowd_probe(struct platform_device *op)
>  	p->regs = of_ioremap(&op->resource[0], 0, 2, DRIVER_NAME);
>  	if (!p->regs) {
>  		pr_err("Cannot map registers\n");
> -		goto out_free;
> +		goto out;
>  	}
>  	/* Make miscdev useable right away */
>  	riowd_device = p;
> @@ -213,9 +213,6 @@ out_iounmap:
>  	riowd_device = NULL;
>  	of_iounmap(&op->resource[0], p->regs, 2);
>  
> -out_free:
> -	kfree(p);
> -
>  out:
>  	return err;
>  }
> @@ -226,7 +223,6 @@ static int riowd_remove(struct platform_device *op)
>  
>  	misc_deregister(&riowd_miscdev);
>  	of_iounmap(&op->resource[0], p->regs, 2);
> -	kfree(p);
>  
>  	return 0;
>  }
> -- 
> 1.7.2.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
