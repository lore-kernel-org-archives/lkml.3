Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbbANQIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:08:37 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:44817 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbANQIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:08:34 -0500
Date: Wed, 14 Jan 2015 16:06:17 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: atull <atull@opensource.altera.com>, Pavel Machek <pavel@denx.de>,
        gregkh@linuxfoundation.org, hpa@zytor.com, monstr@monstr.eu,
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
Message-ID: <20150114160617.02fb9135@lxorguk.ukuu.org.uk>
In-Reply-To: <20150113222450.GA17475@obsidianresearch.com>
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
	<20150113222450.GA17475@obsidianresearch.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The request_firmware interface should be for the DT overlay path, and
> other schemes shouldn't use it. The name should come from the DT and
> no place else.

For the static bindings agreed (or ACPI but that's a detail) or other
dynamic discovery post boot.

>  2) The bootloader starts the kernel and passes a DT that describes
>     the hard logic and soft logic using a scheme like I outlined. The
>     kernel is responsible to request_firmware the bitfile and start
>     the FPGA and connect the drivers.
> 
>     DT purists will rightly point out that this isn't great, but it
>     is a simple and pragmatic solution.
> 
>     This probably falls out automatically if #3 is implemented..
>  3) The bootloader starts the kernel with a DT that only describes the
>     hard logic.
> 
>     Userspace must load a DT overlay early on. Otherwise proceeds like #2.
> 
>     In both 2 and 3 the FPGA can be reprogrammed on resume by re-doing
>     request_firmware.

and I think you effectively have the user usage covered here for such
things. It much like GPIO pins - we can describe them but we can also
declare they are not visible to the user.

> And for folks that need more control, expose all the knobs explicitly
> to user space:
>   4) There is a /dev/ node for the fpga that allows
>      - ioctl to program via mmap'd file (no request_firmware)
> 
>        The ioctl has an option for the kernel to hang on to the mmap
>        for the repogram on resume case.
>      - ioctl to get status/error reporting/etc
>      - ioctl to load/bind a DT overlay to the FPGA instance
>        This provides a gap where userspace can boot and configure the
>        FPGA internals before binding the kernel drivers.
>        (end result is the same as #3 case, but no request_firmware)
>      - (future) ioctl to load a swappable FPGA (what Alan is talking
>        about)

The swappable case mostly comes out of the /dev node. Once you have the
dev node it becomes a detail of the OS not the FPGA driver as to who may
open it, and how it is handed about. It might be an FPU manager daemon it
might not.

> The key thing is that we have a FPGA object that can be associated
> with some DT element, and the kernel can then keep track if the FPGA
> is is in use or not. Exactly like you said in your reply.

I think this is right. You have a set of FPGA objects initially coming
from DT and system enumerations and later maybe even showing up via
hotplug.

You have a set of bindings which describes what to do with those that
have fixed bindings.

The fpga /dev entries are then a subset of the enumerated list which has
not been marked as OS in use (or they return -EBUSY and can't be opened)

At that point it works like pretty much everything else.

> I have no problem with the in kernel stuff, and I'd have no problem if
> the sysfs controls were in debugfs for testing purposes. It just
> doesn't make sense to me to expose that kind of interface as a
> permanent API...

That's my big concern too. We need an FPGA manager in kernel clearly. We
need kernel ability to program FPGA bitstreams (if only because there are
both boot time and suspend/resume cases that turn into complete insanity
otherwise).

Alan
