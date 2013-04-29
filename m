Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab3D2L0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:26:55 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48906 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab3D2L0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:26:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Len Brown'" <len.brown@intel.com>,
        "'Pavel Machek'" <pavel@ucw.cz>, linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM: Add pm_ops_ptr() macro
Date: Mon, 29 Apr 2013 13:35:05 +0200
Message-ID: <2369076.UqXRQJTAqK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <000001ce449c$3e1ce0f0$ba56a2d0$@samsung.com>
References: <000001ce42f2$96128cc0$c237a640$@samsung.com> <20119404.Sfu5WntByi@vostro.rjw.lan> <000001ce449c$3e1ce0f0$ba56a2d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 29, 2013 02:41:48 PM Jingoo Han wrote:
> On Saturday, April 27, 2013 11:41 PM, Rafael J. Wysocki:
> > 
> > On Saturday, April 27, 2013 11:54:50 AM Jingoo Han wrote:
> > > Add pm_ops_ptr() macro that allows the .pm entry in the driver structures
> > > to be assigned without having an #define xxx NULL for the case that PM is
> > > not enabled.
> > >
> > > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > 
> > First, I'm not taking any more PM patches for v3.10 (that don't fix recent
> > regressions).
> > 
> > Second, please add that macro along with a user.
> 
> Hi Rafael,
> 
> This macro can be used as below:
> This macro cannot affect the procedure of suspend/resume
> calls; thus, there is no side effect.
> It just reduces the code size of each drivers.
> In this way, of_match_ptr() macro has been already used.

OK, so care to fold the below into your original patch?

Rafael


> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -1218,7 +1218,6 @@ static int s3c24xx_i2c_resume(struct device *dev)
>  }
>  #endif
> 
> -#ifdef CONFIG_PM
>  static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
>  #ifdef CONFIG_PM_SLEEP
>         .suspend_noirq = s3c24xx_i2c_suspend_noirq,
> @@ -1226,11 +1225,6 @@ static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
>  #endif
>  };
> 
> -#define S3C24XX_DEV_PM_OPS (&s3c24xx_i2c_dev_pm_ops)
> -#else
> -#define S3C24XX_DEV_PM_OPS NULL
> -#endif
> -
>  /* device driver for platform bus bits */
> 
>  static struct platform_driver s3c24xx_i2c_driver = {
> @@ -1240,7 +1234,7 @@ static struct platform_driver s3c24xx_i2c_driver = {
>         .driver         = {
>                 .owner  = THIS_MODULE,
>                 .name   = "s3c-i2c",
> -               .pm     = S3C24XX_DEV_PM_OPS,
> +               .pm     = pm_ops_ptr(&s3c24xx_i2c_dev_pm_ops),
>                 .of_match_table = of_match_ptr(s3c24xx_i2c_match),
>         },
>  };
> 
> Best regards,
> Jingoo Han
> 
> 
> > 
> > Thanks,
> > Rafael
> > 
> > 
> > > ---
> > >  include/linux/pm.h |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/include/linux/pm.h b/include/linux/pm.h
> > > index a224c7f..bd50d15 100644
> > > --- a/include/linux/pm.h
> > > +++ b/include/linux/pm.h
> > > @@ -55,8 +55,10 @@ struct device;
> > >
> > >  #ifdef CONFIG_PM
> > >  extern const char power_group_name[];		/* = "power" */
> > > +#define pm_ops_ptr(_ptr)	(_ptr)
> > >  #else
> > >  #define power_group_name	NULL
> > > +#define pm_ops_ptr(_ptr)	NULL
> > >  #endif
> > >
> > >  typedef struct pm_message {
> > >
> > --
> > I speak only for myself.
> > Rafael J. Wysocki, Intel Open Source Technology Center.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
