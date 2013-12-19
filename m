Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3LSUow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:44:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab3LSUou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:44:50 -0500
Date: Thu, 19 Dec 2013 12:44:52 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Kim Phillips <kim.phillips@linaro.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, R65777@freescale.com, B07421@freescale.com,
        B08248@freescale.com, christoffer.dall@linaro.org,
        alex.williamson@redhat.com, a.motakis@virtualopensystems.com,
        agraf@suse.de, B16395@freescale.com
Subject: Re: [REPOST][PATCH 2/2] driver core: platform: allow platform
 drivers to bind to any device
Message-ID: <20131219204452.GA13301@kroah.com>
References: <20131203123454.3ab18749ed0d0d943b10df9a@linaro.org>
 <20131219010340.GA23055@kroah.com>
 <1387484961.3140.141.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387484961.3140.141.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 02:29:21PM -0600, Scott Wood wrote:
> On Wed, 2013-12-18 at 17:03 -0800, Greg Kroah-Hartman wrote:
> > On Tue, Dec 03, 2013 at 12:34:54PM +0000, Kim Phillips wrote:
> > > Platform drivers such as the vfio-platform "meta-" driver [1]
> > > should be allowed to specify that they can bind to any device,
> > > much like PCI drivers can with PCI_ANY_ID.
> > > 
> > > Currently, binding platform drivers to devices depends on:
> > > 
> > > - a string match in the device node's compatible entry (OF)
> > > - a string match in the ACPI id list (ACPI)
> > > - a string match in the id_table (platform data)
> > > - a string match on the driver name (fall-back)
> > > 
> > > none of which allow for the notion of "match any."
> > > 
> > > This patch adds the notion by adding a "match any device" boolean to
> > > struct platform_driver, for drivers to be able to set and thus not cause
> > > platform_match() to fail when a bind is requested.
> > > 
> > > [1] http://www.spinics.net/lists/kvm/msg96701.html
> > > 
> > > Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
> > > ---
> > > rebased onto 3.13-rc2, and reposted from first submission which
> > > received no comments:
> > > 
> > > https://lkml.org/lkml/2013/10/11/48
> > > 
> > >  drivers/base/platform.c         | 4 ++++
> > >  include/linux/platform_device.h | 1 +
> > >  2 files changed, 5 insertions(+)
> > > 
> > > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > > index 3a94b79..78a5b62 100644
> > > --- a/drivers/base/platform.c
> > > +++ b/drivers/base/platform.c
> > > @@ -736,6 +736,10 @@ static int platform_match(struct device *dev, struct device_driver *drv)
> > >  	struct platform_device *pdev = to_platform_device(dev);
> > >  	struct platform_driver *pdrv = to_platform_driver(drv);
> > >  
> > > +	/* the driver matches any device */
> > > +	if (pdrv->match_any_dev)
> > > +		return 1;
> > 
> > This breaks userspace in that it will never know to load the module that
> > can "bind to anything".
> > 
> > You need a way to encode this in the platform device id that can be a
> > wildcard type of thing, so that userspace can know about this.
> 
> How is userspace broken?  vfio platform is a new thing; there's nothing
> existing to break.  I don't see how automatic module loading makes sense
> for it.  Whether the module needs to be loaded depends on the user's
> intentions, not based on what hardware you have.

As your driver is saying it can "match any device", you need to tell
userspace that, which you aren't doing here.  That's what the ids that
are exported to userspace do, please add some for platform devices to
allow this to work properly, like almost all other busses have.

greg k-h
