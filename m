Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbbAOSsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 13:48:45 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:46252 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbbAOSsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 13:48:43 -0500
Date: Thu, 15 Jan 2015 11:47:26 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: atull <atull@opensource.altera.com>
Cc: gregkh@linuxfoundation.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Pavel Machek <pavel@denx.de>, hpa@zytor.com, monstr@monstr.eu,
        michal.simek@xilinx.com, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        pantelis.antoniou@konsulko.com, robh+dt@kernel.org,
        grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, broonie@kernel.org, philip@balister.org,
        rubini@gnudd.com, s.trumtrar@pengutronix.de, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devel@driverdev.osuosl.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
Message-ID: <20150115184726.GA23247@obsidianresearch.com>
References: <20150107084819.GA1887@amd>
 <alpine.DEB.2.02.1501091302370.30067@linuxheads99>
 <20150109205643.GA5761@amd>
 <20150112210134.687176ed@lxorguk.ukuu.org.uk>
 <20150112214314.GA18610@obsidianresearch.com>
 <20150113162847.2778b5a5@lxorguk.ukuu.org.uk>
 <20150113200032.GA16205@obsidianresearch.com>
 <alpine.DEB.2.02.1501131455130.30192@linuxheads99>
 <20150113222450.GA17475@obsidianresearch.com>
 <alpine.DEB.2.02.1501150936390.16760@linuxheads99>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1501150936390.16760@linuxheads99>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 10:34:39AM -0600, atull wrote:

> This is great!  The way I had it working was using Pantelis' devicetree
> configfs interface.

I figured you were very close to this already in your overlay work..
 
> The DT fragment described the FPGA logic and included a filename
> for firmware to load. In another branch of this thread, I see discussion
> starting on what the overlay should look like and whether it could somehow
> contain the DT itself.

It is a novel idea, my concern would be that embedding the FPGA in the
DT makes it permanent unswappable kernel memory.

Not having the kernel hold the FPGA is best for many uses.

Having the kernel hold the FPGA as a swppable file handle/mmap of some
sort is next best (obviously the fs must be operating during resume)

Unswappable kernel memory is the worst choice

> Long ago this driver started out with a /dev interface.  It didn't have
> an ioctl yet at that point, but programming the fpga was by opening
> the devnode and writing to it.  Greg KH preferred sysfs or configfs
> over adding another ioctl:

I think to justify the ioctls you need a reason to have the context
of a FD. sysfs is stateless, so if my process dies the kernel doesn't
know.

But now that we are talking about adding locking and ownership
concepts a FD is the natural anchor for that in user space.

Ie, if I open the dev node, program a FPGA and then crash the kernel
doesn't attach drivers, and immediately de-programs the
chip. Userspace has to make it all the way through to the DT bind
before the FPGA lifetime would exceed the FD.

> https://lkml.org/lkml/2013/10/8/677

I think Greg's reply makes sense in the context of the question being
asked. Thinking of the FPGA as lockable ref counted kind of resource
changes the question somewhat.

Identifying the ioctls needed would probably clarify things. My
rough start would be 

- Get status: programed, not programmed, error?
  Bitfile type? (eg Xilinx has nearly every permutation of bit/byte
  ordering)
- Start Program with with some kind of context (ie this a new bit
  file, partial reconfiguration basis X, partial reconfiguration
  overlay on X)
- for (;;) write() to do programming
- Get Error to return detailed failure information (CRC error,
  auth error, etc)
- Hand over to a DT overlay (how does this work?) Lock transfers
  from FD to kernel

-  .. something something VFIO .. ?

Where start program is refused if the FPGA is already locked, and
  locks it 
Where start program -> close() returns the FPGA back to reset and
  unlocks
Where start program -> hand over -> close() keeps the FPGA loaded with
 kernel drivers attached and fpga locked (remove the overlay to
 de-program and unlock)

Not sure exactly how to tie together DT overlays with the FPGA state,
but that seems the natural combination..

Not sure about partial reconfiguration - clearly the kernel needs to
know and check that the bitfiles are of the correct family, I wonder
if the approach should be to program a basis on the FPGA which then
creates a new FPGA device in the system that can accept the partial
reconfiguration - this way the locking makes sense, the basis is
locked by the kernel and devices and the overlay remains
lockable/swappable/whatever by a dedicated /dev/ node ??

Just thinking aloud, I've never had a use case for partial
reconfiguration.

Jason
