Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264Ab3E1Mo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 08:44:58 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53269 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759083Ab3E1Moz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 08:44:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-pm@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / Runtime: honor device autosuspend in pm_generic_runtime_idle()
Date: Tue, 28 May 2013 14:53:47 +0200
Message-ID: <1563745.Xy6YCbJQjl@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <14273128.qrOYeDHLlu@vostro.rjw.lan>
References: <1368443127-9636-1-git-send-email-mika.westerberg@linux.intel.com> <14273128.qrOYeDHLlu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 13, 2013 01:50:18 PM Rafael J. Wysocki wrote:
> On Monday, May 13, 2013 02:05:27 PM Mika Westerberg wrote:
> > If the device is using autosuspend we should honor that and call
> > pm_runtime_autosuspend() instead of pm_runtime_suspend(). Failing to do so
> > causes the device to be suspended immediately even though it expects to be
> > suspended only when the autosuspend delay is expired.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> >  drivers/base/power/generic_ops.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/base/power/generic_ops.c b/drivers/base/power/generic_ops.c
> > index bfd898b..19786ca 100644
> > --- a/drivers/base/power/generic_ops.c
> > +++ b/drivers/base/power/generic_ops.c
> > @@ -29,7 +29,10 @@ int pm_generic_runtime_idle(struct device *dev)
> >  			return ret;
> >  	}
> >  
> > -	pm_runtime_suspend(dev);
> > +	if (dev->power.use_autosuspend)
> > +		pm_runtime_autosuspend(dev);
> > +	else
> > +		pm_runtime_suspend(dev);
> >  	return 0;
> 
> First of all, this is racy (power.use_autosuspend shoud be accessed under
> power.lock).
> 
> Second, this is not the only place we'd need to make this change (the analogous
> function for PCI is one example, but there may be others).
> 
> Finally, I'm not sure how to address this problem in general.  It may be better
> to simply modify rpm_idle() and remove pm_generic_runtime_idle() etc. entirely.
> 
> I'll have a look at that, thanks for pointing out the problem.

I'm not sure if the core is the right place to address this, because it's
not entirely clear if all drivers using autosuspend will have the same policy
with respect to pm_runtime_idle() (i.e. to avoid suspending immediately if
the suspend delay timer is active).

In my opinion it'd be better to address that in the driver by adding a
.runtime_idle() callback executing pm_runtime_autosuspend(dev) and returning
-EBUSY.

If all (or at least the majority of) drivers using autosuspend end up doing
that, *then* we can move that to the core.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
