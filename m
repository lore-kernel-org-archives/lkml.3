Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbbAMWZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:25:49 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:59967 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbbAMWZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:25:46 -0500
Date: Tue, 13 Jan 2015 15:24:50 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: atull <atull@opensource.altera.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Pavel Machek <pavel@denx.de>, gregkh@linuxfoundation.org,
        hpa@zytor.com, monstr@monstr.eu, michal.simek@xilinx.com,
        rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, pantelis.antoniou@konsulko.com,
        robh+dt@kernel.org, grant.likely@linaro.org, iws@ovro.caltech.edu,
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
Message-ID: <20150113222450.GA17475@obsidianresearch.com>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
 <1420575219-27061-3-git-send-email-atull@opensource.altera.com>
 <20150107084819.GA1887@amd>
 <alpine.DEB.2.02.1501091302370.30067@linuxheads99>
 <20150109205643.GA5761@amd>
 <20150112210134.687176ed@lxorguk.ukuu.org.uk>
 <20150112214314.GA18610@obsidianresearch.com>
 <20150113162847.2778b5a5@lxorguk.ukuu.org.uk>
 <20150113200032.GA16205@obsidianresearch.com>
 <alpine.DEB.2.02.1501131455130.30192@linuxheads99>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1501131455130.30192@linuxheads99>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 03:37:14PM -0600, atull wrote:

> > I do agree with this, and I think this is where this patch set goes so
> > wrong.
> > 
> > Just exposing all sorts of controls to userspace and having a way for
> > the kernel to load/unload a bitstream compleletely misses the point that
> > the two main ways to use FPGAs *require* some kind of kernel side
> > driver suppport on the FPGA.
> 
> Hi Jason,
> 
> I may be misunderstanding.  I thought you wanted lots of user control
> a couple years ago.
> 
> https://lkml.org/lkml/2013/9/18/490

Yes, that is absolutely true, that is certainly where my projects have
been historically, and in the context of requiring user space to
manage the whole process I think that is completely right.

But - I like Alan's point - this should be a higher level thing, the
kernel should be able to load the FPGA, and handle binding the drivers
so user space doesn't need to be involved, and it makes sense that
should be the place to start the API design.

> Your feedback carried a lot of weight as I've been developing this patchset
> although I didn't do absolutely everything you asked for.  Back then you
> were asking for lots of user control including being able to reset the FPGA
> and being able to know from userspace what configuration steps failed (if any).

Yes, this is all true. Since my FPGAs all seem to require a software
mediated startup sequence the dream of having a DT scheme like I
described is farther away for me, but I think that is not the 90%
case. Almost all vendor IP designs do not require a SW startup and
auto-start after programming. 90% of designs can program and then
immediately connect drivers.

> I'm glad you like DT support for FPGA images + drivers loading since I've
> been pushing that since April and have submitted several earlier versions
> of this patchset which included it.

Yes, I do, thank you for working on this!

> I think your arguements against the current patchset are a bit over
> the top here.

Perhaps, and I apologize. But as you know I've never liked the sysfs
interface, and I think Pavel is right. catting a file name just so you
can call request_firmware on that file in the kernel is a bad design.

The request_firmware interface should be for the DT overlay path, and
other schemes shouldn't use it. The name should come from the DT and
no place else.

> > Make it so linux can boot, automatically fetch the gpio-api1 bit file
> > and load it into the chip and then bind the GPIO driver to the FPGA
> > resource. All without userspace involvment, all potentially done
> > before calling INIT.
> 
> Where would the fpga image be fetch from?  What is the mechanism for
> doing that?  Do we need to reqire everybody to do that or can
> firmware be one of the available mechanisms?

I see there are three options:
 1) The bootloader programs the FPGA and passes a DT to the kernel
    that completely describes the hard and soft logic, the kernel
    doesn't need FPGA bitfile management code or other special
    support.

    Obviously things like reprogram on resume have to be done by the
    bootloader, there is no handoff here where the kernel takes over
    control of the bitfile programming. I think that is fine, #2/#3
    are better choices for most people anyhow.
 2) The bootloader starts the kernel and passes a DT that describes
    the hard logic and soft logic using a scheme like I outlined. The
    kernel is responsible to request_firmware the bitfile and start
    the FPGA and connect the drivers.

    DT purists will rightly point out that this isn't great, but it
    is a simple and pragmatic solution.

    This probably falls out automatically if #3 is implemented..
 3) The bootloader starts the kernel with a DT that only describes the
    hard logic.

    Userspace must load a DT overlay early on. Otherwise proceeds like #2.

    In both 2 and 3 the FPGA can be reprogrammed on resume by re-doing
    request_firmware.

And for folks that need more control, expose all the knobs explicitly
to user space:
  4) There is a /dev/ node for the fpga that allows
     - ioctl to program via mmap'd file (no request_firmware)

       The ioctl has an option for the kernel to hang on to the mmap
       for the repogram on resume case.
     - ioctl to get status/error reporting/etc
     - ioctl to load/bind a DT overlay to the FPGA instance
       This provides a gap where userspace can boot and configure the
       FPGA internals before binding the kernel drivers.
       (end result is the same as #3 case, but no request_firmware)
     - (future) ioctl to load a swappable FPGA (what Alan is talking
       about)

The key thing is that we have a FPGA object that can be associated
with some DT element, and the kernel can then keep track if the FPGA
is is in use or not. Exactly like you said in your reply.

Otherwise, for the /dev/ case the FPGA becomes unuse once the FD is
closed if it wasn't attached to an overlay. This is at least the start
of addressing the space Alan is talking about.

If this sort of world is the goal, it is hard for me to see how the
proposed sysfs interface fits into that long term.

The /dev/ interface is probably a better place to start talking about
partial reconfiguration as well. The fixed part might be bound to a
kernel driver (eg the PCI-E interface) and the reconfigurable part
might be a maths algorithm - for instance.

> > Make it so via sysfs we can reverse this process and reboot the FPGA.
> 
> Better to use the device tree's configfs interface if you are going
> to add/delete a DT overlay.  Adding an overlay could load the fpga,
> enable bridges, and load driver(s).  Some fpga images may have several
> hardware blocks so several drivers to load.

Yes, absolutely!

> > And no, this isn't just a 'theory', I have 4 shipping products today
> > that work pretty much exactly like this, including a Zynq
> > design. Binding kernel drivers to a FPGA once it is loaded is a big
> > functionality gap, and an annoying problem. Programming the actual
> > FPGA? That is the *EASIEST* part of this whole thing!

> That's why I'm trying to get programming the fpga out of the way here.

I have no problem with the in kernel stuff, and I'd have no problem if
the sysfs controls were in debugfs for testing purposes. It just
doesn't make sense to me to expose that kind of interface as a
permanent API...
 
Jason
