Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbbAMUBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:01:52 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:47439 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbbAMUBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:01:50 -0500
Date: Tue, 13 Jan 2015 13:00:32 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@denx.de>, atull <atull@opensource.altera.com>,
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
Message-ID: <20150113200032.GA16205@obsidianresearch.com>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
 <1420575219-27061-3-git-send-email-atull@opensource.altera.com>
 <20150107084819.GA1887@amd>
 <alpine.DEB.2.02.1501091302370.30067@linuxheads99>
 <20150109205643.GA5761@amd>
 <20150112210134.687176ed@lxorguk.ukuu.org.uk>
 <20150112214314.GA18610@obsidianresearch.com>
 <20150113162847.2778b5a5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113162847.2778b5a5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 04:28:47PM +0000, One Thousand Gnomes wrote:

> There is a lot of code overlap in things like loading the bitstreams,
> there is also some overlap because you want to be able to assign FPGA
> resources. For example if you have four FPGAs and you want to use one for
> OS stuff (say video) you want the other three to be open/close
> accessible, but if you've not got a video driver loaded and are running
> the same board headless you'd like all four to be handed out as normal
> resources.
>
> So IMHO it's no different to say kmalloc. We don't pre-empt kernel memory
> and give it to users but we don't reserve memory for kernel and not use
> it.

I do agree with this, and I think this is where this patch set goes so
wrong.

Just exposing all sorts of controls to userspace and having a way for
the kernel to load/unload a bitstream compleletely misses the point that
the two main ways to use FPGAs *require* some kind of kernel side
driver suppport on the FPGA.

Even if it is just a maths FPGA kernel side has to be involved in some
way to restrict DMAs, MMIO, by the user process. Obviously a FPGA that
uses kernel drivers needs kernel side help to bind those drivers.

Plonking /sys/class/fpga_manager/<fpga>/reset for either case is more
likely than not to completely crash the system.

I would look at this problem from a completely different angle - the
90% case is a single FPGA that is loaded to provide HW that Linux
drivers bind to, these days the majority use DT.

So..

soc
{
    zynq_cfg: ps7-dev-cfg@f8007000 { compatible = "xlnx,zynq-devcfg-1.0"; }
    
    fpga@pl {
       compatible = "..";
       fpga,api = "gpio-api1";
       fpga,controller = &zynq_cfg;

       gp0_axi: axi@40000000 {
         gpio3: klina_gpio@80010 {
                 #gpio-cells = <2>;
                 compatible = "linux,basic-mmio-gpio";
                 gpio-controller;
                 reg-names = "dat", "set", "dirin";
                 reg = <0x80010 4>,
                       <0x80014 4>,
                       <0x80018 4>;
         };
       }
    }  
}

Make it so linux can boot, automatically fetch the gpio-api1 bit file
and load it into the chip and then bind the GPIO driver to the FPGA
resource. All without userspace involvment, all potentially done
before calling INIT.

Make it so via sysfs we can reverse this process and reboot the FPGA.

Make it so userspace can't do something to the FPGA without first
unloading the drivers.

Then worry about how to change the FPGA, or providing more user space
control over the process (DT overlays are a natural answer).

Providing a roll-your-own approach via a bunch of sysfs controls
satisfies the 'make the HW work' need without actually providing the
overall architecture someone needs to *make use* of this mechanism.

And no, this isn't just a 'theory', I have 4 shipping products today
that work pretty much exactly like this, including a Zynq
design. Binding kernel drivers to a FPGA once it is loaded is a big
functionality gap, and an annoying problem. Programming the actual
FPGA? That is the *EASIEST* part of this whole thing!

Honestly, I'd much rather see the above use case solved properly
without sysfs support and then go from there to build a replacable
FPGA scheme on the same concepts.

Providing a 'build your own' solution with sysfs controls just seems
to completely miss the mark to me.

> So IMHO it's no different to say kmalloc. We don't pre-empt kernel memory
> and give it to users but we don't reserve memory for kernel and not use
> it.

I think we see a kernel side with more structure, that knows when the
FPGA is in use or not, there is a pretty clear path to later add a
/dev/ scheme for user space use that can properly interlock.

A /dev/ scheme doesn't make much sense to bind kernel drivers...

Jason
