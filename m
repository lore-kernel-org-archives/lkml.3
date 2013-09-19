Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3ISKDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:03:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38327 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3ISKDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:03:41 -0400
Date: Thu, 19 Sep 2013 12:03:39 +0200
From: Pavel Machek <pavel@denx.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu, Alan Tull <atull@altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
Message-ID: <20130919100339.GB19346@amd.pavel.ucw.cz>
References: <cover.1379519753.git.michal.simek@xilinx.com>
 <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
 <20130918191517.GQ19937@titan.lakedaemon.net>
 <20130918203247.GA11181@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918203247.GA11181@obsidianresearch.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > + Jason Gunthorpe
> 
> Thanks, looks interesting, we could possibly use this interface if it 
> met our needs..
>  
> > On Wed, Sep 18, 2013 at 05:56:39PM +0200, Michal Simek wrote:
> > > This new subsystem should unify all fpga drivers which
> > > do the same things. Load configuration data to fpga
> > > or another programmable logic through common interface.
> > > It doesn't matter if it is MMIO device, gpio bitbanging,
> > > etc. connection. The point is to have the same
> > > inteface for these drivers.
> 
> So, we have many years of in-field experience with this and this API
> doesn't really match what we do.
> 
> Here are the steps we perform, from userspace:
...

>  - Ask kernel to place FPGA into reset and prepare for programming
>    * Kernel can return an error (eg FPGA failed to erase, etc)
>    * this is the PROG_N low -> DONE high, PROG_N high -> INIT_N high
>      sequencing on Xilinx chips
>  - Ask kernel to load a bitstream.
>    * Userspace locats the bitstream file to load, and the mmaps it.
>    * Userspace passes the entire file in a single write() call to the
>      kernel which streams it over the configuration bus
>    * The kernel can report an erro rhere (eg Xilinx can report CRC
>    error)
>  - Ask the kernel to verify that configuration is complete. 
>    * On Xilinx this wait for done to go high
>  - Ask the kernel to release the configuration bus (tristate
>    all drivers) (or sometimes we have to drive the bus low,
>    it depends on the bitfile, user space knows what to do)
> 
> It is very important that userspace know exactly which step fails
> because the resolution is different. We use this in a manufacturing
> setting, so failures are expected and need quick root cause
> determination.
> 
> You could probably address that need by very clearly defining a
> variety of errno values for the various cases. However, it would be a
> disaster if every driver did something a little different :|

Well, exact steps are a bit hw-specific, too. So, if anything, I'd
suggest standartizing the errno values.

> Using request_firmware exclusively is not useful for us. We
> format the bitfile with a header that contains our internal tracking
> information. Sometimes we need to bitswap the bitfile. Our userspace
> handles all of this and can pass a bitfile in memory to write().

Take a look at
https://www.kernel.org/doc/Documentation/firmware_class/README . You
can do processing at 

 4), userspace:
     - hotplug: cat appropriate_firmware_image > \
       		    			       /sys/class/firmware/xxx/data

What is the specific reason request_firmware is unsuitable?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
