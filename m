Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab3JHVtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 17:49:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab3JHVt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 17:49:26 -0400
Date: Tue, 8 Oct 2013 14:44:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Tull <atull@altera.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, monstr@monstr.eu,
        Pavel Machek <pavel@denx.de>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
Message-ID: <20131008214401.GC11941@kroah.com>
References: <20131003064915.GB17155@amd.pavel.ucw.cz>
 <524EC965.70701@monstr.eu>
 <20131004141646.GA9396@kroah.com>
 <d700a91e-1319-4c35-895d-55e323c40703@email.android.com>
 <524ED081.1040600@monstr.eu>
 <524EF0CE.4040002@zytor.com>
 <524EFE76.70200@monstr.eu>
 <524F04FD.5020804@zytor.com>
 <20131004233341.GA4028@kroah.com>
 <1381251614.6062.9.camel@atx-linux-37>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381251614.6062.9.camel@atx-linux-37>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 12:00:14PM -0500, Alan Tull wrote:
> On Fri, 2013-10-04 at 16:33 -0700, Greg Kroah-Hartman wrote:
> > On Fri, Oct 04, 2013 at 11:12:13AM -0700, H. Peter Anvin wrote:
> > > On 10/04/2013 10:44 AM, Michal Simek wrote:
> > > > 
> > > > If you look at it in general I believe that there is wide range of 
> > > > applications which just contain one bitstream per fpga and the 
> > > > bitstream is replaced by newer version in upgrade. For them 
> > > > firmware interface should be pretty useful. Just setup firmware 
> > > > name with bitstream and it will be automatically loaded in startup 
> > > > phase.
> > > > 
> > > > Then there is another set of applications especially in connection 
> > > > to partial reconfiguration where this can be done statically by 
> > > > pregenerated partial bitstreams or automatically generated on 
> > > > target cpu. For doing everything on the target firmware interface 
> > > > is not the best because everything can be handled by user 
> > > > application and it is easier just to push this bitstream to do 
> > > > device and not to save it to the fs.
> > > > 
> > > > I think the question here is if this subsystem could have several 
> > > > interfaces. For example Alan is asking for adding char support. 
> > > > Does it even make sense to have more interfaces with the same 
> > > > backend driver? When this is answered then we can talk which one 
> > > > make sense to have. In v2 is sysfs and firmware one. Adding char
> > > > is also easy to do.
> > > > 
> > > 
> > > Greg, what do you think?
> > > 
> > > I agree that the firmware interface makes sense when the use of the
> > > FPGA is an implementation detail in a fixed hardware configuration,
> > > but that is a fairly restricted use case all things considered.
> > 
> > Ideally I thought this would be just like "firmware", you dump the file
> > to the FPGA, it validates it and away you go with a new image running in
> > the chip.
> > 
> > But, it sounds like this is much more complicated, so much so that
> > configfs might be the correct interface for it, as you can do lots of
> > things there, and it is very flexible (some say too flexible...)
> > 
> > A char device, with a zillion different custom ioctls is also a way to
> > do it, but one that I really want to avoid as that gets messy really
> > quickly.
> 
> Hi Greg,
> 
> We are discussing a char device that has very few interfaces:
>  - a way of writing the image to fpga
>  - a way of getting fpga manager status
>  - a way of setting fpga manager state
> 
> This all looks like standard char driver interface to me.  Writing the
> image could be writing to the devnode (cat image.bin > /dev/fpga0). The
> status stuff would be sysfs attributes.  All normal stuff any char
> driver in the kernel would do.  Why not just go with that?

Because we really hate to add new ioctls to the kernel if at all
possible.  Using sysfs (and it's one-value-per-file rule), makes
userspace tools easier, and managing the different devices in the system
easier (you know _exactly_ which device you are talking to, you don't
have to guess based on minor number).

thanks,

greg k-h
