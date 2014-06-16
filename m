Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaFPDDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 23:03:21 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16149 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaFPDDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 23:03:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 15 Jun 2014 19:57:47 -0700
From: Allen Yu <alleny@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        "Len Brown" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jun 2014 11:03:02 +0800
Subject: RE: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled
 and device suspended.
Thread-Topic: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled
 and device suspended.
Thread-Index: Ac+H3Xae0S68LLvuTGuWvxLUEw87XgBL0IfQ
Message-ID: <9E7892CE01168A46922BCCE04DB02F9828E62353@HKMAIL01.nvidia.com>
References: <1402740209-16432-1-git-send-email-alleny@nvidia.com>
 <Pine.LNX.4.44L0.1406141020070.3986-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1406141020070.3986-100000@netrider.rowland.org>
Accept-Language: zh-CN, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jun 2014, Alan Stern wrote:

> > dev->power.is_suspended is set after core suspends device during system
> suspend.
> > This flag mostly means device is not operational (all I/O been
> > quiesced, no more data read or write acceptible, etc.), hence it's
> > dangerous to access hardware if device is suspended even though runtime
> PM status is RPM_ACTIVE.
> >
> > In turn, we should allow device to be accessed in case device is *not*
> > suspended and runtime PM status is RPM_ACTIVE, even if runtime PM
> > disabled. This corner case can happen to a device in a generic PM
> > domain if the domain is not powered off while preparing for a system-wide
> power transition.
> 
> I don't understand.  Even if the PM domain isn't powered off, the device's
> is_suspended flag will still be set by __device_suspend().

Yes, is_suspended flag will be set by __device_suspend(). But runtime PM can be disabled in pm_genpd_prepare():

914 static int pm_genpd_prepare(struct device *dev){
...
956         /*
957          * The PM domain must be in the GPD_STATE_ACTIVE state at this point,
958          * so pm_genpd_poweron() will return immediately, but if the device
959          * is suspended (e.g. it's been stopped by genpd_stop_dev()), we need
960          * to make it operational.
961          */
962         pm_runtime_resume(dev);
963         __pm_runtime_disable(dev, false);
...
978 }

And there is a gap between pm_genpd_prepare() and __device_suspend(), during which is_suspended flag is *not* yet set but runtime PM is disabled and device status is RPM_ACTIVE. 

> 
> >  In this case, runtime PM status will
> > be set to RPM_ACTIVE and then runtime PM is disabled. After that,
> > device driver may call pm_runtime_get_sync() and rpm_resume() should
> > return 1, because the device is still active as long as not been suspended.
> 
> Isn't that what the existing code does already?  Your patch seems to change
> it so that it _doesn't_ behave the way you want.
> 

The existing code return 1 for case is_suspended flag is set.  That means __device_suspend() has been called and device is not in operational state. Whereas the case I mentioned above is before device is suspended.
It's dangerous to access device if it's in suspended state, so I propose only allowing access to a device if it's not suspended (i.e. value of "is_suspneded" flag is false).

> > Signed-off-by: Allen Yu <alleny@nvidia.com>
> > ---
> >  drivers/base/power/runtime.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/base/power/runtime.c
> > b/drivers/base/power/runtime.c index 67c7938..39885f1 100644
> > --- a/drivers/base/power/runtime.c
> > +++ b/drivers/base/power/runtime.c
> > @@ -608,7 +608,7 @@ static int rpm_resume(struct device *dev, int
> rpmflags)
> >   repeat:
> >  	if (dev->power.runtime_error)
> >  		retval = -EINVAL;
> > -	else if (dev->power.disable_depth == 1 && dev-
> >power.is_suspended
> > +	else if (dev->power.disable_depth == 1 && !dev-
> >power.is_suspended
> >  	    && dev->power.runtime_status == RPM_ACTIVE)
> >  		retval = 1;
> 
> Alan Stern

