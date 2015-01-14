Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbbANSOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:14:09 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:38112 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbbANSOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:14:06 -0500
Date: Wed, 14 Jan 2015 11:12:58 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
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
Message-ID: <20150114181258.GB16392@obsidianresearch.com>
References: <20150107084819.GA1887@amd>
 <alpine.DEB.2.02.1501091302370.30067@linuxheads99>
 <20150109205643.GA5761@amd>
 <20150112210134.687176ed@lxorguk.ukuu.org.uk>
 <20150112214314.GA18610@obsidianresearch.com>
 <20150113162847.2778b5a5@lxorguk.ukuu.org.uk>
 <20150113200032.GA16205@obsidianresearch.com>
 <alpine.DEB.2.02.1501131455130.30192@linuxheads99>
 <20150113222450.GA17475@obsidianresearch.com>
 <20150114160617.02fb9135@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114160617.02fb9135@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 04:06:17PM +0000, One Thousand Gnomes wrote:

> and I think you effectively have the user usage covered here for such
> things. It much like GPIO pins - we can describe them but we can also
> declare they are not visible to the user.

A missing element in mainline is a kind of VFIO scheme to let user
space access the FPGA registers designated for user space use.

We have been using these patches since 2.6.16 to allow user space to
access the FPGA register resources via a PCI like /sys/../resource0
mmapable:

    https://github.com/jgunthorpe/linux/commit/59d5d13ddeffa8980ccc6248ebb5f1678ccb23f4
    https://github.com/jgunthorpe/linux/commit/7c29c4344627be8a3906d64d32db533bc131df86
    https://github.com/jgunthorpe/linux/commit/e41bb4a197368a9d505d66b627aee82f2d2b8895

We deliberately split up the FPGA registers and the assign user space
permissions to the resource0 files in a way that makes sense for our
app. Typically there are 10-20 FPGA register regions. User space does
not access register regions that control DMA.

> The swappable case mostly comes out of the /dev node. Once you have the
> dev node it becomes a detail of the OS not the FPGA driver as to who may
> open it, and how it is handed about. It might be an FPU manager daemon it
> might not.

Right, but the thing that scares me about the swappable case is the
kernel side support.. The FPGA has to connect to the CPU in some way,
it must have some address assigned, etc. Swapping needs to take care
of all those details in some way.

A fixed bus interface block and dynamic reconfiguration for the
remainder is probably the way to manage that. But, that implies that
even a family of swappable FPGAs will have a DT overlay associated
with it.

Ideally, I could see wanting to have a file format that combines the
overlay and FPGA bitfile. A loader tool would use the /dev/ interface
to setup both elements. That would be much more robust than the
current scheme I see (eg Xilinx) using where the bitfile and DT bit
live in completely different places and have to be perfectly matched.

Jason
