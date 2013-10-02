Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3JBPgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:36:15 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:54121 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab3JBPgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:36:12 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Alan Tull <atull@altera.com>, Pavel Machek <pavel@ucw.cz>,
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
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH v2 0/1] FPGA subsystem core
Date: Wed,  2 Oct 2013 17:35:57 +0200
Message-Id: <cover.1380727889.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-24586-1380728158-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-24586-1380728158-0001

Hi All,

this is the second attempt to introduce new Linux FPGA subsystem which
can help us to unify all fpga drivers which in general do the same
things.
Xilinx has hwicap in the kernel as char driver (drivers/char/xilinx_hwicap/)
and I would like to base Zynq devcfg driver based on this interface
because make no sense to push the Linux kernel another char driver
(I am testing this interface on this driver).

Based on my discussion at ELC with Greg KH the new driver
should support firmware interface for loading bitstream.

FPGA manager/driver just define set of functions and
call fpga_mgr_register().

struct fpga_manager_ops zynq_fpga_mgr_ops = {
	.read_init = zynq_init,
	.write_init = zynq_init,
	.read = zynq_read,
	.write = zynq_write,
	.read_complete = zynq_complete,
	.write_complete = zynq_complete,
};

fpga_mgr_register(pdev, &zynq_fpga_mgr_ops, "Zynq FPGA Manager", priv);

For unregistration it is enough to call:
fpga_mgr_unregister(pdev);

Here is the set of commands for writing bitstream to FPGA.

Through firmware interface:
cat /sys/class/fpga_manager/fpga0/name
echo -n fpga.bin > /sys/class/fpga_manager/fpga0/firmware

Through sysfs bin file:
cat /sys/class/fpga_manager/fpga0/fpga_config_state
echo -n write_init > /sys/class/fpga_manager/fpga0/fpga_config_state
cat /lib/firmware/fpga.bin > /sys/class/fpga_manager/fpga0/fpga_config_data
echo -n write_complete > /sys/class/fpga_manager/fpga0/fpga_config_state

Subsystem supports working with phandles for cases where you want to load
bitstreams for particular device through defined device.
For example:
mngr@0 {
	compatible = "whatever";
	fpga-mgr = <&ps7_dev_cfg_0>;
	...
} ;

With these lines you can get easily load bitstream to the device.

struct fpga_manager *mgr;
mgr = of_find_fpga_mgr_by_phandle(pdev->dev.of_node, "fpga-mgr");
if (mgr)
	mgr->fpga_firmware_write(mgr, "filename");

NOTE: I have added there of_find_fpga_mgr_by_node()
and of_find_fpga_mgr_by_phandle() but maybe they should be added
separately to drivers/of/of_fpga.c.

Alessandro: I haven't looked at your FMC cases but maybe this
could be also worth for your cases.

TODO:
- Probably make sense to create doc in Documentation folder too.
- When interface is fine also send zynq devcfg driver
- Properly test reading (we have problem with zynq devcfg driver now)
- Not sure if firmware interface also provide option to create
  files from kernel space.

Thanks for your comments,
Michal

Changes in v2:
- Remove ! from all error message not to be shouty
- Fix error codes
- Add sysfs-class-fpga description
- Use read/write helper functions with bit protection
- s/fpga_mgr_status_show/fpga_mgr_status_read/g
- Do not all end driver status just show core status
- Extract firmware support to specific sysfs firmware file
- Add support for sysfs bin attributes (fpga_config_state, fpga_config_data)
- Allocate space for name dynamically
- Introduce new flags bits (INIT_DONE, READ, WRITE)

Michal Simek (1):
  fpga: Introduce new fpga subsystem

 Documentation/ABI/testing/sysfs-class-fpga |  33 ++
 MAINTAINERS                                |   7 +
 drivers/Kconfig                            |   2 +
 drivers/Makefile                           |   1 +
 drivers/fpga/Kconfig                       |  18 +
 drivers/fpga/Makefile                      |   5 +
 drivers/fpga/fpga-mgr.c                    | 753 +++++++++++++++++++++++++++++
 include/linux/fpga.h                       | 110 +++++
 8 files changed, 929 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-fpga
 create mode 100644 drivers/fpga/Kconfig
 create mode 100644 drivers/fpga/Makefile
 create mode 100644 drivers/fpga/fpga-mgr.c
 create mode 100644 include/linux/fpga.h

--
1.8.2.3


--=_mimegpg-monstr-desktop-24586-1380728158-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJMPV4ACgkQykllyylKDCFD7QCggiTAYj46T2IvWnMJrJoECb/m
cbMAnjCXBCM75MIxo+CNOW7ZhL0IpU5F
=qMHo
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-24586-1380728158-0001--
