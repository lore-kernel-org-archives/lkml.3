Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965145Ab3E2IT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:19:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:58958 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759507Ab3E2ITY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:19:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,763,1363158000"; 
   d="scan'208";a="321201740"
Date: Wed, 29 May 2013 11:23:28 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / Runtime: honor device autosuspend in
 pm_generic_runtime_idle()
Message-ID: <20130529082328.GV11878@intel.com>
References: <1368443127-9636-1-git-send-email-mika.westerberg@linux.intel.com>
 <14273128.qrOYeDHLlu@vostro.rjw.lan>
 <1563745.Xy6YCbJQjl@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563745.Xy6YCbJQjl@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 02:53:47PM +0200, Rafael J. Wysocki wrote:
> On Monday, May 13, 2013 01:50:18 PM Rafael J. Wysocki wrote:
> > On Monday, May 13, 2013 02:05:27 PM Mika Westerberg wrote:
> > > If the device is using autosuspend we should honor that and call
> > > pm_runtime_autosuspend() instead of pm_runtime_suspend(). Failing to do so
> > > causes the device to be suspended immediately even though it expects to be
> > > suspended only when the autosuspend delay is expired.
> > > 
> > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > ---
> > >  drivers/base/power/generic_ops.c |    5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/base/power/generic_ops.c b/drivers/base/power/generic_ops.c
> > > index bfd898b..19786ca 100644
> > > --- a/drivers/base/power/generic_ops.c
> > > +++ b/drivers/base/power/generic_ops.c
> > > @@ -29,7 +29,10 @@ int pm_generic_runtime_idle(struct device *dev)
> > >  			return ret;
> > >  	}
> > >  
> > > -	pm_runtime_suspend(dev);
> > > +	if (dev->power.use_autosuspend)
> > > +		pm_runtime_autosuspend(dev);
> > > +	else
> > > +		pm_runtime_suspend(dev);
> > >  	return 0;
> > 
> > First of all, this is racy (power.use_autosuspend shoud be accessed under
> > power.lock).
> > 
> > Second, this is not the only place we'd need to make this change (the analogous
> > function for PCI is one example, but there may be others).
> > 
> > Finally, I'm not sure how to address this problem in general.  It may be better
> > to simply modify rpm_idle() and remove pm_generic_runtime_idle() etc. entirely.
> > 
> > I'll have a look at that, thanks for pointing out the problem.
> 
> I'm not sure if the core is the right place to address this, because it's
> not entirely clear if all drivers using autosuspend will have the same policy
> with respect to pm_runtime_idle() (i.e. to avoid suspending immediately if
> the suspend delay timer is active).
> 
> In my opinion it'd be better to address that in the driver by adding a
> .runtime_idle() callback executing pm_runtime_autosuspend(dev) and returning
> -EBUSY.

Makes sense. I did a quick test with following patch and it seems to fix
the issue for i2c-designware driver.

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 966a554..af8be8f 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -267,7 +267,22 @@ static int dw_i2c_resume(struct device *dev)
 }
 #endif
 
-static SIMPLE_DEV_PM_OPS(dw_i2c_dev_pm_ops, dw_i2c_suspend, dw_i2c_resume);
+#ifdef CONFIG_PM_RUNTIME
+static int dw_i2c_runtime_idle(struct device *dev)
+{
+	/*
+	 * Always schedule autosuspend regardless of what runtime PM the
+	 * client devices use.
+	 */
+	pm_runtime_autosuspend(dev);
+	return -EBUSY;
+}
+#endif
+
+static const struct dev_pm_ops dw_i2c_dev_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(dw_i2c_suspend, dw_i2c_resume)
+	SET_RUNTIME_PM_OPS(NULL, NULL, dw_i2c_runtime_idle)
+};
 
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:i2c_designware");
