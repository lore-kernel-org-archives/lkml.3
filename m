Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab3CSLuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:50:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46417 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3CSLuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:50:17 -0400
Date: Tue, 19 Mar 2013 11:50:12 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 66/88] hwmon: (sht15) Check return value of
 regulator_enable()
Message-ID: <20130319115012.GA3190@hercules>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
 <1363257381-15900-67-git-send-email-luis.henriques@canonical.com>
 <1363662049.3937.363.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363662049.3937.363.camel@deadeye.wl.decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 03:00:49AM +0000, Ben Hutchings wrote:
> On Thu, 2013-03-14 at 10:35 +0000, Luis Henriques wrote:
> > 3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > 
> > commit 3e78080f81481aa8340374d5a37ae033c1cf4272 upstream.
> > 
> > Not having power is a pretty serious error so check that we are able to
> > enable the supply and error out if we can't.
> > 
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> > ---
> >  drivers/hwmon/sht15.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
> > index 8b011d0..eb01802 100644
> > --- a/drivers/hwmon/sht15.c
> > +++ b/drivers/hwmon/sht15.c
> > @@ -926,7 +926,13 @@ static int __devinit sht15_probe(struct platform_device *pdev)
> >  		if (voltage)
> >  			data->supply_uV = voltage;
> >  
> > -		regulator_enable(data->reg);
> > +		ret = regulator_enable(data->reg);
> > +		if (ret != 0) {
> > +			dev_err(&pdev->dev,
> > +				"failed to enable regulator: %d\n", ret);
> > +			return ret;
> > +		}
> > +
> >  		/*
> >  		 * Setup a notifier block to update this if another device
> >  		 * causes the voltage to change
> 
> This needs the same fix-up as in 3.4.y:

Thanks Ben, I'll queue this fix for 3.5.

Cheers,
--
Luis

> 
> --- From: Ben Hutchings <ben@decadent.org.uk> Subject: hwmon: sht15:
> Fix memory leak if regulator_enable() fails Date: Sat, 16 Mar 2013
> 04:11:01 +0000
> 
> Commit 3e78080f8148 ('hwmon: (sht15) Check return value of
> regulator_enable()') depends on the use of devm_kmalloc() for automatic
> resource cleanup in the failure cases, which was introduced in 3.7.  In
> older stable branches, explicit cleanup is needed.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> --- a/drivers/hwmon/sht15.c
> +++ b/drivers/hwmon/sht15.c
> @@ -930,7 +930,7 @@
>  		if (ret != 0) {
>  			dev_err(&pdev->dev,
>  				"failed to enable regulator: %d\n", ret);
> -			return ret;
> +			goto err_free_data;
>  		}
>  
>  		/*
> 
> -- 
> Ben Hutchings
> When you say `I wrote a program that crashed Windows', people just stare ...
> and say `Hey, I got those with the system, *for free*'. - Linus Torvalds
