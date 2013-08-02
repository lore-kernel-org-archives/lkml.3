Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab3HBFgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 01:36:46 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9508 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab3HBFgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 01:36:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 01 Aug 2013 22:36:43 -0700
Message-ID: <1375422317.32701.19.camel@bilhuang-vm1>
Subject: Re: [PATCH v2 1/1] mfd: palmas: Add power off control
From: Bill Huang <bilhuang@nvidia.com>
To: Nishanth Menon <nm@ti.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mallikarjun Kasoju <mkasoju@nvidia.com>
Date: Thu, 1 Aug 2013 22:45:17 -0700
In-Reply-To: <20130801130857.GA3413@kahuna>
References: <1375255037-10024-1-git-send-email-bilhuang@nvidia.com>
	 <51F8FBC4.1040009@ti.com> <1375355332.32701.13.camel@bilhuang-vm1>
	 <20130801130857.GA3413@kahuna>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 21:08 +0800, Nishanth Menon wrote:
> On 04:08-20130801, Bill Huang wrote:
> > On Wed, 2013-07-31 at 19:57 +0800, Nishanth Menon wrote:
> > > 
> > > If you notice the reference code I send, atleast on TWL6035/37 variants 
> > > of Palmas, USB IRQ unmask is mandatory for power on with USB cable - 
> > > example usage scenario: extremely low battery, device powered off, plug 
> > > in usb cable to restart charging - you'd like to initiate charging logic 
> > > in bootloader, but that wont work if the device does not do OFF-ON 
> > > transition with usb cable plugged in for vbus.
> > > 
> > Why do we need to add Palmas USB_IRQ unmask logic in shutdown? Does that
> > mean for all platform using Palmas has to unmask USB IRQ (including
> > those do not power vbus through Palmas)? Can't we just have a simple
> > shutdown function but have the VBus programming been done in USB driver
> > or maybe platform driver since it is platform specific control?
> we dont have a irq cleanup, irq handling is done in palmas-mfd. Further,
> 
> Why would USB driver care about vbus supply needs in complete power off
> - it is the job of palmas driver? Further, palmas-mfd shutdown
> handler(currently missing) if probably cleansup things:
> 
>  mfd_remove_devices(palmas->dev);
>   palmas_irq_exit(palmas);
> 
> shutdown sequence becomes complicated further esp if things are
> cleanedup in shutdown (Dummy patch[1]).
> 
>  
> All I am saying is this: shutdown should allow powerup functionality to
> work as well, how we do that is upto us - I personally found it a little
> easier to keep the IRQ unmask in shutdown easier to deal with, but other
> options might be possible as well.

I'm not sure if I understand your comments completely (maybe due to I'm
not familiar with the mechanism of unmasking USB IRQ in Palmas driver)
but doing cleanup in each driver shutdown handler makes sense to me, if
those clean up can be done in shutdown then we can make power off
function as simple as possible and being part of Palmas mfd driver?
> 
> [1]
> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
> index e4d1c70..6998863 100644
> --- a/drivers/mfd/palmas.c
> +++ b/drivers/mfd/palmas.c
> @@ -447,6 +447,11 @@ static int palmas_i2c_remove(struct i2c_client *i2c)
>  	return 0;
>  }
>  
> +static void palmas_i2c_shutdown(struct i2c_client *i2c)
> +{
> +	palmas_i2c_remove(i2c);
> +}
> +
>  static const struct i2c_device_id palmas_i2c_id[] = {
>  	{ "palmas", },
>  	{ "twl6035", },
> @@ -464,6 +469,7 @@ static struct i2c_driver palmas_i2c_driver = {
>  	},
>  	.probe = palmas_i2c_probe,
>  	.remove = palmas_i2c_remove,
> +	.shutdown = palmas_i2c_shutdown,
>  	.id_table = palmas_i2c_id,
>  };
>  


