Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3CKX6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:58:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:50904 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab3CKX6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:58:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,825,1355126400"; 
   d="scan'208";a="300397829"
Message-ID: <1363046296.2291.91.camel@rzhang1-mobl4>
Subject: Re: [PATCH] kirkwood: fix coccicheck warnings
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>,
        cpufreq@vger.kernel.org, andrew@lunn.ch, jason@lakedaemon.net,
        rob.lee@linaro.org, len.brown@intel.com, khilman@ti.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 12 Mar 2013 07:58:16 +0800
In-Reply-To: <9281321.Y04oYVrc0i@vostro.rjw.lan>
References: <1362987319-6369-1-git-send-email-silviupopescu1990@gmail.com>
	 <1363013700.2291.83.camel@rzhang1-mobl4>
	 <9281321.Y04oYVrc0i@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 18:03 +0100, Rafael J. Wysocki wrote:
> On Monday, March 11, 2013 10:55:00 PM Zhang Rui wrote:
> > On Mon, 2013-03-11 at 09:35 +0200, Silviu-Mihai Popescu wrote:
> > > Convert all uses of devm_request_and_ioremap() to the newly introduced
> > > devm_ioremap_resource() which provides more consistent error handling.
> > > 
> > > devm_ioremap_resource() provides its own error messages so all explicit
> > > error messages can be removed from the failure code paths.
> > > 
> > > Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> > > ---
> > >  drivers/cpufreq/kirkwood-cpufreq.c |    8 +++-----
> > >  drivers/cpuidle/cpuidle-kirkwood.c |    6 +++---
> > >  drivers/thermal/kirkwood_thermal.c |    8 +++-----
> > >  3 files changed, 9 insertions(+), 13 deletions(-)
> > > 
> > > diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
> > > index 0e83e3c..6052476 100644
> > > --- a/drivers/cpufreq/kirkwood-cpufreq.c
> > > +++ b/drivers/cpufreq/kirkwood-cpufreq.c
> > > @@ -175,11 +175,9 @@ static int kirkwood_cpufreq_probe(struct platform_device *pdev)
> > >  		dev_err(&pdev->dev, "Cannot get memory resource\n");
> > >  		return -ENODEV;
> > >  	}
> > > -	priv.base = devm_request_and_ioremap(&pdev->dev, res);
> > > -	if (!priv.base) {
> > > -		dev_err(&pdev->dev, "Cannot ioremap\n");
> > > -		return -EADDRNOTAVAIL;
> > > -	}
> > > +	priv.base = devm_ioremap_resource(&pdev->dev, res);
> > > +	if (IS_ERR(priv.base))
> > > +		return PTR_ERR(priv.base);
> > >  
> > >  	np = of_find_node_by_path("/cpus/cpu@0");
> > >  	if (!np)
> > > diff --git a/drivers/cpuidle/cpuidle-kirkwood.c b/drivers/cpuidle/cpuidle-kirkwood.c
> > > index 670aa1e..53aad73 100644
> > > --- a/drivers/cpuidle/cpuidle-kirkwood.c
> > > +++ b/drivers/cpuidle/cpuidle-kirkwood.c
> > > @@ -66,9 +66,9 @@ static int kirkwood_cpuidle_probe(struct platform_device *pdev)
> > >  	if (res == NULL)
> > >  		return -EINVAL;
> > >  
> > > -	ddr_operation_base = devm_request_and_ioremap(&pdev->dev, res);
> > > -	if (!ddr_operation_base)
> > > -		return -EADDRNOTAVAIL;
> > > +	ddr_operation_base = devm_ioremap_resource(&pdev->dev, res);
> > > +	if (IS_ERR(ddr_operation_base))
> > > +		return PTR_ERR(ddr_operation_base);
> > >  
> > >  	device = &per_cpu(kirkwood_cpuidle_device, smp_processor_id());
> > >  	device->state_count = KIRKWOOD_MAX_STATES;
> > > diff --git a/drivers/thermal/kirkwood_thermal.c b/drivers/thermal/kirkwood_thermal.c
> > > index 65cb4f0..e5500ed 100644
> > > --- a/drivers/thermal/kirkwood_thermal.c
> > > +++ b/drivers/thermal/kirkwood_thermal.c
> > > @@ -85,11 +85,9 @@ static int kirkwood_thermal_probe(struct platform_device *pdev)
> > >  	if (!priv)
> > >  		return -ENOMEM;
> > >  
> > > -	priv->sensor = devm_request_and_ioremap(&pdev->dev, res);
> > > -	if (!priv->sensor) {
> > > -		dev_err(&pdev->dev, "Failed to request_ioremap memory\n");
> > > -		return -EADDRNOTAVAIL;
> > > -	}
> > > +	priv->sensor = devm_ioremap_resource(&pdev->dev, res);
> > > +	if (IS_ERR(priv->sensor))
> > > +		return PTR_ERR(priv->sensor);
> > >  
> > >  	thermal = thermal_zone_device_register("kirkwood_thermal", 0, 0,
> > >  					       priv, &ops, NULL, 0, 0);
> > 
> > there is already a fix for kirkwood_thermal.c at
> > http://marc.info/?l=linux-pm&m=136238017027514&w=2
> > and it has been applied to thermal -next.
> > 
> > would you please refreshed the patch?
> 
> Are you going to take that patch into your tree, then?

I'll take the one that fixes kirkwood_thermal.c. :)

thanks,
rui

