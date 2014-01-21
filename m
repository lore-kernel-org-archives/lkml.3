Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaAUTqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:46:36 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33256 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbaAUTqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:46:31 -0500
Date: Tue, 21 Jan 2014 11:46:25 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: rui.zhang@intel.com, eduardo.valentin@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hongbo.zhang@freescale.com,
        wni@nvidia.com
Subject: Re: [PATCHv5 01/10] Thermal: Do kfree in _unregister functions
Message-ID: <20140121194624.GA29615@core.coreip.homeip.net>
References: <1389916587-2541-1-git-send-email-durgadoss.r@intel.com>
 <1389916587-2541-2-git-send-email-durgadoss.r@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389916587-2541-2-git-send-email-durgadoss.r@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Durgadoss,

On Fri, Jan 17, 2014 at 05:26:18AM +0530, Durgadoss R wrote:
> Currently the thermal_release function does
> kfree for all devices when they call device_unregister.
> This makes code scattering i.e whenever we add new
> devices (to thermal class) we need to add its
> corresponding kfree in thermal_release function.
> And the if-else is also growing lengthy.
> 
> Instead, do all kfree() of devices in their own
> _unregister functions. This makes the code look
> clean and easy to maintain.
> 
> Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> ---
>  drivers/thermal/thermal_core.c |   17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 338a88b..165afc6 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1042,18 +1042,7 @@ EXPORT_SYMBOL_GPL(thermal_zone_unbind_cooling_device);
>  
>  static void thermal_release(struct device *dev)
>  {
> -	struct thermal_zone_device *tz;
> -	struct thermal_cooling_device *cdev;
> -
> -	if (!strncmp(dev_name(dev), "thermal_zone",
> -		     sizeof("thermal_zone") - 1)) {
> -		tz = to_thermal_zone(dev);
> -		kfree(tz);
> -	} else if(!strncmp(dev_name(dev), "cooling_device",
> -			sizeof("cooling_device") - 1)){
> -		cdev = to_cooling_device(dev);
> -		kfree(cdev);
> -	}
> +	/* No-op since kfree(dev) is done in _unregister functions */
>  }
>  
>  static struct class thermal_class = {
> @@ -1146,6 +1135,7 @@ __thermal_cooling_device_register(struct device_node *np,
>  unregister:
>  	release_idr(&thermal_cdev_idr, &thermal_idr_lock, cdev->id);
>  	device_unregister(&cdev->device);
> +	kfree(cdev);

This is broken, you can not assume that you are holding the last
reference. Please observe help text of DEBUG_KOBJECT_RELEASE config
option, activate said option and try unregistering thermal device.

Thanks.

-- 
Dmitry
