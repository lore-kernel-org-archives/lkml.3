Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaCCNoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 08:44:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:61045 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbaCCNoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 08:44:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,577,1389772800"; 
   d="scan'208";a="484819379"
Message-ID: <1393854256.2193.2.camel@rzhang1-mobl4>
Subject: Re: [PATCHv5 01/10] Thermal: Do kfree in _unregister functions
From: Zhang Rui <rui.zhang@intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Durgadoss R <durgadoss.r@intel.com>, eduardo.valentin@ti.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        hongbo.zhang@freescale.com, wni@nvidia.com
Date: Mon, 03 Mar 2014 21:44:16 +0800
In-Reply-To: <20140121194624.GA29615@core.coreip.homeip.net>
References: <1389916587-2541-1-git-send-email-durgadoss.r@intel.com>
	 <1389916587-2541-2-git-send-email-durgadoss.r@intel.com>
	 <20140121194624.GA29615@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-21 at 11:46 -0800, Dmitry Torokhov wrote:
> Hi Durgadoss,
> 
> On Fri, Jan 17, 2014 at 05:26:18AM +0530, Durgadoss R wrote:
> > Currently the thermal_release function does
> > kfree for all devices when they call device_unregister.
> > This makes code scattering i.e whenever we add new
> > devices (to thermal class) we need to add its
> > corresponding kfree in thermal_release function.
> > And the if-else is also growing lengthy.
> > 
> > Instead, do all kfree() of devices in their own
> > _unregister functions. This makes the code look
> > clean and easy to maintain.
> > 
> > Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> > ---
> >  drivers/thermal/thermal_core.c |   17 +++++------------
> >  1 file changed, 5 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> > index 338a88b..165afc6 100644
> > --- a/drivers/thermal/thermal_core.c
> > +++ b/drivers/thermal/thermal_core.c
> > @@ -1042,18 +1042,7 @@ EXPORT_SYMBOL_GPL(thermal_zone_unbind_cooling_device);
> >  
> >  static void thermal_release(struct device *dev)
> >  {
> > -	struct thermal_zone_device *tz;
> > -	struct thermal_cooling_device *cdev;
> > -
> > -	if (!strncmp(dev_name(dev), "thermal_zone",
> > -		     sizeof("thermal_zone") - 1)) {
> > -		tz = to_thermal_zone(dev);
> > -		kfree(tz);
> > -	} else if(!strncmp(dev_name(dev), "cooling_device",
> > -			sizeof("cooling_device") - 1)){
> > -		cdev = to_cooling_device(dev);
> > -		kfree(cdev);
> > -	}
> > +	/* No-op since kfree(dev) is done in _unregister functions */
> >  }
> >  
> >  static struct class thermal_class = {
> > @@ -1146,6 +1135,7 @@ __thermal_cooling_device_register(struct device_node *np,
> >  unregister:
> >  	release_idr(&thermal_cdev_idr, &thermal_idr_lock, cdev->id);
> >  	device_unregister(&cdev->device);
> > +	kfree(cdev);
> 
> This is broken, you can not assume that you are holding the last
> reference. Please observe help text of DEBUG_KOBJECT_RELEASE config
> option, activate said option and try unregistering thermal device.
> 
agreed.
If you think it is too complicated to support the different thermal
components in thermal_release(), we can introduce per device .release()
callback as well.

thanks,
rui
> Thanks.
> 


