Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3JDSbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 14:31:06 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:47116
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751901Ab3JDSbD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 14:31:03 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(z551bizbb2dI98dI9371I936eI1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2fh2a8h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
Message-ID: <1380911455.2920.17.camel@atx-linux-37>
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
From: Alan Tull <atull@altera.com>
To: Michal Simek <monstr@monstr.eu>
CC: Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 4 Oct 2013 13:30:55 -0500
In-Reply-To: <524EDE5C.4040902@monstr.eu>
References: <cover.1380727889.git.michal.simek@xilinx.com>
	 <1380836768.3815.27.camel@atx-linux-37> <524EDE5C.4040902@monstr.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-04 at 17:27 +0200, Michal Simek wrote:
> Hi,
> 
> On 10/03/2013 11:46 PM, Alan Tull wrote:
> > On Wed, 2013-10-02 at 17:35 +0200, Michal Simek wrote:
> > 
> >>
> >> Through firmware interface:
> >> cat /sys/class/fpga_manager/fpga0/name
> >> echo -n fpga.bin > /sys/class/fpga_manager/fpga0/firmware
> >>
> >> Through sysfs bin file:
> >> cat /sys/class/fpga_manager/fpga0/fpga_config_state
> >> echo -n write_init > /sys/class/fpga_manager/fpga0/fpga_config_state
> >> cat /lib/firmware/fpga.bin > /sys/class/fpga_manager/fpga0/fpga_config_data
> >> echo -n write_complete > /sys/class/fpga_manager/fpga0/fpga_config_state
> >>
> > 
> > Hi Michal,
> > 
> > I have v2 working for me with Altera socfpga and had some feedback.
> > 
> > Add me and Dinh as maintainers.
> 
> why not just one? What about you?

That's fine.  Just add "Alan Tull <atull@altera.com>" So we can expect
that in v3, right?

> > 
> > This driver now has two interfaces for programming the image.
> > I don't think things in the kernel usually have multiple interfaces.
> 
> The question here is if this is a problem. i2c create char devices
> and also provide sysfs access too. It is done through notification.

i2c_master_send() is called as the fops write or from an i2c client, but
not by writing data to some attribute under sysfs.  So there aren't two
direct paths from userspace to the i2c core.  I am advocating against
multiple ways for userspace to request/send fpga images for programming.

> 
> > Does the fpga community in general find that the firmware class is
> > suitable for all our use cases?  I think it only supports the most simple
> > use cases.
> 
> Let's continue with this on that second thread and we will see what happen.

Yes, let's continue this particular discussion on the other thread.

> 
> 
> > My original fpga framework that you started with supported writing the
> > fpga device through the devnode, i.e.
> > cat fpga.bin > /dev/fpga0
> > I think we should get back to that basic char driver interface like that.
> > It seems like if you have a char driver, you would open and write to the
> > devnode instead of adding an attribute under /sys.
> 
> It is the same as above. As you know we can simple add support for char
> device with the current set of functions without changing logic in the driver.
> 
> > 
> > The 'flags' implementation is a nice way to do some locking.  But it doesn't
> > replace the status op to get fpga manager status which vanished in v2.
> > So please add that back.  Its interface was that catting the 'status'
> > attribute got a status description from the low level driver such as
> > 'power up phase' or 'reset phase'.  Too useful to just get rid of.
> 
> No problem to add it back but it means that core will loose control
> about values which can be returned back to the user. It is probably better
> to create set of return values.
> 
> Thanks,
> Michal
> 


