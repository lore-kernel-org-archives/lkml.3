Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbbAOVn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:43:28 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:58125 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbbAOVn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:43:26 -0500
Date: Thu, 15 Jan 2015 14:42:30 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
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
Message-ID: <20150115214230.GD23247@obsidianresearch.com>
References: <20150109205643.GA5761@amd>
 <20150112210134.687176ed@lxorguk.ukuu.org.uk>
 <20150112214314.GA18610@obsidianresearch.com>
 <20150113162847.2778b5a5@lxorguk.ukuu.org.uk>
 <20150113200032.GA16205@obsidianresearch.com>
 <alpine.DEB.2.02.1501131455130.30192@linuxheads99>
 <20150113222450.GA17475@obsidianresearch.com>
 <alpine.DEB.2.02.1501150936390.16760@linuxheads99>
 <20150115184726.GA23247@obsidianresearch.com>
 <20150115204502.591bca1d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115204502.591bca1d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 08:45:02PM +0000, One Thousand Gnomes wrote:

> > - Hand over to a DT overlay (how does this work?) Lock transfers
> >   from FD to kernel
> 
> That bit isn't stateful so I would actually have expected something in
> the kernel ABI along the lines of 
> 
>            request_fpga(blah)
> 
> which does
> 
>              if in use by user
>                     EBUSY
>              lock it (all user opens will fail)
> 
> and
> 
>             release_fpga(blah)

I am imagining two ways to start a kernel FPGA, the in-kernel method
triggered by a DT node:

  fpga = request_and_lock_fpga(of_get_fpga_controller(dev->of_node))
  fw = request_firmat(of_get_fpga_firmware(dev->of_node));
  fpga_program_fw(fpga, fw);

  for_each_child_of_node(dev->of_node, child)
    .. of_platform_bus_probe(child ... ) ..

  .. somehow fpga and its lock transfer to dev->of_node ..

The problem with this is it assumes the FPGA is ready to go
immediately after fpga_program_fw. There are a few platforms that can
manage this, but many others require at least some kind of startup
sequence - eg wait for clocking PLLs to lock, do low level setup, etc.

For very common cases (like Zynq can have a pretty common setup scheme
for the PL side) the DT binding can guide the kernel to run the right
code, and the code can live in the kernel because it is simple and
broadly useful.

For wild cases I'd like to just punt the setup code to user space. It
is safer and simpler to run that complexity in a user process than in
the kernel.

Maybe there is a better way to handle this, but I have been under the
impression that these days it is frowned on for the kernel to wait for
userspace?

So my idea is to use the user space method to also load a 'kernel'
fpga, the process follows the kernel flow:

   fd = open("/dev/fpga0"); // request_and_lock_fpga

   ioctl(fd,START_PROGRAMMING); // fpga_program_fw
   write(fd,fw,fw_size);
   
   // Arbitary complexity here
   userspace_setup_fpga();

   icotl(fd,BIND_DT_OVERLAY, .. ?? ..) // for_each_child_of_node

This is what the state is about, if the setup fails I expect the
kernel to go and unlock and deprogram the FPGA if fd is closed. Only a
success on BIND_DT_OVERLAY will make the FPGA permanent beyond closing
fd.

Pantelis: I think this explains why a fd and ioctls. configfs, sysfs,
etc lack the FD context to do the cleanup. 

Essentially, I think a running FPGA should always be attached to some
context that is the user - either the user is in-kernel (a DT of_node)
or the user is in userspace (the fd).

The invarient is - if there is no user then the kernel automatically
makes the FPGA deprogrammed.

Having a device that is potentially attached to the CPU bus running
'rouge' is dangerous. We can't realistically deprogram it safely if we
don't know what it is doing. Eg deprogramming in the middle of a DMA
operation between the CPU and FPGA will often crash the entire system.

The only way to provide reasonable safe guards is to have a clear
chain of ownership. When the kernel takes ownership of the FPGA it
also takes ownership of any cleanup required prior to deprogram.

Jason
