Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab3HQAk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:40:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3HQAku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:40:50 -0400
Date: Fri, 16 Aug 2013 15:08:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/4] driver core: Allow early registration of devices
Message-ID: <20130816220807.GA6848@kroah.com>
References: <1376685563-1053-1-git-send-email-treding@nvidia.com>
 <1376685563-1053-3-git-send-email-treding@nvidia.com>
 <20130816210637.GC2198@kroah.com>
 <20130816215530.GA14464@mithrandir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816215530.GA14464@mithrandir>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 11:55:31PM +0200, Thierry Reding wrote:
> > > +	list_for_each_entry(private, &device_early_list, early) {
> > > +		struct device *dev = private->device;
> > > +		int err;
> > > +
> > > +		if (dev->bus == &platform_bus_type) {
> > 
> > Why special case the platform bus?  We are trying to move things off of
> > the platform bus, don't make it harder to do that :)
> 
> I heard about that, but I must have missed the thread where this was
> discussed. Can you point me to it?

I thought it was on lkml, but it might have been limited to linux-arm
and the ksummit-discuss mailing list on one of the threads there.
Sorry, I can't recall it at the moment.

> > > +			struct platform_device *pdev = to_platform_device(dev);
> > > +
> > > +			err = platform_device_early_fixup(pdev);
> > > +			if (err < 0)
> > > +				dev_err(&pdev->dev,
> > > +					"failed to fixup device %s: %d\n",
> > > +					dev_name(&pdev->dev), err);
> > > +		}
> > 
> > You should just have a bus callback that can be made here that, if
> > present, can be called.  That way any bus can handle this type of thing,
> > not just the platform one.
> 
> You mean something like an .early_fixup() in struct bus_type?

Yes.

> That would indeed be much cleaner. As I mentioned this is a very early
> prototype and this particular hunk exists specifically to fixup the
> platform devices created by the device tree helpers so that the kernel
> actually boots to the login prompt.

That's fine, I was giving you feedback on why I wouldn't take this as-is :)

> > Not that I really like the whole idea anyway, but I doubt there's much I
> > can do about it...
> 
> Well, getting feedback from you and others is precisely the reason why I
> wanted to post this early. There must be a reason why you don't like it,
> so perhaps you can share your thoughts and we can mould this into
> something that you'd be more comfortable with.

Ideally we would have the rest of the system up and running (i.e. sysfs)
before having to deal with devices and drivers.  As it is, you are
"special casing" a number of special devices on special platforms to
work around architectural issues on those platforms.  Stuff that ideally
would never need to be done, except for crazy hardware designers :)

So I understand that it is needed, in some special cases, but that
doesn't mean I have to like it...

> To be honest I don't particularly like it either. It's very hackish for
> core code. But on the other hand there are a few device/driver ordering
> problems that this (or something similar) would help solve. I'm
> certainly open to discuss alternatives and perhaps there's a much
> cleaner way to solve the problem.

As this usually is needed on a case-by-case basis, I'm hoping that your
case really does need this, right?  If so, there's not much the kernel
can do except add hooks like this to make it work properly.

thanks,

greg k-h
