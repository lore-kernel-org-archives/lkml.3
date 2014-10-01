Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaJAJNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 05:13:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:1613 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaJAJNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 05:13:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,630,1406617200"; 
   d="scan'208";a="581761789"
Date: Wed, 1 Oct 2014 12:13:09 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 10/15] leds: leds-gpio: Add ACPI probing support
Message-ID: <20141001091309.GY1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <1852462.V1jlbi8OPt@vostro.rjw.lan>
 <4835699.XutTNxriDg@vostro.rjw.lan>
 <2780318.hxubhI9Rvq@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2780318.hxubhI9Rvq@wuerfel>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:13:04AM +0200, Arnd Bergmann wrote:
> On Wednesday 01 October 2014 04:17:02 Rafael J. Wysocki wrote:
> > Index: linux-pm/drivers/leds/leds-gpio.c
> > ===================================================================
> > --- linux-pm.orig/drivers/leds/leds-gpio.c
> > +++ linux-pm/drivers/leds/leds-gpio.c
> > @@ -231,6 +231,13 @@ static const struct of_device_id of_gpio
> >  
> >  MODULE_DEVICE_TABLE(of, of_gpio_leds_match);
> >  
> > +static const struct acpi_device_id acpi_gpio_leds_match[] = {
> > +       { "PRP0001" }, /* Device Tree shoehorned into ACPI */
> > +       {},
> > +};
> > +
> > +MODULE_DEVICE_TABLE(acpi, acpi_gpio_leds_match);
> > +
> >  static int gpio_led_probe(struct platform_device *pdev)
> >  {
> >         struct gpio_led_platform_data *pdata = dev_get_platdata(&pdev->dev);
> > @@ -286,6 +293,7 @@ static struct platform_driver gpio_led_d
> >                 .name   = "leds-gpio",
> >                 .owner  = THIS_MODULE,
> >                 .of_match_table = of_gpio_leds_match,
> > +               .acpi_match_table = acpi_gpio_leds_match,
> >         },
> >  };
> 
> Is this something you'd have to do in every driver you want to support
> _PRP based probing? For the ".acpi_match_table =" reference, I think
> you could actually provide a generic acpi_device_id table exported from
> core code that you refer to, so each driver just does
> 
> 	.acpi_match_table = acpi_match_by_of_compatible,
> 
> (or whatever you want to call it).

That's a good idea.

> Regarding the MODULE_DEVICE_TABLE, I suspect the above won't work the
> way you are hoping for, because once you get to dozens or hundreds of
> drivers doing this, each device will show up with the same string,
> so udev will try to load all the modules that list "PRP0001". That
> doesn't look right. With the code from patch 3, you can probably drop
> the acpi MODULE_DEVICE_TABLE() entirely and get the correct behavior.

It actually works like this now:

 # cd /sys/bus/platform/devices/PRP0001\:00/
 DRIVER=leds-gpio
 MODALIAS=of:Nprp0001TacpiCgpio-leds

 # cat modalias 
 of:Nprp0001TacpiCgpio-leds

In other words the modalias changes to be of:Nprp0001Tacpi, e.g
name=prp0001, type=acpi and then list of compatible values.

Udev then loads only module that matches the modalias so it should not
load everything listing PRP0001 in their MODULE_DEVICE_TABLE().
