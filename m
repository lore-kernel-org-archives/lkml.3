Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab3IRP5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:57:00 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:50832 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3IRP46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:56:58 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Alan Tull <atull@altera.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Dom Cobley <popcornmix@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH 0/1] FPGA subsystem core
Date: Wed, 18 Sep 2013 17:56:38 +0200
Message-Id: <cover.1379519753.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-22748-1379519800-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-22748-1379519800-0001

Hi All,

this is the first attempt to introduce new Linux FPGA subsystem which
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
	.status = zynq_fpga_status,
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

Subsystem supports working with phandles for cases where you want to load
bitstreams for particular device though defined device.
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
	mgr->fpga_write(mgr, "filename");

NOTE: I have added there of_find_fpga_mgr_by_node()
and of_find_fpga_mgr_by_phandle() but maybe they should be added
separately to drivers/of/of_fpga.c.

Alessandro: I haven't looked at your FMC cases but maybe this
could be also worth for your cases.

TODO:
- Probably make sense to create doc in Documentation folder too.
- When interface is fine also send zynq devcfg driver

Thanks for your comments,
Michal


Michal Simek (1):
  fpga: Introduce new fpga subsystem

 MAINTAINERS             |   7 +
 drivers/Kconfig         |   2 +
 drivers/Makefile        |   1 +
 drivers/fpga/Kconfig    |  18 ++
 drivers/fpga/Makefile   |   5 +
 drivers/fpga/fpga-mgr.c | 433 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fpga.h    | 105 ++++++++++++
 7 files changed, 571 insertions(+)
 create mode 100644 drivers/fpga/Kconfig
 create mode 100644 drivers/fpga/Makefile
 create mode 100644 drivers/fpga/fpga-mgr.c
 create mode 100644 include/linux/fpga.h

--
1.8.2.3


--=_mimegpg-monstr-desktop-22748-1379519800-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlI5zTgACgkQykllyylKDCEHVACfaub9O3/RZAywlh1TAdiMDiGZ
wgMAn2RC25UnUXpGYSWR9ZEJSV5frEFg
=hg5y
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-22748-1379519800-0001--
