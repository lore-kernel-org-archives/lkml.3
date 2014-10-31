Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbaJaQW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:22:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:52531 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbaJaQWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:22:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="409174634"
Date: Fri, 31 Oct 2014 09:23:39 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141031162339.GA7136@psi-dev26.jf.intel.com>
References: <1412355319-18946-1-git-send-email-david.a.cohen@linux.intel.com>
 <1413224639-21552-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141013191405.GB29810@saruman>
 <20141013192404.GB4034@psi-dev26.jf.intel.com>
 <20141013192632.GC29810@saruman>
 <20141013193618.GD29810@saruman>
 <CACRpkdYDiFvwsPwqACXS2bZU9peUyJEn-fpzVqZKYXseuEFGGA@mail.gmail.com>
 <20141028144249.GD8123@saruman>
 <CACRpkdaN5hNWFUOFbHLm8HgZEKVSETUgVF4Cn4UbMQxNEg46Vw@mail.gmail.com>
 <20141031132005.GB1273@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031132005.GB1273@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 08:20:05AM -0500, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Oct 31, 2014 at 09:12:16AM +0100, Linus Walleij wrote:
> > On Tue, Oct 28, 2014 at 3:42 PM, Felipe Balbi <balbi@ti.com> wrote:
> > > On Tue, Oct 28, 2014 at 11:15:20AM +0100, Linus Walleij wrote:
> > >> On Mon, Oct 13, 2014 at 9:36 PM, Felipe Balbi <balbi@ti.com> wrote:
> > >> > On Mon, Oct 13, 2014 at 02:26:32PM -0500, Felipe Balbi wrote:
> > >>
> > >> > I also noticed that this is missing:
> > >> >
> > >> > diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
> > >> > index e12e5b0..7db5ab9 100644
> > >> > --- a/drivers/pinctrl/pinctrl-baytrail.c
> > >> > +++ b/drivers/pinctrl/pinctrl-baytrail.c
> > >> > @@ -614,3 +614,9 @@ static int __init byt_gpio_init(void)
> > >> >  }
> > >> >
> > >> >  subsys_initcall(byt_gpio_init);
> > >> > +
> > >> > +static void __exit byt_gpio_exit(void)
> > >> > +{
> > >> > +       platform_driver_unregister(&byt_gpio_driver);
> > >> > +}
> > >> > +module_exit(byt_gpio_exit);
> > >>
> > >> But the Baytrail driver is not a loadable module, it is bool:
> > >>
> > >> config PINCTRL_BAYTRAIL
> > >>         bool "Intel Baytrail GPIO pin control"
> > >>         depends on GPIOLIB && ACPI && X86
> > >>
> > >> (...)
> > >>
> > >> So I guess it won't need handling for removal, as it can only
> > >> be compiled-in.
> > >
> > > you can still unbind it through sysfs, right ? The thing also already
> > > provides a ->remove() method anyway.
> > 
> > Yes you're right of course...
> > 
> > But another way to get rid of the dilemma is to set
> > .suppress_bind_attrs = true on the .driver field of the
> > device driver. The one can't unbind it through sysfs anymore.
> > 
> >         .driver = {
> >                 .name   = "foo",
> >                 .suppress_bind_attrs = true,
> >         },
> > 
> > So one of them need to be done.
> > 
> > I suspect this is a kind of common problem...
> 
> so instead of taking of taking a three-liner which just makes sure this
> can be used as "intended" you prefer to:
> 
> diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
> index e12e5b0..254ba81 100644
> --- a/drivers/pinctrl/pinctrl-baytrail.c
> +++ b/drivers/pinctrl/pinctrl-baytrail.c
> @@ -587,16 +587,6 @@ static const struct acpi_device_id byt_gpio_acpi_match[] = {
>  };
>  MODULE_DEVICE_TABLE(acpi, byt_gpio_acpi_match);
>  
> -static int byt_gpio_remove(struct platform_device *pdev)
> -{
> -	struct byt_gpio *vg = platform_get_drvdata(pdev);
> -
> -	pm_runtime_disable(&pdev->dev);
> -	gpiochip_remove(&vg->chip);
> -
> -	return 0;
> -}
> -
>  static struct platform_driver byt_gpio_driver = {
>  	.probe          = byt_gpio_probe,
>  	.remove         = byt_gpio_remove,
> @@ -605,6 +595,7 @@ static struct platform_driver byt_gpio_driver = {
>  		.owner  = THIS_MODULE,
>  		.pm	= &byt_gpio_pm_ops,
>  		.acpi_match_table = ACPI_PTR(byt_gpio_acpi_match),
> +		.suppress_bind_attrs = true,
>  	},
>  };
>  
> 
> I don't quite care since this is not an architecture I work for, but I
> prefer drivers which can be unbound one way or another. Not to mention
> that there's already a ->remove callback on the platform_driver anyway.

I think adding the module exit + allowing this driver to be a module
would be a good approach. Then we don't need to force generic x86 kernel
binaries to always have this driver. Unless Mathias or Mika knows a
constraint to force this driver to be builtin only.

Br, David

> 
> -- 
> balbi


