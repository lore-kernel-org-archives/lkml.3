Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab3IRUdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 16:33:04 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:33545 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab3IRUdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 16:33:01 -0400
Date: Wed, 18 Sep 2013 14:32:47 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu, Alan Tull <atull@altera.com>,
        Pavel Machek <pavel@ucw.cz>,
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
Message-ID: <20130918203247.GA11181@obsidianresearch.com>
References: <cover.1379519753.git.michal.simek@xilinx.com>
 <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
 <20130918191517.GQ19937@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918191517.GQ19937@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 03:15:17PM -0400, Jason Cooper wrote:

> + Jason Gunthorpe

Thanks, looks interesting, we could possibly use this interface if it 
met our needs..
 
> On Wed, Sep 18, 2013 at 05:56:39PM +0200, Michal Simek wrote:
> > This new subsystem should unify all fpga drivers which
> > do the same things. Load configuration data to fpga
> > or another programmable logic through common interface.
> > It doesn't matter if it is MMIO device, gpio bitbanging,
> > etc. connection. The point is to have the same
> > inteface for these drivers.

So, we have many years of in-field experience with this and this API
doesn't really match what we do.

Here are the steps we perform, from userspace:
 - Ask kernel to place FPGA into reset and prepare for programming
   * Kernel can return an error (eg FPGA failed to erase, etc)
   * this is the PROG_N low -> DONE high, PROG_N high -> INIT_N high
     sequencing on Xilinx chips
 - Ask kernel to load a bitstream.
   * Userspace locats the bitstream file to load, and the mmaps it.
   * Userspace passes the entire file in a single write() call to the
     kernel which streams it over the configuration bus
   * The kernel can report an erro rhere (eg Xilinx can report CRC
   error)
 - Ask the kernel to verify that configuration is complete. 
   * On Xilinx this wait for done to go high
 - Ask the kernel to release the configuration bus (tristate
   all drivers) (or sometimes we have to drive the bus low,
   it depends on the bitfile, user space knows what to do)

It is very important that userspace know exactly which step fails
because the resolution is different. We use this in a manufacturing
setting, so failures are expected and need quick root cause
determination.

You could probably address that need by very clearly defining a
variety of errno values for the various cases. However, it would be a
disaster if every driver did something a little different :|

Using request_firmware exclusively is not useful for us. We
format the bitfile with a header that contains our internal tracking
information. Sometimes we need to bitswap the bitfile. Our userspace
handles all of this and can pass a bitfile in memory to write().

request_firmware would be horrible to use :)

Our API uses a binary sysfs attribute to stream the FPGA data, you
might want to consider that.

Regards,
Jason
