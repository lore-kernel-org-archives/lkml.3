Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab3JDRGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:06:33 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:52825 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab3JDRGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:06:32 -0400
Date: Fri, 4 Oct 2013 11:05:37 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Alan Tull <atull@altera.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        David Brown <davidb@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2] fpga: Introduce new fpga subsystem
Message-ID: <20131004170537.GA6955@obsidianresearch.com>
References: <cover.1380727889.git.michal.simek@xilinx.com>
 <fe4f34387011339efe9f5868a7eec9d549462d8f.1380727889.git.michal.simek@xilinx.com>
 <20131002174640.GA10287@obsidianresearch.com>
 <524EECA7.7040409@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524EECA7.7040409@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 06:28:23PM +0200, Michal Simek wrote:
> > I strongly encourage you to use text strings to indicate the state of
> > the configuration FSM, and I *really* think you should rework things
> > to have an explicit configuration FSM rather than trying to bodge one
> > together with a bunch of bit flags.
> 
> Any favourite names for states?
> Or ready, write_init, write_complete is enough for now?

Doesnt really matter to me, don't forget error states. Transisionts to
ready, write_init and write_complete can all fail.

> > I wonder if this is right, it seems like a strange way to make a class
> > subsystem, usually the struct fpga_manager would contain the 'struct
> > device' (not a pointer, so you can use container_of) and drvdata would
> > be reserved for something else.
> 
> I am not following you here. mrg structure is connected with the driver
> it means when driver is removed then this structure is freed.

You've got your mgr structure and then later you allocate a struct
device as well, the mgr can be free'd before the struct device is
released, due to the way ref counting works. You are not doing
anything to compensate for that.

> > This seems to create lifetime issues since the devm above will be
> > free'd when the platform driver is released, but the class device will
> > live on with the stray pointer. Better to allocate everything against
> > the class device below.
> 
> device in unregistered before this structure is freed.
> fpga_mgr_unregister() is called in the platform driver in remove function.

Which is the problem, device_unregister dosen't delete 'mgr->dev', and it
doesn't mean the sysfs call backs are uncallable, so you have a free'd
dangling pointer in mgr->dev, and an object lifetime issue.

> > What happens when userspace is holding one of the sysfs files open and
> > you unload the module? Looks like bad things?
> 
> I didn't test this but feel free to check it.

You should fix these problems before your driver reaches Linus.

Jason
