Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab3DEE55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 00:57:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:38939 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab3DEE5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 00:57:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,412,1363158000"; 
   d="scan'208";a="312687470"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 1/3] thermal: introduce thermal_zone_get_zone_by_name
 helper function
Thread-Topic: [PATCHv2 1/3] thermal: introduce thermal_zone_get_zone_by_name
 helper function
Thread-Index: AQHOMLiUY3LidhVScU+woWA60HaxEJjGTOCg///ZrQCAAOvx4A==
Date: Fri, 5 Apr 2013 04:57:48 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59C655C8@BGSMSX101.gar.corp.intel.com>
References: <1365027197-2793-1-git-send-email-eduardo.valentin@ti.com>
 <1365027197-2793-2-git-send-email-eduardo.valentin@ti.com>
 <4D68720C2E767A4AA6A8796D42C8EB59C650A4@BGSMSX101.gar.corp.intel.com>
 <515DE0F8.7070702@ti.com>
In-Reply-To: <515DE0F8.7070702@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Eduardo Valentin [mailto:eduardo.valentin@ti.com]
> Sent: Friday, April 05, 2013 1:52 AM
> To: R, Durgadoss
> Cc: Eduardo Valentin; Zhang, Rui; linux-pm@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCHv2 1/3] thermal: introduce
> thermal_zone_get_zone_by_name helper function
> 
> On 04-04-2013 13:12, R, Durgadoss wrote:
> >> -----Original Message-----
> >> From: Eduardo Valentin [mailto:eduardo.valentin@ti.com]
> >> Sent: Thursday, April 04, 2013 3:43 AM
> >> To: Zhang, Rui
> >> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; R,
> Durgadoss;
> >> Eduardo Valentin
> >> Subject: [PATCHv2 1/3] thermal: introduce
> >> thermal_zone_get_zone_by_name helper function
> >>
> >> This patch adds a helper function to get a reference of
> >> a thermal zone, based on the zone type name.
> >>
> >> It will perform a zone name lookup and return a reference
> >> to a thermal zone device that matches the name requested.
> >> In case the zone is not found or when several zones match
> >> same name or if the required parameters are invalid, it will return
> >> the corresponding error code (ERR_PTR).
> >>
> >> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> >> ---
> >>   drivers/thermal/thermal_sys.c |   34
> >> ++++++++++++++++++++++++++++++++++
> >>   include/linux/thermal.h       |    1 +
> >>   2 files changed, 35 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/thermal/thermal_sys.c
> b/drivers/thermal/thermal_sys.c
> >> index 5bd95d4..6e1da0a 100644
> >> --- a/drivers/thermal/thermal_sys.c
> >> +++ b/drivers/thermal/thermal_sys.c
> >> @@ -1790,6 +1790,40 @@ void thermal_zone_device_unregister(struct
> >> thermal_zone_device *tz)
> >>   }
> >>   EXPORT_SYMBOL_GPL(thermal_zone_device_unregister);
> >>
> >> +/**
> >> + * thermal_zone_get_zone_by_name() - search for a zone and returns
> its
> >> ref
> >> + * @name: thermal zone name to fetch the temperature
> >> + *
> >> + * When only one zone is found with the passed name, returns a
> reference
> >> to it.
> >> + *
> >> + * Return: On success returns a reference to an unique thermal zone
> with
> >> + * matching name equals to @name, a ERR_PTR otherwise.
> >> + */
> >> +struct thermal_zone_device *thermal_zone_get_zone_by_name(const
> >> char *name)
> >> +{
> >> +	struct thermal_zone_device *pos = NULL, *ref = ERR_PTR(-EINVAL);
> >> +	int found = 0;
> >> +
> >> +	if (!name)
> >> +		goto exit;
> >> +
> >> +	mutex_lock(&thermal_list_lock);
> >> +	list_for_each_entry(pos, &thermal_tz_list, node)
> >> +		if (!strnicmp(name, pos->type, THERMAL_NAME_LENGTH)) {
> >> +			found++;
> >> +			ref = pos;
> >> +		}
> >> +	mutex_unlock(&thermal_list_lock);
> >> +
> >> +	/* Success only when an unique zone is found */
> >> +	if (found != 1)
> >> +		ref = ERR_PTR(-ENODEV);
> >
> > I think we should differentiate between the two cases:
> > 1. The zone does not exist at all
> > 	return NULL in this case
> > 2. There are multiple zones
> > 	return ERR_PTR(-EEXIST) in this case
> >
> > This way the calling function can figure out the exact reason
> > for failure.
> 
> I think the code documentation is already clear enough to say that this
> is for unique matches. But in case you want to differentiate these
> cases, I can resend it. Do you have a usage for this?

Yes, the calling function may want to re-try (or even unregister a zone,
to proceed further..)

> 
> Besides, I would prefer to return ERR_PTR(-ENODEV) in the first case.
> The way it is in the original patch.

Okay, I am fine with that too :-)

> 
> >
> > Thanks,
> > Durga
> >
> >> +
> >> +exit:
> >> +	return ref;
> >> +}
> >> +EXPORT_SYMBOL_GPL(thermal_zone_get_zone_by_name);
> >> +
> >>   #ifdef CONFIG_NET
> >>   static struct genl_family thermal_event_genl_family = {
> >>   	.id = GENL_ID_GENERATE,
> >> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> >> index 542a39c..0cf9eb5 100644
> >> --- a/include/linux/thermal.h
> >> +++ b/include/linux/thermal.h
> >> @@ -237,6 +237,7 @@ void thermal_zone_device_update(struct
> >> thermal_zone_device *);
> >>   struct thermal_cooling_device *thermal_cooling_device_register(char *,
> >> void *,
> >>   		const struct thermal_cooling_device_ops *);
> >>   void thermal_cooling_device_unregister(struct thermal_cooling_device
> *);
> >> +struct thermal_zone_device *thermal_zone_get_zone_by_name(const
> >> char *name);
> >>
> >>   int thermal_zone_trend_get(struct thermal_zone_device *, int);
> >>   struct thermal_instance *thermal_instance_get(struct
> >> thermal_zone_device *,
> >> --
> >> 1.7.7.1.488.ge8e1c
> >
> >
> >

