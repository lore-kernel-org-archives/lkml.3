Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaB0Xgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:36:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:32173 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaB0Xgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:36:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,558,1389772800"; 
   d="scan'208";a="463759703"
Date: Thu, 27 Feb 2014 15:41:31 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>, Josh Cartwright <joshc@codeaurora.org>,
        linux-pm@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] usb: phy: msm: use ASSIGN_*_PM_OPS variants
Message-ID: <20140227234129.GA21032@psi-dev26.jf.intel.com>
References: <1393261707-30565-1-git-send-email-joshc@codeaurora.org>
 <1393261707-30565-4-git-send-email-joshc@codeaurora.org>
 <20140225183336.GH23275@saruman.home>
 <20140227190324.GC4421@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227190324.GC4421@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 11:03:24AM -0800, Greg Kroah-Hartman wrote:
> On Tue, Feb 25, 2014 at 12:33:36PM -0600, Felipe Balbi wrote:
> > Hi,
> > 
> > On Mon, Feb 24, 2014 at 11:08:27AM -0600, Josh Cartwright wrote:
> > > Use ASSIGN_SYSTEM_SLEEP_PM_OPS and ASSIGN_RUNTIME_PM_OPS in the
> > > initializer for msm_otg_dev_pm_ops.  Doing so allows us to eliminate
> > > preprocessor conditionals around the specified callbacks.
> > > 
> > > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > > ---
> > >  drivers/usb/phy/phy-msm-usb.c | 13 +++----------
> > >  1 file changed, 3 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> > > index 5b37b81..c04f2e3 100644
> > > --- a/drivers/usb/phy/phy-msm-usb.c
> > > +++ b/drivers/usb/phy/phy-msm-usb.c
> > > @@ -414,8 +414,6 @@ static int msm_otg_reset(struct usb_phy *phy)
> > >  #define PHY_SUSPEND_TIMEOUT_USEC	(500 * 1000)
> > >  #define PHY_RESUME_TIMEOUT_USEC	(100 * 1000)
> > >  
> > > -#ifdef CONFIG_PM
> > > -
> > >  #define USB_PHY_SUSP_DIG_VOL  500000
> > >  static int msm_hsusb_config_vddcx(int high)
> > >  {
> > > @@ -609,7 +607,6 @@ skip_phy_resume:
> > >  
> > >  	return 0;
> > >  }
> > > -#endif
> > >  
> > >  static void msm_otg_notify_charger(struct msm_otg *motg, unsigned mA)
> > >  {
> > > @@ -1664,7 +1661,6 @@ static int msm_otg_remove(struct platform_device *pdev)
> > >  	return 0;
> > >  }
> > >  
> > > -#ifdef CONFIG_PM_RUNTIME
> > >  static int msm_otg_runtime_idle(struct device *dev)
> > >  {
> > >  	struct msm_otg *motg = dev_get_drvdata(dev);
> > > @@ -1699,9 +1695,7 @@ static int msm_otg_runtime_resume(struct device *dev)
> > >  	dev_dbg(dev, "OTG runtime resume\n");
> > >  	return msm_otg_resume(motg);
> > >  }
> > > -#endif
> > >  
> > > -#ifdef CONFIG_PM_SLEEP
> > >  static int msm_otg_pm_suspend(struct device *dev)
> > >  {
> > >  	struct msm_otg *motg = dev_get_drvdata(dev);
> > > @@ -1731,12 +1725,11 @@ static int msm_otg_pm_resume(struct device *dev)
> > >  
> > >  	return 0;
> > >  }
> > > -#endif
> > >  
> > >  static const struct dev_pm_ops msm_otg_dev_pm_ops = {
> > > -	SET_SYSTEM_SLEEP_PM_OPS(msm_otg_pm_suspend, msm_otg_pm_resume)
> > > -	SET_RUNTIME_PM_OPS(msm_otg_runtime_suspend, msm_otg_runtime_resume,
> > > -				msm_otg_runtime_idle)
> > > +	ASSIGN_SYSTEM_SLEEP_PM_OPS(msm_otg_pm_suspend, msm_otg_pm_resume)
> > > +	ASSIGN_RUNTIME_PM_OPS(msm_otg_runtime_suspend, msm_otg_runtime_resume,
> > > +			      msm_otg_runtime_idle)
> > 
> > if the patch introducing assign_if() gets accepted, I'm ok with this
> > patch.
> 
> I can't take that patch at this point in time, it's just too ugly...
> 
> As are those crazy SET_SYSTEM_SLEEP_PM_OPS() macros, ick, who made those
> things?
> 
> What language are we trying to program in here people?

Since we're discussing this topic here, I'd like point my RFC which gets
rid of same ifdeffery in a different way:
http://lkml.org/lkml/2013/12/13/4

Comments are welcome.

Br, David

> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
