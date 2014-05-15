Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaEOK4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:56:15 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55092 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751255AbaEOK4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:56:13 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [RFC][PATCH 2/3] PM / sleep: Mechanism to avoid resuming runtime-suspended devices unnecessarily
Date: Thu, 15 May 2014 13:13:02 +0200
Message-ID: <1495375.YeObBhD5SE@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1405141041360.1432-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1405141041360.1432-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 14, 2014 10:53:16 AM Alan Stern wrote:
> On Tue, 13 May 2014, Rafael J. Wysocki wrote:
> 
> > > It would be surprising if ->prepare() needed to make any difficult
> > > checks.  This would imply that the device could have multiple
> > > runtime-suspend states, some of which are appropriate for system
> > > suspend while others aren't.  Not impossible, but I wouldn't expect it
> > > to come up often.
> > 
> > That is the case for every device with ACPI power management in principle. :-)
> > 
> > Please see patch [3/3] for details.
> 
> I don't understand enough about the ACPI subsystem to follow the
> details of that patch.
> 
> > OK, I've updated the $subject patch in the meantime and the result is appended
> > Former patch [1/3] is not necessary any more now and patch [3/3] is still valid.
> > 
> > Rafael
> > 
> > ---
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: PM / sleep: Mechanism to avoid resuming runtime-suspended devices unnecessarily
> > 
> > Currently, some subsystems (e.g. PCI and the ACPI PM domain) have to
> > resume all runtime-suspended devices during system suspend, mostly
> > because those devices may need to be reprogrammed due to different
> > wakeup settings for system sleep and for runtime PM.
> 
> ...
> 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> This is looking quite good.  I have one suggestion for a small 
> improvement...
> 
> > @@ -1332,6 +1338,16 @@ static int __device_suspend(struct devic
> >  	if (dev->power.syscore)
> >  		goto Complete;
> >  
> > +	if (dev->power.direct_complete) {
> > +		pm_runtime_disable(dev);
> > +		if (dev->power.disable_depth == 1
> > +		    && pm_runtime_status_suspended(dev))
> > +			goto Complete;
> > +
> > +		dev->power.direct_complete = false;
> > +		pm_runtime_enable(dev);
> > +	}
> 
> Do we want to allow ->prepare() to return > 0 if the device isn't
> runtime suspended?  If we do then non-suspended devices may be a common
> case.  We should then avoid the extra overhead of disable + enable.  
> So I would write:
> 
> 	if (dev->power.direct_complete) {
> 		if (pm_runtime_status_suspended(dev)) {
> 			pm_runtime_disable(dev);
> 			if (dev->power.disable_depth == 1
> 			    && pm_runtime_status_suspended(dev))
> 				goto Complete;
> 			pm_runtime_enable(dev);
> 		}
> 		dev->power.direct_complete = false;
> 	}

That is a good idea, thanks!

> Also, now that we have finally settled on the appropriate API, there
> needs to ba a patch updating the PM documentation.

Absolutely.  I thought about updating the documentation in the same patch
(at least the comments in pm.h), but I guess a separate patch for files
under Documentation/ may be better.

Rafael

