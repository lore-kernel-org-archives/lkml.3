Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3IRVRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:17:53 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:38317
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873Ab3IRVRw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:17:52 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI936eI1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h177df4h17326ah1de097h186068h8275dhz2fh2a8h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
Message-ID: <1379539063.31417.23.camel@atx-linux-37>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
From: Alan Tull <atull@altera.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <monstr@monstr.eu>, Pavel Machek <pavel@ucw.cz>,
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
Date: Wed, 18 Sep 2013 16:17:43 -0500
In-Reply-To: <20130918203247.GA11181@obsidianresearch.com>
References: <cover.1379519753.git.michal.simek@xilinx.com>
	 <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
	 <20130918191517.GQ19937@titan.lakedaemon.net>
	 <20130918203247.GA11181@obsidianresearch.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 14:32 -0600, Jason Gunthorpe wrote:
> On Wed, Sep 18, 2013 at 03:15:17PM -0400, Jason Cooper wrote:
> 
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
> 
> Using request_firmware exclusively is not useful for us. We
> format the bitfile with a header that contains our internal tracking
> information. Sometimes we need to bitswap the bitfile. Our userspace
> handles all of this and can pass a bitfile in memory to write().
> 
> request_firmware would be horrible to use :)
> 
> Our API uses a binary sysfs attribute to stream the FPGA data, you
> might want to consider that.
> 
> Regards,
> Jason

The firmware approach is interesting.  It might be less flexible
compared with my original code (see link to git below) that this is
based on.  The original code created a devnode like /dev/fpga0 and a raw
bitstream could be loaded by doing 'cat bitstream > /dev/fpga0'.  Or
some other userspace app could write the /dev/fpga0 to handle any
headers that needed to be added to the bitstream.

This code also creates a set of files under /sys for each separate fpga.
I.e. checking status by looking at /sys/class/fpga/fpag0/status.  It
would be pretty small changes to control reseting the fpga by adding a
'reset' file there also (added first to the framework, and an interface
into the low level fpga manager driver).

I am trying this out with my low level fpga manager driver.  I'm very
curious about your approach and I am wondering whether the firmware
approach will work for us or not.

Will this framework handle more than one fpga at a time?

Is there some way a per-device userspace helper can be added that can
handle adding the headers?  Such that different fpga types get different
helpers?

My fpga framework code is in git at:
http://rocketboards.org/gitweb/?p=linux-socfpga.git;a=commit;h=7b7c04ef3f8589349211bdfe884e42d6b7554b27

and

http://rocketboards.org/gitweb/?p=linux-socfpga.git;a=commit;h=57ee6197d65015620cd6aad435a695ce00a48a8c

Best Regards,
Alan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


