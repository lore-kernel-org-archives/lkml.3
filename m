Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaJIDP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 23:15:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:39153 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbaJIDPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 23:15:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,682,1406617200"; 
   d="scan'208";a="615559258"
Message-ID: <1412824517.13621.6.camel@rzhang1-toshiba>
Subject: Re: [PATCH 3/3] thermal: core: fix: Check return code of the
 ->get_max_state() callback
From: Zhang Rui <rui.zhang@intel.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 09 Oct 2014 11:15:17 +0800
In-Reply-To: <20141003124054.404ac26c@amdc2363>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
	 <1411547232-21493-4-git-send-email-l.majewski@samsung.com>
	 <20141002222441.GA11510@developer> <20141003124054.404ac26c@amdc2363>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-03 at 12:40 +0200, Lukasz Majewski wrote:
> Hi Eduardo, Rui,
> 
> > On Wed, Sep 24, 2014 at 10:27:12AM +0200, Lukasz Majewski wrote:
> > > Without this check it was possible to execute cooling device
> > > binding code even when wrong max cooling state was read.
> > > 
> > > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > 
> > Acked-by: Eduardo Valentin <edubezval@gmail.com>
> > 
> > Rui, are you taking these patches? Do you prefer me to collect them?
> 
> I'd like to ask you NOT to apply those patches.
> 
> In short: It will cause regression on all non Exynos boards.
> 
> Explanation:
> 
> Up till now the cpu_cooling device was bind even when the
> get_max_state() returned -EINVAL and everything worked after late
> cpufreq policy initialization.
> 
> However, during this time window the thermal driver is not properly
> configured.
> 
> Applying PATCH2/3 and PATCH3/3 would cause bind error without any
> further occasion for re-bind. As a result THERAL will not be present
> on the target system.
> 
> It works on the Exynos boards, since at the report_trigger() function, 
> when first trip point is reached, it is checked if cpu_cooling device
> is bind. If it is not (due to "fixes" at PATCH2/3 and PATCH3/3) it
> is rebind then.
> 
> Due to above, I think that it would be best to leave things as they are
> now and prepare proper fix as suggested by Eduardo.
> 
Agreed. Can anyone please propose such a patch?

thanks,
rui
> > 
> > Cheers
> > 
> > Eduardo
> > 
> > > ---
> > >  drivers/thermal/thermal_core.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/thermal/thermal_core.c
> > > b/drivers/thermal/thermal_core.c index 747618a..8a4dc35 100644
> > > --- a/drivers/thermal/thermal_core.c
> > > +++ b/drivers/thermal/thermal_core.c
> > > @@ -928,7 +928,7 @@ int thermal_zone_bind_cooling_device(struct
> > > thermal_zone_device *tz, struct thermal_zone_device *pos1;
> > >  	struct thermal_cooling_device *pos2;
> > >  	unsigned long max_state = 0;
> > > -	int result;
> > > +	int result, ret;
> > >  
> > >  	if (trip >= tz->trips || (trip < 0 && trip !=
> > > THERMAL_TRIPS_NONE)) return -EINVAL;
> > > @@ -945,7 +945,9 @@ int thermal_zone_bind_cooling_device(struct
> > > thermal_zone_device *tz, if (tz != pos1 || cdev != pos2)
> > >  		return -EINVAL;
> > >  
> > > -	cdev->ops->get_max_state(cdev, &max_state);
> > > +	ret = cdev->ops->get_max_state(cdev, &max_state);
> > > +	if (ret)
> > > +		return ret;
> > >  
> > >  	/* lower default 0, upper default max_state */
> > >  	lower = lower == THERMAL_NO_LIMIT ? 0 : lower;
> > > -- 
> > > 2.0.0.rc2
> > > 
> 
> 
> 


