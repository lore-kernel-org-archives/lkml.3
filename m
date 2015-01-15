Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbbAOUrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 15:47:49 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:46786 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbbAOUrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 15:47:47 -0500
Date: Thu, 15 Jan 2015 20:45:02 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: atull <atull@opensource.altera.com>, gregkh@linuxfoundation.org,
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
Message-ID: <20150115204502.591bca1d@lxorguk.ukuu.org.uk>
In-Reply-To: <20150115184726.GA23247@obsidianresearch.com>
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
	<20150115184726.GA23247@obsidianresearch.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 11:47:26 -0700
Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> It is a novel idea, my concern would be that embedding the FPGA in the
> DT makes it permanent unswappable kernel memory.
> Not having the kernel hold the FPGA is best for many uses.

If you have a filesysytem before the FPGA is set up then it belongs in
the file system. As you presumably loaded the kernel from somewhere there
ought to be a file system (even an initrd).

> Having the kernel hold the FPGA as a swppable file handle/mmap of some
> sort is next best (obviously the fs must be operating during resume)

For a lot of hardware that gets somewhat hairy because you don't know
what the dependancies between devices are on the resume but yes.

> Unswappable kernel memory is the worst choice

There is another case here - which is where the firmware is somewhere
else physically. For example in PCI ROM space, or flash, but designed to
be loaded by the OS.


> I think to justify the ioctls you need a reason to have the context
> of a FD. sysfs is stateless, so if my process dies the kernel doesn't
> know.

That isn't to say the stateless information doesn't belong in sysfs. Eg
you don't neccessarily want to open the device node and go through ioctls
just for bits of information that are interesting to reporting tools.

(Imagine an 'lsfpga' tool for the kind of things you'd leave in sysfs)

> Identifying the ioctls needed would probably clarify things. My
> rough start would be 
> 
> - Get status: programed, not programmed, error?
>   Bitfile type? (eg Xilinx has nearly every permutation of bit/byte
>   ordering)

That's probably some kind of "what are you" ioctl that returns the
vendor/type information.

> - Hand over to a DT overlay (how does this work?) Lock transfers
>   from FD to kernel

That bit isn't stateful so I would actually have expected something in
the kernel ABI along the lines of 

           request_fpga(blah)

which does

             if in use by user
                    EBUSY
             lock it (all user opens will fail)

and

            release_fpga(blah)

and a sysfs node indicating its busy (and perhaps also what for if the
request_fpga passes a textual name)

> Not sure about partial reconfiguration - clearly the kernel needs to
> know and check that the bitfiles are of the correct family, I wonder
> if the approach should be to program a basis on the FPGA which then
> creates a new FPGA device in the system that can accept the partial
> reconfiguration - this way the locking makes sense, the basis is
> locked by the kernel and devices and the overlay remains
> lockable/swappable/whatever by a dedicated /dev/ node ??

I think so.

If you closed the device you have no idea what happened between the close
and a re-open, therefore you have no idea what the FPGA state is.
 
> Just thinking aloud, I've never had a use case for partial
> reconfiguration.

The API handles it but whether it needs to be there from day one I don't
know.

Alan

