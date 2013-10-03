Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3JCVqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:46:23 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:54587
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755518Ab3JCVqV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:46:21 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z551biz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2fh2a8h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
Message-ID: <1380836768.3815.27.camel@atx-linux-37>
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
From: Alan Tull <atull@altera.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: <linux-kernel@vger.kernel.org>, <monstr@monstr.eu>,
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
Date: Thu, 3 Oct 2013 16:46:08 -0500
In-Reply-To: <cover.1380727889.git.michal.simek@xilinx.com>
References: <cover.1380727889.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 17:35 +0200, Michal Simek wrote:

> 
> Through firmware interface:
> cat /sys/class/fpga_manager/fpga0/name
> echo -n fpga.bin > /sys/class/fpga_manager/fpga0/firmware
> 
> Through sysfs bin file:
> cat /sys/class/fpga_manager/fpga0/fpga_config_state
> echo -n write_init > /sys/class/fpga_manager/fpga0/fpga_config_state
> cat /lib/firmware/fpga.bin > /sys/class/fpga_manager/fpga0/fpga_config_data
> echo -n write_complete > /sys/class/fpga_manager/fpga0/fpga_config_state
> 

Hi Michal,

I have v2 working for me with Altera socfpga and had some feedback.

Add me and Dinh as maintainers.

This driver now has two interfaces for programming the image.
I don't think things in the kernel usually have multiple interfaces.

Does the fpga community in general find that the firmware class is
suitable for all our use cases?  I think it only supports the most simple
use cases.

My original fpga framework that you started with supported writing the
fpga device through the devnode, i.e.
cat fpga.bin > /dev/fpga0
I think we should get back to that basic char driver interface like that.
It seems like if you have a char driver, you would open and write to the
devnode instead of adding an attribute under /sys.

The 'flags' implementation is a nice way to do some locking.  But it doesn't
replace the status op to get fpga manager status which vanished in v2.
So please add that back.  Its interface was that catting the 'status'
attribute got a status description from the low level driver such as
'power up phase' or 'reset phase'.  Too useful to just get rid of.

Alan



> Subsystem supports working with phandles for cases where you want to load
> bitstreams for particular device through defined device.
> For example:
> mngr@0 {
> 	compatible = "whatever";
> 	fpga-mgr = <&ps7_dev_cfg_0>;
> 	...
> } ;
> 
> With these lines you can get easily load bitstream to the device.
> 
> struct fpga_manager *mgr;
> mgr = of_find_fpga_mgr_by_phandle(pdev->dev.of_node, "fpga-mgr");
> if (mgr)
> 	mgr->fpga_firmware_write(mgr, "filename");
> 
> NOTE: I have added there of_find_fpga_mgr_by_node()
> and of_find_fpga_mgr_by_phandle() but maybe they should be added
> separately to drivers/of/of_fpga.c.
> 
> Alessandro: I haven't looked at your FMC cases but maybe this
> could be also worth for your cases.
> 
> TODO:
> - Probably make sense to create doc in Documentation folder too.
> - When interface is fine also send zynq devcfg driver
> - Properly test reading (we have problem with zynq devcfg driver now)
> - Not sure if firmware interface also provide option to create
>   files from kernel space.
> 
> Thanks for your comments,
> Michal
> 
> Changes in v2:
> - Remove ! from all error message not to be shouty
> - Fix error codes
> - Add sysfs-class-fpga description
> - Use read/write helper functions with bit protection
> - s/fpga_mgr_status_show/fpga_mgr_status_read/g
> - Do not all end driver status just show core status
> - Extract firmware support to specific sysfs firmware file
> - Add support for sysfs bin attributes (fpga_config_state, fpga_config_data)
> - Allocate space for name dynamically
> - Introduce new flags bits (INIT_DONE, READ, WRITE)
> 
> Michal Simek (1):
>   fpga: Introduce new fpga subsystem
> 
>  Documentation/ABI/testing/sysfs-class-fpga |  33 ++
>  MAINTAINERS                                |   7 +
>  drivers/Kconfig                            |   2 +
>  drivers/Makefile                           |   1 +
>  drivers/fpga/Kconfig                       |  18 +
>  drivers/fpga/Makefile                      |   5 +
>  drivers/fpga/fpga-mgr.c                    | 753 +++++++++++++++++++++++++++++
>  include/linux/fpga.h                       | 110 +++++
>  8 files changed, 929 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-fpga
>  create mode 100644 drivers/fpga/Kconfig
>  create mode 100644 drivers/fpga/Makefile
>  create mode 100644 drivers/fpga/fpga-mgr.c
>  create mode 100644 include/linux/fpga.h
> 
> --
> 1.8.2.3
> 




